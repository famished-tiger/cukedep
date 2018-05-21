# File: hook-dsl.rb


module Cukedep # Module used as a namespace
# Mix-in module that defines the DSL (Domain-Specific Language)
# for specifying Cukedep hooks.
# A hook is a custom code block that is executed when
# a pre-defined Cukedep event occurs.
module HookDSL
  ValidHookScopes = %i[all each].freeze

  attr_reader(:before_hooks)
  attr_reader(:after_hooks)


  # This method registers the code block to execute
  # before a Cucumber invocation.
  def before_cuke(aScope, &aBlock)
    kind = :before
    scope = validated_scope(kind, aScope)
    register_hook(kind, scope, aBlock) if block_given?
  end

  # This method registers the code block to execute
  # before a Cucumber invocation.
  def after_cuke(aScope, &aBlock)
    kind = :after
    scope = validated_scope(kind, aScope)
    register_hook(kind, scope, aBlock) if block_given?
  end

=begin
  # Execute the specific hook.
  def execute_hook(aKind, aScope)
    scope = validated_scope(aKind, aScope)
    case [aKind, scope]
    when [:before, :all],  [:before, :each], [:after, :each], [:after, :all]
      handler = handler_for(aKind, scope)
    else
      raise StandardError, "Unknown Cukedep hook #{aKind}, #{aScope}"
    end

    handler.call unless handler.nil?
  end
=end

  private

  def register_hook(aKind, aScope, aBlock)
    scope = validated_scope(aKind, aScope)

    ivar = "@#{aKind}_hooks".to_sym
    instance_variable_set(ivar, {}) if instance_variable_get(ivar).nil?
    instance_variable_get(ivar)[scope] = aBlock
  end

  def validated_scope(aKind, aScope)
    unless ValidHookScopes.include?(aScope)
      msg = "Unknown scope '#{aScope}' for #{aKind}_cuke hook."
      raise StandardError, msg
    end

    return aScope
  end

  def handler_for(aKind, aScope)
    if aKind == :before
      hooks = before_hooks
    else
      hooks = after_hooks
    end

    handler = hooks.nil? ? nil : hooks.fetch(aScope)
    return handler
  end
end # module
end # module
# End of file
