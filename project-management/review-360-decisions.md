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
   **Précision de l'Owner du 2026-08-28, en réponse à un finding de l'Inspector
   au `diff-review` de la slice 03 du chantier 1 :** le finding constatait que
   `socle/agents/profiles/mason.md` s'interdit d'éditer une zone 🧑 alors que les
   formulas ordonnent au Mason d'y écrire son program design, et proposait soit
   une exception dans le contrat du Mason, soit un autre marqueur dans le
   template. L'Owner a écarté les deux : « Le program design doit être persisté
   dans ***-work, un document qui appartient au maçon. Le Mason ne doit pas
   éditer la tâche d'origine. Il nous faut certainement 2 templates d'ailleurs. »
   Donc la contradiction ne se répare pas dans le contrat du Mason : elle
   disparaît quand le program design quitte le fichier de spec. **Deux templates
   sont confirmés** pour ce chantier — celui de la spec, celui du document de
   travail — et l'interdit du Mason d'éditer la tâche d'origine devient exact au
   lieu d'être enfreint. D'ici là, l'état transitoire est celui que le chantier 1
   avait déjà consigné (ses Implementation Decisions, point 12) : faute de
   fichier `-work`, le program design reste là où le template le met aujourd'hui.
   Rien n'est corrigé au coup par coup dans le contrat du Mason en attendant.
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
   **Constat du 2026-08-27, remonté par un Mason au design-check de la slice
   02 du chantier 1 et vérifié :** le contrôle de parsing des formulas dépend
   de `tomllib`, donc de python ≥ 3.11, et se met silencieusement en `SKIP`
   sinon. Sur la machine de l'Owner, `python3` est un pyenv 3.9 : la suite
   annonce 93 assertions vertes qui ne contiennent **aucune** vérification des
   gates ni du nombre de steps. Avec `/opt/homebrew/bin` en tête du `PATH`
   elle en annonce 94 et le contrôle passe. Un test qui se saute en se
   déclarant vert est exactement ce que le port doit supprimer — le runtime
   Deno n'aura pas cette dépendance. En attendant, toute vérification de ce
   dépôt se lance avec un python qui a `tomllib`.
   **Deuxième orphelin à nettoyer ici, ajouté le 2026-08-28 par la slice 04
   du chantier 1 (suppression de l'interrupteur, ruling G10) :** un projet
   équipé avant cette slice garde dans sa glue une sous-section
   « §B3 · Autonomous runs » de `.agents/project.md` que le socle ne nomme
   plus nulle part. Rien ne la lit — tous les pointeurs qui y menaient sont
   supprimés — et `chisel check` ne la signale jamais, la glue étant hors du
   jeu de fichiers managés. Résidu cosmétique seul, de la même classe que les
   copies périmées de la page Foreman supprimée : le nettoyage des orphelins
   de ce chantier les prend tous les deux.
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
   **Élargissement du 2026-08-28, remonté par un Mason au plan de la slice 04
   du chantier 1 et vérifié :** le périmètre écrit ci-dessus (« les profils et
   `methodology.md` ») sous-compte les porteurs. `socle/agents/discipline.md`
   lui-même cite §C dans sa règle de lecture et §F dans sa règle de
   vérification en lettres nues — le fichier qui porte la règle l'enfreint — et
   `socle/agents/skills/chisel-beads/`, `chisel-setup/` et `upgrade-v2/` citent
   §B1, §B2 et §H de la même façon. Le balayage les prend tous ; rien ne change
   au principe déjà tranché, seule la liste s'allonge.
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

- ✅ **G6 — Le pipeline renommé, remis dans l'ordre, et lu comme deux axes.**
  Constat Owner en regardant tourner la tâche 1, sur le nommage d'abord :
  « Design check je m'attendais à un check du system design, alors qu'ici
  c'est un check du programming design et du plan du maçon. Inversement,
  `plan` est apparemment la step de validation de la spec, alors qu'on
  utilise souvent `plan` pour désigner le plan du maçon. » Le nommage cachait
  une duplication réelle, vécue en session : l'Architect rédige un plan au
  step `plan`, puis le Mason produit un program design au step `design-check`
  — deux fois le même travail sous deux noms.
  **(a) Le program design appartient à l'agent qui code**, qui l'écrit pour
  lui-même au moment de coder (et, avec le split B5, dans son fichier
  `-work`). Raison Owner, qui devient la justification durable du séquençage :
  « un ticket peut se retrouver bloqué en statut "spec done" mais sans qu'on
  lance son écriture. Or, écrire tout un tas de pseudo code vieillira mal si
  entretemps des tâches ont été effectuées et ont modifié le code. Le system
  design vieillit mieux logiquement car l'architecture du projet ne change pas
  autant. »
  **(b) Les trois reviews se nomment par leur objet** : `spec-review`,
  `plan-review` (l'actuel `design-check`) et `diff-review` (l'actuel
  `review`). Le step `plan` garde son nom et dit enfin dans son corps ce
  qu'il produit — le program design — et qui l'écrit : la session qui
  implémente.
  **(c) La séparation CREATE / WORK est mal placée** : `spec-review` se
  trouve sous le trait « WORK (fresh session) » alors que la review de la
  spec est en amont de la production. Le trait descend d'un step.
  **(d) Les presets sont deux axes, pas une échelle.** Axe des gates
  humaines (relecture de la spec, validation du plan, code review) et axe des
  sous-agents de validation (Checker sur la spec, Architect au `plan-review`,
  Inspector au `diff-review`). `chisel-light` retire les sous-agents,
  `chisel-auto` retire les gates, `chisel-supervised` est un point
  intermédiaire sur l'axe des gates.

## Addendum 2 (2026-08-27) — le pipeline default, dicté par l'Owner

Séquence de référence du mode default, telle que l'Owner l'a posée. Elle sert
de cible aux quatre formulas ; les numéros ne sont PAS des codes à citer,
juste l'ordre de lecture.

1. Nouvelle session : l'humain amène une problématique.
2. Le Foreman mène l'interview.
3. Il lance un sous-agent Architect pour écrire la spec — le sous-agent ne
   peut pas interviewer l'humain. Sous-agent indisponible → on fait au mieux
   dans la conversation.
4. Review automatique par un sous-agent Checker.
5. **Gate humaine** : relecture du fichier produit et du system design,
   échanges possibles avec l'Architect. Jusqu'ici le système tourne
   silencieusement.
6. La spec est prête. Commit pour sauvegarder. **On peut rester dans cet état
   longtemps.**
7. Nouvelle session (ou sous-agent Mason) pour travailler. Le contexte neuf
   est à privilégier ; le mode dégradé est un chat conservé.
8. Le Mason fait le tour du travail et génère son fichier de travail `-work` :
   program design, pseudo-code. Échange possible sur du tactical programming,
   mais l'agent devrait avoir toutes les cartes pour avancer seul.
9. Sous-agent Architect qui valide et échange avec le Mason autour du plan.
10. **Gate humaine** : le Mason demande le feu vert. Un format de sortie est à
    prévoir — un condensé du plan sur lequel l'humain puisse dire go.
11. Frappe. L'agent utilise les automatisations du projet tout du long (lint,
    build, tests). Selon le harness, des informations peuvent lui revenir
    automatiquement.
