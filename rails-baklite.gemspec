require_relative 'lib/rails/baklite/version'

Gem::Specification.new do |spec|
  spec.name        = 'rails-baklite'
  spec.version     = Rails::Baklite::VERSION
  spec.authors     = ['Victor García Fernández']
  spec.email       = ['victorgf2011@gmail.com']
  spec.homepage    = 'https://github.com/tortitast/rails-baklite'
  spec.summary     = 'Backup and restore SQLite3 databases in your Rails app.'
  spec.description = 'Backup and restore SQLite3 databases in your Rails app.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tortitast/rails-baklite.git'
  spec.metadata['changelog_uri'] = 'https://github.com/tortitast/rails-baklite.git'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 7.1.3.4'
end
