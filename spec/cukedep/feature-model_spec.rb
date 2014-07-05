# File: feature-model_spec.rb

require_relative '../spec_helper'


require_relative 'file-parsing'
require_relative '../../lib/cukedep/gherkin-listener'

# Load the class under testing
require_relative '../../lib/cukedep/feature-model'

module Cukedep # Open module to get rid of long qualified names

describe FeatureModel do
  # An array of FeatureFile objects created after parsing sample files.
  FeatureFiles = begin
    listener = GherkinListener.new
    self.extend(FileParsing)  # Add behaviour from mixin module
    parse_for(listener) # Method from mixin to parse sample feature files
    listener.feature_files
  end
  
  # Default instantiation rule
  subject { FeatureModel.new(FeatureFiles) }

  context 'Creation and initialization:' do
    it 'should be created with a list of feature files' do
      expect { FeatureModel.new(FeatureFiles) }.not_to raise_error
    end

    it 'should know its feature file objects' do
      expect(subject.feature_files).to eq(FeatureFiles)
    end

  end # context
  
  context 'Provided services:' do
    it 'should list all features without identifiers' do
      unidentified = subject.anonymous_features
      expect(unidentified.size).to eq(1)
      expect(unidentified[0].filepath).to match(/standalone\.feature$/)
    end
   
    it 'should retrieve a feature file given its identifier' do
      # Case of a single id argument
      one_id = 'foo'
      found = subject.select_by_ids(one_id)
      expect(found.size).to eq(1)
      expect(found[0].feature.identifier).to eq(one_id)
      
      # Case of multiple id arguments
      second_id = 'qux'
      found = subject.select_by_ids(one_id, second_id)
      expect(found.size).to eq(2)
      actual_ids = found.map {|ff| ff.feature.identifier}
      expected_ids = [one_id, second_id]
      expect(actual_ids.sort).to eq(expected_ids.sort)
      
      # Case of unknown id
      wrong_id = 'does_not_exist'
      err_type = StandardError
      err_msg = "No feature file with identifier 'does_not_exist'."
      expect { subject.select_by_ids(wrong_id) }.to raise_error(err_type, err_msg)
    end


    it 'should resolve dependency links' do
      mapping = subject.send(:id2features)
      deps = subject.dependency_links()
      expect(deps).not_to be_empty
      
      # Case of an identified feature without dependencies
      case1 = deps.find {|a_dep| a_dep.dependee == mapping['baz']} 
      expect(case1.dependents).to be_empty
      
      # Case of a feature having dependencies
      case2 = deps.find {|a_dep| a_dep.dependee == mapping['foo']}
      expectations = subject.select_by_ids('bar', 'qux')
      expect(case2.dependents).to eq(expectations)
    end

    it 'should sort the feature files' do
     sorted_files = subject.sort_features_by_dep()
     actual_order = sorted_files.map {|f| f.feature.identifier}
     expected_order = %w[qux baz bar foo]
    end
    
    it 'should generate mapping reports' do
      subject.mapping_reports('feature2id.csv', 'id2feature.csv')
    end
    
    it 'should generate dependency graph' do
      subject.dependency_links()
      subject.draw_dependency_graph('dependencies.dot')
    end

  end # context

end # describe

end # module

# End of file