12. Auto-review par un sous-agent Inspector. Allers-retours possibles.
13. **Gate humaine** : code review.
14. Finalisation de la tâche.
15. Commit.

**Une step de validation reste utile dans la formule ; relancer toute la
suite quand tout est déjà au vert n'est pas une fatalité** (c'est long).

**Les presets sont deux axes.** `chisel-light` retire les sous-agents de
validation (4, 9, 12). `chisel-auto` retire les gates humaines (5, 10, 13).
`chisel-supervised` est un point intermédiaire sur l'axe des gates. La
combinaison des deux retraits — ni gates ni sous-agents — est posée comme
question ouverte par l'Owner, pas comme décision.

**Suite de G6, tranché le 2026-08-27.** (1) Les renommages sont pris :
`design-check` devient `plan-review`, `review` devient `diff-review`,
`spec-review` ne bouge pas — les trois reviews se nomment par leur objet.
(2) La combinaison « ni gates ni sous-agents » **est construite**, contre la
recommandation du Foreman qui la jugeait sans filet. Raison de l'Owner : « je
serais curieux de l'avoir quand même pour faire du benchmark » — c'est un
instrument de mesure, le plancher du pipeline, et sa formula doit le dire
franchement dans son en-tête plutôt que se présenter comme un cran de plus
sur une échelle. Nom retenu par composition des deux existants :
`chisel-auto-light`.

