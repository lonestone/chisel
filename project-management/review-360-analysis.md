# Review 360 — v2 (2026-09-02)

Rapport comparatif entre les notes manuscrites de l'Owner
(`review-360-notes.md`) et l'état du repo au 2026-09-02 (branche `review-360`,
120 commits). Il remplace une première version du même jour qui lisait Crucible
de travers.

Crucible, tel que l'Owner le définit : un repo « projet standard » avec une
codebase, des tâches et des scripts pour lancer différents workflows IA, puis
comparer des métriques. Pas d'orchestrateur. C'est un banc d'essai.

**Légende des verdicts** : ✅ garder · 🔧 changer · ❌ retirer · ❓ à trancher.

---

## 1. Verdict global

**La direction est bonne.** Tes notes et le repo disent la même chose sur le
fond : neuf étapes, deux gates humaines, quatre rôles plus l'humain, un thread
pour la spec et un pour l'implémentation, un modèle cher pour penser et un moins
cher pour taper, une trace écrite de tout. La v2 n'a pas dévié de la v1 ; elle
l'a formalisée. Ce qui a été construit n'est pas à jeter.

**Ce qui a dérapé, c'est la forme et l'ordre.** La forme : trop de fichiers
portent chaque concept, la prose est longue, les codes remplacent les noms, cinq
presets sont maintenus pour un seul utilisé. L'ordre : le socle a été formalisé,
audité et remodelé trois fois sans être installé une seule fois, ni ici ni sur
un pilote. La v1 avait fait l'inverse, et c'est pour ça qu'elle était «
efficace, simple, token efficient ».

**L'organisation des fichiers est bonne dans son découpage** (discipline,
méthodologie, formulas, profils, skills, templates, glue) **et mauvaise dans sa
distribution** : le même concept est écrit dans quatre à six fichiers au lieu
d'un. Le repo énonce lui-même la règle « une source normative par concept » et
ne la tient pas.

**Les use cases factory ne sont pas du travail perdu.** Environ la moitié du use
case « mode auto avec Plane » existe déjà dans le socle. Ce qui manque est
identifiable et listé en §5. Le désaccord de la première version de ce rapport
est retiré : la factory est une direction légitime, la question est seulement
_quand_ et _dans quels fichiers_.

---

## 2. Tes notes, point par point, face au repo

### Page 1 — les grandes étapes et les notes

| Ta note                                                                                                  | Ce que le repo a                                                                                                                                                                                               | Verdict                                                                               |
| -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Les 9 étapes (grill → spec → review spec → gate → code + plan → lint/test → review auto → gate → commit) | La formula `chisel-default` a 9 steps : interview, spec, spec-review, plan, plan-review, type, verify, diff-review, close. Une seule différence : `plan-review`, où un Architect frais valide le plan du Mason | ✅ Identique. `plan-review` est la seule addition, et `chisel-light` la retire déjà   |
| « On peut inverser gate et commit »                                                                      | La spec est commitée dès le step `spec` ; le code est commité au `close`, après arbitrage                                                                                                                      | ✅ Réglé pour la spec. Pour le code, le commit avant review est une option non écrite |
| IDE ou terminal, human-in-the-loop, ça réduit les besoins de sync                                        | Mode default : l'humain relance chaque step ; G15(4) « en default, l'humain est le Foreman »                                                                                                                   | ✅ C'est exactement le default                                                        |
| Traçabilité indispensable, artefacts ou db sqlite / git                                                  | Fichiers spec + work dans le repo, registre de décisions, CHANGELOG, trace de blocage signée rôle + date + heure (G15). Beads en option : c'est précisément une db sqlite versionnée dans git                  | ✅ Ta question a déjà sa réponse : markdown par défaut, beads quand on veut requêter  |
| Sous-agent : fonctionne, coût en tokens très élevé, à challenger                                         | Default = 5 spawns par tâche (Architect, Checker, Mason, Architect au plan-review, Inspector). Light = 2 (Architect, Mason). **Aucune mesure de coût dans le repo**                                            | ❓ Se tranche avec Crucible, pas sur avis. Voir décision A                            |
| Séparation forte archi / maçon, modèles différents                                                       | Tiers frontier / mid / cheap, cascade user.md > project.md > défaut du socle                                                                                                                                   | ✅                                                                                    |
| Efficacité éprouvée : 1 thread archi, 1 thread implém, + option sous-agent review à la fin               | C'est `chisel-light` exactement. Le **default** du socle est plus lourd que ce que tu dis avoir éprouvé                                                                                                        | 🔧 Le preset par défaut devrait être celui qui a fait ses preuves. Voir décision A    |

