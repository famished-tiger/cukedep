require 'pp'

require_relative '../../lib/cukedep/file-action'

copy_config = { 
  save_patterns: [],
  save_subdir: '',
  delete_patterns: [],
  delete_subdir: '',
  copy_patterns: ['*.txt'],
  copy_subdir: '' 
}

pp Dir.pwd 
instance = Cukedep::ActionTriplet.new(copy_config)
path = 'C:/Ruby193/lib/ruby/site_ruby/Cukedep/spec/cukedep/'
files_to_copy_dir = path + 'sample_features/files_to_copy'

Dir.chdir(files_to_copy_dir)
pp Dir.pwd

proj_dir = path + 'dummy_project'
instance.run!(Dir.getwd, proj_dir)

# Check that the project dir contain the requested files
Dir.chdir(proj_dir)
pp Dir.pwd # TODO
actuals = Dir['*.*']
pp actuals
