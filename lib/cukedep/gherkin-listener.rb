# File: gherkin-listener.rb

require_relative 'feature-rep'


module Cukedep # This module is used as a namespace
  class FeatureFileRep 
    attr_reader(:filepath)
    attr(:feature, true)
    
    def initialize(aFilepath)
      @filepath = aFilepath
    end
    
    def basename()
      File.basename(filepath)
    end
  end # class

  # A ParserListener listens to all the formatting events
  # emitted by the Gherkin parser.
  # It converts the received the feature file elements and builds
  # a representation of the feature files that is appropriate
  # for the Cukedep application.
  class GherkinListener
    # The list of feature files encountered so far
    attr_reader(:feature_files)

    # Internal representation of the feature being parsed
    attr(:current_feature, true)
    
    def initialize()
      @feature_files = []
    end
    
    ######################################
    # Event listening methods
    ######################################

    # Called when beginning the parsing of a feature file.
    # featureURI: path + filename of feature file.
    def uri(featureURI)
      new_file = FeatureFileRep.new(featureURI)
      feature_files << new_file
    end

    # aFeature is a Gherkin::Formatter::Model::Feature instance
    def feature(aFeature)
      tag_names = aFeature.tags.map(&:name)
      @current_feature = feature_files.last.feature = FeatureRep.new(tag_names)
    end

    # aBackground is a Gherkin::Formatter::Model::Background instance
    def background(_aBackground)
      ; # Do nothing
    end
    
    # aScenario is a Gherkin::Formatter::Model::Scenario instance
    def scenario(_aScenario)
      ; # Do nothing
    end
    
    # aScenarioOutline is a Gherkin::Formatter::Model::ScenarioOutline instance
    def scenario_outline(_aScenarioOutline)
      ; # Do nothing  
    end
    
    # theExamples is a Gherkin::Formatter::Model::Examples instance
    def examples(_theExamples)
      ; # Do nothing 
    end

    # aStep is a Gherkin::Formatter::Model::Step instance
    def step(_aStep)
      ; # Do nothing
    end
    
    # End of feature file notification.
    def eof()
      ; # Do nothing
    end


    # Catch all method
    def method_missing(message, *_args)
      puts "Method #{message} is not implemented (yet)."
    end
  end # class
end # module

# End of file
