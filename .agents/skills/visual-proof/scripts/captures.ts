#!/usr/bin/env node
// SPDX-License-Identifier: MIT
// Copied into Chisel from the Harness (vault commit a05b1092), with Olympe's
// agreement of 21/11/2026, under Chisel's licence. A copy, not a link.
// captures : prendre les captures d'une page et dire, en texte, ce qui a changé.
//
// Pourquoi : une capture lue par l'outil Read reste dans le contexte de la session et se relit
// à chaque appel. Une session qui a lu 22 PNG (~10 Mo) a coûté près de 10 $.
// Ce script fait le travail mécanique sans modèle :
// les captures vont sur le disque, la comparaison avant/après se fait au pixel, et seul un
// rapport en texte revient. Regarder une image reste le travail d'un sous-agent
// (skill visual-proof), jamais du fil principal.
//
// Usage :
//   node captures.ts <url de base> <chemin,chemin…> --out <dossier> [--largeurs 390,1280] [--avant <dossier>] [--plein] [--sombre] [--clic <sélecteur>]... [--json]
// --sombre : la page avec prefers-color-scheme: dark. --clic <sélecteur> : clique cet élément avant la capture ; répétée,
// elle enchaîne les clics dans l'ordre (un menu ouvert, un onglet, un accordéon). Un sélecteur sans élément fait échouer la commande.
// Une page qui défile dans un conteneur interne se capture à la hauteur de la fenêtre : ce qui est
// sous le pli manque, et un sous-agent l'a déjà dit absent. Le rapport le signale ; --plein agrandit la fenêtre
// jusqu'à ce que le conteneur montre tout.
// Un conteneur qui défile de côté est signalé, avec ce qu'il cache.
// Playwright vient du repo où l'on se trouve (node_modules : playwright, playwright-core ou
// @playwright/test), sinon d'un playwright-core posé à côté de ce script.
// Si CHISEL_PLAYWRIGHT_WS est définie, le navigateur est celui du serveur Playwright qu'elle désigne :
// chromium.connect avec exposeNetwork '<loopback>', qui lui montre le localhost de ce client.

import { createRequire } from 'node:module';
import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';

// cache : les px qui restent cachés dans un conteneur qui défile en hauteur ; cote : les conteneurs qui défilent de côté.
export type Shot = { chemin: string; largeur: number; fichier: string; hauteur: number; debord: number; erreurs: string[]; titre: string; cache?: number; cote?: string[]; clics?: string[] };
export type Diff = { fichier: string; statut: 'identique' | 'change' | 'nouveau' | 'taille'; pixels?: number; part?: number; zone?: { x: number; y: number; l: number; h: number }; image?: string; avant?: [number, number]; apres?: [number, number] };

export function nomFichier(chemin: string, largeur: number): string {
  const base = chemin === '/' || chemin === '' ? 'accueil' : chemin.replace(/[^a-zA-Z0-9-]+/g, '_').replace(/^_+|_+$/g, '');
  return `${base || 'page'}-${largeur}.png`;
}

export function parseArgs(argv: string[]) {
  const pos: string[] = [];
  const o: { out?: string; largeurs: number[]; avant?: string; json: boolean; plein: boolean; sombre: boolean; clics: string[] } = { largeurs: [390, 1280], json: false, plein: false, sombre: false, clics: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--out') o.out = argv[++i];
    else if (a === '--avant') o.avant = argv[++i];
    else if (a === '--largeurs') o.largeurs = argv[++i].split(',').map(Number);
    else if (a === '--json') o.json = true;
    else if (a === '--plein') o.plein = true;
    else if (a === '--sombre') o.sombre = true; // prefers-color-scheme: dark ; sans, Chromium se dit en clair
    else if (a === '--clic') { const sel = argv[++i]; if (!sel || sel.startsWith('--')) throw new Error('--clic : un sélecteur CSS est attendu'); o.clics.push(sel); }
    else if (a.startsWith('-')) throw new Error(`option inconnue : ${a}\nusage : node captures.ts <url de base> <chemin,chemin…> --out <dossier> [--largeurs 390,1280] [--avant <dossier>] [--plein] [--sombre] [--clic <sélecteur>]... [--json]`);
    else pos.push(a);
  }
  if (pos.length < 2 || !o.out) throw new Error('usage : node captures.ts <url de base> <chemin,chemin…> --out <dossier> [--largeurs 390,1280] [--avant <dossier>] [--plein] [--sombre] [--clic <sélecteur>]... [--json]');
  if (o.largeurs.some((n) => !Number.isInteger(n) || n < 200 || n > 4000)) throw new Error('--largeurs : des entiers entre 200 et 4000');
  return { base: pos[0].replace(/\/$/, ''), chemins: pos[1].split(',').map((c) => (c.startsWith('/') ? c : '/' + c)), ...o };
}