- ⏭️ **G7 — Scinder la formula en deux : écriture de la spec, puis travail.**
  Idée de l'Owner (2026-08-27), explicitement **différée** : « à terme on
  pourrait p-e scinder la formule en 2 : écriture de la spec et work. Mais
  pas urgent. » Elle épouse la séquence de référence, qui marque une frontière
  nette à l'étape 6 — la spec est commitée et la tâche peut attendre là
  longtemps. Deux inconnues à lever avant de la construire : ce que beads
  attend d'un dossier `formulas` lié, et si deux fichiers valent mieux qu'un
  seul avec deux moitiés. Notée, pas construite.
  **Refermée le 2026-08-27 :** l'Owner ne la lance pas — « du coup non pas de
  scission », dans la même respiration que le refus du JSON ci-dessous. Elle
  reste une idée consignée, pas un chantier.

- ❌ **G8 — Formulas en JSON : rejeté.** Demande de l'Owner (2026-08-27) pour
  la lisibilité dans son éditeur : « ce qui serait bien c'est d'utiliser le
  format json parce que c'est plus clair pour moi finalement (à moins que je
  trouve une extension toml pour vscode) ». Constat opposé par le Foreman :
  JSON n'a pas de commentaires, et les formulas en portent entre vingt et
  quarante lignes chacune — la promesse « lisible sans outillage », la raison
  de chaque gate, l'interdit des noms de modèles. La proposition de les
  promouvoir en vrais champs a été écartée par l'Owner : « pas de json, tant
  pis ». Le TOML reste, et le CLI n'ayant jamais codé l'extension en dur, la
  question pourra se rouvrir sans dette. Inconnue jamais levée, à garder si
  elle revient : ce que beads attend d'un dossier `formulas` lié.

- ✅ **G9 — Les skills vendorisés doivent cesser de contredire notre doctrine.**
  Constat de l'Owner (2026-08-27), en comparant nos formulas au jeu de skills
  amont : « notre façon de faire n'est pas celle de Matt ». Seize skills sont
  vendorisés depuis `mattpocock/skills`, la plupart en fork verbatim, et rien
  ne garantit qu'ils ne portent pas des affirmations incompatibles avec ce
  qu'on construit. Deux exemples donnés par l'Owner : son `to-spec` produit
  des specs qui ne sont pas vraiment lisibles par un humain, alors que nous
  avons un format très spécifique (gradient de lecture, zones 🧑/🤖) ; et il
  n'a pas la séparation system design / program design, qui est devenue
  centrale chez nous. Décision : **auditer les seize**, chacun contre la
  doctrine du socle, et sortir la liste des contradictions concrètes — l'audit
  d'abord, les corrections comme chantier ensuite. Un fork verbatim reste
  légitime ; ce qui ne l'est pas, c'est un fork qui affirme le contraire de ce
  que le socle enseigne à côté.

- ✅ **G10 — L'interrupteur « Autonomous runs » est supprimé.** Tranché par
  l'Owner le 2026-08-28, à la question de savoir si §B3 devait aussi nommer
  `chisel-auto-light` : « mais l'interrupteur, c'est débile quoi, je ne veux
  pas d'interrupteur ». Deux reproches distincts. (1) **Mauvais fichier** :
  autoriser ou non les runs autonomes n'est pas un réglage d'équipe versionné,
  c'est un choix de la personne qui lance — « c'est un choix de l'utilisateur
  ça ». (2) **Mauvaise question** : un interrupteur de permission ne répond
  pas à ce dont on a besoin ; la bonne question serait « c'est quoi ton flow
  préféré ? », posée dans `.agents/user.md` — « moi par défaut j'aime bien
  chisel-default », et ce preset devient celui qui est pris par défaut.
  **Décision pour maintenant : on supprime, et on ne construit rien à la
  place.** C'est à l'utilisateur de lancer le flow qu'il veut, à chaque
  invocation. Le « flow préféré dans `user.md` » reste une idée consignée, pas
  un chantier : l'Owner veut d'abord l'usage — « je ne sais même pas si ça vaut
  le coup de se faire chier […] il faut que nous on fasse des tests, il faut
  que je voie c'est quoi le plus pratique ». Conséquence directe : la doctrine
  de la posture d'invocation perd sa moitié « ET la glue le permet » et garde
  l'autre — le choix du preset est humain, à l'invocation, jamais celui d'un
  agent. Dix fichiers du socle portent l'interrupteur ; inventaire dans le
  fichier de la slice qui l'exécute.

