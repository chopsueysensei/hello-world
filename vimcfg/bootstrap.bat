@echo off

:: Check permissions
net session >nul 2>&1
if NOT %errorlevel% == 0 goto errorNoAdmin

:: Install chocolatey
choco --version
if %errorlevel% == 0 goto haveChoco

powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:haveChoco
:: Check for git on the command line
git --version
if %errorlevel% == 0 goto haveGit

choco install git

:haveGit
:: Link vim config files in home dir
mklink "%HOMEPATH%\.vimrc" "%~dp0\.vimrc"
mklink "%HOMEPATH%\.gvimrc" "%~dp0\.gvimrc"
mklink /d "%HOMEPATH%\.vim" "%~dp0\.vim"

:: Remap CAPS to ESC and BLOCK-DESP to CAPS
regedit "%~dp0\remap_capslock.reg"

echo Please log off from the user session so that the keyboard mapping is applied..

:: Make sure at least Vundle submodule is not empty
for /F %%i in ('dir /b "c:\test directory\*.*" 2^>NUL') do (
  echo 'Vundle.vim' submodule contains files. Skipping submodule downloading..
  goto :skipSUBs
)

echo 'Vundle.vim' submodule is empty. Updating..
git submodule init
git submodule update

:skipSUBs
:: Run vim and install all plugins (add '+qall' to make it quit after it's done)
vim +PluginInstall

goto:eof


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:errorNoAdmin
echo Error: Admin privileges required. Run this script as administrator.
pause
goto:eof
