# encoding: utf-8
# Grille des pages projets : chaque projet est une suite de rangées, chaque rangée une suite de blocs.
#
#   'nom-de-fichier'                  image plein bloc (début du nom dans assets/img)
#   [:fit, 'fichier', '#fond', ratio, marge, position] visuel détouré posé sur un fond de couleur
#                                     (ratio = largeur / hauteur du bloc ; marge et position facultatives)
#   [:crop, 'fichier', ratio, position] image recadrée à un autre format (position = côté conservé)
#   [:lockup, ['a', 'b'], '#fond', ratio, 'légende'] plusieurs visuels détourés côte à côte dans un même bloc
#   [:video, 'nom', ratio]            vidéo assets/video/nom.mp4 (ratio facultatif pour la recadrer)
#   [:yt, 'identifiant']              vidéo YouTube
#   [:color, '#couleur', ratio]       aplat de couleur
#   [:stack, bloc, bloc]              deux blocs empilés dans une colonne
#   [:note, 'texte']                  petit bloc de texte (titre de section)

TILE = '#141414'

LAYOUT = {
  'galamoon' => [
    [[:crop, 'new-galamoon-banner', 2.83]],
    [[:video, 'galamoon-cover', 0.8], [:crop, 'new-galamoon-retro', 0.8]],
    [[:video, 'galamoon-2'], [:video, 'galamoon-mouton', 1.0]],
    [[:fit, 'daaae6b1', TILE, 1.5, '3%']],
    [[:fit, 'new-galamoon-insta-big', TILE, 1.63, '2%']]
  ],
  'spottid' => [
    ['new-spottid-logo'],
    [[:yt, 'S2AgSYSlJLk']],
    ['new-spottid-secu', [:video, 'spottid-1']],
    [[:fit, 'new-spottid-blob', TILE, 1.0, '14%'], [:fit, 'new-spottid-colors', '#000', 1.78, '0']],
    [[:fit, 'new-spottid-icons', TILE, 4.6, '0 6%']],
    ['new-spottid-site'],
    [[:yt, 'l_hfX_Nky38']],
    ['new-spottid-encart-1', 'new-spottid-encart-2', 'new-spottid-encart-3'],
    ['new-spottid-mockup-1'],
    ['new-spottid-mockup-2', 'new-spottid-cards'],
    ['new-spottid-boxes'],
    ['new-spottid-insta']
  ],
  'olivas' => [
    ['new-olivas-logo'],
    ['b32ba7ec', [:video, 'olivas-gif', 1.39]],
    ['06bfc348', 'new-olivas-variants'],
    ['new-olivas-can'],
    ['c7a7b413', '69ad4d14', '16eb14b9'],
    ['new-olivas-bag', 'new-olivas-tshirt']
  ],
  'meme-pas-sourd' => [
    ['1c04042c'],
    [[:yt, 'bruGMnYle08']],
    ['b5396918'],
    [[:fit, '598d6bf6', TILE, 1.3], [:lockup, %w[6532a275-cbf8 6532a275-8950 6532a275-672f], TILE, 1.0, 'Icons for donation on Twitch']],
    ['6b90702b', [:fit, 'ae20e158', TILE, 0.62]],
    [[:fit, '3db8e745', TILE, 1.04, '17%'], 'fa249b9f'],
    ['e519fc67', [:fit, '2143dc7e-9d50', TILE, 1.0]]
  ],
  'la-patate-groove' => [
    ['new-patate-cover'],
    ['025fa049', [:video, 'la-patate-groove-2']],
    [[:fit, 'fdbe6906', '#3d64d2', 0.9, '7% 0 7% 7%', 'right center'], [:fit, '8ba8d117', '#fdf1c7', 1.0]],
    [[:fit, 'ed70c31a', '#f987e3', 1.5], [:video, 'la-patate-groove-1']],
    ['936c457f']
  ],
  'myreport' => [
    [[:fit, '62d59759', '#000', 2.6, '11%']],
    [[:note, 'Logo animation']],
    [[:video, 'myreport-1'], [:video, 'myreport-2']],
    [[:note, 'Motion design']],
    [[:yt, 'vGBNRMKV0wA']],
    [[:video, 'myreport-3'], [:video, 'myreport-4']],
    [[:note, 'Ads']],
    [[:crop, 'dbd81bd6', 0.725, 'right center'], [:stack, '40f36474', '53308781']],
    [[:note, 'Podcast']],
    [[:fit, 'a7d5cf3c', TILE, 2.0], [:fit, '8baad698', '#fff', 2.0]],
    [[:fit, '49ba9d26', TILE, 0.6], '955147f5', [:stack, 'abe59743', 'f820d63d']],
    [[:note, 'Annual seminar']],
    ['2c199f75', [:stack, '07f2809f', '2947a113'], [:stack, '3477b08d', '7b3fb9bb']],
    [[:note, 'Card game']],
    ['5351adba'],
    ['ad6bac7f', '9aae9adf', 'c458f5c3']
  ]
}

