# File: feature-rep_spec.rb

require_relative '../spec_helper'

# Load the class under testing
require_relative '../../lib/cukedep/feature-rep'

module Cukedep # Open module to get rid of long qualified names
describe FeatureRep do
  # Tag names as provided by Gherkin parser
  RawTagNames = %w(@some @feature:CO801_foo @depends_on:CO201_bar @depends_on:CO001_qux)

  SampleTagNames = RawTagNames.map { |t| t[1..-1] }

  subject { FeatureRep.new(RawTagNames) }


  context 'Creation and initialization:' do
    it 'could be created with an empty list of tags' do
      expect { FeatureRep.new([]) }.not_to raise_error
    end

    it 'could be created with a list of tag names' do
      expect { FeatureRep.new(RawTagNames) }.not_to raise_error
    end

    it 'should know its tags' do
      expect(subject.tags).to eq(SampleTagNames)
    end

    it 'should know its identifier' do
      expect(subject.identifier).to eq('CO801_foo')
    end

    it 'should know whether is has an indentifier' do
      expect(subject).not_to be_anonymous
    end
  end # context

  context 'Provided services:' do
    it 'should know the feature files it depends on' do
      expected_values = %w(CO201_bar CO001_qux)

      expect(subject.dependency_tags.sort).to eq(expected_values.sort)
    end
  end # context
end # describe
end # module

# End of file