### Page 2 — les deux sessions, les rôles

| Ta note                                                                                 | Ce que le repo a                                                                                                                                                               | Verdict                                                                                                                                                           |
| --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Session 1 (grill, validation, spec, review) / Session 2 (lecture, plan, implém, review) | Séparateur CREATE / WORK dans les formulas ; « the session that creates does not implement »                                                                                   | ✅                                                                                                                                                                |
| Aucune orchestration, l'humain fait beaucoup sur le pouce                               | Default : « the human relaunches every step »                                                                                                                                  | ✅ Assumé et écrit                                                                                                                                                |
| 4 rôles : Architect, Maçon, Spec-reviewer, Code-reviewer                                | 5 profils : Architect, Mason, Checker, Inspector, **Foreman**. En default le Foreman est l'humain (G15-4)                                                                      | ✅ pour les 4. 🔧 pour le Foreman : un profil de 183 lignes pour un rôle que l'humain tient en default. Il n'a de sens qu'en supervised / auto. Voir §3           |
| Les 2 s'exécutent à la file ; jamais du long horizon, ça c'est ailleurs (Plane, Linear) | Le socle fait du long horizon en interne : parent + slices avec graphe de blocages, `wayfinder` (vendorisé, chantier 6 « local-first » prévu), concept Frontier, beads `ready` | ❓ Tension réelle. Le graphe de slices d'une feature est utile et court. `wayfinder` (épics, roadmap) fait ce que tu dis vouloir laisser à Plane. Voir décision F |
| Spec-reviewer et code-reviewer : coût fort, valeur                                      | Checker et Inspector, frais, jamais auteurs                                                                                                                                    | ✅                                                                                                                                                                |
| Chisel v1 : 1 fichier par tâche, pas de fiche rôle                                      | Templates spec + work, 5 profils                                                                                                                                               | ✅ La v2 a répondu                                                                                                                                                |
| But : MAJ facile + compatible tout projet                                               | `chisel init / update / check`, blocs managés, manifeste, glue A–H dans un seul fichier, 9 scénarios de test                                                                   | ✅ **C'est la partie la plus solide du repo**, la seule avec une preuve mécanique                                                                                 |

### Page 3 — lacunes et avantages de la v1

| Ta note                                                           | Ce que le repo a                                                                                                                                                             | Verdict                                                     |
| ----------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| Lacune : pas clair ce qu'il fallait relire                        | Gradient de lecture (deux zones 🧑), puis split spec / work : le Mason n'écrit plus jamais dans le fichier que l'humain relit                                                | ✅ Résolu structurellement. Non éprouvé sur une vraie tâche |
| Lacune : pas de rôle, incompatible factory                        | Profils avec Inputs, spawn = profil verbatim + brief (G5)                                                                                                                    | ✅                                                          |
| Lacune : workflows en prose, pas dans un format solide            | 5 formulas TOML                                                                                                                                                              | ✅ fait, 🔧 forme à revoir. Voir décision B                 |
| Avantages v1 : efficace, simple, token efficient                  | La v2 a perdu « simple » (mesuré : 3 lignes de méta par ligne de produit). « Efficace » et « token efficient » ne sont pas mesurés                                           | 🔧                                                          |
| Question : factory dans le même repo, bonne idée ?                | E1 a dégradé la claim « Factory = auto × beads » le 27/08, mais les 3 presets sans gate et la doctrine par mode restent dans les fichiers du default                         | ❓ Voir décision C                                          |
| Question : rôles et workflows code-based nécessaires ? Pourquoi ? | Profils : oui, pour une raison vécue (G5, framing improvisé non versionné) et parce que Claude Code et Codex les consomment. Formulas TOML : rien ne les exécute aujourd'hui | ✅ profils · ❓ TOML                                        |

### Page 3 — la v2 désagréable à utiliser

