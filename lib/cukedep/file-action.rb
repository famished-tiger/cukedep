# File: file-action.rb

require 'pathname'
require 'fileutils'

module Cukedep # This module is used as a namespace
  class FileAction
    attr(:patterns, true)
    attr_reader(:delta)

    # Constructor.
    # [thePatterns] An array of file patterns.
    def initialize(thePatterns, aDelta = nil)
      @patterns = validate_file_patterns(thePatterns)
      @delta  = validate_delta(aDelta)
    end


    # Datavalue semantic: FileActions don't have identity
    def ==(other)
      return true if object_id == other.object_id
      return false if self.class != other.class

      attrs = [:patterns, :delta]
      equality = true

      attrs.each do |accessor|
        equality = send(accessor) == other.send(accessor)
        break unless equality
      end

      return equality
    end


    protected

    def validate_file_patterns(filePatterns)
      err_msg = 'Expecting a list of file patterns'
      fail StandardError, err_msg unless filePatterns.is_a?(Array)
      filePatterns.each do |filePatt|
        err_msg = "Invalid value in list of file patterns: #{filePatt}"
        fail StandardError, err_msg unless filePatt.is_a?(String)
      end

      return filePatterns
    end

    def validate_delta(aDelta)
      case aDelta
        when NilClass then validated = nil
        when String
          validated = aDelta.empty? ? nil : aDelta
        else
          fail StandardError, 'Invalid relative path #{aDelta}'
      end

      return validated
    end

    # Determine the complete target path
    # complete target path = target dir + delta
    def full_path(targetDir)
      if delta.nil?
        result = Pathname.new(targetDir)
      else
        result = (Pathname.new(targetDir) + delta)
      end

      path = result.relative? ? result.expand_path : result

      return path.to_s
    end
  end # class



  # A delete action object has for purpose to
  # delete files matching one of its file patterns.
  # These file are deleted from (a subdir of) a given 'target' directory.
  class DeleteAction < FileAction
    # Constructor.
    # [thePatterns] An array of file patterns.
    def initialize(thePatterns, aDelta = nil)
      super(thePatterns, aDelta)
    end

    def run!(targetDir)
      return if patterns.empty?
      orig_dir = Dir.getwd  # Store current work directory
      # pp orig_dir

      begin
        Dir.chdir(full_path(targetDir))

        patterns.each do |pattern|
          Dir.glob(pattern) { |fname| single_action(fname) }
        end
      ensure
        Dir.chdir(orig_dir) # Restore original work directory
      end
    end

    private

    def single_action(aFilename)
      FileUtils.remove_file(aFilename)
    end
  end # class



  # A copy action object has for purpose to
  # copy files matching one of its file patterns.
  # These file are copied from a given 'source' directory
  # and are placed in a target directory or a specific subdirectory
  # of the target directory.
  class CopyAction < FileAction
    def run!(sourceDir, targetDir)
      return if patterns.empty?
      orig_dir = Dir.getwd  # Store current work directory

      begin
        Dir.chdir(sourceDir)

        destination = full_path(targetDir)

        patterns.each do |pattern|
          Dir.glob(pattern) { |fname| single_action(fname, destination) }
        end
      ensure
        Dir.chdir(orig_dir) # Restore original work directory
      end
    end

    private

    def single_action(aFilename, aDirectory)
      FileUtils.cp(aFilename, aDirectory)
    end
  end # class


  # An (file) action triplet combines three FileActions
  # that are executed in sequence.
  class ActionTriplet
    attr_reader(:save_action)
    attr_reader(:delete_action)
    attr_reader(:copy_action)

    # [theActionSettings] An object that responds to the [] operator.
    # The argument of the operator must be:
    # :save_patterns, :save_subdir, :delete_patterns, :delete_subdir,
    # :copy_patterns, :copy_subdir
    def initialize(theActionSettings)
      @save_action = CopyAction.new(theActionSettings[:save_patterns],
                                    theActionSettings[:save_subdir])
      @delete_action = DeleteAction.new(theActionSettings[:delete_patterns],
                                        theActionSettings[:delete_subdir])
      @copy_action = CopyAction.new(theActionSettings[:copy_patterns],
                                    theActionSettings[:copy_subdir])
    end


    def ==(other)
      return true if object_id == other.object_id

      return (save_action == other.save_action) &&
        (delete_action == other.delete_action) &&
        (copy_action == other.copy_action)
    end


    # Launch the file actions in sequence.
    def run!(currentDir, projectDir)
      save_action.run!(projectDir, currentDir)
      delete_action.run!(projectDir)
      copy_action.run!(currentDir, projectDir)
    end


    # Retrieve the 'built-in' action triplet associated with the given event.
    # Return nil if no triplet was found for the event.
    def self.builtin(anEvent)
      @@builtin_actions ||= {
        before_each: ActionTriplet.new(
          save_patterns: [],
          save_subdir: '',
          delete_patterns: ['*.feature'],
          delete_subdir: './features',
          copy_patterns: [],
          copy_subdir: './features'
        ),
        after_each: ActionTriplet.new(
          save_patterns: [],
          save_subdir: '',
          delete_patterns: ['*.feature'], # Remove feature files after the run
          delete_subdir: './features',
          copy_patterns: [],
          copy_subdir: ''
        )
      }

      return @@builtin_actions.fetch(anEvent, nil)
    end
  end # class
end # module

# End of file
