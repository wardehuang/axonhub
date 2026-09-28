@echo off
setlocal EnableExtensions
title AxonHub deploy - my-feature

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "REPO_ROOT=%%~fI"
set "LOG_FILE=%SCRIPT_DIR%latest.log"
> "%LOG_FILE%" echo.
>> "%LOG_FILE%" echo ==== AxonHub deploy started %date% %time% ====
set "BASH_EXE="

if exist "%ProgramFiles%\Git\usr\bin\bash.exe" set "BASH_EXE=%ProgramFiles%\Git\usr\bin\bash.exe"
if not defined BASH_EXE if exist "%ProgramFiles%\Git\bin\bash.exe" set "BASH_EXE=%ProgramFiles%\Git\bin\bash.exe"
if not defined BASH_EXE if exist "%LocalAppData%\Programs\Git\usr\bin\bash.exe" set "BASH_EXE=%LocalAppData%\Programs\Git\usr\bin\bash.exe"
if not defined BASH_EXE if exist "%LocalAppData%\Programs\Git\bin\bash.exe" set "BASH_EXE=%LocalAppData%\Programs\Git\bin\bash.exe"
if not defined BASH_EXE for /f "delims=" %%I in ('where bash.exe 2^>nul') do if not defined BASH_EXE set "BASH_EXE=%%I"

if not defined BASH_EXE (
  >> "%LOG_FILE%" echo Git for Windows bash.exe not found.
  echo Git for Windows bash.exe not found.
  pause
  exit /b 1
)

set "REPO_ROOT=%REPO_ROOT:\=/%"
>> "%LOG_FILE%" echo Running AxonHub deployment from branch my-feature...
echo Running AxonHub deployment from branch my-feature...
"%BASH_EXE%" -lc "set -o pipefail; cd '%REPO_ROOT%' && bash remote_deploy/deploy 2^>^&1 | tee -a remote_deploy/latest.log"
set "EXIT_CODE=%ERRORLEVEL%"

if "%EXIT_CODE%"=="0" (
  >> "%LOG_FILE%" echo Deployment completed.
  echo Deployment completed.
) else (
  >> "%LOG_FILE%" echo Deployment failed with exit code %EXIT_CODE%.
  echo Deployment failed with exit code %EXIT_CODE%.
)
>> "%LOG_FILE%" echo ==== AxonHub deploy finished with exit code %EXIT_CODE% ====
pause
exit /b %EXIT_CODE%
