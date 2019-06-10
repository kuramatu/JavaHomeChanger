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
@rem   jhc             Change "JAVA_HOME" to the selected JDK.
@rem 
@rem   jhc update      Update JDK list and after update JavaHomeChanger run.
@rem                   Please use it when new JDK is installed or
@rem                   existing JDK is uninstalled.
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
  call :showCurrentJavaHome
  call :selectJDKVersion
  call :setJavaHome
)
call :printEndStatus
exit /b !ERROR_CODE!


:isAdmin
openfiles > nul 2>&1
if not "%ERRORLEVEL%"=="0" (
  echo Please running this tool with administrator authority.
  call :error
)
exit /b


:updateJDKList
if "%JHC_COMMAND_LINE_ARG%"=="update" (
  call %JHC_HOME%mjl.bat
)
exit /b


:existsJDKList
if not exist %JHC_HOME%conf\JDKList.conf (
  call %JHC_HOME%mjl.bat
)
exit /b


:showCurrentJavaHome
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
    call :getJavaHomeSettedMark
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


:getJavaHomeSettedMark
set SETTED_MARK=
if "%JAVA_HOME%"=="!JAVA_DIRECTORY_PATH!" (
  set SETTED_MARK=***
)
exit /b


:setJavaHome
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

endlocal
