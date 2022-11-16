@echo off
REM Self-installing wrapper script for Digestif

setlocal
REM Change the line below to install in a different location
set "DIGESTIF_HOME=%APPDATA%\digestif"
REM Git repo from which to fetch Digestif
set "DIGESTIF_REPO=https://github.com/astoff/digestif"

if not exist "%DIGESTIF_HOME%" (
   echo>&2 Digestif not found in %DIGESTIF_HOME%, fetching it now
   md "%DIGESTIF_HOME%"
   git clone --depth 1 "%DIGESTIF_REPO%" "%DIGESTIF_HOME%"
   echo>&2 Done! If you are running this interactively, press Control-C to quit
)

set "LUA_PATH=%DIGESTIF_HOME%\?.lua"
set "DIGESTIF_PRERELEASE=dev"

texlua "%DIGESTIF_HOME%\bin\digestif" %*