| Ta remarque                                                               | Ce que je constate                                                                                                                                                                                                       | Verdict                                                                             |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------- |
| Claude cite des codes partout (G15, SP1, ST-B)                            | Ruling C1 interdit les codes. Mais le registre de décisions est **indexé** par codes (A1…G17), et la spec du split cite « G14 » 14 fois. Le système produit ce qu'il interdit                                            | 🔧 Décision D                                                                       |
| Hyper dur de savoir où j'en suis, le RAF                                  | Les tâches parentes v1 et v2 affichent 🔴 Not Started alors que leurs slices sont toutes Complete. Il n'existe aucun fichier qui dise ce qui reste. Le plan d'action (8 chantiers) est en fin d'un fichier de 866 lignes | 🔧 Priorité 2                                                                       |
| Claude gibberish, lecture galère, passations aussi                        | Entrées CHANGELOG de 31, 38, 55 lignes pour une tâche fermée. Fichiers de slice de 700 à 1 900 lignes. Le style « prose, jamais de liste » imposé par plusieurs rulings produit exactement ça                            | 🔧 Décision E                                                                       |
| Maintenance galère, références partout                                    | Mesuré sur les 12 derniers commits : methodology touché 5 fois, discipline 4, chaque profil 3-4, bloc AGENTS 3, 2 formulas. Un changement de doctrine touche 10 à 12 fichiers                                            | 🔧 §3 et priorité 3                                                                 |
| Les workflows beads, format toml/json, nous lient à beads                 | Vrai : le format formula (`[[steps]]`, `needs`, `[steps.gate]`) vient de beads/gastown. L'inconnue « ce que beads attend d'un dossier formulas » n'a jamais été levée (G7, G8)                                           | ❓ Décision B                                                                       |
| Peut-être que la duplication vaut mieux que du générique chiant           | Le repo a fait les deux à la fois, dans le mauvais sens : les formulas sont **dupliquées** 5 fois alors qu'elles diffèrent d'une ligne par step, et la doctrine est **générique** là où le lecteur voudrait du concret   | 🔧 Inverser : une formula, cinq deltas ; une doctrine par mode dans un seul fichier |
| Les rôles, sauf le Foreman, ne devraient pas connaître le contexte global | C'est déjà la doctrine : le Mason reçoit « artifacts only, never the planning conversation »                                                                                                                             | ✅ Tu as redécouvert une règle écrite mais jamais exercée                           |
| Ce qui implique de bien les prompter au lancement, plus complexe qu'en v1 | G5 : profil collé verbatim + brief composé depuis la section Inputs. Zéro doctrine inventée au spawn                                                                                                                     | ✅ Répond exactement à ta remarque                                                  |

### Page 4 — questions ouvertes

| Ta question                                    | Réponse de ce rapport                                                                                                                                                              |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Séparer en deux versions de Chisel ?           | Décision C                                                                                                                                                                         |
| Que récupérer de la v2 ?                       | §6                                                                                                                                                                                 |
| Comment simplifier ?                           | §6, priorités 2 et 3                                                                                                                                                               |
| Un canal de com entre agents en mode factory ? | Utile seulement avec des agents concurrents. Aujourd'hui les agents se passent des fichiers via le thread owner, et ça suffit à un pipeline séquentiel. À rouvrir quand UC2 tourne |

---

## 3. Organisation des fichiers et de la documentation

### Le socle (`socle/`)

