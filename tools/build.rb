# encoding: utf-8
# Générateur du site — lit content/manifest.json et écrit les pages HTML à la racine.
# Usage :  ruby tools/build.rb
require 'json'
require 'cgi'

ROOT = File.expand_path('..', __dir__)
IMG  = File.join(ROOT, 'assets', 'img')
M    = JSON.parse(File.read(File.join(ROOT, 'content', 'manifest.json'), encoding: 'utf-8'))

NAME  = 'Zoé Mossino'
EMAIL = 'zoemossino@gmail.com'
CV    = 'assets/2026-EN.pdf'
YEAR  = 2026
VER   = Time.now.strftime('%m%d%H%M') # évite que le navigateur garde une ancienne version du style

X0 = 240.0   # origine horizontale de la colonne noire dans la maquette d'origine
CW = 784.0   # largeur de la colonne noire

# ---------------------------------------------------------------- contenu
PAGES = [
  { file: 'branding.html', key: 'branding', nav: 'Branding', title: 'Branding',
    intro: 'Visual identities, from logo to launch.',
    projects: [
      { slug: 'galamoon', name: 'Galamoon', meta: 'Branding', range: [-1e9, 2000], cover: 'daaae6b1-fa12',
        desc: ['Visual identity for GalaMoon, a retro gaming YouTube channel.'] },
      { slug: 'spottid', name: 'Spottid', meta: 'Branding', range: [2000, 4840], cover: 'c4a3d037-54cd',
        desc: ['SPOTTID is a marketplace specialising in arts and crafts, offering a cutting-edge selection of handmade creations by French artisans.'] },
      { slug: 'olivas', name: 'Olivas', meta: 'Branding — fictional project', range: [4840, 1e9], cover: 'ee8deaed-2673',
        desc: ['Olive oil made with fresh, handpicked olives. With character, Olivas brings out the best in your dishes — perfect for meat, fish and Mediterranean cuisine.',
               'Opting for eco-responsible packaging, its stainless steel bottle is refillable.'] }
    ] },
  { file: 'art-direction.html', key: 'artdir', nav: 'Art. Dir.', title: 'Art direction',
    intro: 'Concepts and campaigns, built end to end.',
    projects: [
      { slug: 'meme-pas-sourd', name: 'Même pas sourd', meta: 'Activation — Petits Frères des Pauvres (school project)', range: [-1e9, 2900], cover: '1c04042c-c32d',
        desc: ['Même pas Sourd is a live intergenerational speed dating on Twitch, touring the concept all over France. Hang on and open your ears: the elders do not have their tongue in their pockets…',
               'The brief was to develop the notoriety of Petits Frères des Pauvres and (re)put the fight against the isolation of elderly people at the heart of concerns — by raising awareness and mobilising French citizens.'] },
      { slug: 'la-patate-groove', name: 'La Patate Groove', meta: 'La Patate Douce Radio — fictional group project', range: [2900, 1e9], cover: '936c457f-54ec',
        desc: ['La Patate Douce Radio is a webradio born in Lyon (France) which broadcasts Disco-Funk Groovy, Afro-Soul & House 24/7.',
               'The project was to transform this application into a physical object or device. The Patate Groove is a mixing deck 100% connected to your La Patate Douce playlist — no need for USB!'] }
    ] },
  { file: 'layout.html', key: 'edition', nav: 'Layout', title: 'Layout',
    intro: 'Layout and editorial design.',
    projects: [
      { slug: 'cbre', name: 'CBRE', meta: 'Layout design — current job', range: [-1e9, 1e9], cover: 'e25dcf7c-61e5',
        desc: ['Investor presentation packages for commercial real estate, designed with a distinct visual identity for each project.'] }
    ] },
  { file: 'corporate.html', key: 'job', nav: 'Corporate', title: 'Corporate',
    intro: 'Motion design and brand content.',
    projects: [
      { slug: 'myreport', name: 'MyReport', meta: 'Motion design — Branding', range: [-1e9, 1e9], cover: '5351adba-eef6',
        desc: ['MyReport is the most comprehensive and easy-to-use French data analysis solution. Their new branding was created by graphic designer Claudia Allegre in 2023.',
               'My two years of experience within the company allowed me to develop their new identity across multiple projects.'] }
    ] }
]

