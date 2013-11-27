# File: file-action_spec.rb

require_relative '../spec_helper'

# Load the class under testing
require_relative '../../lib/cukedep/file-action'

module Cukedep # Open module to get rid of long qualified names

# Test the behaviour of the superclass
describe FileAction do
  let(:some_patterns) { %w[README.* *tests.feature] }
  let(:subpath) { './some-dir' }

  subject { FileAction.new(some_patterns, subpath) }

  context 'Creation & initialization:' do

    it 'should be created with file patterns and a subdirectory argument' do
      # Case 1: empty instance
      expect { FileAction.new([], '') }.not_to raise_error

      # Case 2: stuffed instance
      expect { FileAction.new(some_patterns, subpath) }.not_to raise_error
    end

    it 'should know its file patterns' do
      expect(subject.patterns).to eq(some_patterns)
    end

    it "should know the target's subdirectory" do
      expect(subject.delta).to eq(subpath)
    end

  end # context


  context 'Basic services:' do

    it 'should know whether it is equal to another instance' do
      # Case 1: comparing with itself
      expect(subject).to eq(subject)

      # Case 2: comparing with instance with same attribute values
      expect(subject).to eq(subject.dup)

      # Case 3: comparing with instances having different attribute values
      another = FileAction.new(some_patterns, '')
      expect(subject).not_to eq(another)
      another = FileAction.new(['*.feature'], subpath)
      expect(subject).not_to eq(another)
    end
  end # context

end # describe


describe CopyAction do
  let(:source_dir) do
    my_dir = File.dirname(__FILE__)
    my_dir + '/sample_features/files_to_copy'
  end

  let(:subdir) do
    './sample_features/saved_files'
  end


  def clean_dir(aDirectory)
    terminator = DeleteAction.new(['*.*'])
    terminator.run!(aDirectory)
  end


  before(:all) do
    # Clean stuffed dirs
    target_dir = File.join(File.dirname(__FILE__), '/sample_features/saved_files')
    unless Dir.exist?(target_dir)
      Dir.mkdir(target_dir)
    else
      clean_dir(target_dir)
    end
  end


  before(:each) do
    # Store the working dir before starting
    @original_work_dir = Dir.getwd
  end


  after(:each) do
    # Restore the original working dir
    Dir.chdir(@original_work_dir)
  end


  context 'Copying files' do
    it 'should copy files matching the patterns' do
      my_dir = File.dirname(__FILE__)

      # Case: one file pattern
      instance1 = CopyAction.new(['*.md'], subdir)
      expect{ instance1.run!(source_dir, my_dir) }.not_to raise_error

      Dir.chdir(my_dir)
      # Control the result...
      copied_files = Dir.glob(subdir + '/' + '*.*')
      expect(copied_files).to have(1).items

      # Case: two file patterns
      instance2 = CopyAction.new(['file1.txt', 'file2.txt'], subdir)
      expect{ instance2.run!(source_dir, my_dir) }.not_to raise_error

      # Control the result...
      copied_files = Dir.glob(subdir + '/' + '*.*')
      expect(copied_files).to have(3).items
    end

  end # context

end # describe


describe DeleteAction do
  let(:subdir) do
    './sample_features/saved_files'
  end

  let(:target_dir) do
    File.join(File.dirname(__FILE__), subdir)
  end


  before(:each) do
    # Store the working dir before starting
    @original_work_dir = Dir.getwd
  end


  after(:each) do
    # Restore the original working dir
    Dir.chdir(@original_work_dir)
  end


  context 'Deleting files' do
    it 'should delete files matching the patterns' do
      my_dir = File.dirname(__FILE__)

      # Case: one file pattern and a subdir
      instance1 = DeleteAction.new(['*.md'], subdir)
      expect{ instance1.run!(my_dir) }.not_to raise_error
      Dir.chdir(my_dir)
      
      # Control the result...
      remaining_files = Dir.glob(subdir + '/' + '*.*')
      expect(remaining_files).to have(2).items

      # Case: multiple file patterns and no subdir
      instance2 = DeleteAction.new(['file1.txt', 'file3.txt'])
      expect{ instance2.run!(target_dir) }.not_to raise_error

      # Control the result...
      remaining_files = Dir.glob(subdir + '/' + '*.*')
      expect(remaining_files).to have(1).items

      # Delete all files
      instance3 = DeleteAction.new(['*.*'])
      expect{ instance3.run!(target_dir) }.not_to raise_error

      # Control the result...
      remaining_files = Dir.glob(subdir + '/' + '*.*')
      expect(remaining_files).to have(0).items
    end
  end # context


end # describe


describe ActionTriplet do

  let(:saved_files_dir) do
    my_dir = File.dirname(__FILE__)
    my_dir + '/sample_features/saved_files'
  end

  # File patterns
  let(:all_files) { ['*.*'] }
  let(:txt_only) { ['*.txt'] }

  let(:empty_config) do
    {
      save_patterns: [],
      save_subdir: '',
      delete_patterns: [],
      delete_subdir: '',
      copy_patterns: [],
      copy_subdir: ''
    }
  end

  let(:sample_config) do
    {
      save_patterns: txt_only,
      save_subdir: saved_files_dir,
      delete_patterns: all_files,
      delete_subdir: '',
      copy_patterns: txt_only,
      copy_subdir: ''
    }
  end

  context 'Creation & initialization:' do

    it 'should be created with Hash-like arguments' do
      # Case 1: empty instance
      expect { ActionTriplet.new(empty_config) }.not_to raise_error

      # Case 2: stuffed instance
      expect { ActionTriplet.new(sample_config) }.not_to raise_error
    end

  end # context

  context 'Basic services:' do
    subject { ActionTriplet.new(sample_config) }

    it 'should compare with other instances' do
      # Case 1: comparing with itself
      expect(subject).to eq(subject)

      # Case 2: comparing with instance with same attribute values
      expect(subject).to eq(subject.dup)

      # Case 3: comparing with instance with different attribute values
      other_config = sample_config.dup
      other_config[:copy_patterns] = all_files
      another = ActionTriplet.new(other_config)
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
      instance = DeleteAction.new(all_files, '')

      # Clean the directory
      instance.run!(aDirectory)
    end


    it 'should be able to delete all files in the specified dir' do
      # Clean project dir
      clean_dir(proj_dir)
      Dir.chdir(proj_dir)
      expect(Dir['*.*']).to be_empty
    end

    it 'should copy files to specified dir' do
      # Case 1: an instance with just one copy file pattern
      copy_config = empty_config.dup
      copy_config[:copy_patterns] = txt_only
      instance = ActionTriplet.new(copy_config)

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
      copy_config[:copy_patterns] << 'README.md'
      instance = ActionTriplet.new(copy_config)

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

      save_config = empty_config.dup
      save_config[:save_patterns] = ['README.md']

      # Case 1: the save dir is absolute
      instance = ActionTriplet.new(save_config)
      instance.run!(Dir.getwd, proj_dir)
      actuals = Dir['*.*']
      expect(actuals).to have(1).items
      expect(actuals).to eq(['README.md'])

      # Clean again saved_files dir
      clean_dir(saved_files_dir)
      my_dir = File.dirname(__FILE__)
      save_config[:save_patterns] = txt_only
      save_config[:save_subdir] = './sample_features/saved_files'

      instance = ActionTriplet.new(save_config)
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
