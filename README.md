Cukedep
===========
[![Build Status](https://travis-ci.org/famished-tiger/cukedep.png?branch=master)](https://travis-ci.org/famished-tiger/cukedep)

_Handle dependencies between feature file._  
[Homepage](https://github.com/famished-tiger/cukedep)

__Cukedep__ is a command-line utility that helps to run feature files in the proper sequence.  
  
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
$[sudo] cukedep --version
```

You should see the version of cukedep gem.


### Synopsis ###
To get a first taste of how cukedep works, install it first.
Then go to the root dir of the cukedep gem, then open a shell/command window
and type the command-line:
```bash  
$[sudo] rake
```

You will see tests running and Cucumber executing a number of feature files.

To learn more what's happening, go to the ```pec/sample_features``` dir
You will notice a number of feature files for a sample application.
Stay in that folder and type the following command-line:
```bash  
$[sudo] cukedep --project ../../../sample --dry-run
```

You instructed cukedep to do the following:
* Read (parse) all the feature files in the current dir.
* Resolve the dependencies between the feature files (based on specific Gherkin @tags).
* Generate a number of dependency reports and drawing.
* Generate a rake file that will execute the feature files in the proper sequence for
the project located at the relative path ```../../../sample```

To generate all the above files and run the feature files with Cucumber,
then retry the command line without the --dry-run option:
```bash  
$[sudo] cukedep --project ../../../sample --dry-run
```

Copyright
---------
Copyright (c) 2013, Dimitri Geshef. Cukedep is released under the MIT License see [LICENSE.txt](https://github.com/famished-tiger/Cukedep/blob/master/LICENSE.txt) for details.