# File: file-parsing.rb

require_relative '../../lib/cukedep/gherkin-facade'

module Cukedep # This module is used as a namespace

  # Mixin module used in tests.
  # Purpose: to parse a sample of feature files.
  module FileParsing
    # The list of sample feature file names.
    SampleFileNames = [ "a_few_tests.feature", 
        "some_tests.feature",
        "still_other_tests.feature",
        "yet_other_tests.feature",
        "more_tests.feature",
        "standalone.feature"
      ]

    # Helper method. It parses sample feature files and
    # notifies the provided listener of its progress.
    def parse_for(aListener)
      orig_dir = Dir.getwd()
      begin
        # Determine the folder where the sample files reside
        my_dir = File.dirname(__FILE__)
        sample_dir = File.expand_path(my_dir + '/sample_features')
        Dir.chdir(sample_dir)
        
        # Parse the specified feature files in work directory
        is_verbose = false
        gherkin_facade = GherkinFacade.new(is_verbose, 'UTF-8')
        gherkin_facade.parse_features(aListener, SampleFileNames)
      ensure
        Dir.chdir(orig_dir)
      end
      
    end
  
  end # module

end # module

# End of file