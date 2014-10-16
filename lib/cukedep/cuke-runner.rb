# File: cuke-runner.rb

require 'pathname'
require 'rake'

# Run Cucumber via specialized Rake task
require 'cucumber/rake/task'

require_relative 'file-action'
require_relative 'customization'

# UGLY workaround for bug in Cucumber's rake task
if Gem::VERSION[0].to_i >= 2 && Cucumber::VERSION <= '1.3.2'
  # Monkey-patch a buggy method
  module Cucumber
    module Rake
      class Task
        class ForkedCucumberRunner
          def gem_available?(gemname)
            if Gem::VERSION[0].to_i >= 2
              gem_available_new_rubygems?(gemname)
            else
              gem_available_old_rubygems?(gemname)
            end
          end
        end # class  
      end # class
    end # module
  end # module
end



module Cukedep # This module is used as a namespace

# Purpose: to launch Cucumber in the appropriate directory
# and pass it command-line arguments.
# Responsibilities:
# Know how to invoke Cucumber
# Know the base directory
# Know the project's root dir
class CukeRunner
  # The current state of the runner.
  attr_reader(:state)

  # The absolute path of the root's project directory
  attr_reader(:proj_dir)
  attr_reader(:base_dir)
  attr_reader(:config)
  attr_reader(:handlers)

  attr(:cucumber_opts, true)

  # Constructor
  def initialize(baseDir, projectDir, aConfig)
    @base_dir = baseDir
    @proj_dir = validated_proj_dir(projectDir)
    @config = aConfig
    @handlers = Customization.new.build_handlers(baseDir)

    @state = :Initialized
  end

  # Launch Cucumber in the project directory.
  def invoke()
    options = [] # TODO: retrieve Cucumber options
    orig_dir = Dir.getwd
    Dir.chdir(proj_dir)

    begin
      cuke_task = Cucumber::Rake::Task.new do |t|
        t.cucumber_opts = options
      end

      cuke_task.runner.run
    rescue SystemExit => exc  # Cucumber reports a failure.
      raise StandardError, "Cucumber exited with status #{exc.status}"
    ensure
      Dir.chdir(orig_dir)
    end
  end

  # Event handler that is triggered
  # before any other event.
  # It executes the before all hook first.
  # Then it executes in the following order:
  # Built-in save action, Custom save action
  # Built-in delete action, Custom delete action
  # Built-in copy action, Custom copy action
  def before_all()
    expected_state(:Initialized)

    # Execute before all hook code
    run_code_block

    # Execute file actions
    builtin_actions = ActionTriplet.builtin(:before_all)
    custom_actions = ActionTriplet.new(config.before_all_f_actions)
    run_triplets([builtin_actions, custom_actions])
    @state = :ReadyToRun
  end


  # Event handler that is triggered
  # after any other event.
  # It executes first actions in the following order:
  # Built-in save action, Custom save action
  # Built-in delete action, Custom delete action
  # Built-in copy action, Custom copy action
  # Then it executes the after all hook last.
  def after_all()
    expected_state(:ReadyToRun)

    builtin_actions = ActionTriplet.builtin(:after_all)
    custom_actions = ActionTriplet.new(config.after_all_f_actions)
    run_triplets([builtin_actions, custom_actions])

    # Execute before all hook code
    run_code_block
    @state = :Complete
  end


  def run!(fileNames)
    expected_state(:ReadyToRun)
    before_each(fileNames)
    invoke
    after_each
  end


  private

  def validated_proj_dir(projectDir)
    path = Pathname.new(projectDir)
    path = path.expand_path if path.relative?
    fail StandardError, "No such project path: '#{path}'" unless path.exist?

    return path.to_s
  end

  def expected_state(aState)
    return if state == aState
    msg = "expected state was '#{aState}' instead of '#{state}'."
    fail StandardError, msg
  end


  def before_each(fileNames)
    # Execute before each hook code
    run_code_block(fileNames)

    builtins = ActionTriplet.builtin(:before_each).dup
    builtins.copy_action.patterns = fileNames unless builtins.nil?

    custom_actions = ActionTriplet.new(config.before_each_f_actions)
    run_triplets([builtins, custom_actions])
  end


  def after_each()
    builtin_actions = ActionTriplet.builtin(:after_each)

    custom_actions = ActionTriplet.new(config.after_each_f_actions)
    run_triplets([builtin_actions, custom_actions])

    # Execute after each hook code
    run_code_block
  end


  def run_triplets(theTriplets)
    all_triplets = theTriplets.compact # Remove nil elements

    # Do all save actions...
    all_triplets.each { |t| t.save_action.run!(proj_dir, base_dir) }

    # Do all delete actions...
    all_triplets.each { |t| t.delete_action.run!(proj_dir) }

    # Do all copy actions...
    all_triplets.each { |t| t.copy_action.run!(base_dir, proj_dir) }
  end


  def run_code_block(*args)
    # Retrieve the name of the parent method.
    parent_mth = (caller[0].sub(/^(.+):in (.+)$/, '\2'))[1..-2]
    kind, scope = parent_mth.split('_')
    hook_kind = (kind + '_hooks')

    kode = handlers[hook_kind.to_sym][scope.to_sym]
    return if kode.nil?
    safe_args = args.map { |one_arg| one_arg.dup.freeze }
    kode.call(*safe_args)
  end


end # class

end # module

# End of file