function chargerPlaywright(): any {
  const essais = [process.cwd()];
  for (const dir of essais) {
    const req = createRequire(join(dir, 'package.json'));
    for (const nom of ['playwright', 'playwright-core', '@playwright/test']) {
      try { return req(nom); } catch { /* suivant */ }
    }
  }
  try { return createRequire(import.meta.url)('playwright-core'); } catch { /* introuvable */ }
  throw new Error('Playwright introuvable : lance la commande depuis un repo qui l’a dans node_modules');
}

function chromeEnCache(): string | undefined {
  const cache = join(homedir(), process.platform === 'darwin' ? 'Library/Caches/ms-playwright' : '.cache/ms-playwright');
  if (!existsSync(cache)) return undefined;
  const dirs = readdirSync(cache).filter((d) => /^chromium-\d+$/.test(d)).sort((a, b) => Number(b.split('-')[1]) - Number(a.split('-')[1]));
  for (const d of dirs) {
    for (const exe of ['chrome-linux64/chrome', 'chrome-linux/chrome', 'chrome-mac/Chromium.app/Contents/MacOS/Chromium', 'chrome-mac-arm64/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing']) {
      const p = join(cache, d, exe);
      if (existsSync(p)) return p;
    }
  }
  return undefined;
}

// La voie du navigateur : le serveur Playwright commun si la variable est définie et non vide, sinon un Chromium local.
export function voieNavigateur(env: Record<string, string | undefined> = process.env): { voie: 'distant'; ws: string } | { voie: 'local' } {
  const ws = env.CHISEL_PLAYWRIGHT_WS?.trim();
  return ws ? { voie: 'distant', ws } : { voie: 'local' };
}

async function lancer(pw: any) {
  const voie = voieNavigateur();
  if (voie.voie === 'distant') return await pw.chromium.connect(voie.ws, { exposeNetwork: '<loopback>' });
  try { return await pw.chromium.launch(); } catch (e) {
    const exe = chromeEnCache();
    if (!exe) throw e;
    return await pw.chromium.launch({ executablePath: exe });
  }
}

// Les conteneurs internes qui défilent (html et body exclus, que fullPage capture déjà) : la plus grande hauteur cachée,
// et ceux qui défilent de côté, nommés par balise, id et première classe.
function mesurer(): { cache: number; cote: string[] } {
  let cache = 0;
  const cote: string[] = [];
  for (const e of Array.from(document.querySelectorAll('body *')) as HTMLElement[]) {
    const st = getComputedStyle(e);
    if (/(auto|scroll)/.test(st.overflowY) && e.scrollHeight > e.clientHeight + 1) cache = Math.max(cache, e.scrollHeight - e.clientHeight);
    if (/(auto|scroll)/.test(st.overflowX) && e.scrollWidth > e.clientWidth + 1) {
      const nom = e.tagName.toLowerCase() + (e.id ? '#' + e.id : '') + (e.classList[0] ? '.' + e.classList[0] : '');
      cote.push(`${nom} (${e.scrollWidth - e.clientWidth}px cachés)`);
    }
  }
  return { cache, cote };
}

