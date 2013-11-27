# File: file-action_spec.rb

require 'stringio'
require_relative '../spec_helper'

# Load the class under testing
require_relative '../../lib/cukedep/hook-dsl'

module Cukedep # Open module to get rid of long qualified names

# Let's specify the behaviour of the mix-in module
describe HookDSL do

  subject do
    obj = Object.new
    obj.extend(HookDSL)
    obj
  end

  context 'Hook definitions:' do
    let(:code_block) do
      -> { ; }
    end

    it 'should accept the before all hook' do
      # Case 1: before all with block code
      expect { subject.before_cuke(:all, &code_block) }.not_to raise_error

      # Case 2: before all without block code
      expect { subject.before_cuke(:all) }.not_to raise_error
    end

    it 'should accept the before each hook' do
      # Case 1: before each with block code
      expect { subject.before_cuke(:each, &code_block) }.not_to raise_error

      # Case 2: before each without block code
      expect { subject.before_cuke(:each) }.not_to raise_error
    end


    it 'should accept the after all hook' do
      # Case 1: after all with block code
      expect { subject.after_cuke(:all, &code_block) }.not_to raise_error

      # Case 2: before all without block code
      expect { subject.after_cuke(:all) }.not_to raise_error
    end

    it 'should accept the after each hook' do
      # Case 1: after each with block code
      expect { subject.after_cuke(:each, &code_block) }.not_to raise_error

      # Case 2: after each without block code
      expect { subject.after_cuke(:each) }.not_to raise_error
    end

    it 'should reject invalid scope argument' do
      # Case 1: before invalid with block code
      msg = "Unknown scope 'invalid' for before_cuke hook."
      error = StandardError
      expect { subject.before_cuke(:invalid, &code_block) }.to raise_error(error, msg)

      # Case 2: after invalid with block code
      msg = "Unknown scope 'invalid' for after_cuke hook."
      expect { subject.after_cuke(:invalid, &code_block) }.to raise_error(error, msg)
    end


    it 'should register the block code with the event' do
      # No block code registered yet.
      expect(subject.instance_variables).not_to include(:@before_hooks)

      # Case 1: No before all handler provided
      subject.before_cuke(:all)
      expect(subject.instance_variables).not_to include(:@before_hooks)

      # Case 1: Add before all handler
      subject.before_cuke(:all, &code_block)

      # Check that handler code is stored in instance variable
      expect(subject.instance_variables).to include(:@before_hooks)
      expect(subject.before_hooks.keys).to eq([:all])
      expect(subject.before_hooks[:all]).to eq(code_block)

      # Case 2: No before each handler provided
      subject.before_cuke(:each)
      expect(subject.before_hooks.keys).to eq([:all])

      # Case 3: Add before each handler
      subject.before_cuke(:each, &code_block)

      # Check that handler code is stored in instance variable
      expect(subject.before_hooks.keys).to eq([:all, :each])
      expect(subject.before_hooks[:each]).to eq(code_block)


      # Case 4: No after all handler provided
      subject.after_cuke(:all)
      expect(subject.instance_variables).not_to include(:@after_hooks)

      # Case 5: Add after all handler
      subject.after_cuke(:all, &code_block)

      # Check that handler code is stored in instance variable
      expect(subject.instance_variables).to include(:@after_hooks)
      expect(subject.after_hooks.keys).to eq([:all])
      expect(subject.after_hooks[:all]).to eq(code_block)

      # Case 6: No after each handler provided
      subject.after_cuke(:each)
      expect(subject.after_hooks.keys).to eq([:all])

      # Case 7: Add after each handler
      subject.after_cuke(:each, &code_block)

      # Check that handler code is stored in instance variable
      expect(subject.after_hooks.keys).to eq([:all, :each])
      expect(subject.after_hooks[:each]).to eq(code_block)
    end

  end # context
=begin
  context 'Executing handler code:' do
    let(:ostream) { StringIO.new('', 'w') }
    
    it 'should ignore missing handler' do
      expect { subject.execute_hook(:before, :all) }.not_to raise_error
    end

    it 'should execute the before all handler' do
      text = 'before all'
      # Let's create the hook
      subject.before_cuke(:all) { ostream.print text }

      # Let's execute it...
      subject.execute_hook(:before, :all)

      expect(ostream.string).to eq(text)
    end


    it 'should execute the before all handler' do
      text = 'before each'
      # Let's create the hook
      subject.before_cuke(:each) { ostream.print text }

      # Let's execute it...
      subject.execute_hook(:before, :each)

      expect(ostream.string).to eq(text)
    end


    it 'should execute the after all handler' do
      text = 'after all'
      # Let's create the hook
      subject.after_cuke(:all) { ostream.print text }

      # Let's execute it...
      subject.execute_hook(:after, :all)

      expect(ostream.string).to eq(text)
    end


    it 'should execute the after each handler' do
      text = 'after each'
      # Let's create the hook
      subject.after_cuke(:each) { ostream.print text }

      # Let's execute it...
      subject.execute_hook(:after, :each)

      expect(ostream.string).to eq(text)
    end

  end # context
=end

end # describe

end # module

# End of file