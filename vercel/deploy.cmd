@echo off
setlocal EnableExtensions

rem Run Vercel from the repository root while keeping its config in vercel\.

set "VERCEL_DIR=%~dp0"
if "%VERCEL_DIR:~-1%"=="\" set "VERCEL_DIR=%VERCEL_DIR:~0,-1%"
for %%I in ("%VERCEL_DIR%\..") do set "ROOT=%%~fI"

set "VERCEL_CLI="
for /f "delims=" %%I in ('where vercel 2^>nul') do (
  set "VERCEL_CLI=%%I"
  goto :have
)

echo Vercel CLI is not on PATH.
echo Install: npm install --global vercel
echo Then:    vercel login
exit /b 1

:have
if "%~1"=="" goto deploy
if /I "%~1"=="deploy" goto deploy
if /I "%~1"=="production" goto deploy
if /I "%~1"=="prod" goto deploy
if /I "%~1"=="preview" goto preview
if /I "%~1"=="link" goto link
if /I "%~1"=="dev" goto dev
if /I "%~1"=="logs" goto logs

echo Usage: vercel\deploy.cmd [deploy^|preview^|link^|dev^|logs]
echo.
echo   vercel\deploy.cmd             deploy to production
echo   vercel\deploy.cmd deploy      deploy to production
echo   vercel\deploy.cmd preview     create a preview deployment
echo   vercel\deploy.cmd link        link this folder to a Vercel project
echo   vercel\deploy.cmd dev         run the Vercel development server
echo   vercel\deploy.cmd logs        show production runtime logs
exit /b 1

:link
call :run link
exit /b %ERRORLEVEL%

:dev
call :verify
if errorlevel 1 exit /b %ERRORLEVEL%
call :run dev
exit /b %ERRORLEVEL%

:preview
call :run deploy
exit /b %ERRORLEVEL%

:deploy
call :run deploy --prod
exit /b %ERRORLEVEL%

:logs
call :run logs --environment production
exit /b %ERRORLEVEL%

:verify
pushd "%ROOT%"
call npm.cmd run verify
set "ERR=%ERRORLEVEL%"
popd
exit /b %ERR%

:run
pushd "%ROOT%"
call "%VERCEL_CLI%" %* --local-config "%VERCEL_DIR%\vercel.json"
set "ERR=%ERRORLEVEL%"
popd
exit /b %ERR%
