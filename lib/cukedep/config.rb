# File: config.rb

module Cukedep # Module used as a namespace

FileMetaData = Struct.new(:name)

Config = Struct.new(
  :proj_dir,    # The directory of the cucumber project
  :feature2id,  # Meta-data about the feature => feature id report
  :id2feature,  # Meta-data about the feature id => feature report
  :graph_file,  # Meta-data about the dependency graph file
  :rake_file,   # Name of the output rake file
  :cucumber_args # Command-line syntax to use for the cucumber application
)

# Re-open the class for further customisation
  
# Configuration object for the Cukedep application.
class Config
  # Factory method. Build a config object with default settings.
  def self.default()
    Config.new(nil, FileMetaData.new('feature2id.csv'), 
      FileMetaData.new('feature2id.csv'), FileMetaData.new('dependencies.dot'),
      'cukedep.rake', [])
  end

end # class

end # module

# End of file