# JavaHomeChanger (JHC)

This tool change system-environment-variable "JAVA_HOME" for Windows OS.

This tool requires administrator authority.



## Description

This tool automatically gathers JDK choices.

This tool's default JDK search directories are "C:\Program Files\Java\" and "C:\Program Files (x86)\Java\".



## Install

1. Download "jhc.bat" and "mjl.bat" to any folder. (Put the two files in the same folder)

2. Please add "JHC_HOME" to "PATH" of user environment variable or system environment variable.



**Notice**

 If you do not add "%JAVA_HOME%\bin" to the system environment variable "PATH" or the user environment variable "PATH", please add it.



## Usage

1. Start command prompt with administrator authority.
2. jhc [option]

	- `jhc`  Change the environment variable "JAVA_HOME" to the selected JDK.

	- `jhc update`  Use this when installing a new JDK, uninstalling an existing JDK, or customizing the "SearchTargetDirectories.conf" file.



## Customize

If JDK is installed other than the default search directory, please add the directory you want to search to the "SearchTargetDirectories.conf" file.

The "SearchTargetDirectories.conf" file is located in "JHC_HOME\conf\".



## Licence

[MIT](https://github.com/kuramatu/JavaHomeChanger/blob/master/LICENSE)



## Author

[kuramatu](https://github.com/kuramatu)