// La comparaison se fait dans le navigateur : il décode les PNG, sans dépendance.
async function comparer(page: any, avant: string, apres: string, sortie: string): Promise<Omit<Diff, 'fichier' | 'statut'> & { statut: Diff['statut'] }> {
  const a = 'data:image/png;base64,' + readFileSync(avant).toString('base64');
  const b = 'data:image/png;base64,' + readFileSync(apres).toString('base64');
  const r = await page.evaluate(async ([a, b]: [string, string]) => {
    const charger = (src: string) => new Promise<HTMLImageElement>((ok, ko) => { const i = new Image(); i.onload = () => ok(i); i.onerror = ko; i.src = src; });
    const [ia, ib] = await Promise.all([charger(a), charger(b)]);
    const taille = ia.width !== ib.width || ia.height !== ib.height;
    // Tailles différentes : on compare la zone commune, en haut à gauche.
    const w = Math.min(ia.width, ib.width), h = Math.min(ia.height, ib.height);
    const ctx = (img: HTMLImageElement) => { const c = document.createElement('canvas'); c.width = w; c.height = h; const x = c.getContext('2d')!; x.drawImage(img, 0, 0); return x.getImageData(0, 0, w, h); };
    const da = ctx(ia).data, db = ctx(ib).data;
    const out = document.createElement('canvas'); out.width = w; out.height = h;
    const ox = out.getContext('2d')!; const od = ox.createImageData(w, h);
    let n = 0, x0 = w, y0 = h, x1 = -1, y1 = -1;
    for (let i = 0; i < da.length; i += 4) {
      const d = Math.abs(da[i] - db[i]) + Math.abs(da[i + 1] - db[i + 1]) + Math.abs(da[i + 2] - db[i + 2]);
      const p = i / 4, x = p % w, y = (p / w) | 0;
      if (d > 24) {
        n++; if (x < x0) x0 = x; if (y < y0) y0 = y; if (x > x1) x1 = x; if (y > y1) y1 = y;
        od.data[i] = 255; od.data[i + 1] = 0; od.data[i + 2] = 80; od.data[i + 3] = 255;
      } else { const g = (db[i] + db[i + 1] + db[i + 2]) / 3; od.data[i] = od.data[i + 1] = od.data[i + 2] = 255 - (255 - g) * 0.25; od.data[i + 3] = 255; }
    }
    ox.putImageData(od, 0, 0);
    return { taille, avant: [ia.width, ia.height], apres: [ib.width, ib.height], n, total: w * h, zone: n ? { x: x0, y: y0, l: x1 - x0 + 1, h: y1 - y0 + 1 } : undefined, png: n ? out.toDataURL('image/png') : undefined };
  }, [a, b]);
  const tailles = r.taille ? { avant: r.avant, apres: r.apres } : {};
  if (!r.n) return { statut: r.taille ? 'taille' : 'identique', pixels: 0, part: 0, ...tailles };
  writeFileSync(sortie, Buffer.from(r.png.split(',')[1], 'base64'));
  return { statut: r.taille ? 'taille' : 'change', ...tailles, pixels: r.n, part: Math.round((r.n / r.total) * 10000) / 100, zone: r.zone, image: sortie };
}

export async function capturer(o: ReturnType<typeof parseArgs>, pw = chargerPlaywright()) {
  mkdirSync(o.out!, { recursive: true });
  const browser = await lancer(pw);
  const shots: Shot[] = [];
  const externes = new Set<string>();
  const hote = new URL(o.base).hostname;
  try {
    for (const largeur of o.largeurs) {
      const ctx = await browser.newContext({ viewport: { width: largeur, height: 900 }, reducedMotion: 'reduce', colorScheme: o.sombre ? 'dark' : 'light' });
      const page = await ctx.newPage();
      let erreurs: string[] = [];
      page.on('pageerror', (e: Error) => erreurs.push(String(e.message).slice(0, 200)));
      page.on('console', (m: any) => { if (m.type() === 'error') erreurs.push(String(m.text()).slice(0, 200)); });
      page.on('request', (r: any) => { try { const u = new URL(r.url()); if (/^https?:$/.test(u.protocol) && u.hostname !== hote) externes.add(u.origin); } catch { /* data: */ } });
      for (const chemin of o.chemins) {
        erreurs = [];
        await page.goto(o.base + chemin, { waitUntil: 'networkidle' });
        // Faire défiler pour déclencher le chargement paresseux, puis revenir en haut.
        await page.evaluate(async () => { for (let y = 0; y < document.body.scrollHeight; y += 600) { window.scrollTo(0, y); await new Promise((r) => setTimeout(r, 30)); } window.scrollTo(0, 0); });
        await page.waitForTimeout(300);
        // --plein : la fenêtre grandit de ce que cache le conteneur, jusqu'à ce qu'il montre tout (30 000 px au plus).
        let haut = 900;
        for (let i = 0; o.plein && i < 4; i++) {
          const { cache } = await page.evaluate(mesurer);
          if (cache <= 0 || haut >= 30_000) break;
          haut = Math.min(30_000, haut + cache);
          await page.setViewportSize({ width: largeur, height: haut });
          await page.waitForTimeout(300);
        }
        // --clic : les clics dans l'ordre, chacun suivi d'une courte pause pour que la page réagisse.
        for (const sel of o.clics) {
          try { await page.locator(sel).first().click({ timeout: 5000 }); } catch (e: any) { throw new Error(`--clic ${sel} sur ${chemin} à ${largeur}px : ${String(e.message).split('\n')[0]}`); }
          await page.waitForTimeout(300);
        }
        const fichier = join(o.out!, nomFichier(chemin, largeur));
        await page.screenshot({ path: fichier, fullPage: true });
        const vu = await page.evaluate(mesurer);
        if (haut !== 900) await page.setViewportSize({ width: largeur, height: 900 });
        const m = await page.evaluate(() => ({ debord: document.documentElement.scrollWidth - window.innerWidth, hauteur: document.documentElement.scrollHeight, titre: document.title }));
        shots.push({ chemin, largeur, fichier, hauteur: Math.max(m.hauteur, haut), debord: Math.max(0, m.debord), erreurs: [...erreurs], titre: m.titre, cache: vu.cache, cote: vu.cote, ...(o.clics.length ? { clics: o.clics } : {}) });
      }
      await ctx.close();
    }
    const diffs: Diff[] = [];
    if (o.avant) {
      const page = await (await browser.newContext()).newPage();
      for (const s of shots) {
        const nom = nomFichier(s.chemin, s.largeur);
        const avant = join(o.avant, nom);
        if (!existsSync(avant)) { diffs.push({ fichier: nom, statut: 'nouveau' }); continue; }
        diffs.push({ fichier: nom, ...(await comparer(page, avant, s.fichier, join(o.out!, nom.replace(/\.png$/, '.diff.png')))) });
      }
    }
    return { shots, diffs, externes: [...externes] };
  } finally {
    await browser.close();
  }
}

