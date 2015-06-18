# File: customization_spec.rb

require_relative '../spec_helper'

# Load the class under testing
require_relative '../../lib/cukedep/customization'

module Cukedep # Open module to get rid of long qualified names
  describe Customization do
    context 'Provided services:' do
      it 'should load hook handlers' do
        directory = File.join(File.dirname(__FILE__), '/sample_features')

        expect { subject.build_handlers(directory) }.not_to raise_error
        expect(subject.build_handlers(directory)).not_to be_nil
        handlers = subject.build_handlers(directory)
        expect(handlers[:before_hooks].size).to eq(2)
        expect(handlers[:after_hooks].size).to eq(2)
      end

      it 'should return nil when hook file absent' do
        directory = File.dirname(__FILE__)

        expect { subject.build_handlers(directory) }.not_to raise_error
        expect(subject.build_handlers(directory)).to be_nil
      end
    end # context
  end # describe
end # module

# End of file
