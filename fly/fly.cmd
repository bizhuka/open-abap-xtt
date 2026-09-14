@echo off
setlocal EnableExtensions

rem This file is named fly.cmd. Never call "fly" from here — CMD would recurse.
rem Always deploy from the repo root so Docker context includes package.json/src/web.

set "FLY_DIR=%~dp0"
if "%FLY_DIR:~-1%"=="\" set "FLY_DIR=%FLY_DIR:~0,-1%"
for %%I in ("%FLY_DIR%\..") do set "ROOT=%%~fI"

set "FLYCTL="
for /f "delims=" %%I in ('where flyctl 2^>nul') do (
  set "FLYCTL=%%I"
  goto :have
)
for /f "delims=" %%I in ('where fly.exe 2^>nul') do (
  set "FLYCTL=%%I"
  goto :have
)
if exist "%USERPROFILE%\.fly\bin\flyctl.exe" (
  set "FLYCTL=%USERPROFILE%\.fly\bin\flyctl.exe"
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

echo Usage: fly\fly.cmd [deploy^|launch^|open^|logs^|status^|ssh]
echo.
echo   fly\fly.cmd          deploy
echo   fly\fly.cmd launch   create the Fly app from fly.toml (once)
echo   fly\fly.cmd open     open the app URL
echo   fly\fly.cmd logs     tail logs
echo   fly\fly.cmd status   machine status
echo   fly\fly.cmd ssh      SSH into the machine
exit /b 1

:launch
call :run launch --copy-config --yes --no-deploy --config "%FLY_DIR%\fly.toml"
exit /b %ERRORLEVEL%

:deploy
call :run deploy "%ROOT%" --config "%FLY_DIR%\fly.toml"
exit /b %ERRORLEVEL%

:open
call :run open --config "%FLY_DIR%\fly.toml"
exit /b %ERRORLEVEL%

:logs
call :run logs --config "%FLY_DIR%\fly.toml"
exit /b %ERRORLEVEL%

:status
call :run status --config "%FLY_DIR%\fly.toml"
exit /b %ERRORLEVEL%

:ssh
call :run ssh console --config "%FLY_DIR%\fly.toml"
exit /b %ERRORLEVEL%

:run
pushd "%ROOT%"
"%FLYCTL%" %*
set "ERR=%ERRORLEVEL%"
popd
exit /b %ERR%
