# File: cmd-line_spec.rb

require 'stringio'
require_relative '../../spec_helper'

# Load the class under testing
require_relative '../../../lib/cukedep/cli/cmd-line'

module Cukedep # Open module to get rid of long qualified names

describe CLI::CmdLine do

  context 'Creation & initialization:' do
    subject { CLI::CmdLine.new }

    it 'should be created without argument' do
    expect { CLI::CmdLine.new }.not_to raise_error
    end
  end # context
  
  context 'Provided services:' do
    def capture_output()
      @output = $>
      ostream = StringIO.new('rw')
      $> = ostream
    end
    
    def release_output()
      $> = @output
    end

  
    it 'should accept an empty command-line' do
      expect { subject.parse!([]) }.not_to raise_error
      expect(subject.options).to be_empty
    end

    it 'should accept the dry-run option' do
      expect { subject.parse!(['--dry-run']) }.not_to raise_error
      expect(subject.options).to eq({ :"dry-run" => true })
    end

    it 'should accept the setup option' do
      expect { subject.parse!(['--setup']) }.not_to raise_error
      expect(subject.options).to eq({ :setup => true })
    end
    
    it 'should validate the project option argument' do
      # Case 1: missing project dir argument
      cmd_opts = ['--project']
      err_type = StandardError
      err_msg = <<-MSG_END
No argument provided with command line option: --project
To see the command-line syntax, do:
cukedep --help
MSG_END
      expect { subject.parse!(cmd_opts) }.to raise_error(err_type)
      
      # Case 2: non existing project dir
      cmd_opts = ['--project', 'nowhere']
      err_msg = "Cannot find the directory 'nowhere'."
      expect { subject.parse!(cmd_opts) }.to raise_error(err_type, err_msg) 

      # Case 3: project dir exists
      #cmd_opts = ['--project', '../../../sample']
      #expect { subject.parse!(cmd_opts) }.not_to raise_error
      #expect(subject.options).to eq({ :project => '../../../sample' })
    end

    it 'should handle the version option' do
      capture_output
      cmd_opts = ['--version']
      expect { subject.parse!(cmd_opts) }.to raise_error(SystemExit)
      expect($>.string).to eq(Cukedep::Version + "\n")
      release_output
    end

    it 'should handle the help option' do
      capture_output
      cmd_opts = ['--help']
      expect { subject.parse!(cmd_opts) }.to raise_error(SystemExit)
      expect($>.string).to eq(subject.parser.to_s)      
      release_output
    end
  end # context
  
  

end # describe

end # module