- ✅ **G11 — La forme des sorties reste dans le profil du Foreman, mais en
  prose.** Tranché par l'Owner le 2026-08-28, au `close` du chantier 1, sur la
  première proposition de la rétro — puis **corrigé le même jour**, le Foreman
  ayant d'abord consigné l'inverse de ce qui était dit : « c'est exactement
  l'inverse que je dis… je veux que ça reste, en prose, dans `foreman.md` ».
  Ce que l'Owner refuse n'est pas l'emplacement, c'est le **gabarit**. La
  section « Reporting to the Owner » de `socle/agents/profiles/foreman.md`
  garde donc sa maison et change de registre : « c'est pas la peine de mettre
  un format ultra strict, je pense que de la prose suffira ». Elle cesse de se
  lire comme un formulaire à remplir — la liste des sections, l'ordre imposé,
  les deux « shapes » nommées — et dit en prose ce qui rend une sortie lisible.
  Ce qu'il faut y garder du vécu de ce chantier n'est pas la liste des sections :
  c'est ce qui l'a fait échouer. Un rapport correct et illisible a bloqué une
  gate, l'Owner ne pouvant pas répondre à une question qu'il ne pouvait pas
  décoder — « j'ai rien compris, putain tu écris tellement mal, tu formate
  n'importe comment, c'est imbittable » — et quatre propositions de rétro sont
  mortes du défaut symétrique le même jour, trop comprimées : « le reste j'ai
  pas compris, donc on laisse tomber pour l'instant ». Une idée par ligne, des
  phrases courtes, une question posée en trois temps — le fait, le problème,
  les issues — et une seule question à la fois quand la réponse compte. Motif
  de fond, dans ses mots : « il va falloir qu'on travaille sur la forme ».
  Aucun fichier `format.md` n'est créé : la piste a existé le temps d'un
  malentendu, elle est refermée.

- ✅ **G12 — On ne lance pas un Mason sans fichier de tâche.** Tranché par
  l'Owner le 2026-08-28, quand le Foreman a proposé de spawner un Mason pour
  réécrire une seule section d'un seul fichier : « Fais les 2 tâches toi-même.
  Pas de sous-agent à tout va, on lance pas un maçon sans une tâche (fichier). »
  Le contrat du Mason le suppose déjà — sa section `Inputs` s'ouvre sur « le
  fichier de spec (chemin, pas contenu collé) », ses cases d'implémentation sont
  son point de reprise, et son brief est « artefacts seulement ». Sans fichier,
  rien de tout cela n'existe et le spawn n'est plus qu'un coût.
  **Le manque de doctrine que ça révèle.** Le chantier 1 a rendu la délégation
  au Mason **obligatoire** — « la frappe passe toujours par le contrat du
  Mason », dans `socle/agents/methodology.md` et dans les Prohibitions du profil
  Foreman — sans exception pour le one-shot, alors que la règle du pont de
  `socle/agents/discipline.md` dit précisément qu'un one-shot n'a pas de fichier
  de spec. Les deux règles se croisent sans se voir : appliquées à la lettre,
  elles ordonnent de spawner un Mason pour un travail qui ne peut pas lui être
  briefé. Ce que la règle manquante doit dire n'est **pas** tranché ici : le
  Foreman avait proposé « le one-shot est frappé par la session qui possède le
  fil », et l'Owner a aussitôt refusé le cadrage — « je t'ai pas demandé de
  one-shot this ou autre » : personne n'avait décidé que ce travail était un
  one-shot, le Foreman l'avait classé seul. Le classement lui-même est la
  question ouverte G13 ci-dessous.
  Trois porteurs à corriger quand elle sera tranchée : le corollaire du
  gradient de coût de `methodology.md`, la première Prohibition de
  `socle/agents/profiles/foreman.md` (« Never types the code itself »), et la
  règle du pont de `discipline.md`, qui gagne le pendant de sa propre phrase.
  Consigné ici, non corrigé : ouvrir la tâche est la décision de l'Owner.