| Couche                      | Taille                 | Verdict               | Pourquoi                                                                                                                                                                                                                                                                          |
| --------------------------- | ---------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `discipline.md`             | 12 règles              | ✅ objet · 🔧 contenu | Les règles 1 à 8 sont de la discipline ambiante. 9 et 10 sont de la plomberie de rôles, 11 est un comportement du CLI, 12 est une règle d'écriture. Sept règles suffiraient ; les autres ont une maison ailleurs                                                                  |
| `methodology.md`            | 446 lignes             | 🔧                    | Annoncé comme « le pourquoi », il porte aussi du normatif : glossaire, zone ownership par preset, forme de la trace de blocage, cascade des tiers. Le ruling E4 (chantier 5) a déjà décidé l'extraction. Il faut la faire : un « pourquoi » court et stable, une référence à part |
| `formulas/`                 | 5 × ~220 lignes        | 🔧                    | Cinq copies qui diffèrent d'une ligne par step, sans garde anti-drift (finding E3 accepté, non résolu). Les 20 à 40 lignes de commentaires par fichier répètent la doctrine des autres couches. Voir décision B                                                                   |
| `profiles/`                 | 5 × ~140 lignes        | ✅                    | Bon objet : un contrat par rôle, avec Inputs. Un bémol : le profil Foreman n'a d'usage réel qu'en supervised / auto                                                                                                                                                               |
| `skills/`                   | 20, dont 17 vendorisés | ✅                    | Rien à changer dans la mécanique. Le ruling G9 (les skills vendorisés contredisent la doctrine) est ouvert. Trois skills ne sont pas du socle utilisateur : `sync-upstream` (mainteneur, déménagement déjà tranché), `upgrade-v2` (jetable), `wayfinder` (décision F)             |
| `templates/` spec + work    | 182 + 149 lignes       | ✅                    | Bons objets. La prose « Standards » autour des templates redit la méthodologie ; le template proprement dit fait 70 lignes                                                                                                                                                        |
| `project.md.tpl` (glue A–H) | 201 lignes             | ✅                    | Une seule place pour tout ce qui est propre au projet. C'est ce qui permet `update` sans conflit                                                                                                                                                                                  |
| `bin/chisel.sh` + `test/`   | 851 + 592 lignes       | ✅                    | Seule partie du repo prouvée mécaniquement. Le port Deno est tranché ; il n'est pas urgent                                                                                                                                                                                        |

**Le défaut n'est pas le découpage, c'est la distribution.** Exemple mesurable :
« qui possède une zone 🧑 selon le preset » est écrit dans methodology (Zone
ownership), dans le template spec (table des zones), dans l'en-tête des 5
formulas, dans les profils Mason et Architect, et dans le bloc AGENTS. Le repo
énonce la règle « une source normative par concept, ailleurs des pointeurs »
(slice 07 de la v2) et ne la tient pas. Chaque ruling repasse donc dans 10 à 12
fichiers.

### La gestion de projet (`project-management/`)

| Élément                       | État                                                                                        | Verdict                                                                                  |
| ----------------------------- | ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Fichiers de tâche et de slice | 700 à 1 900 lignes par slice                                                                | 🔧 Le gradient met le long en bas, mais le long est là et il se relit à chaque passation |
| `CHANGELOG.md`                | 23 entrées, les 3 dernières font 31, 38, 55 lignes                                          | 🔧 Une entrée devrait tenir en un écran. Décision E                                      |
| `review-360-decisions.md`     | 866 lignes, 40 rulings indexés par code                                                     | ✅ l'objet · 🔧 la forme (décision D)                                                    |
| Statuts                       | v1 et v2 parents « Not Started », slices « Complete » ; « dogfood » bloquée depuis le 26/08 | 🔧 Priorité 2                                                                            |
| Vue « où on en est »          | N'existe pas                                                                                | 🔧 Priorité 2                                                                            |
| `AGENTS.md` du repo           | Décrit le flow v1, pointe un template qui n'existe plus sous ce nom                         | 🔧 Priorité 2                                                                            |
| Archive                       | 1 tâche archivée (remodel), dossier + fichier parent ensemble                               | ✅                                                                                       |

---

## 4. Ce que la v2 a réellement apporté

À garder, avec la preuve :

1. **Le CLI et sa suite** : installe, met à jour, détecte la dérive, 9 scénarios
   verts. Preuve mécanique.
