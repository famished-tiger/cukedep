# File: file-actions_spec.rb

require_relative '../spec_helper'

# Load the class under testing
require_relative '../../lib/cukedep/gherkin-facade'
require_relative '../../lib/cukedep/gherkin-listener'

module Cukedep # Open module to get rid of long qualified names
describe GherkinFacade do
  subject { GherkinFacade.new(false, 'UTF-8') }

  context 'Creation & initialization:' do
    it 'should be created with two arguments' do
      expect { GherkinFacade.new(true, 'UTF-8') }.not_to raise_error
    end
    
    it 'should whether it is verbose or not' do
      # Case 1: instance is verbose
      expect(subject.verbose).to be_falsey
      
      # Case 2: instance is silent
      instance =  GherkinFacade.new(true, 'UTF-8')
      expect(instance.verbose).to be_truthy 
    end
    
    it 'should know the feature file external encoding' do
      expect(subject.external_encoding).to eq('UTF-8')
    end
  end # context


  
  context 'Provided services:' do
    let(:listener) { GherkinListener.new }
    it 'should parse ASCII feature files' do
      instance = GherkinFacade.new(false, 'US-ASCII')
      patterns = [ 'sample_features/a_few_tests.feature' ]
      expect { instance.parse_features(listener, patterns) }.not_to raise_error
    end
    
    it 'should parse feature files with other external encoding' do
      patterns = [ 'sample_features/standalone.feature' ]
      expect { subject.parse_features(listener, patterns) }.not_to raise_error
    end
  end # context
end # describe
end # module
# End of file