# Version téléphone : blocs qui passent en pleine largeur (full) et blocs qui passent en premier dans leur rangée (first).
# On les désigne par le nom du fichier ou de la vidéo, comme dans LAYOUT ci-dessus.
# ratio : autre format du bloc sur téléphone (largeur / hauteur) ; before : { 'bloc déplacé' => 'bloc devant lequel il passe' }
MOBILE = {
  'galamoon' => { full: %w[galamoon-cover new-galamoon-retro galamoon-2 galamoon-mouton],
                  before: { 'daaae6b1' => 'galamoon-mouton' } },
  'spottid' => { full: %w[new-spottid-secu spottid-1 new-spottid-mockup-2 new-spottid-cards] },
  'olivas' => { full: %w[new-olivas-logo b32ba7ec olivas-gif 06bfc348 new-olivas-variants new-olivas-can 16eb14b9 new-olivas-bag new-olivas-tshirt] },
  'meme-pas-sourd' => { full: %w[598d6bf6 6532a275-cbf8 6b90702b ae20e158 3db8e745 fa249b9f e519fc67 2143dc7e-9d50],
                        ratio: { '6532a275-cbf8' => 1.8 } },
  'la-patate-groove' => { full: %w[025fa049 la-patate-groove-2 ed70c31a la-patate-groove-1], first: %w[8ba8d117] },
  # half : les deux visuels d'une pile [:stack] se répartissent à moitié de largeur (grille de 2 × 2 avec la pile voisine)
  # hide : masqué sur téléphone ; pair : côte à côte sur une ligne à eux seuls
  'myreport' => { full: %w[myreport-1 myreport-2 myreport-3 myreport-4 dbd81bd6 40f36474 2c199f75 8baad698],
                  half: %w[07f2809f 3477b08d abe59743], hide: %w[a7d5cf3c], pair: %w[49ba9d26 955147f5] },
  'cbre' => { full: :all }
}

# CBRE : la grande image d'ouverture, puis chaque dossier séparé : son nom, sa couverture en pleine largeur,
# une deuxième page en pleine largeur, puis les autres pages en plus petit sur une rangée
CBRE_NAMES = ['The Quay', 'Handelsbeurs', 'Belnine', 'Birmingham 225']
cbre = M['edition'].select { |i| i['t'] == 'img' }.sort_by { |i| i['y'] }
stem = ->(i) { i['src'].sub(/\.\w+$/, '') }
LAYOUT['cbre'] = [[stem.call(cbre.shift)]]
cbre.slice_when { |a, b| b['y'] - a['y'] > 30 && (b['y'] - 387) .div(518) != (a['y'] - 387).div(518) }.each_with_index do |grp, n|
  big, small = grp.partition { |i| i['w'] > 350 }
  big = big.sort_by { |i| i['y'] }
  LAYOUT['cbre'] << [[:gap]] << [[:note, CBRE_NAMES[n] || "Project #{n + 1}"]]
  big.each { |i| LAYOUT['cbre'] << [stem.call(i)] }
  LAYOUT['cbre'] << small.sort_by { |i| i['y'] }.map { |i| stem.call(i) } unless small.empty?
end

