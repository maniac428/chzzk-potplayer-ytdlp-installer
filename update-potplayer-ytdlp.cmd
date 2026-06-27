@echo off
setlocal

set "SCRIPT=%~dp0scripts\Install_PotPlayer_YtDlp_Extension.ps1"

if not exist "%SCRIPT%" (
  echo Installer script not found:
  echo %SCRIPT%
  pause
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
exit /b %ERRORLEVEL%
