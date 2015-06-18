# File: cli.rb

# Access the OptionParser library from the standard Ruby library
require 'optparse'
require 'pathname'

require_relative '../constants'

module Cukedep # This module is used as a namespace
# Module dedicated to the command-line interface
module CLI
# Manages the application command-line interface (CLI).
# It is merely a thin wrapper around the OptionParser library.
# Responsibilities:
#- Specify the command-line syntax,
#- Return the result of the command-line parsing
class CmdLine
  # A Hash with the result of the command-line parse.
  attr_reader(:options)

  # OptionParser object
  attr_reader(:parser)

  # Constructor.
  def initialize()
    @options = {}

    @parser = OptionParser.new do |opts|
      opts.banner = <<-EOS
Usage: cukedep [options]
The command-line options are:
EOS

      # No argument.  Check
      dry_txt1 = 'Check the feature file dependencies'
      dry_txt2 = ' without running the feature files.'
      opts.on(nil, '--dry-run', dry_txt1 + dry_txt2) do
        options[:dryrun] = true
      end

      # No argument.  Create .cukedep.yml file
      setup_txt = 'Create a default .cukedep.yml file in current dir.'
      opts.on(nil, '--setup', setup_txt) do
        options[:setup] = true
      end

      # Mandatory argument
      msg_p1 = 'Run the Cucumber project at given path '
      msg_p2 = 'with features from current dir.'
      opts.on('--project PROJ_PATH', msg_p1 + msg_p2) do |project_path|
        options[:project] = validated_project(project_path)
      end

      # No argument, shows at tail.  This will print an options summary.
      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        options[:help] = true
      end

      opts.on_tail('--version', 'Show application version number') do
        puts Cukedep::Version
        options[:version] = true
      end
    end
  end

  public

  # Perform the command-line parsing
  def parse!(theCmdLineArgs)
    begin
      parser.parse!(theCmdLineArgs)    
    rescue OptionParser::MissingArgument => exc
      err_msg = ''
      exc.args.each do |arg|
        err_msg << "No argument provided with command line option: #{arg}\n"
      end
      err_msg << 'To see the command-line syntax, do:\ncukedep --help'
      raise(StandardError, err_msg)
    end

    # Some options stop the application
    exit if options[:version] || options[:help]
    
    return options
  end

  private
  
  def validated_project(theProjectPath)
    unless Dir.exist?(theProjectPath)
      fail StandardError, "Cannot find the directory '#{theProjectPath}'."
    end
    
    # If current dir is /features and project dir is parent of it
    # then we have an error
    current_path = Pathname.getwd
    if current_path.to_s =~ /features$/
      if current_path.parent == Pathname.new(theProjectPath)
        msg_prefix = "Don't place original feature file in 'features'"
        msg_suffix = ' subdir of project dir.'
        fail StandardError, msg_prefix + msg_suffix
      end
    end
    

    return theProjectPath
  end
end # class
end # module
end # module

# End of file
