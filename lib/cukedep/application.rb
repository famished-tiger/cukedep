# File: application.rb

require 'yaml'
require 'gherkin/parser/parser'

require_relative 'cli/cmd-line'
require_relative 'config'
require_relative 'gherkin-listener'
require_relative 'feature-model'

module Cukedep # Module used as a namespace

# Runner for the Cukedep application.
class Application
  attr_reader(:proj_dir)
public

  # Entry point for the application object.
  def start!(theCmdLineArgs)
    options = options_from(theCmdLineArgs)
    create_default_cfg if options[:setup]
    config = load_cfg

    # Complain if no project dir is specified
    if config.proj_dir.nil? || config.proj_dir.empty?
      if options[:project]
        @proj_dir = options[:project]
      else
        msg_p1 = "No project dir specified via 'Cukedep::YMLFilename'"
        msg_p2 = ' nor via --project option.'
        fail(StandardError, msg_p1 + msg_p2)
      end
    else
      @proj_dir = config.proj_dir
    end

    feature_files = parse_features
    
    model = FeatureModel.new(feature_files)
    generate_files(model)
    unless options[:dryrun]
      rake_cmd = 'rake -f cukedep.rake'
      system(rake_cmd)
    end
  end

protected
  # Retrieve the user-entered command-line options
  def options_from(theCmdLineArgs)
    cli = CLI::CmdLine.new
    cli.parse!(theCmdLineArgs.dup)
  end


  # Create a local copy of the .cukedep.yml file, then
  # stop the application.
  def create_default_cfg()
    if File.exist?(Cukedep::YMLFilename)
      puts "OK to overwrite file #{Cukedep::YMLFilename}."
      puts '(Y/N)?'
      answer = $stdin.gets
      exit if answer =~ /^\s*[Nn]\s*$/
    end
    File.open(Cukedep::YMLFilename, 'w') { |f| YAML.dump(Config.default, f) }
    exit
  end

  # Read the .cukedep.yml file in the current working directory
  def load_cfg()
    if File.exist?(Cukedep::YMLFilename)
      YAML.load_file(Cukedep::YMLFilename)
    else
      Config.default
    end
  end

  # Parse the feature files
  def parse_features()
    # Create a Gherkin listener
    listener = Cukedep::GherkinListener.new

    # Create a Gherkin parser
    parser = Gherkin::Parser::Parser.new(listener)

    # List all the .feature files
    filenames = Dir.glob('*.feature')
    puts "\nParsing:"
    
    # Parse them
    filenames.each do |fname|
      puts "  #{fname}"
      File.open(fname, 'r') { |f| parser.parse(f.read, fname, 0) }
    end

    return listener.feature_files
  end


  def generate_files(aModel)
    # Sort the feature files by dependency order.
    aModel.sort_features_by_dep
    
    puts "\nGenerating:"
    
    # Generate CSV files detailing the feature to identifier mapping
    # and vise versa
    # TODO: replace hardcoded names by value from config
    aModel.mapping_reports('feature2id.csv', 'id2feature.csv', true)
    aModel.draw_dependency_graph('dependencies.dot', true)
    aModel.generate_rake_tasks('cukedep.rake', proj_dir)
  end
end # class

end # module

# End of file
