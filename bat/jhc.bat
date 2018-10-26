@rem ------------------------------------------------------------------
@rem 
@rem JavaHomeChanger (JHC)
@rem This tool change system-environment-variable "JAVA_HOME".
@rem Requires administrator authority.
@rem 
@rem This tool automatically gathers JDK choices.
@rem The default JDK search directories are
@rem "C:\Program Files\Java\" and "C:\Program Files (x86)\Java\".
@rem 
@rem If JDK is installed other than the default search folder,
@rem please add the directory you want to search to the
@rem "SearchTargetDirectories.conf" file lacated "JHC_HOME\conf\".
@rem 
@rem Usage: jhc [option]
@rem 	jhc				Change "JAVA_HOME" to the selected JDK.
@rem 
@rem 	jhc update		Update JDK list and after update JavaHomeChanger run.
@rem 					Please use it when new JDK is installed or
@rem 					existing JDK is uninstalled.
@rem 
@rem ------------------------------------------------------------------

@echo off
setlocal enabledelayedexpansion

:main
set JHC_HOME=%~dp0
set JHC_COMMAND_LINE_ARG=%1
set ERROR_CODE=0
call :isAdmin
if "!ERROR_CODE!"=="0" (
	call :updateJDKList
	call :existsJDKList
	call :showJAVA_HOME
	call :selectJDKVersion
	call :setJAVA_HOME
)
call :printEndStatus
exit /b !ERROR_CODE!


rem Check running this tool with administrator authority.
:isAdmin
openfiles > nul 2>&1
if not "%ERRORLEVEL%"=="0" (
	echo Please running this tool with administrator authority.
	call :error
)
exit /b


:updateJDKList
if "%JHC_COMMAND_LINE_ARG%"=="update" (
	call :makeJDKList
)
exit /b


:existsJDKList
if not exist %JHC_HOME%conf\JDKList.conf (
	call :makeJDKList
)
exit /b


:showJAVA_HOME
echo Current "JAVA_HOME": %JAVA_HOME%
echo;
exit /b


:selectJDKVersion
call :viewJDKChoices
set /p SELECT_KEY="Please input the existing key number."
exit /b


:viewJDKChoices
call :viewJDKChoicesHeader
call :viewJDKOptions
call :viewNotChangeOption
exit /b


:viewJDKChoicesHeader
echo ^|Key	^|Setted	^|Bit	^|JDK Version
call :drawHorizon
exit /b


:viewJDKOptions
if exist %JHC_HOME%conf\JDKList.conf (
	for /f "tokens=1,2,3,4 delims=," %%a in (%JHC_HOME%conf\JDKList.conf) do (
		set JAVA_DIRECTORY_PATH=%%d
		call :isSettedJAVA_HOME
		echo ^|%%a	^|!SETTED_MARK!	^|%%b	^|%%c
	)
	call :drawHorizon
)
exit /b


:viewNotChangeOption
echo ^|0	^|	^|	^|Not change
call :drawHorizon
echo;
exit /b


:drawHorizon
echo ------------------------------------------------------------------
exit /b


:isSettedJAVA_HOME
if "%JAVA_HOME%"=="!JAVA_DIRECTORY_PATH!" (
	set SETTED_MARK=***
) else (
	set SETTED_MARK=
)
exit /b


rem Set system-environment-variable "JAVA_HOME"
:setJAVA_HOME
set SELECT_NOT_CHANGE_OPTION=false
set IS_CHANGED=false
if "!SELECT_KEY!"=="0" (
	set SELECT_NOT_CHANGE_OPTION=true
	exit /b
)
set /a COUNT_ROW=1
for /f "tokens=4 delims=," %%a in (%JHC_HOME%conf\JDKList.conf) do (
	if "!COUNT_ROW!"=="!SELECT_KEY!" (
		setx /m JAVA_HOME "%%a" 2>&1 > nul
		set IS_CHANGED=true
	)
	set /a COUNT_ROW+=1
)
if "!IS_CHANGED!"=="false" (
	echo The inputted numbers did not match key numbers.
	call :error
)
exit /b


:error
set ERROR_CODE=1
exit /b


:printEndStatus
if "!SELECT_NOT_CHANGE_OPTION!"=="true" (
	echo;
	echo JAVA_HOME does not change.
) else if "!ERROR_CODE!"=="1" (
	echo;
	echo Fail to change.
) else (
	echo;
	echo Successfully changed.
)
exit /b


:makeJDKList
call :makeSearchTargetDirectoriesConfFile
call :deleteJDKList
set /a PRIMARY_KEY=1
for /f "delims=" %%a in (%JHC_HOME%conf\SearchTargetDirectories.conf) do (
	set SEARCH_TARGET_DIRECTORY=%%a
	dir /a:d /b /o:n "!SEARCH_TARGET_DIRECTORY!" 2>nul | findstr /v "jre" > %JHC_HOME%conf\collect_jdk_directories.tmp 2> nul
	for /f "delims=" %%b in (%JHC_HOME%conf\collect_jdk_directories.tmp) do (
		set JDK_DIRECTORY=%%b
		call :collectJDKInfo
		call :addJDKList
		set /a PRIMARY_KEY+=1
	)
)
del %JHC_HOME%conf\*.tmp
exit /b


:makeSearchTargetDirectoriesConfFile
if not exist %JHC_HOME%conf (
	mkdir %JHC_HOME%conf
)
if not exist %JHC_HOME%conf\SearchTargetDirectories.conf (
	echo C:\Program Files^\Java^\>> %JHC_HOME%conf\SearchTargetDirectories.conf
	echo C:\Program Files ^(x86^)^\Java^\>> %JHC_HOME%conf\SearchTargetDirectories.conf
)
exit /b


:deleteJDKList
if exist %JHC_HOME%conf\JDKList.conf (
	del %JHC_HOME%conf\JDKList.conf
)
exit /b


:collectJDKInfo
"!SEARCH_TARGET_DIRECTORY!!JDK_DIRECTORY!\bin\java.exe" -version 2> %JHC_HOME%conf\java_version.tmp
call :checkJDKVersion
call :checkJavaBit
exit /b


:checkJDKVersion
find "openjdk" %JHC_HOME%conf\java_version.tmp > nul
if !ERRORLEVEL! equ 0 (
	set JDK_TYPE=OpenJDK
) else (
	set JDK_TYPE=OracleJDK
)
set /a JAVA_VERSION_TMP_FILE_ROW_COUNT=1
for /f "tokens=3" %%a in (%JHC_HOME%conf\java_version.tmp) do (
	set VERSION_NUMBER=%%a
	if !JAVA_VERSION_TMP_FILE_ROW_COUNT!==1 (
		set JDK_VERSION=!JDK_TYPE!-!VERSION_NUMBER:~1,-1!
	)
	set /a JAVA_VERSION_TMP_FILE_ROW_COUNT+=1
)
exit /b


:checkJavaBit
find "64-Bit" %JHC_HOME%conf\java_version.tmp > nul
if !ERRORLEVEL! equ 0 (
	set JAVA_BIT=64bit
) else (
	set JAVA_BIT=32bit
)
exit /b


:addJDKList
echo !PRIMARY_KEY!,!JAVA_BIT!,!JDK_VERSION!,!SEARCH_TARGET_DIRECTORY!!JDK_DIRECTORY!>>%JHC_HOME%conf\JDKList.conf
exit /b

endlocal