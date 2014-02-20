# File: application.rb


require_relative 'cli/cmd-line'
require_relative 'config'
require_relative 'gherkin-listener'
require_relative 'gherkin-facade'
require_relative 'feature-model'

module Cukedep # Module used as a namespace

# Runner for the Cukedep application.
class Application
  attr_reader(:proj_dir)
  
  public

  # Entry point for the application object.
  def run!(theCmdLineArgs)
    options = options_from(theCmdLineArgs)
    create_default_cfg if options[:setup]
    config = Config.load_cfg(Cukedep::YMLFilename)

    # Complain if no project dir is specified
    if config.proj_dir.nil? || config.proj_dir.empty?
      if options[:project]
        @proj_dir = options[:project]
      else
        msg_p1 = "No project dir specified in '#{Cukedep::YMLFilename}'"
        msg_p2 = ' nor via --project option.'
        fail(StandardError, msg_p1 + msg_p2)
      end
    else
      @proj_dir = config.proj_dir
    end

    feature_files = parse_features(config.feature_encoding)
    
    model = FeatureModel.new(feature_files)
    generate_files(model, config)

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
    Config.default.write(Cukedep::YMLFilename)

    exit
  end
=begin
  # Read the .cukedep.yml file in the current working directory
  def load_cfg()
    if File.exist?(Cukedep::YMLFilename)
      YAML.load_file(Cukedep::YMLFilename)
    else
      Config.default
    end
  end
=end
  # Parse the feature files (with the specified external encoding)
  def parse_features(external_encoding)
    # Create a Gherkin listener
    listener = Cukedep::GherkinListener.new
    
    # Parse the feature files in work directory
    is_verbose = true
    gherkin_facade = GherkinFacade.new(is_verbose, external_encoding)
    gherkin_facade.parse_features(listener, ['*.feature'])

    return listener.feature_files
  end


  def generate_files(aModel, aConfig)
    # Sort the feature files by dependency order.
    aModel.sort_features_by_dep
    
    puts "\nGenerating:"
    
    # Generate CSV files detailing the feature to identifier mapping
    # and vise versa
    # TODO: replace hard-coded names by value from config
    feature2id_report = aConfig.feature2id.name
    id2feature_report = aConfig.id2feature.name
    aModel.mapping_reports(feature2id_report, id2feature_report, true)
    aModel.draw_dependency_graph(aConfig.graph_file.name, true)
    aModel.generate_rake_tasks(aConfig.rake_file, proj_dir)
  end
end # class

end # module

# End of file
