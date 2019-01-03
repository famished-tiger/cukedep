# File: cukedep.gemspec
# Gem specification file for the Cukedep project.

require 'rubygems'

# The next line generates an error with Bundler
require_relative './lib/cukedep/constants'


CUKEDEP_GEMSPEC = Gem::Specification.new do |pkg|
  pkg.name = 'cukedep'
  pkg.version = Cukedep::Version
  pkg.author = 'Dimitri Geshef'
  pkg.email = 'famished.tiger@yahoo.com'
  pkg.homepage = 'https://github.com/famished-tiger/Cukedep'
  pkg.platform = Gem::Platform::RUBY
  pkg.summary = Cukedep::Description
  pkg.description = 'Handle dependencies between Cucumber feature files'
  pkg.post_install_message = <<EOSTRING
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Thank you for installing Cukedep...
Enjoy using Cucumber with macros...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOSTRING
  pkg.rdoc_options << '--exclude="sample|spec"'
  file_list = Dir[
    '.rspec', '.ruby-gemset', '.ruby-version', '.simplecov',
    '.travis.yml', '.yardopts', 'cucumber.yml', 'Gemfile', 'Rakefile',
    'CHANGELOG.md', 'LICENSE.txt', 'README.md', 'bin/**', 'lib/*.*',
    'lib/**/*.rb', 'sample/**/*.rb', 'sample/**/*.yml', 'spec/**/*.rb',
    'spec/cukedep/sample_features/**',
    'spec/cukedep/sample_features/files_to_copy/**', 'templates/*.erb'
  ]
  pkg.files = file_list
  pkg.require_path = 'lib'

  pkg.extra_rdoc_files = ['README.md']
  pkg.add_runtime_dependency 'cucumber', '~> 3.1', '>= 3.1.0'
  pkg.add_runtime_dependency 'gherkin', '~> 5.0', '< 6.0.0' # Gherkin 6.x.x is code breaking
  pkg.add_runtime_dependency 'rake', '~> 12.0', '>= 12.0.0'
  pkg.add_development_dependency 'rspec', '~> 3.6', '>= 3.6.0'
  pkg.add_development_dependency 'rubygems', '~> 2.0', '>= 2.0.0'
  pkg.add_development_dependency('simplecov', ['>= 0.10.0'])

  pkg.bindir = 'bin'
  pkg.executables = ['cukedep']
  pkg.license = 'MIT'
  pkg.required_ruby_version = '>= 2.1.0'
end

if $PROGRAM_NAME == __FILE__
  require 'rubygems/package'
  Gem::Package.build(CUKEDEP_GEMSPEC)
end

# End of file
