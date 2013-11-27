# File: spec_helper.rb
# Purpose: utility file that is loaded by all our RSpec files

require 'simplecov' # Use SimpleCov for test coverage measurement


require 'rspec'	# Use the RSpec framework
require 'pp'	# Use pretty-print for debugging purposes

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # Disable the `should` syntax...
    c.syntax = :expect
  end
  config.full_backtrace = true
end


# End of file
