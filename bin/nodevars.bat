@echo off

rem Ensure portable bin directory is in PATH
set "PATH=%~dp0;%PATH%"

setlocal enabledelayedexpansion
pushd "%~dp0"

rem Figure out the Node.js version.
set print_version=.\node.exe -p -e "process.versions.node + ' (' + process.arch + ')'"
for /F "usebackq delims=" %%v in (`%print_version%`) do set version=%%v

rem Print message.
if exist npm.cmd (
  echo Your portable environment has been set up for using Node.js !version! and npm.
) else (
  echo Your portable environment has been set up for using Node.js !version!.
)

popd
endlocal