- ✅ **G13 — Le passage en mode « flow » est déclenché par l'humain, jamais
  classé par l'agent.** Question
  ouverte par l'Owner le 2026-08-28, en voyant le Foreman classer un travail
  tout seul : « je t'ai pas demandé de one-shot this ou autre. Faudrait p-e
  qu'on améliore / rende gated le fait de passer en mode flow ? »
  **Le constat, dans les deux sens.** Entrer dans le flow : la règle du pont de
  `socle/agents/discipline.md` dit de PROPOSER le pipeline quand une
  conversation devient du travail réel — « inform, never force » — mais une
  session qui reçoit un fichier de tâche y est déjà, sans proposition ni gate,
  et elle spawne ensuite des rôles sans que personne ait validé qu'on y entre.
  Sortir du flow : rien du tout. Aucune règle ne dit qui décide qu'un travail
  est assez petit pour se passer de fichier — le Foreman l'a décidé deux fois
  le même jour, dont une en proposant un Mason sans tâche à lui donner (G12).
  **Recommandation du Foreman, à trancher par l'Owner.** Ne pas inventer un
  mécanisme : le socle en a déjà un, le **sizing check**, déjà inconditionnel
  et déjà dit à voix haute, et qui pose déjà une question au même endroit
  (« light or full ? »). Il ne couvre aujourd'hui que le travail qui a DÉJÀ un
  fichier. Le remonter d'un cran : la première question du sizing check devient
  « est-ce que ça a besoin du pipeline du tout ? », posée à voix haute au moment
  où le travail est reconnu, et sa réponse est celle de l'humain, comme l'est
  déjà celle de « light or full ? ». Une réponse silencieuse à celle-là est un
  trou de revue, exactement comme les deux autres.
  Coût : le sizing check déménage de l'intérieur du pipeline vers son seuil, ce
  qui touche `socle/agents/methodology.md` (section « Why slicing is
  conditional »), la règle du pont de `discipline.md`, et le step `spec` des
  cinq formulas. À articuler avec le chantier 2, qui rouvre déjà les formulas.
  **Tranché par l'Owner le 2026-08-28.** Le mode ne se devine pas et ne se
  négocie pas : il se lit d'un acte explicite de l'humain, sous deux formes
  seulement — une nouvelle session ouverte en indiquant de travailler sur une
  tâche, ou `work on task` prononcé à un moment dans une session en cours. En
  dehors de ces deux formes, aucun agent n'entre dans le flow.
  **Le sens retour est réglé par la même phrase.** Une fois dans une session,
  les petites tâches qui apparaissent en chemin **ne déclenchent pas** de flow.
  L'exception est unique et cumulative : indication directe de l'utilisateur
  **et** un fichier de tâche créé. Sans fichier de tâche, on reste en mode
  **ambiant** — celui de la première version de Chisel, « plan, propose, do the
  work » — sans les steps supplémentaires : « ça doit grosso modo revenir à
  auto-light ».
  **Ce que la décision écarte.** La recommandation du Foreman ci-dessus
  (remonter le sizing check d'un cran pour que sa première question soit « est-ce
  que ça a besoin du pipeline ? ») devient sans objet plutôt que rejetée : si le
  déclencheur est un acte de l'humain, il n'y a plus de classement à faire
  valider par une question au seuil. Le sizing check reste où il est et garde son
  périmètre — le travail qui a déjà un fichier.
  **Ce que la décision referme, lecture du Foreman à confirmer à
  l'implémentation.** G12 laissait ouvert son propre corollaire : qui frappe un
  travail qui n'a pas de fichier. La réponse tombe ici — la session qui possède
  le fil, en mode ambiant, sans Maçon à spawner, puisqu'il n'y a rien à lui
  briefer. Le cadrage que l'Owner avait refusé au moment de G12 n'était pas faux
  sur le fond ; ce qui était fautif, c'était que le Foreman avait classé le
  travail tout seul. Le classement appartient à l'humain ; le mode ambiant est ce
  qui s'applique une fois qu'il a classé.
  **Porteurs à corriger quand ce sera exécuté** — les trois que G12 nommait déjà,
  auxquels la doctrine du déclencheur explicite s'ajoute : la règle du pont de
  `socle/agents/discipline.md`, qui gagne le pendant de sa propre phrase (pas de
  fichier → ambiant, et le pipeline ne s'ouvre que sur un acte de l'humain) ; le
  corollaire du gradient de coût de `socle/agents/methodology.md` ; et la
  première Prohibition du profil `socle/agents/profiles/foreman.md` (« Never
  types the code itself »), qui doit cesser d'ordonner un Maçon là où aucun
  fichier ne peut le briefer. Les cinq formulas ne bougent pas : le sizing check
  n'en sort plus.
  **Différé par l'Owner : « on fera ça plus tard. »** Non affecté à un chantier.
  Recoupement à surveiller : `discipline.md` et le profil Foreman sont aussi
  touchés par le chantier 2.

