@echo off
REM Double-click friendly launcher for Windows lab PCs
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*
pause
