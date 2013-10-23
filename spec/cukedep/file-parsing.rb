# File: file-parsing.rb

require 'gherkin/parser/parser'

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
      # Determine the folder where the sample files reside
      my_dir = File.dirname(__FILE__)
      sample_dir = File.expand_path(my_dir + '/sample_features')
      
      # Create a Gherkin parser
      parser = Gherkin::Parser::Parser.new(aListener)
      
      # Let it parse the requested files
      SampleFileNames.each do |sample|
        path = sample_dir + '/' + sample
        File::open(path, 'r') { |f| parser.parse(f.read, path, 0) }
      end
    end
  
  end # module

end # module

# End of file