- ✅ **G14 — Le split spec / travail, tranché en interview le 2026-08-28.**
  Consigné ici parce que le Checker du `spec-review` a eu raison de le réclamer :
  la spec du chantier 2 s'appuyait sur des décisions prises en conversation et
  écrites nulle part, ce qui est exactement le défaut — une décision de l'Owner
  qui ne vit que dans un chat — que ce chantier existe pour supprimer. Les
  décisions ci-dessous priment sur le « suffixe pressenti `-work.md` » de la
  décision B5 et sur le « `***-work` » de la précision du 2026-08-28 : le tiret
  y était une hypothèse, pas un arbitrage.
  **(1) Nommage — les DEUX documents sont suffixés, avec un segment POINTÉ.**
  Proposition de l'Owner : « P-e qu'on peut aussi suffixer la spec ? Et utiliser
  `.spec` et pas `-spec` — `xxxx-my-task.spec.md`, `xxxx-my-task.work.md` ».
  Raison retenue : le point marque un genre de fichier (`.test.ts`,
  `.config.js`), le tiret se lirait comme un mot du nom. Deux gains constatés en
  posant la forme : la symétrie enlève la lecture « la spec, plus un
  appendice », et `.spec.md` trie avant `.work.md`, donc la surface de
  relecture arrive en premier dans l'arbre. Pour une slice :
  `<NN>-<slug>.spec.md` et `<NN>-<slug>.work.md`.
  **Formes écartées, avec leur motif** — `-work` seul : l'invocation
  `work on slice <fichier>` attend la spec, un fichier `-work` juste à côté rend
  la mauvaise invocation naturelle ; `-plan` : il y a une gate humaine sur le
  plan, donc un fichier nommé ainsi se lit comme quelque chose à approuver,
  ce qu'il n'est pas ; `-mason` : nomme un rôle renommable, et inexistant en
  mode ambiant ; `-log`, `-build`, `-scaffold` : collision avec le vocabulaire
  dev courant. `.task.md` a été proposé par l'Owner puis retiré par lui dans la
  même respiration — « Bon partons sur .spec ».
  **Idée consignée, non ouverte :** abandonner le mot « spec » du vocabulaire,
  pas seulement du nom de fichier — « p-e qu'on devrait laisser tomber le mot
  `spec` ». L'Owner l'a ouverte et refermée lui-même ; elle n'est pas un
  chantier.
  **(2) Un document de travail par fichier de spec qui est FRAPPÉ.** Une slice
  en a un, une tâche non découpée en a un ; le parent d'une tâche découpée a un
  `.spec.md` et jamais de `.work.md`, n'étant jamais frappé. Il est créé par le
  Maçon au step `plan` — ni par l'installeur, ni à l'avance — et vit dans le
  même dossier que sa spec. Conséquence utile : une spec sans document de
  travail à côté est une spec jamais frappée, et ça se lit sans rien ouvrir.
  **(3) La frontière des sections, arrêtée section par section.** Au
  `.spec.md` : Context, Scope, Acceptance Criteria, Seams, Architecture /
  system design, Implementation Decisions, Testing Strategy, Slices &
  Dependencies, Deliverables, References, et la Retrospective écrite au
  `close`. Au `.work.md` : le program design et le pseudo-code, le worklog, les
  cases d'implémentation, Notes & Snippets, et les findings de review de
  l'Inspector. Les trois lignes que le Foreman donnait pour contestables —
  Deliverables, Testing Strategy, Retrospective — sont toutes tranchées côté
  spec.
  **(4) La review du `.work.md` est celle de l'INSPECTOR, pas celle de
  l'Owner.** Correction de l'Owner, mot pour mot : « La review n'est pas un truc
  écrit pas l'owner, c'est écrit pas l'Inspector. Ma review à moi se fait dans
  le chat ou via un autre channel. » La sienne n'est donc une section d'aucun
  fichier. La Retrospective est un autre artefact et reste dans la spec.
  **(5) Cycle de vie : commité, régénérable en vol, archivé au `close`.**
  Définition de l'Owner : « supprimable veut simplement dire qu'on peut le
  supprimer, modifier la spec, et repartir ». La fenêtre de suppression se ferme
  au `close`, où le document part à l'archive avec sa spec et n'est jamais
  supprimé. Trois raisons de ne pas le jeter : le `diff-review` lit le program
  design comme pièce à conviction, la section « Sources » du skill `retro`
  nomme le worklog, et la règle 8 de `socle/agents/discipline.md` fait du dépôt
  la seule mémoire.
  **(6) Migration : « on laisse l'historique `done` tel quel, mais renomme les
  taches à faire. »** Inventaire vérifié : six fichiers non terminés sous
  `project-management/tasks/`, l'archive intacte, et tout le reste de `tasks/`
  au vert garde son nom.
  **(7) La zone 🤖 disparaît de la spec.** Le `.spec.md` ne garde que ses deux
  zones 🧑 ; le `.work.md` ne porte aucun marqueur, appartenant au Maçon en
  entier. Effet recherché : « le Maçon n'édite jamais une zone 🧑 » et « le
  Maçon n'édite jamais la spec » deviennent la même phrase.
  **(8) Deux templates**, `project-management/000-template.spec.md` et
  `000-template.work.md`, tous deux fichiers managés du CLI. L'ancien
  `000-task-file-template.md` restera orphelin sur un projet déjà équipé —
  troisième orphelin de sa classe, il rejoint la liste de nettoyage du
  chantier 4 (port Deno).