export function rapport(r: Awaited<ReturnType<typeof capturer>>, plein = false): string {
  const l: string[] = [];
  l.push(`${r.shots.length} capture(s) :`);
  for (const s of r.shots) {
    const marques = [s.clics?.length ? `après clic : ${s.clics.join(' puis ')}` : '', s.debord ? `DÉBORDE de ${s.debord}px` : '',
      s.cache ? `SOUS LE PLI : ${s.cache}px cachés dans un conteneur qui défile${plein ? '' : ', relance avec --plein'}` : '',
      s.cote?.length ? `défile de côté : ${s.cote.join(', ')}` : '',
      s.erreurs.length ? `${s.erreurs.length} erreur(s) : ${s.erreurs.join(' | ')}` : ''].filter(Boolean).join(' · ');
    l.push(`- ${s.chemin} à ${s.largeur}px : ${s.fichier} (hauteur ${s.hauteur}px${s.titre ? `, « ${s.titre} »` : ''})${marques ? ' · ' + marques : ''}`);
  }
  if (r.diffs.length) {
    l.push('', 'Avant/après :');
    for (const d of r.diffs) {
      if (d.statut === 'identique') l.push(`- ${d.fichier} : identique`);
      else if (d.statut === 'nouveau') l.push(`- ${d.fichier} : pas de capture avant`);
      else {
        const taille = d.statut === 'taille' ? `la taille change, ${d.avant!.join('×')} → ${d.apres!.join('×')} ; sur la zone commune, ` : '';
        l.push(`- ${d.fichier} : ${taille}${d.pixels ? `${d.part} % des pixels changent, dans la zone x ${d.zone!.x}, y ${d.zone!.y}, ${d.zone!.l}×${d.zone!.h} px · carte : ${d.image}` : 'rien ne change'}`);
      }
    }
  }
  l.push('', r.externes.length ? `Requêtes hors du site : ${r.externes.join(', ')}` : 'Aucune requête hors du site.');
  if (r.shots.some((s) => s.cache || s.cote?.length)) l.push('Ce qui est sous le pli ou caché de côté n\'est pas sur la capture : pour le sous-agent, « absent » y veut dire « non vérifié ».');
  l.push('Ne lis pas ces images dans ton fil : confie-les à un sous-agent (skill visual-proof).');
  return l.join('\n');
}

async function main() {
  const o = parseArgs(process.argv.slice(2));
  const r = await capturer(o);
  console.log(o.json ? JSON.stringify(r, null, 2) : rapport(r, o.plein));
}

if (import.meta.main) main().catch((e) => { console.error(`captures : ${String(e.message).slice(0, 400)}`); process.exit(1); });