2. **Le gradient de lecture puis le split spec / work** : réponse structurelle à
   la lacune n°1 de la v1. Résout un vrai conflit (le Mason interdit d'écrire là
   où la formula lui ordonnait d'écrire).
3. **Les profils comme prompt de spawn versionné** (G5) : règle simple qui
   élimine un risque vécu (framing improvisé, variable selon le modèle).
4. **Les ACs nommés, jamais effacés** (C4).
5. **Le registre de décisions** comme objet : le « pourquoi » est retrouvable.
6. **Le repo est la seule mémoire** (G17).
7. **La cascade des tiers** : inoffensive, prose-only, et elle retire les noms
   de modèles du socle.
8. **La convention beads** : frontière nette (le bead coordonne entre tâches, le
   fichier porte tout le reste, `--spec-id` pointe). Elle est la moitié du UC1
   et n'a rien coûté au default.

Sans preuve d'usage à ce jour, à ne pas étendre avant d'en avoir une : les trois
presets sans gate humaine, le Foreman agent, `upgrade-v2`, `wayfinder`.

---

## 5. Les deux use cases factory face au socle

### 5.1 Mode auto avec Plane (page 5)

| Étape                                                                  | Déjà dans le socle                                                                                                                                                                        | À construire                                                                                                                                                                     |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1. PM met un ticket dans Plane                                         | Glue §B2 « Link to an external tracker », champ `external_ref` réservé sur le bead, page adaptateur prévue                                                                                | L'adaptateur Plane lui-même (lire un ticket, écrire un commentaire, lire un statut)                                                                                              |
| 2. Agent analyse, grill-me async, questions dans Plane                 | Skill `grilling` (conversationnel)                                                                                                                                                        | Une variante par lot : toutes les questions d'un coup, chacune avec sa réponse recommandée, postées dans le ticket                                                               |
| 3. Cron spot les réponses PM                                           | Rien                                                                                                                                                                                      | Un lanceur : quelque chose qui démarre une session sur un step quand un événement arrive                                                                                         |
| 4. Architect écrit la spec, bead + commentaire Plane                   | Profil Architect ; convention beads ; la spec vit dans le repo et le bead pointe dessus                                                                                                   | Le commentaire Plane. Ta note « stockage dans beads » : non, la spec reste un fichier, c'est ce que la convention dit, et c'est ce qui rend la review humaine possible (étape 5) |
| 5. Review humaine de la spec dans Plane                                | **`chisel-supervised` est exactement cette gate**. Mode dégradé écrit : statut `awaiting approval`, session terminée, « nothing polls and nothing notifies », une session fraîche reprend | La reprise déclenchée par Plane au lieu d'un humain qui relance                                                                                                                  |
| 6. PM bouge en « todo »                                                | Rien                                                                                                                                                                                      | Le pont Plane → statut. C'est le signal de reprise de l'étape 5                                                                                                                  |
| 7. Mason implémente avec sous-agent review ; blocage → fichier + Plane | Mason, Inspector, trace de blocage signée dans le `.work.md` (G15), escalade                                                                                                              | L'écriture Plane du blocage. Et « appel à un agent plus frontier » : le Mason n'a qu'un geste, bloquer et rapporter ; il n'a pas de canal question vers l'Architect              |
| 8. Auto review, push, branche, PR                                      | `diff-review`, `close` avec commit et push par le Foreman                                                                                                                                 | Une convention branche / worktree / PR. Le socle n'en a aucune                                                                                                                   |
| 9. Review humaine, validation Plane, merge                             | Rien                                                                                                                                                                                      | Le merge, l'intégration GitHub, la seconde gate                                                                                                                                  |

Couverture : environ la moitié. Les rôles, les gates, la trace et la convention
beads existent. Manquent : l'adaptateur Plane, le grilling par lot, le lanceur,
la convention PR/merge.

Trois choses que ce schéma révèle sur le socle :

- **UC1 a deux gates humaines, spec et PR, et pas de gate plan.** Aucun des cinq
  presets n'a cette forme. L'axe des gates compte les gates (3 / 1 / 0) ; ton
  usage les choisit par position. Un preset devrait dire _quelles_ gates, pas
  _combien_.
- **UC1 déclenche la spec et le travail sur deux événements différents** (ticket
  créé, ticket passé en todo). C'est la scission de la formula en deux que G7 a
  différée puis refermée. Ton schéma la rouvre avec un argument que G7 n'avait
  pas.
- **UC1 tient deux registres de statut**, Plane et beads. Chaque transition
  s'écrit deux fois. Si Plane est la file, beads n'apporte plus que `ready` par
  graphe de blocages et le claim avec lease. À décider si ça vaut une seconde
  base.

### 5.2 Version encore plus automatique (page 6)

| Étape                                                   | Déjà dans le socle                             | À construire                                                                                                                                          |
| ------------------------------------------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Wayfinding local → epics / tickets dans Plane ou Linear | `wayfinder` vendorisé, chantier 6 non commencé | La cible Plane / Linear ; où stocker la doc markdown générée                                                                                          |
| Orchestrateur trouve la next step d'un chantier         | Concept Frontier, `bd ready` avec beads        | L'orchestrateur lui-même : le Foreman du socle **est la session invocante**, il meurt avec elle. UC2 a besoin d'un Foreman qui vit entre les sessions |
| Architect grill-me, humain répond async                 | Comme UC1 étape 2                              | Idem ; ta note en marge (« frustrant en async, top si dynamique et conclusions conservées ») est la vraie inconnue de design                          |
| Task ready, orchestrateur la chope                      | Claim + vérification d'assignee (chisel-beads) | L'acteur qui chope                                                                                                                                    |
| Mason implémente, sous-agents question + review         | Inspector oui ; question non                   | Le canal question                                                                                                                                     |
| MAJ ticket, PR ; loop humain si décision                | G15 pour la loop                               | Ticket + PR, comme UC1                                                                                                                                |
| Review humaine → merge                                  | Rien                                           | Comme UC1                                                                                                                                             |
| VM Daytona                                              | Rien                                           | Sandbox pour un Mason sans humain : sécurité, pas méthodo                                                                                             |

### 5.3 Ce que les deux schémas ont en commun

Un seul objet manque partout : **un Foreman qui est un processus, pas une
session** : il écoute un événement (Plane, GitHub), reprend une formula au step
suivant depuis un état persisté, spawne un rôle avec son profil, écrit dehors.
Le statut `awaiting approval` du mode supervised est le début de cette idée.
Aucun des huit chantiers du plan d'action ne le contient.

Ce que le socle a et que tes schémas n'ont pas : le Checker (review auto de la
spec) et le `plan-review`. Si les UC sont la cible, ce sont des options, pas le
défaut.

