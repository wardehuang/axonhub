@echo off
setlocal EnableExtensions
title AxonHub stop

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "REPO_ROOT=%%~fI"
set "LOG_FILE=%SCRIPT_DIR%latest.log"
> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo ==== AxonHub stop started %date% %time% ====
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
>> "%LOG_FILE%" echo Stopping AxonHub...
echo Stopping AxonHub...
"%BASH_EXE%" "%REPO_ROOT%/remote_deploy/run_with_log" stop
set "EXIT_CODE=%ERRORLEVEL%"

if "%EXIT_CODE%"=="0" (
  >> "%LOG_FILE%" echo Stop completed.
  echo Stop completed.
) else (
  >> "%LOG_FILE%" echo Stop failed with exit code %EXIT_CODE%.
  echo Stop failed with exit code %EXIT_CODE%.
)
>> "%LOG_FILE%" echo ==== AxonHub stop finished with exit code %EXIT_CODE% ====
pause
exit /b %EXIT_CODE%