# Dossiers CBRE ajoutés ensuite : images assets/img/cbre-<code>-1.jpg, -2.jpg… (1 et 2 en grand, les suivantes en petit)
[['Degroof Petercam', 'dp'], ['Vander Elst', 've'], ['The Frame', 'frame']].each do |name, code|
  files = Dir[File.join(IMG, "cbre-#{code}-*")].sort.map { |x| File.basename(x, '.*') }
  LAYOUT['cbre'] << [[:gap]] << [[:note, name]]
  files.first(2).each { |x| LAYOUT['cbre'] << [x] }
  LAYOUT['cbre'] << files.drop(2) if files.size > 2
end

POSTERS = File.readlines(File.join(ROOT, 'content', 'videos.txt'), encoding: 'utf-8').drop(1).map { |l| l.strip.split("\t") }
              .to_h { |a, b| [a.sub('.mp4', ''), b] }

DIMS_FILE = File.join(ROOT, 'content', 'dims.json')
DIMS = File.exist?(DIMS_FILE) ? JSON.parse(File.read(DIMS_FILE)) : {}

def find_img(stem)
  all = Dir[File.join(IMG, "#{stem}*")].sort
  f = all.find { |x| File.basename(x, '.*') == stem } || all.first
  abort "visuel introuvable : #{stem}" unless f
  "assets/img/#{File.basename(f)}"
end

def ratio(rel)
  DIMS[rel] ||= begin
    path = File.join(ROOT, rel)
    if rel.end_with?('.mp4')
      o = `mdls -name kMDItemPixelWidth -name kMDItemPixelHeight "#{path}"`
      w = o[/PixelWidth\s*=\s*(\d+)/, 1].to_f; hh = o[/PixelHeight\s*=\s*(\d+)/, 1].to_f
    elsif rel.end_with?('.svg')
      vb = File.read(path)[/viewBox="([^"]+)"/, 1].split.map(&:to_f); w = vb[2]; hh = vb[3]
    else
      o = `sips -g pixelWidth -g pixelHeight "#{path}"`
      w = o[/pixelWidth: (\d+)/, 1].to_f; hh = o[/pixelHeight: (\d+)/, 1].to_f
    end
    hh > 0 ? (w / hh).round(4) : 1.5
  end
end

