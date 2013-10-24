Cukedep
===========
[![Build Status](https://travis-ci.org/famished-tiger/cukedep.png?branch=master)](https://travis-ci.org/famished-tiger/cukedep)
[![Gem Version](https://badge.fury.io/rb/cukedep.png)](http://badge.fury.io/rb/cukedep)

_Handle dependencies between feature file._  
[Homepage](https://github.com/famished-tiger/cukedep)

__Cukedep__ is a command-line utility that helps to run a set feature files in the proper sequence.  
  
### Highlights ###
* Simple syntax to specify dependencies
* Generates dependency reports (in CSV format)
* Generates dependency diagram (in DOT format),
* Generates a Rake file.


### Installation ###
The installation of the cukedep gem is fairly standard:  
```bash  
$[sudo] gem install cukedep
```

To check the installation, open a shell/command window
and type the command-line:
```bash  
cukedep --version
```

You should see the version of cukedep gem.


### Synopsis ###
To get a first taste of how cukedep works, install it first.
Then go to the root dir of the cukedep gem, then open a shell/command window
and type the command-line:
```bash  
rake
```

You will see tests running and Cucumber executing a number of feature files.

To learn more what's happening, go to the ```rspec/sample_features``` dir
You will notice a number of feature files for a sample application.
Stay in that folder and type the following command-line:
```bash  
cukedep --project ../../../sample --dry-run
```

You told cukedep to do the following:
* Read (parse) all the feature files in the current dir.
* Resolve the dependencies between the feature files (based on Gherkin @tags with a special format).
* Generate a number of dependency reports and drawing.
* Generate a rake file that will execute the feature files in the proper sequence for
the project located at the relative path ```../../../sample```

To generate all the above files and run the feature files with Cucumber,
then retry the command line without the --dry-run option:
```bash  
cukedep --project ../../../sample
```

Now you see cukedep redoing the same actions as previously but in addition
it:
* Copies a feature file from the current directive to the Cucumber-based project
* Let Cucumber execute the feature file
* Repeat the two above steps in a sequence that meet the dependencies specified in the feature files.


### How can I define dependencies? ###
To define dependencies between feature files, use Gherkin specific tags.
Suppose that feature `foo` depends on feature `bar`.
Then the feature file `foo` may begin as follows:

```cucumber
# The next line names this feature 'foo' and make dependent on 'bar'
@feature:foo @depends_on:bar
Feature: Check-in
  As a video rental employee
  I want to register return of rented videos
  So that other members can them too  
```

While feature `bar` may start like this:
```cucumber
# The next line names this feature 'bar'
@feature:bar
Feature: Renting videos
  As a video rental employee
  I want to register rentals made by a member 
  So I can run my business
```



Copyright
---------
Copyright (c) 2013, Dimitri Geshef. Cukedep is released under the MIT License see [LICENSE.txt](https://github.com/famished-tiger/Cukedep/blob/master/LICENSE.txt) for details.