# Visuels de la page d'accueil (assets/img/home-<projet>.webp) : largeur / hauteur
HOME_AR = { 'spottid' => 869.0 / 1053, 'cbre' => 695.0 / 767, 'olivas' => 1183.0 / 755, 'myreport' => 484.0 / 510,
            'meme-pas-sourd' => 818.0 / 989, 'galamoon' => 785.0 / 559, 'la-patate-groove' => 1080.0 / 645 }

# Ordre des projets sur la page d'accueil
HOME_ORDER = %w[spottid cbre olivas myreport meme-pas-sourd galamoon la-patate-groove]

# Couleur du bouton de chaque catégorie quand on est dedans (nil = noir)
CAT_COLOR = {
  'branding.html' => '#ff4800',      # orange (couleur d'origine Readymag)
  'art-direction.html' => '#1100ff', # bleu (couleur d'origine Readymag)
  'layout.html' => '#ff00d9',        # rose (couleur d'origine Readymag)
  'corporate.html' => '#00dc00'      # vert (repris du CV)
}

# Texte de présentation de la page d'accueil (HTML autorisé)
INTRO = [
  'Bonjour ! My name is Zoé Mossino, but everybody call me <strong>Zazou</strong>.',
  'I am a <strong>graphic designer</strong> and <strong>artistic director</strong>. Inspired by <a href="https://letterboxd.com/zo_moss/" target="_blank" rel="noopener">movies</a>, furniture, <a href="https://open.spotify.com/playlist/0AR71CUG0xulv4rX8KRE00" target="_blank" rel="noopener">disco</a> and my friends.',
  'Currently graphic designer at <a class="it-link" href="layout.html#cbre"><em>CBRE</em></a>, I make designs and layout remarkable and enjoyable.'
]

# Corrections manuelles de position (repère de la maquette d'origine), par début de nom de fichier
OVERRIDES = {}

# Visuels retirés du site, par début de nom de fichier
REMOVED = %w[d24674d9]

# Logo de chaque projet : centré et seul sur sa ligne (plusieurs fichiers = un même logo en plusieurs morceaux)
LOGOS = [%w[22af731b 756eaaf7], %w[e6693a5e], %w[8d909bb9], %w[svg-386ffd7a], %w[62d59759]]

SHAPE_FILL = {
  'shape-363caa7e.svg' => ['#161616', 0], 'shape-4f475695.svg' => ['#ec4b03', 0],
  'shape-3644b213.svg' => ['#88d18a', 4], 'shape-e6bd0052.svg' => ['#ec4b03', 8]
}

# ---------------------------------------------------------------- helpers
def h(s) CGI.escapeHTML(s.to_s) end
def pct(v) format('%.3f%%', v) end

def img(base)
  return "assets/img/#{base}" if base =~ /\.\w+$/ && File.exist?(File.join(IMG, base))
  stem = base.sub(/\.\w+$/, '')
  %w[jpg png jpeg svg webp].each { |e| return "assets/img/#{stem}.#{e}" if File.exist?(File.join(IMG, "#{stem}.#{e}")) }
  warn "image manquante: #{base}"
  "assets/img/#{base}"
end

def inside?(a, b)
  a['x'] >= b['x'] - 2 && a['y'] >= b['y'] - 2 && a['x'] + a['w'] <= b['x'] + b['w'] + 2 && a['y'] + a['h'] <= b['y'] + b['h'] + 2
end

require_relative 'grid'