# renvoie [ratio, html] ; mode = :row (bloc dans une rangée) ou :col (bloc dans une pile)
def cell(c, proj, mode = :row)
  c = [:img, c] if c.is_a?(String)
  alt = "#{h(proj[:name])} — project visual"
  st = ->(ar, extra = '') { %(style="--ar:#{ar};--g:#{mode == :row ? ar : (1 / ar).round(4)}#{extra}") }
  case c[0]
  when :img
    src = find_img(c[1]); ar = ratio(src)
    [ar, %(<a class="tile pic" #{st.call(ar)} href="#{src}" data-zoom><img src="#{src}" alt="#{alt}" loading="lazy" decoding="async"></a>)]
  when :fit
    src = find_img(c[1]); ar = c[3] || ratio(src)
    extra = ";--bg:#{c[2]}"
    extra += ";--pad:#{c[4]}" if c[4]
    extra += ";--pos:#{c[5]}" if c[5]
    [ar, %(<a class="tile pic fit" #{st.call(ar, extra)} href="#{src}" data-zoom><img src="#{src}" alt="#{alt}" loading="lazy" decoding="async"></a>)]
  when :crop
    src = find_img(c[1]); ar = c[2]
    [ar, %(<a class="tile pic" #{st.call(ar, ";--pos:#{c[3] || 'center'}")} href="#{src}" data-zoom><img src="#{src}" alt="#{alt}" loading="lazy" decoding="async"></a>)]
  when :lockup
    ar = c[3]
    imgs = c[1].map { |s| %(<img src="#{find_img(s)}" alt="" loading="lazy" decoding="async">) }.join
    cap = c[4] ? %(<figcaption>#{h(c[4])}</figcaption>) : ''
    [ar, %(<figure class="tile lockup" #{st.call(ar, ";--bg:#{c[2]}")}><div>#{imgs}</div>#{cap}</figure>)]
  when :video
    rel = "assets/video/#{c[1]}.mp4"; ar = c[2] || ratio(rel)
    poster = POSTERS[c[1]] ? %( poster="assets/img/#{POSTERS[c[1]]}") : ''
    # GIF de secours (même nom, .gif) : affiché quand le téléphone bloque la vidéo (mode économie d'énergie)
    gif = File.exist?(File.join(ROOT, "assets/video/#{c[1]}.gif")) ? %( data-gif="assets/video/#{c[1]}.gif") : ''
    [ar, %(<div class="tile vid" #{st.call(ar)}><video muted loop playsinline preload="none"#{poster} data-src="#{rel}"#{gif} aria-label="#{h(proj[:name])} — video"></video></div>)]
  when :yt
    ar = 1.7778
    [ar, %(<div class="tile yt" #{st.call(ar)} data-yt="#{c[1]}" role="img" aria-label="#{h(proj[:name])} — video"><img src="assets/img/yt-#{c[1]}.jpg" alt="" loading="lazy" decoding="async"></div>)]
  when :color
    [c[2], %(<span class="tile" #{st.call(c[2], ";--bg:#{c[1]}")} aria-hidden="true"></span>)]
  when :stack
    parts = c[1..].map { |x| cell(x, proj, :col) }
    ar = (1 / parts.sum { |a, _| 1 / a }).round(4)
    [ar, %(<div class="stack" style="--g:#{ar}">#{parts.map(&:last).join}</div>)]
  when :gap
    [nil, %(<span class="gap" aria-hidden="true"></span>)]
  when :note
    [nil, %(<h3 class="tile note">#{h(c[1])}</h3>)]
  end
end

def cell_key(c)
  return c if c.is_a?(String)
  c[1].is_a?(Array) ? c[1].first : c[1]
end

def grid(proj)
  rows = LAYOUT[proj[:slug]] or abort "pas de grille pour #{proj[:slug]}"
  mob = MOBILE[proj[:slug]] || {}
  before = mob[:before] || {}
  # ordre sur téléphone : rangée n° i → 10·i ; une rangée contenant une cible est « éclatée » (ses blocs ont chacun leur ordre)
  pos = {}
  rows.each_with_index do |r, i|
    r.each_with_index { |c, j| pos[cell_key(c)] = { row: i, mo: i * 10 + j * 2 + 2 } }
  end
  targets = before.values.map { |t| pos[t] && pos[t][:row] }.compact
  out = rows.each_with_index.map do |r, i|
    split = targets.include?(i)
    cells = r.map do |c|
      html = cell(c, proj).last
      k = cell_key(c)
      cls = []
      cls << 'mfull' if mob[:full] == :all || Array(mob[:full]).include?(k)
      cls << 'mfirst' if Array(mob[:first]).include?(k)
      cls << 'mhalf' if Array(mob[:half]).include?(k)
      cls << 'mhide' if Array(mob[:hide]).include?(k)
      cls << 'mpair' if Array(mob[:pair]).include?(k)
      html = html.sub(/class="(tile|stack)/, %(class="\\1 #{cls.join(' ')})) unless cls.empty?
      html = html.sub('style="', %(style="--mar:#{mob[:ratio][k]};)) if mob[:ratio] && mob[:ratio][k]
      html = html.sub('style="', %(style="--mo:#{pos[k][:mo]};)) if split
      html
    end
    moved = r.map { |c| cell_key(c) }.find { |k| before[k] && pos[before[k]] }
    mo = moved ? pos[before[moved]][:mo] - 1 : i * 10
    attrs = before.empty? ? '' : %( style="--mo:#{mo}")
    %(<div class="row#{split ? ' msplit' : ''}"#{attrs}>#{cells.join}</div>)
  end
  File.write(DIMS_FILE, JSON.pretty_generate(DIMS))
  html = %(<div class="grid">\n        #{out.join("\n        ")}\n      </div>)
  # numéro de version par fichier : le navigateur recharge un visuel dès qu'il est remplacé
  html.gsub(%r{assets/(?:img|video)/[^"?]+}) { |p| File.exist?(File.join(ROOT, p)) ? "#{p}?v=#{File.mtime(File.join(ROOT, p)).to_i.to_s(36)}" : p }
end
