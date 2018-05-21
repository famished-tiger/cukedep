# File: gherkin-facade.rb
require 'gherkin/parser'


module Cukedep # This module is used as a namespace
  # Facade design pattern: A facade is an object that provides
  # a simplified interface to a larger body of code.
  # Here the GherkinFacade class provides basic parsing service.
  class GherkinFacade
    # Indicate whether the parsing must be verbose or silent
    attr_reader(:verbose)

    # (External) encoding of the feature files.
    # It is a string that represents the name of an encoding
    # as expected by the mode argument of the IO#new method
    attr_reader(:external_encoding)

    def initialize(isVerbose, anExternalEncoding)
      @verbose = isVerbose
      @external_encoding = anExternalEncoding
    end

    # Parse feature files from the work directory that match
    # one of the given file name patterns.
    # Parse events are sent to the passed listener object.
    def parse_features(aListener, file_patterns)
      # Create a Gherkin parser
      parser = Gherkin::Parser.new

      puts "\nParsing:" if verbose
      # List all .feature files in work directory that match the pattern
      filenames = []
      file_patterns.each { |patt| filenames.concat(Dir.glob(patt)) }
      # Parse them
      filenames.each do |fname|
        puts "  #{fname}" if verbose
        # To prevent encoding issue, open the file
        # with an explicit external encoding
        File.open(fname, "r:#{external_encoding}") do |f|
          raw = parser.parse(f.read)
          parse_raw_feature(raw[:feature], fname, aListener) if raw[:feature]
        end
      end

      return aListener
    end

    def parse_raw_feature(raw_feature, file_name, listener)
      listener.uri(file_name)
      raw_tags = raw_feature[:tags]
      tag_names = raw_tags.map { |raw_tag| raw_tag[:name] }
      listener.feature_tags(tag_names)
    end
  end # class
end # module

# End of file
