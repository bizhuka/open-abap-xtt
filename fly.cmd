@echo off
setlocal EnableExtensions

rem This file is named fly.cmd. Never call "fly" from here — CMD would recurse.
set "FLYCTL="
for /f "delims=" %%I in ('where flyctl 2^>nul') do (
  set "FLYCTL=%%I"
  goto :have
)
for /f "delims=" %%I in ('where fly.exe 2^>nul') do (
  set "FLYCTL=%%I"
  goto :have
)

echo flyctl is not on PATH.
echo Install: https://fly.io/docs/flyctl/install/
echo Then:    flyctl auth login
exit /b 1

:have
if "%~1"=="" goto deploy
if /I "%~1"=="deploy" goto deploy
if /I "%~1"=="launch" goto launch
if /I "%~1"=="open" goto open
if /I "%~1"=="logs" goto logs
if /I "%~1"=="status" goto status
if /I "%~1"=="ssh" goto ssh

echo Usage: fly.cmd [deploy^|launch^|open^|logs^|status^|ssh]
echo.
echo   fly.cmd          deploy
echo   fly.cmd launch   create the Fly app from fly.toml (once)
echo   fly.cmd open     open the app URL
echo   fly.cmd logs     tail logs
echo   fly.cmd status   machine status
echo   fly.cmd ssh      SSH into the machine
exit /b 1

:launch
"%FLYCTL%" launch --copy-config --yes --no-deploy
exit /b %ERRORLEVEL%

:deploy
"%FLYCTL%" deploy
exit /b %ERRORLEVEL%

:open
"%FLYCTL%" open
exit /b %ERRORLEVEL%

:logs
"%FLYCTL%" logs
exit /b %ERRORLEVEL%

:status
"%FLYCTL%" status
exit /b %ERRORLEVEL%

:ssh
"%FLYCTL%" ssh console
exit /b %ERRORLEVEL%
