### 0.1.08 / 2014-07-06
* [CHANGE] File `.rubocop.yml`. Removed AccessControl cop.
* [CHANGE] File `CukeRunner#before_each`. Minor refactoring to please Rubocop 0.26.1

### 0.1.08 / 2014-07-06
* [CHANGE] Most source files comply to Rubocop 0.24.1.

### 0.1.07 / 2014-07-05
* [CHANGE] Spec files updated for RSpec 3.0.x.

### 0.1.06 / 2014-02-20
* [CHANGE] Round of code style improvement complete.

### 0.1.05 / 2014-02-19
* [CHANGE] File `.rubocop.yml`. Updated, cop EmptyLinesAroundBody disabled.
* [CHANGE] Style of several /lib files improved:  `feature-model`, `feature-rep`, `file-action`, `gherkin-facade`, `hook-dsl`, `sandbox`.

### 0.1.04 / 2013-01-14
* [CHANGE] File `.travis.yml`. Addition of MRI Ruby 2.1.0 to Travis CI.
* [CHANGE] File `LICENSE.txt`. Addition of 2014 in copyright year.

### 0.1.03 / 2013-11-28
* [FIX] Failing execution of generated Rake file in Travis CI. Cause: Rake template always referenced class in gem while it should reference development code while self-testing.
* [FIX] Added three missing test data files in the committed version.

### 0.1.02 / 2013-11-27
* [FIX] Failing test again in `file-action_spec.rb` file. Cause: Commit to GitHub doesn't copy empty dir!. Added directory creation code.

### 0.1.01 / 2013-11-27
* [FIX] Failing test in `file-action_spec.rb` file. Cause: Commit to GitHub doesn't copy empty dir!. Added directory creation code.

### 0.1.00 / 2013-11-27
* [FEATURE] Customized file actions (save, delete, copy) associated with invocation event
* [FEATURE] Hooks for further invocation event customization.
* [NEW] `Cukedep::CukeRunner` class. Responsibilities: -Invokes Cucumber, handles the invocation events.
* [NEW] `Cukedep::Customization` class. Responsibilities: -Loads custom hook code blocks (in `cukedep_hooks.rb`)
* [NEW] `Cukedep::FileAction` class hierarchy. Responsibilities: specify the actions to perform before/after Cucumber invocation(s).
* [NEW] `Cukedep::HookDSL` module. Used to define a DSL (Domain Specific Language)
* [NEW] `Cukedep::Sandbox`. Responsibilities: Gives the context in which hook code block are executed.
* [NEW] `Cukedep::Config` class: new methods: `load_cfg`, `write`, `file_action_attrs`
* [CHANGE] Method `Application#run!`: Using new interface of `Cukedep::Config` class.


### 0.0.9 / 2013-11-04 [unreleased]
* [CHANGE] For uniformity reasons, method `Application#start!` renamed to `Application#run!`
* [FIX] Method `Application#run!`: incorrect string interpolation in error message.

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