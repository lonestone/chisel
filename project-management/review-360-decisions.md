# Review 360 — décisions Owner (2026-08-27)

Rapport source : artifact « Review 360 de chisel »
(https://claude.ai/code/artifact/8ec4c0f0-3d03-4cac-b27d-7becbb6f9903).
Chaque bloc du rapport reçoit ici une décision, prise à l'oral avec l'Owner,
une question à la fois. Statut : 🔲 à trancher · ✅ tranché · ⏭️ différé.

## A · Jointures normatives

- ✅ **A1 — « Tracker section » ×5, « Wayfinding operations », « architecture index »**
  Tranché (2026-08-27) : (1) renommage mécanique des cinq pointeurs vers
  « `.agents/project.md`, §B · Coordination » (§B2 quand c'est le tracker
  externe) ; (2) ~~wayfinder borné dormant~~ **amendé par F1.1 : wayfinder
  gardé et adapté local-first** (le renvoi « Wayfinding operations » reste
  supprimé) ;
  (3) §D gagne un champ « Architecture index » (défaut
  `doc/architecture/ARCHITECTURE.md`) que les formulas supposent déjà.
- ✅ **A2 — Allotment exigé, produit par personne**
  Tranché (2026-08-27) : **l'allotment comme limite stricte est un mauvais
  pattern — il disparaît des profils.** Interdire au Mason de toucher des
  fichiers est rejeté ; l'inverse fonctionne mieux : le system design (fait en
  amont) déclare « voici les fichiers à modifier » et « voici les fichiers à
  éviter » (indicatif, motivé par le choix d'architecture, jamais une limite
  stricte — on découvre toujours des choses en implémentant). La zone grise
  est assumée : tout lister causerait des oublis. Le reviewer juge les écarts
  a posteriori — une modification d'un fichier « à éviter » peut être validée,
  ou au contraire servir de révélateur d'un mauvais pattern. À réécrire :
  mason.md (retirer « never touches files outside the allotment »),
  architect.md (l'allotment de chaque slice → la carte fichiers-à-modifier /
  fichiers-à-éviter du design), foreman.md, et le duty correspondant côté
  Inspector (juger les écarts, pas les interdire).
- ✅ **A3 — Trois pointeurs livrés cassés (SDD-bench, sync-upstream, The Ledger)**
  Tranché (2026-08-27) : (1) la phrase « Full analysis: `SDD-bench/…` » de
  methodology.md est **supprimée** (contexte de développement, pas du
  normatif ; une URL le jour où c'est publié) ; (2) **sync-upstream déménage
  dans `socle/scripts/`**, à côté de son script, hors du set que l'installeur
  copie — outillage mainteneur, pas socle livré ; (3) « The Ledger » dans
  architect.md : l'Owner ne sait pas lui-même d'où vient ce mot (« gloubiboulga
  généré par les agents ») — remplacé par « the coordination state », la
  formule des trois autres profils.
- ✅ **A4 — README : « init asks two questions »**
  Tranché (2026-08-27) : le README dit la vérité du flux réel — `chisel init`
  installe le socle avec des défauts sûrs, muet ; le questionnaire est le
  skill `chisel-setup`, lancé ensuite dans la session agent, qui remplit
  `.agents/project.md`. Le CLI reste bête, le skill reste le questionnaire.

## B · Contradictions de doctrine

- ✅ **B1 — Template : « 🧑 = l'humain » vs doctrine « 🧑 = le propriétaire »**
  Tranché (2026-08-27) : le template cède, sans jargon. Sa table des zones
  devient : « 🧑 REVIEW CAREFULLY — le propriétaire de la zone relit avant
  tout code. En preset par défaut, c'est toi (l'humain). Qui possède quoi
  selon le preset : voir `methodology.md`, "Zone ownership" ». Le lecteur du
  mode par défaut ne perd rien, la contradiction disparaît pour les deux
  autres presets.
