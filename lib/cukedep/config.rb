# File: config.rb

require 'yaml'
require_relative 'file-action'

module Cukedep # Module used as a namespace
  FileMetaData = Struct.new(:name)

  Config = Struct.new(
    :feature_encoding, # The character encoding of feature files
    :proj_dir,    # The directory of the cucumber project
    :feature2id,  # Meta-data about the feature => feature id report
    :id2feature,  # Meta-data about the feature id => feature report
    :graph_file,  # Meta-data about the dependency graph file
    :rake_file,   # Name of the output rake file
    :cucumber_args, # Command-line syntax to use for the cucumber application
    # File actions triggered at Cucumber invocation events
    :before_all_f_actions,
    :before_each_f_actions,
    :after_each_f_actions,
    :after_all_f_actions
  )

  # Re-open the class for further customisation
  # Configuration object for the Cukedep application.
  class Config
    # Factory method. Build a config object with default settings.
    def self.default
      instance = Config.new(
        'UTF-8',
        nil,
        FileMetaData.new('feature2id.csv'),
        FileMetaData.new('feature2id.csv'),
        FileMetaData.new('dependencies.dot'),
        'cukedep.rake',
        []
      )

      file_action_attrs.each do |attr|
        instance[attr] = empty_action_triplet
      end

      return instance
    end

    # Read the YAML file with specified name from the current working directory.
    # If that file does not exist, then return an instance with default values.
    def self.load_cfg(filename)
      # TODO: validation
      instance = File.exist?(filename) ? YAML.load_file(filename) : default

      return instance
    end

    # Save the Config object to a YAML file.
    def write(filename)
      File.open(filename, 'w') { |f| YAML.dump(self, f) }
    end

    # Purpose: get the list of attributes referencing
    # a file action triplet.
    def self.file_action_attrs
      return %I[
        before_all_f_actions
        before_each_f_actions
        after_each_f_actions
        after_all_f_actions
      ]
    end

    # Return Hash config for a no-op action triplet.
    def self.empty_action_triplet
      {
        save_patterns: [],
        save_subdir: '',
        delete_patterns: [],
        delete_subdir: '',
        copy_patterns: [],
        copy_subdir: ''
      }
    end
  end # class
end # module

# End of file
