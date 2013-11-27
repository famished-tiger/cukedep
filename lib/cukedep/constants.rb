# File: constants.rb
# Purpose: definition of Cukedep constants.

module Cukedep # Module used as a namespace
  # The version number of the gem.
  Version = '0.1.01'

  # Brief description of the gem.
  Description = 'Manage dependencies between Cucumber feature files'

  # Constant Cukedep::RootDir contains the absolute path of Rodent's
  # root directory. Note: it also ends with a slash character.
  unless defined?(RootDir)
  # The initialisation of constant RootDir is guarded in order
  # to avoid multiple initialisation (not allowed for constants)

    # The root folder of Cukedep.
    RootDir = begin
      require 'pathname'	# Load Pathname class from standard library
      rootdir = Pathname(__FILE__).dirname.parent.parent.expand_path
      rootdir.to_s + '/'	# Append trailing slash character to it
    end

    # The file name for the user's settings
    YMLFilename = '.cukedep.yml'
    
    # The file name for the custom block codes associated
    # with before/after events.
    HookFilename = 'cukedep_hooks.rb'
  end
end # module

# End of file
