### 0.0.8 / 2013-10-31
* [Fix] After adding a non-ASCII in a sample feature, Gherkin raised an encoding incompatibility error. Fixed
* [CHANGE] Added a new field 'feature_encoding' in Config object to store the encoding of feature files (default = 'UTF-8')
* [NEW] Class `GherkinFacade`
* [CHANGE] `Application#parse_features` method

### 0.0.7 / 2013-10-25
* [CHANGE] Method `Application#generate_files` now uses the filenames as specified in the `cukedep.yml` file.

### 0.0.6 / 2013-10-25
* [CHANGE] File `README.md` Added rationale text and recap paragraph.

### 0.0.5 / 2013-10-24
* [CHANGE] File `README.md` Added section on how to specify dependencies.

### 0.0.4 / 2013-10-24
* [CHANGE] Files `Gemfile`, `cukedep.gemspec`. Updated dependencies towards other gems.

### 0.0.3 / 2013-10-24
* [FIX] File `rake.erb`. Removal of pp method call.

### 0.0.2 / 2013-10-24
* [CHANGE] Code cleanup done to fix most code style issues reported by Rubocop.

* [FEATURE] Initial public working version

### 0.0.1 / 2013-10-23

* [FEATURE] Initial public working version