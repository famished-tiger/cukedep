# File: env.rb

require 'rspec/expectations'
require_relative '../../model/model'

AfterConfiguration do |_|
  # Quick and dirty implementation: use a global variable
  # as an entry point to the domain model.
  $store = Sample::RentalStore.new
end

# End of file