## Addendum 3 (2026-09-02) — arbitrage S1 : la trace des blocages

- ✅ **G15 — Tout blocage laisse une trace écrite ; elle vit dans les documents
  de la tâche, pas dans le journal du projet.** Tranché à l'oral (2026-09-02),
  en arbitrage du finding S1 de l'Inspector sur les quatre commits de la
  slice 02 (le doctrine livré exigeait un « signal projet partagé » — ligne ⚠️
  datée au journal — que ni la spec parente ni ce fichier n'autorisaient).
  **(1) La traçabilité est ratifiée, la destination est amendée.** Tout
  blocage, dans tous les modes, même quand l'Owner est disponible à l'oral,
  laisse une trace écrite. Mais « c'est pas dans le journal du projet, c'est
  dans les documents de travail » : chaque rôle écrit ses notes dans le
  document qu'il travaille — le Maçon dans le `.work.md`, l'Architecte dans le
  `.spec.md` (ses notes pré-`plan`). La ligne ⚠️ obligatoire au journal
  disparaît de la règle.
  **(2) La forme de la trace : qui, quand.** Chaque note de blocage porte le
  rôle de son auteur et la date **et l'heure** — « qu'on sache, qu'on a un peu
  de traçabilité ». Et si l'Owner répond (à l'oral ou autrement), **sa réponse
  est notée aussi**, au même endroit.
  **(3) L'escalade est ratifiée telle que livrée** : ça remonte toujours d'un
  cran ; au-dessus du Foreman, l'humain, point. La clause supprimée
  (« l'humain n'en entend jamais parler ») reste supprimée.
  **(4) Clarification du Foreman par mode**, dans la ligne de B3(c) : en mode
  default, **l'humain est le Foreman** — la session principale, pas de
  sous-agent Foreman intermédiaire (« un sous-agent de trop et ça consomme
  beaucoup ») ; l'humain parle directement à l'Architecte. En mode auto, un
  Foreman agent existe et orchestre ; il tranche rarement — « il a assez peu
  de connaissances du projet, c'est plus un orchestrateur qu'autre chose » —
  et ce qu'il ne possède pas remonte à l'humain.
  **(5) Le canal de découverte d'une tâche bloquée, tranché le même jour.**
  Pas de signal partagé dédié : en auto sans beads, « je suis dans mon IDE ou
  terminal, l'agent me dit que c'est bloqué » — la session rapporte le blocage
  directement à l'humain quand le run s'arrête. Avec beads, « on utilise la
  feature native de status dans beads » — le bead de la tâche passe au statut
  bloqué ; le bead `escalation` séparé assigné à l'Owner disparaît avec la
  ligne ⚠️ au journal.
  **(6) « L'architecte démarre un maçon » était une façon de parler.**
  Confirmé le même jour : B3(c) tient — l'Architecte rend un artefact et ne
  pilote personne ; c'est le propriétaire du fil qui ouvre la session Mason.
  **(7) Toute décision sur un blocage est tracée, pas seulement celles de
  l'Owner.** Tranché (2026-09-02), sur question remontée par l'Architecte au
  plan-review du round 5 : quiconque tranche un blocage — l'Owner ou le
  Foreman en auto — sa décision est notée au même endroit que la trace du
  blocage, signée rôle + date et heure. Le point (2) se lit donc « quiconque
  répond », l'Owner en étant le cas nommé.

