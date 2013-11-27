# File: cmd-line_spec.rb

require 'stringio'
require_relative '../spec_helper'

# Load the class under testing
require_relative '../../lib/cukedep/application'

module Cukedep # Open module to get rid of long qualified names

describe Application do

  context 'Creation & initialization:' do
    it 'should be created without argument' do
      expect { Application.new }.not_to raise_error
    end
  end # context
  
  context 'Provided services:' do
    subject { Application.new }
    
    it 'should read its command-line' do
      options = subject.send(:options_from, %w[])
      expect(options).to be_empty
    end
    
    it 'should generate a user settings file' do
      # Start state: no config
      File.delete(Cukedep::YMLFilename) if File.exist?(Cukedep::YMLFilename)
      
      # --setup option creates the config file then stops the application
      expect { subject.run!(['--setup'])}.to raise_error(SystemExit)
      
      # Check that the config file was effectively created.
      expect { File.exist?(Cukedep::YMLFilename) }.to be_true
      created_config = Config.load_cfg(Cukedep::YMLFilename)
      expect(created_config).to eq(Config.default)
      
      # Re-run again with --setup option.
      # It should ask permission for overwriting
      # Capture console IO
      old_stdout = $>
      ostream = StringIO.new('rw')
      $> = ostream
      old_stdin = $stdin
      $stdin = StringIO.new("n\n", 'r')
      expect { subject.run!(['--setup'])}.to raise_error(SystemExit)
      $> = old_stdout
      $sdtin = old_stdin
    end
    
    it 'should complain in absence of project dir' do
      # Start state: no config
      File.delete(Cukedep::YMLFilename) if File.exist?(Cukedep::YMLFilename)
      expect(File.exist?(Cukedep::YMLFilename)).to be_false
      
      # Create default config
      expect { subject.run!(['--setup'])}.to raise_error(SystemExit)
        
      err = StandardError
      err_msg = "No project dir specified in '.cukedep.yml' nor via --project option."
      expect {subject.run!([])}.to raise_error(err, err_msg)
    end
    
    it 'should parse the feature files' do
      curr_dir = Dir.getwd()
      begin
        file_dir = File.dirname(__FILE__)
        Dir.chdir(file_dir + '/sample_features')
        unless File.exist?(Cukedep::YMLFilename)
          expect { subject.run!(['--setup'])}.to raise_error(SystemExit)
        end
        subject.run!(['--project', '../../../sample'])
      ensure
        Dir.chdir(curr_dir)
      end
    end
  end # context
end # describe

end # module