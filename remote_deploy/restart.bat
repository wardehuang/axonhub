@echo off
setlocal EnableExtensions
title AxonHub restart

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "REPO_ROOT=%%~fI"
set "LOG_FILE=%SCRIPT_DIR%latest.log"
> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo ==== AxonHub restart started %date% %time% ====
set "BASH_EXE="

if exist "%ProgramFiles%\Git\usr\bin\bash.exe" set "BASH_EXE=%ProgramFiles%\Git\usr\bin\bash.exe"
if not defined BASH_EXE if exist "%ProgramFiles%\Git\bin\bash.exe" set "BASH_EXE=%ProgramFiles%\Git\bin\bash.exe"
if not defined BASH_EXE if exist "%LocalAppData%\Programs\Git\usr\bin\bash.exe" set "BASH_EXE=%LocalAppData%\Programs\Git\usr\bin\bash.exe"
if not defined BASH_EXE if exist "%LocalAppData%\Programs\Git\bin\bash.exe" set "BASH_EXE=%LocalAppData%\Programs\Git\bin\bash.exe"
if not defined BASH_EXE for /f "delims=" %%I in ('where bash.exe 2^>nul') do if not defined BASH_EXE set "BASH_EXE=%%I"

if not defined BASH_EXE (
  >> "%LOG_FILE%" echo Git for Windows bash.exe not found.
  echo Git for Windows bash.exe not found.
  type "%LOG_FILE%"
  pause
  exit /b 1
)

set "REPO_ROOT=%REPO_ROOT:\=/%"
>> "%LOG_FILE%" echo Restarting AxonHub...
echo Restarting AxonHub...
"%BASH_EXE%" -lc "cd '%REPO_ROOT%' && bash remote_deploy/restart" >> "%LOG_FILE%" 2>&1
set "EXIT_CODE=%ERRORLEVEL%"

if "%EXIT_CODE%"=="0" (
  >> "%LOG_FILE%" echo Restart completed.
  echo Restart completed.
) else (
  >> "%LOG_FILE%" echo Restart failed with exit code %EXIT_CODE%.
  echo Restart failed with exit code %EXIT_CODE%.
)
>> "%LOG_FILE%" echo ==== AxonHub restart finished with exit code %EXIT_CODE% ====
type "%LOG_FILE%"
pause
exit /b %EXIT_CODE%
