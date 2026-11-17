# encoding: utf-8
# Prépare le dossier « en-ligne » : uniquement les fichiers du site, prêt à glisser chez l'hébergeur.
# Usage :  ruby tools/export.rb
require 'fileutils'

ROOT = File.expand_path('..', __dir__)
OUT  = File.join(ROOT, 'en-ligne')

system('ruby', File.join(ROOT, 'tools', 'build.rb'), exception: true) # régénère d'abord les pages

FileUtils.rm_rf(OUT) if File.basename(OUT) == 'en-ligne' # n'efface que l'ancien export
FileUtils.mkdir_p(OUT)
Dir[File.join(ROOT, '*.html')].each { |f| FileUtils.cp(f, OUT) }
FileUtils.cp_r(File.join(ROOT, 'assets'), OUT)
Dir[File.join(OUT, '**', '.DS_Store')].each { |f| File.delete(f) }

files = Dir[File.join(OUT, '**', '*')].select { |f| File.file?(f) }
mb = files.sum { |f| File.size(f) } / 1_048_576.0
puts "✓ en-ligne/ prêt : #{files.size} fichiers, #{mb.round} Mo"
