# File: customization.rb

require_relative 'constants'
require_relative 'hook-dsl'

module Cukedep # This module is used as a namespace


  class Customization

    # Retrieve before/after handlers from file
    # Handlers are put in a Hash with keys :before_hooks, :after_hooks.
    def build_handlers(directory)
      handlers = nil

      filepath = directory + '/' + Cukedep::HookFilename
      if File.exist? filepath
        obj = Object.new
        obj.extend(HookDSL)
        hook_source = File.read(filepath)
        obj.instance_eval(hook_source)
        handlers =  {
          before_hooks: obj.before_hooks,
          after_hooks: obj.after_hooks
        }
      end

      return handlers
    end

  end # class

end # module

# End of file