## Addendum 4 (2026-09-02) — réutilisation des rôles, et où vit la mémoire

- ✅ **G16 — Reviewers frais, Maçon réutilisé dans un fil vivant.** Tranché à
  l'oral (2026-09-02), pendant la slice 03 du chantier 2. Les rôles de
  jugement (Architect, Inspector) sont spawnes **frais** quand ils découvrent
  un travail — séparation des pouvoirs ; le même Architect peut re-valider un
  plan qu'il vient de retoquer (il vérifie la résolution de ses propres
  findings). Le **Maçon est réutilisé** : celui qui écrit le plan porte aussi
  les corrections du plan-review ET l'implémentation — « inutile de créer un
  second maçon ». Le « build fresh from the spec/work pair » de la
  méthodologie reste vrai pour la **reprise** (fil interrompu, autre session,
  autre jour) : c'est ce que le document de travail persisté garantit, pas la
  continuité d'un fil vivant.
  **Porteur dû, par la porte des propositions :** cette règle doit vivre dans
  le socle (le profil Foreman, qui possède le spawn, et/ou la méthodologie),
  hors de toute carte de slice du chantier 2 — à embarquer avec les résidus
  `AGENTS.md` / `profiles/README.md` déjà consignés.
- ✅ **G17 — Rien de ce projet ne va dans la mémoire privée d'un assistant.**
  Tranché à l'oral (2026-09-02), verbatim : « Ta mémoire, je m'en fous. Moi,
  je veux enregistrer ça dans chisel. Il faut que les futurs toi ne fassent
  pas la même erreur — et les futurs toi, c'est pas forcément des Claude. »
  Toute connaissance qui mérite de survivre est persistée dans le dépôt — le
  code, les documents de tâche, ce fichier de décisions, la doctrine — jamais
  dans la mémoire propre d'un outil. Appliqué sur-le-champ : la note de
  mémoire écrite plus tôt ce jour est supprimée, remplacée par G16 ici et par
  une ligne d'instruction dans `AGENTS.md`.