- ✅ **B2 — Mason optionnel (methodology) vs obligatoire (architect + formulas)**
  Tranché (2026-08-27) : **option B — la frappe passe toujours par le contrat
  Mason, la délégation n'est plus opt-in.** Deux voies : (a) l'outil sait
  spawner → sous-agent Mason lancé automatiquement ; (b) sinon, l'utilisateur
  est invité à ouvrir une session fraîche (Claude/Cursor) et à lancer
  `work on slice <fichier>`. À retirer de methodology.md : « optional Mason »
  et « The agent OFFERS this choice ». Correctif joint (constat vérifié : rien
  ne garantit aujourd'hui qu'une session fraîche charge mason.md — la règle
  « lis le profil avant de spawner » ne s'adresse qu'au délégant) : ajouter la
  règle côté session entrante — « une session ouverte pour exécuter un step
  endosse le rôle de ce step : elle lit son profil avant d'agir » (discipline
  ou bloc AGENTS).
- ✅ **B3 — Chaîne d'escalade inversée par rapport au roster**
  Tranché (2026-08-27) — la question a fait émerger un remodelage plus
  profond que le finding :
  **(a) Les rôles n'ont pas de hiérarchie.** La chaîne fixe
  « Mason → Architect → Inspector → digest » disparaît des 7 fichiers qui la
  portent. La hiérarchie vient du contexte : celui qui possède le fil est
  celui qui l'a lancé (ou le co-possède).
  **(b) Le mot « digest » meurt.** L'Owner ne reconnaît pas ce concept
  pourtant consigné dans methodology.md — preuve vivante du finding C3 (une
  décision enterrée dans la prose d'agent n'a jamais été possédée). La
  mécanique du rapport (ligne ⚠️ datée au journal + bead bloquant en mode
  beads) peut survivre comme FORME du rapport de blocage, sans le jargon.
  **(c) Nouveau découpage des rôles :**
  - **Foreman = le propriétaire du fil.** Gère UNE conversation / une session
    de travail, porte le contexte métier, spawne Architect/Mason/Inspector,
    collecte les rapports, décide dans les limites de ce qu'il possède.
    **Le Foreman devient un vrai rôle avec profil** (renverse la décision v2
    « a doc page, never a profile »). En default, l'humain co-possède ce fil
    (le Foreman = la session principale). C'est lui qui porte « lis le profil
    d'un rôle avant de le spawner ».
  - **Architect = l'expert haut niveau, dé-chargé de la coordination** :
    exploration de codebase, rédaction de specs/design. Rend un artefact, ne
    pilote personne.
  - **Mason** = tape le code (inchangé).
  - **Inspector** = même hauteur de vue que l'Architect (vision 360),
    objectif différent : juger, pas concevoir. Pas de hiérarchie entre eux.
  **(d) L'escalade** : un sous-agent rapporte à son spawneur (le Foreman).
  Au-dessus de l'autorité du Foreman → tâche bloquée + rapport écrit, le cran
  au-dessus décide. **Au-dessus du Foreman : l'humain, point** (aujourd'hui).
  L'extension factory (un « Master Architect » frontier qui porte les wishes
  de l'Owner au-dessus des sessions) reste notée-pas-construite.
  Variante default à deux conversations reconnue : humain+Architect pour le
  plan, puis humain+Mason pour le travail — l'Inspector rapporte alors au fil
  humain+Mason.
