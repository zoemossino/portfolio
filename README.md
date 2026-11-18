# Portfolio — Zoé Mossino

Site statique (HTML / CSS / JS, sans dépendance ni abonnement). Il peut être hébergé n'importe où et relié à un nom de domaine privé.

## Contenu du dossier

| Élément | Rôle |
| --- | --- |
| `index.html` | Accueil : index des projets |
| `branding.html` | Galamoon, Spottid, Olivas |
| `art-direction.html` | Même pas sourd, La Patate Groove |
| `layout.html` | CBRE |
| `corporate.html` | MyReport |
| `404.html` | Page d'erreur |
| `assets/` | Design, script, police, images, vidéos et CV : tout ce qui est en ligne |
| `tools/build.rb` | Générateur des pages : textes des projets, ordre de l'accueil, couleurs, e-mail, CV |
| `tools/grid.rb` | Grille de chaque projet : quelles images, dans quel ordre, par rangées |
| `tools/export.rb` | Prépare le dossier `en-ligne/` à envoyer chez l'hébergeur |
| `en-ligne/` | Copie du site prête à mettre en ligne (recréée à chaque export) |
| `content/` | Données de travail du générateur |
| `Projets Vidéos/`, `new assets/` | Fichiers sources : ne vont pas en ligne |

## Voir le site en local

```bash
ruby -run -e httpd . -p 4173
```

puis ouvrir http://localhost:4173 (les vidéos YouTube ne se lisent pas si on ouvre les `.html` en double-clic).

## Mettre en ligne gratuitement

1. Préparer le dossier : `ruby tools/export.rb` (crée `en-ligne/`, environ 67 Mo).
2. Créer un compte gratuit sur netlify.com, puis dans *Add new project → Deploy manually*, glisser le dossier `en-ligne`.
3. Dans *Project configuration → Change project name*, choisir un nom : le site sera à `https://<nom>.netlify.app`.

Pour une mise à jour : refaire l'étape 1, puis dans l'onglet *Deploys* du projet, glisser le nouveau dossier `en-ligne`.
L'adresse ne change pas.

Alternative : Cloudflare Pages (*Workers & Pages → Create → Pages → Upload assets*), même principe, adresse en `.pages.dev`.

Nom de domaine personnel (facultatif, payant, environ 10 à 15 € par an) : l'acheter chez OVH, Gandi, Namecheap…,
puis l'ajouter dans *Domain management* sur Netlify, qui indique les réglages DNS à faire.

## Modifier ou ajouter un projet

Toutes les modifications se font dans `tools/`, puis on régénère avec `ruby tools/build.rb` (ou directement
`ruby tools/export.rb` avant une mise en ligne). Ne pas corriger les `.html` à la main : ils sont écrasés à chaque génération.

- **Texte d'un projet** (nom, sous-titre, description) : tableau `PAGES` en haut de `tools/build.rb`.
- **Ordre des projets sur l'accueil** : `HOME_ORDER` dans `tools/build.rb`.
- **Visuel de survol sur l'accueil** : `assets/img/home-<projet>.webp`, et son format dans `HOME_AR`.
- **Images d'un projet** : les déposer dans `assets/img/`, puis les placer dans `LAYOUT` dans `tools/grid.rb`,
  une ligne par rangée (`[['image-a'], ['image-b', 'image-c']]` = une image pleine largeur puis deux côte à côte).
  Les types de blocs possibles sont décrits en haut du fichier.
- **Vidéo** : déposer le `.mp4` (H.264, idéalement moins de 10 Mo) dans `assets/video/`, puis `[:video, 'nom']` dans la grille.
- **Nouveau projet** : ajouter une entrée dans `PAGES` (avec un `slug`, ex. `mon-projet`), une grille `'mon-projet' => [...]`
  dans `LAYOUT`, un visuel `assets/img/home-mon-projet.webp`, et le slug dans `HOME_ORDER`.
- **CV** : remplacer `assets/2026-EN.pdf` en gardant le même nom.

Ruby est déjà installé sur macOS : rien à installer.

## Vidéos et mode économie d'énergie (iPhone)

En mode économie d'énergie, l'iPhone bloque les vidéos : le site affiche alors à la place un GIF du même nom (`assets/video/<nom>.gif`).
Après avoir remplacé une vidéo, refaire son GIF :

```bash
swift tools/mp4togif.swift assets/video/<nom>.mp4 assets/video/<nom>.gif 600 15
```

(600 = largeur en pixels, 15 = images par seconde ; baisser à 480 et 12 pour une vidéo longue ou très chargée.)
Les vidéos YouTube ne peuvent pas être lues dans ce mode : elles affichent leur image fixe.

## Version téléphone

Dans `tools/grid.rb`, la liste `MOBILE` indique les visuels qui passent en pleine largeur (`full`) ou en premier dans leur rangée (`first`) sur téléphone.