### 5.4 Le lien avec Crucible

Crucible lancera des workflows par script. Pour qu'un workflow Chisel soit
lançable par script, il faut pouvoir démarrer une formula sur une tâche sans
humain devant : c'est ce que `chisel-auto` et `chisel-auto-light` sont conçus
pour être, et c'est aussi la première brique du lanceur de UC1 (étape 3). Même
primitive, deux usages. Ce n'est pas un orchestrateur dans Crucible ; c'est une
commande d'entrée dans Chisel, que le socle n'a pas encore.

Conséquence pour Crucible : sans humain, il ne pourra comparer que les presets
sans gate. Pour mesurer default ou light, il faudra un « Owner-bot » qui répond
aux questions et approuve les specs, ou accepter que ces presets se mesurent
avec un humain dans la boucle. À poser dans la spec de Crucible.

---

## 6. Décisions à trancher

Chaque bloc : le fait, les options, ma recommandation.

**A · Le preset par défaut.** Fait : le default fait 5 spawns par tâche ; ce que
tu as éprouvé est light (2 spawns). Aucune mesure. Options : garder default ;
passer light par défaut ; attendre Crucible. Reco : **light par défaut** dès
maintenant, parce que c'est le seul preset avec une preuve d'usage, et Crucible
dira plus tard si les 3 sous-agents en plus valent leur coût.

**B · La forme des formulas.** Fait : 5 fichiers TOML de 220 lignes, lus par un
LLM comme une checklist, exécutés par rien. Options : (1) garder les 5 ; (2) une
formula default en TOML et une table de deltas pour les autres presets ; (3)
repasser en markdown. Reco : **(2) maintenant**, sans trancher TOML ou markdown
: la question du format se tranchera quand un lanceur existera (Crucible ou
UC1), et un seul fichier à convertir coûte moins que cinq. Ne plus ajouter de
preset.

