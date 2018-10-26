# JavaHomeChanger (JHC)

This tool change system-environment-variable "JAVA_HOME" for WindowsOS.

This tool requires administrator authority.



## Description

This tool automatically gathers JDK choices.

This tool's default JDK search directories are "C:\Program Files\Java\" and "C:\Program Files (x86)\Java\".



## Install

1. Download "jhc.bat" to any folder.

2. Please add "JHC_HOME" to "PATH" of user environment variable or system environment variable.



**Notice**

 If you do not add "% JAVA_HOME% \ bin" to the system environment variable "PATH", please add it.



## Usage

1. Start command prompt with administrator authority.
2. jhc [option]

	- `jhc`  Change "JAVA_HOME" to the selected JDK.

	- `jhc update`  Please use it when new JDK is installed or existing JDK is uninstalled.



## Customize

If JDK is installed other than the default search directory, please add the directory you want to search to the "SearchTargetDirectories.conf" file.

The "SearchTargetDirectories.conf" file is located in "JHC_HOME \ conf \".



## Licence

[MIT](https://github.com/kuramatu/JavaHomeChanger/blob/master/LICENSE)



## Author

[kuramatu](https://github.com/kuramatu)
