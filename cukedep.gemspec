# File: cukedep.gemspec
# Gem specification file for the Cukedep project.

require 'rubygems'

# The next line generates an error with Bundler
require_relative './lib/cukedep/constants'


CUKEDEP_GEMSPEC = Gem::Specification.new do |pkg|
	pkg.name = "cukedep"
	pkg.version = Cukedep::Version
	pkg.author = "Dimitri Geshef"
	pkg.email = "famished.tiger@yahoo.com"
	pkg.homepage = "https://github.com/famished-tiger/Cukedep"
	pkg.platform = Gem::Platform::RUBY
	pkg.summary = Cukedep::Description
	pkg.description = "Handle dependencies between feature files"
	pkg.post_install_message =<<EOSTRING
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Thank you for installing Cukedep...
Enjoy using Cucumber with macros...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOSTRING
  pkg.rdoc_options << '--exclude="sample|spec"'  
	file_list = Dir['.rspec', '.ruby-gemset', '.ruby-version', '.simplecov', '.travis.yml', '.yardopts', 'cucumber.yml', 'Gemfile', 'Rakefile',  'CHANGELOG.md', 'LICENSE.txt', 'README.md', 
    'bin/**', 'lib/*.*', 'lib/**/*.rb', 'sample/**/*.*', 'spec/**/*.rb', 'spec/cukedep/sample_features/**', 'templates/*.erb'
  ]
	pkg.files = file_list
	pkg.require_path = "lib"
	
	pkg.extra_rdoc_files = ['README.md']
  pkg.add_runtime_dependency('cucumber',[">= 0.7.0"])
  pkg.add_runtime_dependency('gherkin',[">= 1.0.24"])
  pkg.add_runtime_dependency('rake',[">= 0.8.0"])
  pkg.add_development_dependency('rspec',[">= 2.11.0"])
  pkg.add_development_dependency('simplecov',[">= 0.5.0"])
  pkg.add_development_dependency('rubygems', [">= 2.0.0"])
	
	pkg.bindir = 'bin'
	pkg.executables = ['cukedep']
  pkg.license = 'MIT'
  pkg.required_ruby_version = '>= 1.9.1'
end

if $0 == __FILE__
  require 'rubygems/package'
	Gem::Package.build(CUKEDEP_GEMSPEC)
end

# End of file