**C · La factory dans le même repo.** Fait : les concepts auto et beads sont
mélangés aux fichiers du default (methodology, discipline, templates, bloc
AGENTS). Options : (a) un seul repo, tout mélangé ; (b) **un seul repo, une
seule maison pour la doctrine des modes sans gate** (un fichier ou un dossier
`auto`, pointé depuis le default, jamais l'inverse) ; (c) deux repos. Reco :
**(b)**. La séparation utile est par fichier, pas par repo. Le default cesse de
payer la factory à chaque ruling, et la factory reste là pour UC1.

**D · Le registre des décisions.** Fait : indexé par codes alors que C1 les
interdit. Options : garder ; indexer par titre et garder le code en suffixe.
Reco : **par titre**, une ligne par décision en tête de fichier comme index, et
les tâches citent « le ruling sur le split spec / travail », pas « G14 ».

**E · La verbosité.** Fait : G2 refuse toute limite chiffrée ; les entrées
CHANGELOG font 55 lignes. Options : rien ; une limite qualitative (« une entrée
tient en un écran », « une slice se résume en dix lignes en tête »). Reco : **la
limite qualitative**, dans les deux templates et dans le profil Foreman,
contrôlée par le Checker comme G1 le prévoit déjà pour le reste.

**F · Le long horizon.** Fait : tu dis que c'est ailleurs (Plane, Linear) ; le
socle a `wayfinder` et prévoit un chantier pour l'adapter. Options : garder ;
retirer du socle et le garder dans le repo comme skill mainteneur ; le brancher
sur Plane (UC2). Reco : **le sortir du socle installé**, et laisser UC2 décider
s'il revient en version Plane.

**G · Le dogfood.** Fait : bloqué depuis le 26/08 « tant que le socle bouge ».
Reco : **débloquer maintenant**, dès la slice 04 fermée. Le socle ne s'arrêtera
pas de bouger tant que personne ne l'utilise.

**H · Le port Deno.** Fait : tranché D5, aucun bug bloquant. Reco : **après tout
le reste**. Le bash marche et est testé.

---

## 7. Priorités

Dans l'ordre. Chaque item dit ce qu'il produit.

1. **Fermer le split spec / work** (slice 04, la dernière). Sinon le socle
   décrit deux modèles à la fois. Une slice, déjà spécifiée.

2. **Rendre l'état lisible et installer le socle ici.** `chisel init` sur ce
   repo, `AGENTS.md` réécrit contre la réalité, statuts parents corrigés, un
   fichier court qui dit ce qui est fait et ce qui reste. Puis **une vraie tâche
   sous le socle installé, en light, doctrine gelée pendant qu'elle tourne**.
   C'est la tâche « dogfood » écrite le 26/08. Elle dira en une session ce que
   six jours de relecture n'ont pas dit : si le TOML gêne, si le Foreman a un
   sens quand c'est toi, ce qui manque dans les profils.

3. **Réduire les porteurs.** Dans cet ordre : methodology scindée en « pourquoi
   » court et référence (chantier 5, déjà tranché) ; une formula default plus
   une table de deltas (décision B) ; la doctrine des modes sans gate dans une
   seule maison (décision C) ; le registre indexé par titres (décision D) ; la
   limite qualitative de longueur (décision E). Après ça, un ruling touche 2 ou
   3 fichiers au lieu de 12.

4. **Une commande d'entrée pour lancer une formula par script.** C'est ce que
   Crucible attend de Chisel pour le benchmarker, et c'est la brique de base du
   lanceur de UC1. À spécifier avec Crucible : quels arguments (formula, spec,
   preset), quelle sortie (statut, artefacts, coût en tokens). Les presets auto
   et auto-light prennent ici leur premier usage réel.

5. **UC1, mode auto avec Plane**, dans l'ordre où les briques se débloquent :
   l'adaptateur Plane (§B2) ; le grilling par lot ; la scission de la formula
   sur les deux événements (G7 rouvert) ; la convention branche / PR / merge au
   `close` ; le lanceur sur événement. Chaque brique est une tâche, et chacune
   est utile seule avant la suivante.

6. **Ensuite** : le port Deno (H), l'audit des skills vendorisés (G9), le
   wayfinder si UC2 le rappelle, UC2.

Ce qui s'arrête : les rulings de doctrine sans usage derrière. Entre les
priorités 2 et 4, la règle est « on ne change la doctrine que sur un fait
observé en session, pas sur une relecture ».

---

## 8. Ce que je ne peux pas juger

- Le coût réel des sous-agents : aucune mesure. C'est la première chose que
  Crucible produira.
- Si Cursor lit `AGENTS.md` seul de façon fiable : le test prévu (v1 slice 06)
  n'a jamais été fait.
- Le contenu de `factory-bench` et de Crucible : hors de ce repo, non lus.
