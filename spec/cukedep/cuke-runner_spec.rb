# File: cuke-runner_spec.rb

require_relative '../spec_helper'
require_relative '../../lib/cukedep/config'

# Load the class under testing
require_relative '../../lib/cukedep/cuke-runner'


module Cukedep # Open module to get rid of long qualified names
  describe CukeRunner do
    let(:project_dir) { '../../sample' }
    let(:base_dir) do
      file_dir = File.dirname(__FILE__)
      file_dir + '/sample_features'
    end

    subject { CukeRunner.new(base_dir, project_dir, Config.default) }

    before(:each) do
      @orig_dir = Dir.getwd
      Dir.chdir(File.dirname(__FILE__))
    end

    after(:each) do
      Dir.chdir(@orig_dir)
    end


    context 'Creation & initialization:' do
      it 'should be created with three arguments' do
        expect { CukeRunner.new(base_dir, project_dir, Config.default) }
          .not_to raise_error
      end

      it 'should know its work directory' do
        expect(subject.base_dir).to eq(base_dir)
      end

      it 'should know the project directory' do
        expect(subject.proj_dir).to eq(File.expand_path(project_dir))
      end
    end # context


    context 'Provided services:' do
      it 'should launch Cucumber when requested' do
        # subject.invoke
      end

      it "should handle the 'before_all' event" do
        expect { subject.before_all }.not_to raise_error
      end

      it "should reject a second 'before_all' event" do
        subject.before_all
        err_msg = "expected state was 'Initialized' instead of 'ReadyToRun'."
        expect { subject.before_all }.to raise_error(StandardError, err_msg)
      end

      it "should handle the 'after_all' event" do
        subject.before_all
        expect { subject.after_all }.not_to raise_error
      end

      it 'should run the designated feature files' do
        subject.before_all
        # expect { 
        subject.run!(['a_few_tests.feature']) # }.not_to raise_error
      end
    end # context
  end # describe
end # module
# End of file
