@rem ------------------------------------------------------------------
@rem 
@rem MakeJDKList (MJL)
@rem This tool is to make the "JDKList.conf" file for JavaHomeChanger.
@rem Please put it in the same directory as "jhc.bat."
@rem 
@rem "JDKList.conf" file is the installed JDK List.
@rem "JDKList.conf" file is created under "MAKE_JDK_LIST_HOME\conf"
@rem 
@rem ------------------------------------------------------------------


@echo off
setlocal enabledelayedexpansion

:main
set MAKE_JDK_LIST_HOME=%~dp0
call :makeSearchTargetDirectoriesConfFile
call :deleteJDKList
call :createJDKList
call :deleteTemporaryFiles
exit /b


:makeSearchTargetDirectoriesConfFile
if not exist %MAKE_JDK_LIST_HOME%conf (
  mkdir %MAKE_JDK_LIST_HOME%conf
)
if not exist %MAKE_JDK_LIST_HOME%conf\SearchTargetDirectories.conf (
  echo C:\Program Files^\Java^\>> %MAKE_JDK_LIST_HOME%conf\SearchTargetDirectories.conf
  echo C:\Program Files ^(x86^)^\Java^\>> %MAKE_JDK_LIST_HOME%conf\SearchTargetDirectories.conf
)
exit /b


:deleteJDKList
if exist %MAKE_JDK_LIST_HOME%conf\JDKList.conf (
  del %MAKE_JDK_LIST_HOME%conf\JDKList.conf
)
exit /b


:createJDKList
set /a PRIMARY_KEY=1
for /f "delims=" %%a in (%MAKE_JDK_LIST_HOME%conf\SearchTargetDirectories.conf) do (
  set SEARCH_TARGET_DIRECTORY=%%a
  call :getJDKDirectories
)
for /f "delims=" %%b in (%MAKE_JDK_LIST_HOME%conf\collect_jdk_directories.tmp) do (
    set JDK_DIRECTORY_FULLPATH=%%b
    call :collectJDKInformation
    call :addJDKList
    set /a PRIMARY_KEY+=1
)
exit /b


:getJDKDirectories
call :getJavacExeFileFullPath
set REPLACE_TARGET=\bin\javac.exe
for /f "delims=" %%a in (%MAKE_JDK_LIST_HOME%conf\collect_javac_fullpath.tmp) do (
  set JDK_DIRECTORY_NAME=%%a
  echo !JDK_DIRECTORY_NAME:%REPLACE_TARGET%=!>> %MAKE_JDK_LIST_HOME%conf\collect_jdk_directories.tmp 2> nul
)
exit /b


:getJavacExeFileFullPath
if not exist "!SEARCH_TARGET_DIRECTORY!" (
  exit /b
)
dir /b /o:n /s "!SEARCH_TARGET_DIRECTORY!" | findstr "javac.exe" > %MAKE_JDK_LIST_HOME%conf\collect_javac_fullpath.tmp 2> nul
exit /b


:collectJDKInformation
call :printJavaVersionInfomationToTemporaryFile
call :getJDKVersionInfomation
call :getJavaBitInformation
exit /b


:printJavaVersionInfomationToTemporaryFile
"!JDK_DIRECTORY_FULLPATH!\bin\java.exe" -version 2> %MAKE_JDK_LIST_HOME%conf\java_version.tmp
exit /b


:getJDKVersionInfomation
call :getJDKDistributionInformation
set /a JAVA_VERSION_TMP_FILE_ROW_COUNT=1
for /f "tokens=3" %%a in (%MAKE_JDK_LIST_HOME%conf\java_version.tmp) do (
  set VERSION_NUMBER=%%a
  if !JAVA_VERSION_TMP_FILE_ROW_COUNT!==1 (
    set JDK_VERSION=!JDK_DISTRIBUTION_TYPE!-!VERSION_NUMBER:~1,-1!
  )
  set /a JAVA_VERSION_TMP_FILE_ROW_COUNT+=1
)
exit /b


:getJDKDistributionInformation
set JDK_DISTRIBUTION_TYPE=OracleJDK
call :isOpenJDK
if !ERRORLEVEL! equ 0 (
  set JDK_DISTRIBUTION_TYPE=OpenJDK
)
call :isAdoptOpenJDK
if !ERRORLEVEL! equ 0 (
  set JDK_DISTRIBUTION_TYPE=AdoptOpenJDK
)
exit /b


:isOpenJDK
find "openjdk" %MAKE_JDK_LIST_HOME%conf\java_version.tmp > nul
exit /b


:isAdoptOpenJDK
find "AdoptOpenJDK" %MAKE_JDK_LIST_HOME%conf\java_version.tmp > nul
exit /b


:getJavaBitInformation
set JAVA_BIT=32bit
call :is64BitVersion
if !ERRORLEVEL! equ 0 (
  set JAVA_BIT=64bit
)
exit /b


:is64BitVersion
find "64-Bit" %MAKE_JDK_LIST_HOME%conf\java_version.tmp > nul
exit /b


:addJDKList
echo !PRIMARY_KEY!,!JAVA_BIT!,!JDK_VERSION!,!JDK_DIRECTORY_FULLPATH!>>%MAKE_JDK_LIST_HOME%conf\JDKList.conf
exit /b


:deleteTemporaryFiles
del %MAKE_JDK_LIST_HOME%conf\*.tmp
exit /b

endlocal
