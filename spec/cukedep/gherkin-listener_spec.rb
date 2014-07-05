# File: gherkin-listener_spec.rb

require_relative '../spec_helper'


require_relative 'file-parsing'

# Load the class under testing
require_relative '../../lib/cukedep/gherkin-listener'

module Cukedep # Open module to get rid of long qualified names

describe GherkinListener do
  include FileParsing # Use mixin module to parse of sample feature files
  
  subject { GherkinListener.new }

  context 'Creation and initialization:' do
    it 'should be created without argument' do
      expect {GherkinListener.new }.not_to raise_error
    end
    
    it 'should have no feature file at start' do
      expect(subject.feature_files.size).to eq(0)
    end
  end # context
  
  context 'Provided services:' do
    it 'should build a FeatureFileRep per parsed file' do
      parse_for(subject)
      expect(subject.feature_files.size).to eq(FileParsing::SampleFileNames.size)
    end
    
    it 'should know the tags of each feature' do
      parse_for(subject)
      
      expectations = [
        %w[a_few feature:qux],
        %w[some feature:foo depends_on:bar depends_on:qux],
        %w[still_other feature:baz],
        %w[yet_other feature:bar depends_on:baz depends_on:qux depends_on:quux],
        %w[feature:quux more],
        []
      ]

      # Sort the expectations to ease further comparison
      expectations.map! { |tags| tags.sort }
      
      subject.feature_files.each_with_index do |file, i|
        expect(file.feature.tags.sort).to eq(expectations[i])
      end
    end
  end # context

end # describe

end # module

# End of file