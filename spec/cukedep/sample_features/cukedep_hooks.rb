# File: cukedep_hooks.rb
# This Ruby file specifies the custom code
# associated with Cukedep hooks.

# The code block will be executed before
# the very first Cucumber invocation.
before_cuke(:all) do
  puts 'before all'
end

# The code block will be executed just before
# a Cucumber invocation.
# The argument is a frozen Array of feature file names
before_cuke(:each) do |filenames|
  puts 'before each'
end

# The code block will be executed just after
# a Cucumber invocation.
after_cuke(:each) do
  puts 'after each'
end

# The code block will be executed just after
# the last Cucumber invocation.
after_cuke(:all) do
  puts 'after all'  
end

# End of file