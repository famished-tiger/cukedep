# File: sandbox.rb


module Cukedep # This module is used as a namespace

  # A context in which hook block codes are run.
  class Sandbox

    attr_reader(:base_dir)
    attr_reader(:proj_dir)

    def initialize(theBaseDir, theProjectDir)
      @base_dir = theBaseDir.dup.freeze
      @proj_dir = theProjectDir.dup.freeze
    end

  end # class

end # module

# End of file