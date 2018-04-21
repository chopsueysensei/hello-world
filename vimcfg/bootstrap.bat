@echo off

::
:: MAKE SURE YOU CLONE THE REPO USING GIT OTHERWISE SUBMODULES WON'T WORK!
::

::
:: Check permissions
::
net session >nul 2>&1
if NOT %errorlevel% == 0 goto errorNoAdmin

::
:: Go directly to install stage?
::
if NOT %1.==. goto %1


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: General tools
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Install chocolatey
::
echo "Check required software"
pause
cls
choco --version
if %errorlevel% == 0 goto haveChoco

powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:haveChoco
::
:: Check for Python on the command line
::
python --version
if %errorlevel% == 0 goto havePython

choco install python2 --version 2.7.14

:havePython
::
:: Check for cmder on the command line
::
if defined CMDER_ROOT goto haveCmder

choco install cmder

:haveCmder
::
:: Check for git on the command line
::
git --version
if %errorlevel% == 0 goto haveGit

choco install git
refreshenv

:haveGit
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ViM
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
start vim --version
if %errorlevel% == 0 goto haveVim

echo "Now install vim"
pause
cls
choco install vim-tux

:haveVim
::
:: Link vim config files in home dir
::
:: TODO ? Check if this has already been done (or silence the error)
echo "Set up vim paths & plugins"
pause
cls

mklink "%USERPROFILE%\.vimrc" "%~dp0\.vimrc"
mklink "%USERPROFILE%\.gvimrc" "%~dp0\.gvimrc"
mklink /d "%USERPROFILE%\.vim" "%~dp0\.vim"

set VIMDIR=%HOMEPATH%\.vim

::
:: Create a folder to hold backup & undo files
::
mkdir "%USERPROFILE%\.backup"

::
:: Remap CAPS to ESC and BLOCK-DESP to CAPS
::
echo "!! Gonna install the CAPSLOCK mapping into the registry. Please answer yes to the prompt !!"
regedit "%~dp0\bootstrap\remap_capslock.reg"

echo "Please log off from the user session after the installation so that the CAPSLOCK mapping is applied.."
pause

::
:: Install ripgrep
::
rg --version
if %errorlevel% == 0 goto haveGrep

choco install ripgrep

:haveGrep
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: GNU Global (http://www.gnu.org/software/global)
:: FIXME Upload their 'gtags.vim' to github and make it installable via Vundle/NeoBundle
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
global --version
if %errorlevel% == 0 goto haveGlobal

choco install global

:haveGlobal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: universal-ctags (https://github.com/universal-ctags/ctags) (no choco..)
:: TODO Remove?
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Just check it's in the path
ctags --version
if NOT %errorlevel% == 0 echo "WARNING: No ctags binary in path!"



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: TODO ? YouCompleteMe
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Check msbuild is in path
:: msbuild
:: if NOT %errorlevel% == 0 goto errorMsbuildPath

:: Check CMake exists
:: Install CMake
:: Add to path if not in it already

:: Install libclang from http://releases.llvm.org/4.0.0/LLVM-4.0.0-win64.exe (no choco?)

:: Compile YCM lib
:: mkdir %VIMDIR%\bundle\YouCompleteMe\build
:: pushd %VIMDIR%\bundle\YouCompleteMe\build
:: cmake -G "Visual Studio 12 Win64" -DPATH_TO_LLVM_ROOT="C:\Program Files\LLVM" . ..\third_party\ycmd\cpp      :: FIXME This assumes VS 2013
:: cmake --build . --target ycm_core --config Release
:: if NOT exist ..\third_party\ycmd\libclang.dll goto errorYCMmake

:: Build omnisharp server
:: cd ..
:: install.py --omnisharp-completer         :: FIXME This shit's not working! ('No CMAKE_C_COMPILER could be found')

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:setupMods
::
:: Make sure at least Vundle submodule is not empty (is this necessary??)
::
for /F %%i in ('dir /b "%VIMDIR%\bundle\Vundle.vim\*.*" 2^>NUL') do (
  echo "'Vundle.vim' submodule contains files. Skipping submodule downloading.."
  goto :skipMods
)

echo "'Vundle.vim' submodule is empty. Updating.."
cd %~dp0
git submodule init
git submodule update

:: FIXME Some PATHs (git) seem to still be missing after reboot! -> Use cmder from here on
:: TODO Make another submodule for the retro-minimal color scheme!
:: TODO Install fonts!


:skipMods
echo "Now I'll start vim and tell it to install all plugins."
pause
cls

::
:: Run vim and install all plugins (add '+qall' to make it quit after it's done)
::
echo "Starting vim..."
vim +PluginInstall

goto:eof


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:errorNoAdmin
echo "ERROR: Admin privileges required. Run this script as administrator."
pause
goto:eof

:errorYCMmake
echo "ERROR: YCM compilation failed! libclang.dll is not in third_party\ycmd."
pause
goto:eof



