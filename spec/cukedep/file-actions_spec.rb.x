# File: file-actions_spec.rb

require_relative '../spec_helper'

# Load the class under testing
require_relative '../../lib/cukedep/file-actions'

module Cukedep # Open module to get rid of long qualified names

describe FileActions do

  let(:saved_files_dir) do
    my_dir = File.dirname(__FILE__)
    my_dir + '/sample_features/saved_files'
  end

  # File patterns
  let(:delete_all) { ['*.*'] }
  let(:txt_only) { ['*.txt'] }

  context 'Creation & initialization:' do

    it 'should be created with 4 arguments' do
      # Case 1: empty instance
      expect {FileActions.new([], '', [], [])}.not_to raise_error

      # Case 2: stuffed instance
      expect {FileActions.new(txt_only, saved_files_dir, delete_all, txt_only)}.not_to raise_error
    end

  end # context

  context 'Basic services:' do
    subject { FileActions.new(txt_only, saved_files_dir, delete_all, txt_only) }

    it 'should compare with other instances' do
      # Case 1: comparing with itself
      expect(subject).to eq(subject)

      # Case 2: comparing with instance with same attribute values
      expect(subject).to eq(subject.dup)

      # Case 3: comparing with instance with different attribute values
      another = FileActions.new(txt_only, saved_files_dir, txt_only, txt_only)
      expect(subject).not_to eq(another)
    end
  end # context



  context 'Actions on files:' do
    before(:each) do
      # Store the working dir before starting
      @original_work_dir = Dir.getwd
    end


    after(:each) do
      # Restore the original working dir
      Dir.chdir(@original_work_dir)
    end

    after(:all) do
      # Clean stuffed dirs
      clean_dir(saved_files_dir)
      clean_dir(proj_dir)
    end


    # Directories
    let(:proj_dir) do
      my_dir = File.dirname(__FILE__)
      my_dir + '/dummy_project'
    end

    let(:files_to_copy_dir) do
      my_dir = File.dirname(__FILE__)
      my_dir + '/sample_features/files_to_copy'
    end


    def clean_dir(aDirectory)
      # Create an instance with just delete file items
      instance = FileActions.new([], '', delete_all, [])

      # Clean the directory
      instance.run!(Dir.getwd, aDirectory)
    end


    it 'should be able to delete all files in the specified dir' do
      # Clean project dir
      clean_dir(proj_dir)
      Dir.chdir(proj_dir)
      expect(Dir['*.*']).to be_empty
    end

    it 'should copy files to specified dir' do
      # Case 1: an instance with just one copy file pattern
      instance = FileActions.new([], '', [], txt_only)

      # Current dir is the directory containing the files to copy
      Dir.chdir(files_to_copy_dir)
      instance.run!(Dir.getwd, proj_dir)

      # Check that the project dir contain the requested files
      Dir.chdir(proj_dir)
      actuals = Dir['*.*']
      expect(actuals).to have(3).items
      expect(actuals.sort).to eq(%w[file1.txt file2.txt file3.txt])

      # Clean project dir
      clean_dir(proj_dir)

      # Case 2: an instance with just two copy file patterns
      instance = FileActions.new([], '', [], txt_only << 'README.md')

      # Current dir is the directory containing the files to copy
      Dir.chdir(files_to_copy_dir)
      instance.run!(Dir.getwd, proj_dir)

      actuals = Dir['*.*']
      expect(actuals).to have(4).items
      (txt_files, md_files) = actuals.partition {|f| f =~ /\.txt/}
      expect(txt_files.sort).to eq(%w[file1.txt file2.txt file3.txt])
      expect(md_files).to eq(%w[README.md])
    end


    it 'should save files to the specified folder' do
      # Clean saved_files dir
      clean_dir(saved_files_dir)
      Dir.chdir(saved_files_dir)
      expect(Dir['*.*']).to be_empty

      # Case 1: the save dir is absolute
      instance = FileActions.new(['README.md'], saved_files_dir, [], [])
      instance.run!(Dir.getwd, proj_dir)
      actuals = Dir['*.*']
      expect(actuals).to have(1).items
      expect(actuals).to eq(['README.md'])

      # Clean again saved_files dir
      clean_dir(saved_files_dir)
      my_dir = File.dirname(__FILE__)
      subdir = './sample_features/saved_files'

      instance = FileActions.new(txt_only, subdir, [], [])
      Dir.chdir(my_dir)
      instance.run!(my_dir, proj_dir)

      Dir.chdir(saved_files_dir)
      actuals = Dir['*.*']
      expect(actuals).to have(3).items
      expect(actuals.sort).to eq(%w[file1.txt file2.txt file3.txt])
    end

  end # context
end # describe

end # module

# End of file