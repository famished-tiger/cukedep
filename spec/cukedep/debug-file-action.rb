require 'pp'

require_relative '../../lib/cukedep/file-action'

copy_config = {:save_patterns=>[],
 :save_subdir=>"",
 :delete_patterns=>[],
 :delete_subdir=>"",
 :copy_patterns=>["*.txt"],
 :copy_subdir=>""}

pp Dir.pwd 
instance = Cukedep::ActionTriplet.new(copy_config)

files_to_copy_dir = 'C:/Ruby193/lib/ruby/site_ruby/Cukedep/spec/cukedep/sample_features/files_to_copy'

Dir.chdir(files_to_copy_dir)
pp Dir.pwd

proj_dir = "C:/Ruby193/lib/ruby/site_ruby/Cukedep/spec/cukedep/dummy_project"
instance.run!(Dir.getwd, proj_dir)

# Check that the project dir contain the requested files
Dir.chdir(proj_dir)
pp Dir.pwd # TODO
actuals = Dir['*.*']
pp actuals