- ✅ **B4 — chisel-auto : « STOP » sans relanceur ; digest contradictoire ; upgrade-v2 sous auto**
  Tranché (2026-08-27) :
  (1) **Les formulas auto/supervised se réécrivent sur l'orchestration
  Foreman** (cf. B3) : la session invocante EST le Foreman ; chaque step = un
  sous-agent spawné frais avec le profil du rôle ; le « Then STOP » ne
  survit qu'en default (l'humain relance) — en auto/supervised il devient
  « le Foreman spawne la suite, fraîche ». Au step `close`, le Foreman
  commit/push, nommé explicitement.
  (2) La contradiction du digest est réglée par B3 (le digest meurt ;
  escalade = rapport au Foreman ; au-dessus de son autorité = tâche bloquée
  + rapport écrit à l'humain).
  (3) **upgrade-v2 sort complètement du système de presets** : c'est un
  processus séparé — une MàJ de chisel sur un projet existant, hors
  workflows. La règle 10 de la discipline perd son câblage preset (« runs it
  under supervised/auto » disparaît) ; le redirect vit dans le message de
  refus du CLI, qui nomme déjà le skill. Le processus reste ce qu'il est :
  l'agent migre, l'humain valide, toujours.
- ✅ **B5 — code-review réduit la spec à 4 sections**
  Tranché (2026-08-27) — le finding a débouché sur un split structurel
  (inspiration spec-kit/openspec) :
  **(a) Deux documents par tâche.**
  - *Le document de spec* (l'amont de TYPE) : Context, Scope, ACs, Seams,
    Architecture/system design. Propriétaires : humain + Architect. Le Mason
    n'y écrit jamais. Durable ; le bead pointe dessus via `--spec-id`.
  - *Le document de travail* (suffixe pressenti `-work.md`) : program design,
    worklog, checkboxes d'implémentation. Propriétaire : le Mason.
    L'Architect le VALIDE au design-check (verdict, pas édition). Jetable :
    si la spec change (choix d'archi révisé, on relance un Mason), il peut
    être supprimé et régénéré.
  **(b) La review deux-axes devient mécanique.** L'axe Spec juge le diff
  contre le document de spec SEUL (system design inclus — fin de
  l'énumération en dur des 4 sections dans code-review). Le program design
  n'est jamais un référentiel (circulaire : il reflète ce qui a été codé) —
  il est lu comme pièce à conviction (les justifications du Mason). Une
  divergence program design ↔ system design est un finding à juger, jamais
  un vert automatique.
  **(c) Coût assumé : tâche dédiée** dans le plan d'action (touche template
  scindé, slice-task, step plan des formulas, profils mason/architect/
  inspector, code-review, chisel-beads, methodology). Résout
  structurellement C4 (Designs de 450 lignes dans la surface de relecture).

## C · Lisibilité des tâches

- ✅ **C1 — Zone 🧑 non autoportante (codes sans explication)**
  Tranché (2026-08-27), règle plus forte que la proposition initiale :
  **les codes sont à éviter « au max du max du max »** — on nomme les choses
  par leur signification, pas par un code (pas de « AC2 », « S5 »,
  « fb-3kk.8 » nus). Quand un code doit VRAIMENT être cité, sa signification
  l'accompagne entre parenthèses. Corollaire : la zone « à relire
  attentivement » se comprend sans ouvrir un autre fichier (un lien pour
  approfondir, oui ; un renvoi obligatoire pour comprendre la phrase, non).
- ✅ **C2 — Références par numéro de ligne (slice:ligne)**
  Tranché (2026-08-27) : **interdit dans les fichiers de tâche.** Une
  référence de prose cite le titre de section + quelques mots verbatim,
  jamais un numéro de ligne (ils périment — 78 références déjà fausses dans
  la slice 07). Extension naturelle de la règle 11 (fichier + titre, jamais
  un numéro nu). Lintable.
- ✅ **C3 — Décisions Owner enterrées en zone 🤖**
  Tranché (2026-08-27) : **une décision de l'Owner ne séjourne jamais dans la
  zone de travail.** Quand une décision tombe en cours de route, elle monte
  dans la surface de décision du document de spec (Implementation Decisions
  ou la zone concernée), datée, au plus près des mots de l'Owner ; la zone de
  travail ne garde que le récit de son application. Preuve vécue en session :
  le « Owner's digest », « arbitré » le 26/08 et consigné en zone agent,
  était inconnu de l'Owner. Note de l'Owner : le nom « zone agent » est
  trompeur (des agents peuvent posséder des zones 🧑 en auto) — l'important
  est que LE FICHIER À RELIRE soit bien défini ; le split en 2 fichiers (B5)
  règle le problème structurellement.
- ✅ **C4 — ACs numérotés → ACs nommés ; Designs sans gradient interne**
  Tranché (2026-08-27) : (1) **les ACs sont nommés, pas numérotés** —
  `- [ ] **plus-de-labels-w** — le grep W0/W1/W2 ne retourne rien` ; on les
  cite par leur nom, qui se comprend en place et survit aux réécritures ; le
  template change en conséquence. (2) **Un AC ne se réécrit pas par
  effacement** : l'original reste barré, la nouvelle version datée dessous.
  (La moitié « Designs de 450 lignes sans plan de lecture » est réglée par le
  split spec/travail de B5.) Esprit général confirmé par l'Owner : « moins de
  code ».

## D · Code exécutable

- ✅ **D1 — Bug newline : init corrompt un CLAUDE.md sans newline finale**
  Tranché (2026-08-27) : corriger (garantir le retour à la ligne avant
  l'append) + fixture de test avec un CLAUDE.md sans newline finale.
- ✅ **D2 — check valide n'importe quel symlink .claude/skills**
  Tranché (2026-08-27) : corriger (comparer la cible du lien à
  `../.agents/skills`, comme le fait déjà l'inventaire) + assertion de test.
- ✅ **D3 — Orphelins d'update jamais nettoyés, faussement « étrangers »**
  Tranché (2026-08-27) : **option (a) — suppression sûre + rapport.**
  `update` compare ancien et nouveau manifeste ; un fichier disparu dont le
  contenu local correspond encore au hash posé par chisel est supprimé
  (prouvé chisel-owned, non modifié) avec une ligne `removed:` au rapport ;
  modifié localement → on ne touche pas, ligne `orphaned:` + warning. Fidèle
  au modèle de propriété (« chisel ne réécrit que ce qui est à lui »,
  suppression gardée par le hash). Corriger au passage le message mensonger
  de `warn_foreign_skills`.
- ✅ **D4 — Oracle tautologique du rendu ; checker non testé ; gardes journal sans test**
  Tranché (2026-08-27) : combler les quatre trous, en tests de comportement —
  profil-fixture piégeux avec rendu attendu committé en golden file (oracle
  indépendant de l'awk du script), boucle sur les vrais `profiles/*.md`
  (checker inclus), groupe `journal` (gardes LOG/CHANGELOG et réécriture §A),
  assertion de survie d'une définition posée par l'utilisateur à `update`.
  **Et le plafond dur de 600 lignes de la suite SAUTE** — « on n'a pas de
  limites à mettre, c'est une fausse bonne idée » (Owner). Le runner cesse de
  vérifier une taille ; étend l'arbitrage anti-limites-chiffrées à la suite
  de tests elle-même.
- ✅ **D5 — Lot mineur CLI → supplanté : PORT DENO COMPLET**
  Tranché (2026-08-27) : **le CLI et sa suite de tests sont réécrits en
  Deno/TypeScript.** Motivations Owner : typing, tests modernes et propres,
  runtime adapté à ce genre d'outil. Distribution : publication JSR (le nom
  npm peut rester pour la découvrabilité), invocation consommateur via `dx`
  (l'équivalent npx de Deno 2.6, vérifié : exécute les binaires npm/JSR avec
  confirmation + permissions Deno). Prérequis documenté : Deno ≥ 2.6.
  Conséquences :
  - La moitié du lot mineur s'évapore avec bash (python3, trap/mktemp, dédup
    sha256, portabilité BSD/GNU) ; le reste devient exigence du port :
    rejet des arguments excédentaires + `--help` digne, le runner de tests
    conserve les artefacts de diagnostic en cas d'échec, commentaires sobres.
  - **Les bugs D1–D3 et les tests D4 se corrigent DANS le port** (les
    fixtures golden s'écrivent dans la nouvelle suite) — pas de double
    travail en bash.
  - Méthode : porter les tests d'abord (le seam CLI arbre-entrant →
    arbre-sortant est déjà spécifié par la suite noire), l'implémentation
    ensuite. Réécriture complète ≠ réécriture du comportement : parité
    attendue, les fixtures existantes font foi.

## E · Dette déclarative

- ✅ **E1 — Factory = auto × beads : outiller ou dégrader la claim**
  Tranché (2026-08-27) : **option (b) — dégrader la claim.** PHILOSOPHY et
  methodology cessent de présenter la factory comme une case du produit
  (« factory = auto × beads ») : elle devient une destination possible,
  peut-être hors de chisel. Raison stratégique (Owner) : il n'est pas acquis
  que la factory vive DANS chisel — chisel se veut léger et souple pour
  s'adapter partout, une factory implique beaucoup de sur-mesure ; la
  question « factory d'un côté, chisel de l'autre, les deux ensemble ? »
  reste ouverte à dessein. Aucune machinerie beads de factory n'est écrite
  (ni bead de blocage formalisé, ni gates async) tant que cette question
  n'est pas tranchée par un vrai besoin.
- ✅ **E2 — Cascade de tiers : câbler `model:` ou déclarer prose-only**
  Tranché (2026-08-27) : **prose-only, déclaré.** Le choix du modèle d'un
  agent appartient à la plomberie de l'utilisateur (ou d'une éventuelle
  factory), pas à chisel — d'autant que les formats de définition d'agents
  varient selon les outils. Une ligne dans le README des profils : les tiers
  se résolvent à la lecture, par le délégant, au spawn ; les définitions
  générées ne portent pas de champ modèle. Nuance actée : le socle PEUT
  lister des modèles en EXEMPLE des tiers (« Frontier : Fable, Opus,
  GPT… ») sans rien fixer — assouplit la règle v2 « zéro nom vendeur » :
  l'exemple illustratif est permis, le normatif reste tier-only. Ferme le
  finding hérité de l'audit fable-v2 (la cascade sans consommateur).
- ✅ **E3 — Trois formulas dupliquées sans garde anti-drift ; steps qui restatent les profils**
  Tranché (2026-08-27) : (1) **dégraisser les corps de steps** — « Role: X,
  contrat : profiles/x.md » + ce qui est propre au step (ordre, artefacts),
  fin des paraphrases de profils ; se fait dans la réécriture Foreman des
  formulas (cf. B3/B4). (2) **Ni génération, ni assertion d'identité** — la
  génération est rejetée, et le test d'identité « revient à des checks sur
  des magic strings comme les greps, pas fou » (Owner, cohérent avec
  l'arbitrage de la slice 09). Pari sur la sobriété : une fois les steps
  réduits, la surface dupliquée est si petite que le risque baisse
  mécaniquement. Risque de drift accepté pour le moment.
- ✅ **E4 — methodology.md héberge du normatif ; pas de chemin « medium »**
  Tranché (2026-08-27) :
  (1) **Extraire le normatif de methodology.md** (glossaire, doctrine de
  propriété des zones, tiers) vers une référence courte que skills, formulas
  et template pointent ; methodology redevient l'essai du pourquoi ; couper
  la redite économique. Passe de dédoublonnage jointe : « Seam » est défini
  3× (glossaire, tdd, codebase-design — vérifié) → une définition dans la
  référence, les skills gardent une ligne de rappel + pointeur (le réflexe
  « Slice » généralisé).
  (2) **Pas d'élision au cas par cas — un workflow « light » clairement
  défini** (préférence Owner : pas de « trucs comme ça » ad hoc). Nouvelle
  formula `chisel-light` : les gates HUMAINES demeurent (l'humain relit la
  spec et le plan) ; ce qu'on retire, ce sont les sous-agents de review —
  pas de Checker sur la spec, pas d'Inspector sur le diff, pas de
  design-check. La relecture humaine est le filet. Choisi explicitement par
  l'humain au sizing (« light ou complet ? »). [Précision Owner du
  2026-08-27 : « la review des specs par l'humain reste nécessaire, ce sont
  les sous-agents auto (review spec, inspector) qu'on enlèverait ».]

## F · Mineurs (liste de courses)

- ✅ **F1 — Lot mineurs prose** — tranché (2026-08-27), dans l'ordre du
  rapport :
  1. **wayfinder : GARDÉ absolument, et ça devient un chantier** (amende la
     mise en dormance décidée en A1). Usage visé : le brainstorm local —
     cartographier les décisions ouvertes, les résoudre, déboucher sur des
     epics/tâches. Chantier : analyser en détail ce que le tracker externe
     couvrait (unités adressables, blocages entre décisions, requête de
     frontière) et écrire la déclinaison markdown locale ; le tracker
     redevient une option, pas le défaut. Reformuler aussi les « tickets »
     locaux (mot réservé aux trackers externes).
  2. upgrade-v2 « three role profiles » → ne plus compter (« the role
     profiles »).
  3. design-check « Mason (cheap tier) » → aligner sur « cheap or mid ».
  4. **Statuts : discussion dédiée à ouvrir** — le modèle actuel est « à
     l'arrache » ; l'Owner veut un vrai cycle (créée, métier OK, design
     system OK, reviewed/ready, in progress, stalled…). Chantier à part dans
     le plan d'action ; le mapping « awaiting approval » s'y fond.
  5. **Prototype : option (b)** — la règle 6 du skill (branche jetable +
     pointeur) est la référence, la discipline s'aligne (« delete the code »
     disparaît) ; ET une habitude de nettoyage est inscrite : au close de la
     tâche qui a consommé la décision, les branches de prototype qu'elle
     pointe sont supprimées une fois la décision intégrée.
  6. retro « rendered into the AGENTS block » → corriger : le bloc POINTE
     vers discipline.md (vérifié), il ne la rend pas.
  7. Surdéclaration « Nothing in this socle names a model or a vendor » →
     restreinte aux modèles/tiers (noms d'outils légitimes ; cohérent E2).
  8. Sédiments de rétro → purger : « Status: 🟢 Complete / Version: 2 » du
     template lui-même, « moved here from type », et la règle « rewrite
     labels » réécrite pour se comprendre seule ou supprimée.
  9. **Règle 10 de la discipline : supprimée, point final** — « l'update,
     faut qu'on arrête de se prendre la tête dessus, je serai le seul à le
     faire » (Owner). Le message de refus du CLI fait le redirect. La règle
     11 reste ; sa maison se règle en G1.
  10. grill-with-docs → supprimé.
  11. **Le skill triage sort du socle livré pour le moment** — noté comme
      intéressant à terme (avec un vrai tracker d'équipe).
  12. Glue : pas de patch-commentaire — **le port Deno (D5) donne au parsing
      de la glue une architecture propre et logique** (parser structuré des
      sections, fin des chaînes exactes).

## G · Règles de rédaction & questions transverses

- ✅ **G1 — Les règles de rédaction (adoption et placement)**
  Tranché (2026-08-27) — l'essentiel avait été tranché en C ; les miettes :
  (1) règle adoptée : tout renvoi vers un autre document dit en une phrase ce
  que le lecteur y trouverait ; (2) règle abandonnée : le résumé-chapeau des
  longs Designs (sans objet depuis le split B5) ; (3) placement : la FORME
  dans les deux templates (spec et travail) ; le COMPORTEMENT en une règle
  compacte de la discipline (pas de codes, nomme les choses, fichier + titre
  pour les références — absorbe l'actuelle règle 11) ; le CONTRÔLE en duty du
  Checker (zone de spec illisible = finding bloquant). Pas de script de lint
  — c'est le Checker qui juge, pas un grep.
- ✅ **G2 — Q5 : contraintes de forme chiffrées dans le template ?**
  Tranché de fait par D4 (« on n'a pas de limites à mettre, c'est une fausse
  bonne idée ») : aucune limite chiffrée nulle part — ni socle, ni template,
  ni suite de tests. Les règles de forme restent qualitatives
  (« autoportante », « se comprend seul ») et le Checker juge.
- ✅ **G3 — Q6 : langue des artefacts**
  Tranché (2026-08-27) : **tout en anglais** — socle, fichiers de tâche,
  journal, commits. Le choix est maintenant posé (c'était le reproche : il ne
  l'avait jamais été). Les citations de l'Owner restent dans leur langue
  d'origine, entre guillemets. Une ligne de la glue peut le déclarer pour
  les équipes qui voudraient un autre réglage.
- ✅ **G4 — Q7 : distiller un skill codebase-audit**
  Tranché (2026-08-27) : oui — `socle/agents/skills/codebase-audit/`, en
  anglais, distillé du protocole de cette session : finders indépendants à
  l'aveugle, un par lentille (paramétrables selon le projet) → vérification
  des claims graves avant affirmation → tri contre les audits antérieurs et
  les arbitrages Owner (nouveau / correctif raté / déjà tranché — on ne
  re-litige pas) → rapport → décisions bloc par bloc, une question à la
  fois, recommandation incluse. Écriture selon `writing-great-skills`.

---

## Plan d'action révisé (issu des 22 décisions)

Chaque chantier deviendra une tâche via le process chisel normal (interview →
fichier de spec) ; ce fichier est la source des intentions.

1. **Remodelage des rôles et des formulas** (décisions B2, B3, B4, A2, E3,
   E4.2) — le gros morceau doctrinal : profil Foreman (propriétaire du fil),
   Architect dé-chargé de la coordination, escalade contextuelle (mort du
   « digest », tâche bloquée + rapport écrit), Mason obligatoire + règle
   « une session entrante endosse le rôle du step », carte
   fichiers-à-modifier/à-éviter à la place de l'allotment, formulas
   réécrites sur l'orchestration Foreman avec steps dégraissés, nouvelle
   formula `chisel-light`.
2. **Split spec / document de travail** (B5, C3, C4) — deux templates, ACs
   nommés jamais effacés, code-review sur toutes les zones de la spec,
   program design = pièce à conviction, pointeur `--spec-id` inchangé.
   S'articule avec le chantier 1 (les deux réécrivent formulas et profils —
   à séquencer ensemble ou 2 avant 1).
3. **Passe jointures & mineurs** (A1, A3, A4, B1, E1, E2, F1 sauf 1/4/12) —
   mécanique, aucun arbitrage restant : pointeurs §B, champ Architecture
   index, SDD-bench supprimé, sync-upstream déménagé, Ledger remplacé,
   README véridique, template 🧑 reformulé, claim factory dégradée, tiers
   prose-only (+ exemples permis), et les mineurs 2/3/5/6/7/8/9/10/11.
4. **Port Deno du CLI et de la suite** (D5, D1–D4, F1.12) — tests portés
   d'abord (parité, fixtures existantes font foi), bugs newline/symlink/
   orphelins corrigés dedans, golden files pour le rendu, groupe journal,
   parser de glue structuré, plafond de lignes supprimé, distribution
   JSR + `dx`, Deno ≥ 2.6.
5. **Extraction du normatif & règles de rédaction** (E4.1, G1, C1, C2) —
   référence courte (glossaire dédoublonné, zone ownership, tiers),
   methodology redevient le pourquoi, règle d'écriture compacte dans la
   discipline (absorbe la règle 11, la règle 10 supprimée), duty lisibilité
   du Checker. Après les chantiers 1–2 (les concepts bougent).
   **Ajout du 2026-08-27, remonté par l'Inspector au close de la slice 01 du
   chantier 1 :** les profils et `methodology.md` citent `.agents/project.md`
   §A, §B, §C… sans jamais nommer le titre de la section, ce que la règle 11
   interdit — mais la règle leur est postérieure, et corriger un seul fichier
   rendrait le socle moins cohérent, pas plus. L'Owner a tranché : **une
   passe de balayage en une fois, ici**, dans le chantier qui possède déjà la
   maison de la règle 11. Rien n'est corrigé au coup par coup d'ici là.
6. **Wayfinder local-first** (F1.1) — analyser ce que le tracker couvrait,
   écrire la déclinaison markdown locale ; brainstorm → décisions →
   epics/tâches.
7. **Modèle de statuts des tâches** (F1.4) — discussion dédiée à ouvrir
   (créée, métier OK, design OK, ready, in progress, stalled…).
8. **Skill codebase-audit** (G4) — distiller le protocole de cette session.

Transverse (G3) : tout nouvel artefact en anglais ; citations Owner dans leur
langue.

## Addendum (2026-08-27, en cours d'exécution)

- ✅ **G5 — Le cadrage de spawn d'un rôle n'est jamais improvisé.** Constat
  Owner en regardant tourner la tâche 1 : les prompts « You are the
  ARCHITECT… you report to the Foreman… you spawn no one » sont composés à
  la volée par l'agent délégant — non versionnés, « magiques », variables
  selon le modèle. Décision : ce cadrage VIT DANS LE PROFIL du rôle (le
  corps du profil est le prompt, collé verbatim au spawn) ; le délégant ne
  compose que le brief par-tâche depuis la section Inputs du profil
  (chemins, scope, artefacts) — zéro doctrine inventée au spawn. Exigence
  intégrée à la tâche 1 (remodel-roles-and-formulas) : les nouveaux profils
  (Foreman compris) doivent contenir ce cadrage — mission, à qui l'on
  rapporte, ce qu'on ne fait jamais — pour que « spawner un rôle » =
  profil verbatim + brief, rien d'autre.