def nav(current)
  a = PAGES.map do |p|
    col = CAT_COLOR[p[:file]]
    %(<a class="pill" href="#{p[:file]}"#{col ? %( style="--cat:#{col}") : ''}#{p[:file] == current ? ' aria-current="page"' : ''}>#{p[:nav]}</a>)
  end
  %(<nav class="pills" aria-label="Categories">#{a.join}</nav>)
end

def brand(current)
  home = current == 'index.html' ? ' aria-current="page"' : ''
  %(<div class="top"><a class="brand" href="index.html">#{NAME}</a><nav class="links" aria-label="Main"><a href="index.html"#{home}>Home</a><a href="mailto:#{EMAIL}">Contact</a></nav></div>)
end

def head(title, desc, cover)
  <<~HTML
    <!doctype html>
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>#{h(title)}</title>
    <meta name="description" content="#{h(desc)}">
    <meta property="og:type" content="website">
    <meta property="og:title" content="#{h(title)}">
    <meta property="og:description" content="#{h(desc)}">
    <meta property="og:image" content="#{cover}">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="theme-color" content="#fffdf4">
    <link rel="icon" href="assets/favicon.svg" type="image/svg+xml">
    <link rel="preload" href="assets/fonts/ReadexPro-latin.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="stylesheet" href="assets/site.css?v=#{VER}">
    <script>document.documentElement.classList.add('js')</script>
    <script src="assets/site.js?v=#{VER}" defer></script>
    </head>
  HTML
end

def side_foot
  %(<div class="side-foot"><a href="#{CV}" target="_blank" rel="noopener">CV <span aria-hidden="true">↗</span></a><a href="mailto:#{EMAIL}">#{EMAIL}</a></div>)
end

def stage_end(nxt)
  <<~HTML
    <footer class="end">
          <a class="next" href="#{nxt[0]}"><span>Next</span><strong>#{h(nxt[1])}</strong><i aria-hidden="true">→</i></a>
          <div class="contact">
            <p>Let’s work together</p>
            <a href="mailto:#{EMAIL}">#{EMAIL}</a>
          </div>
          <p class="copy">© #{YEAR} #{NAME}<a href="#top">Back to top ↑</a></p>
        </footer>
  HTML
end

# ---------------------------------------------------------------- pages projets
PAGES.each_with_index do |pg, pi|
  items = M[pg[:key]]
  nxt = PAGES[(pi + 1) % PAGES.size]
  nxt = pi == PAGES.size - 1 ? ['index.html', 'All projects'] : [nxt[:file], nxt[:title]]
  plist = pg[:projects].each_with_index.map do |p, n|
    <<~HTML
      <li>
              <a href="##{p[:slug]}" data-spy="#{p[:slug]}"><span class="n">#{format('%02d', n + 1)}</span><span class="t">#{h(p[:name])}</span></a>
              <div class="d"><div><p class="meta">#{h(p[:meta])}</p>#{p[:desc].map { |d| "<p>#{h(d)}</p>" }.join}</div></div>
            </li>
    HTML
  end.join('      ')
  sections = pg[:projects].each_with_index.map do |p, n|
    <<~HTML
      <section class="project" id="#{p[:slug]}" aria-labelledby="t-#{p[:slug]}">
            <header class="project-head">
              <p class="idx">#{format('%02d', n + 1)} / #{format('%02d', pg[:projects].size)}</p>
              <h2 id="t-#{p[:slug]}">#{h(p[:name])}</h2>
              <p class="meta">#{h(p[:meta])}</p>
              #{p[:desc].map { |d| "<p>#{h(d)}</p>" }.join("\n          ")}
            </header>
            #{grid(p)}
          </section>
    HTML
  end.join("\n      ")
  desc = "#{pg[:title]} — #{pg[:projects].map { |p| p[:name] }.join(', ')}. Portfolio of #{NAME}."
  html = head("#{pg[:title]} — #{NAME}", desc, img(pg[:projects][0][:cover])) + <<~HTML
    <body class="work" id="top">
    <a class="skip" href="#main">Skip to content</a>
    <div class="shell">
      <aside class="side">
        #{brand(pg[:file])}
        #{nav(pg[:file])}
        <div class="side-body">
          <h1>#{h(pg[:title])}</h1>
          <ol class="plist">
            #{plist}</ol>
        </div>
        #{side_foot}
      </aside>
      <main class="stage" id="main">
        #{sections}
        #{stage_end(nxt)}
      </main>
    </div>
    <dialog class="zoom" aria-label="Image viewer"><button class="zoom-close" type="button" aria-label="Close">Close ✕</button><button class="zoom-prev" type="button" aria-label="Previous image">←</button><img alt=""><button class="zoom-next" type="button" aria-label="Next image">→</button></dialog>
    </body>
    </html>
  HTML
  File.write(File.join(ROOT, pg[:file]), html)
  puts "✓ #{pg[:file]}"
end

# ---------------------------------------------------------------- accueil
n = 0
all = PAGES.flat_map { |pg| pg[:projects].map { |p| [pg, p] } }
rows = all.sort_by { |_, p| HOME_ORDER.index(p[:slug]) || 99 }.map do |pg, p|
  n += 1
  c = "assets/img/home-#{p[:slug]}.webp"
  ar = format('%.4f', HOME_AR[p[:slug]] || 1.5)
  <<~HTML
    <li><a href="#{pg[:file]}##{p[:slug]}" data-cover="#{c}" data-ar="#{ar}">
            <img class="thumb" src="#{c}" alt="" style="aspect-ratio:#{ar}" loading="#{n < 3 ? 'eager' : 'lazy'}" decoding="async">
            <span class="n">#{format('%02d', n)}</span><span class="name">#{h(p[:name])}</span><span class="cat">#{h(pg[:title])}</span>
          </a></li>
  HTML
end.join('      ')

home = head("#{NAME} — Portfolio", "Portfolio of #{NAME} — branding, art direction, editorial and motion design.", img('1c04042c-c32d')) + <<~HTML
  <body class="home" id="top">
  <a class="skip" href="#main">Skip to content</a>
  <div class="shell">
    <aside class="side">
      #{brand('index.html')}
      #{nav('index.html')}
      <div class="side-body hello">
        <h1>Zoé<br>Mossino</h1>
        <div class="bio">#{INTRO.map { |t| "<p>#{t}</p>" }.join}</div>
      </div>
      #{side_foot}
    </aside>
    <main class="stage" id="main">
      <p class="kicker"><span>Selected work</span><span>#{format('%02d', n)} projects</span></p>
      <ol class="index">
        #{rows}</ol>
      <footer class="end">
        <div class="contact">
          <p>Let’s work together</p>
          <a href="mailto:#{EMAIL}">#{EMAIL}</a>
        </div>
        <p class="copy">© #{YEAR} #{NAME}<a href="#{CV}" target="_blank" rel="noopener">CV ↗</a></p>
      </footer>
    </main>
  </div>
  <div class="preview" aria-hidden="true"></div>
  </body>
  </html>
HTML
File.write(File.join(ROOT, 'index.html'), home)
puts '✓ index.html'

nf = head("Page not found — #{NAME}", 'Page not found.', img('1c04042c-c32d')) + <<~HTML
  <body class="home nf" id="top">
  <div class="shell">
    <aside class="side">
      #{brand('')}
      #{nav('')}
      <div class="side-body hello"><h1>404</h1><p>This page doesn’t exist (anymore).</p></div>
      #{side_foot}
    </aside>
    <main class="stage" id="main"><ol class="index"><li><a href="index.html"><span class="n">←</span><span class="name">Back home</span><span class="cat">All projects</span></a></li></ol></main>
  </div>
  </body>
  </html>
HTML
File.write(File.join(ROOT, '404.html'), nf)
puts '✓ 404.html'

