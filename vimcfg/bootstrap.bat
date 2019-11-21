@echo off
setlocal enableextensions

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
echo Let's check required software
pause
cls
call choco --version >nul 2>&1
if %errorlevel% == 0 goto haveChoco

powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
call refreshenv.cmd

:haveChoco
::
:: Check for Python on the command line
::
call py -2 --version >nul 2>&1
if %errorlevel% == 0 goto havePython

choco install python2 --version 2.7.14 -y -r
call refreshenv.cmd

:havePython
::
:: Check for cmder on the command line
::
:: FIXME Also check for a registry key or something, for manually installed Cmder
where cmder >nul 2>&1
if %errorlevel% == 0 goto haveCmder

choco install cmder -y -r

:haveCmder
:: Add a context menu for it
cmder.exe /REGISTER ALL

::
:: Check for git on the command line
::
call git --version >nul 2>&1
if %errorlevel% == 0 goto haveGit

choco install git -y -r
call refreshenv.cmd

:haveGit
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ViM
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: FIXME Cmder now has command line vim in its git-for-windows stuff, make sure to discard that!
:: TODO Look for it only among the chocolatey installed packages
::call vim --version >nul 2>&1
::if %errorlevel% == 0 goto haveVim

echo.
echo.
echo.
echo Now to the good stuff
pause
cls
choco install vim-tux -y -r

:haveVim
::
:: Link vim config files in home dir
::
:: TODO ? Check if this has already been done (or silence the error)
echo.
echo.
echo.
echo We need some paths and plugins
pause

set HOME=%USERPROFILE%
setx HOME %HOME%
set VIMDIR=%HOME%\.vim
setx VIMDIR %HOME%\.vim

mklink "%HOME%\.vimrc" "%~dp0\.vimrc"
mklink "%HOME%\.gvimrc" "%~dp0\.gvimrc"
mklink /d "%HOME%\.vim" "%~dp0\.vim"
::
:: Create a folder to hold backup & undo files
::
mkdir "%HOME%\.backup"


::
:: Install ripgrep
::
call rg --version >nul 2>&1
if %errorlevel% == 0 goto haveGrep

choco install ripgrep -y -r

:haveGrep
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: GNU Global (http://www.gnu.org/software/global)
:: FIXME Upload their 'gtags.vim' to github and make it installable via Vundle/NeoBundle
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
call global --version >nul 2>&1
if %errorlevel% == 0 goto haveGlobal

choco install global -y -r

:haveGlobal
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: universal-ctags (https://github.com/universal-ctags/ctags) (no choco..)
:: TODO Remove?
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Just check it's in the path
call ctags --version >nul 2>&1
if NOT %errorlevel% == 0 echo WARNING: No ctags binary in path!



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
  echo.
  echo.
  echo.
  echo 'Vundle.vim' submodule contains files. Skipping submodule downloading..
  goto :skipMods
)

:setupModsForce
echo.
echo.
echo.
echo 'Vundle.vim' submodule is empty. Updating..
cd /d %~dp0
git submodule init
git submodule update

:: FIXME Some PATHs (git) seem to still be missing after reboot! -> Use cmder from here on
:: TODO Make another submodule for the retro-minimal color scheme!
:: TODO Install fonts!


:skipMods
echo.
echo.
echo.
echo Now I'll start vim and tell it to install all plugins (should close itself afterwards).
pause
cls

::
:: Run vim and install all plugins (add '+qall' to make it quit after it's done)
::
echo Starting vim...
start vim +PluginInstall +qall


:applyPatch
echo.
echo.
echo.
set vimrgdir=%VIMDIR%\bundle\vim-ripgrep
set patchfile=vim-ripgrep_fix_derive_root.patch
echo Apply %patchfile% into %vimrgdir%..
cd /d "%vimrgdir%"
git apply "%~dp0\bootstrap\%patchfile%"


:installFonts
echo Installing fonts..
powershell -command "Set-ExecutionPolicy Unrestricted"
powershell "%~dp0\bootstrap\install_fonts.ps1"


:remapCaps

::
:: Remap CAPS to ESC and BLOCK-DESP to CAPS
::
::echo.
::echo.
::echo.
::echo Now I'll install the CAPSLOCK mapping into the registry. Please answer yes to the prompt !!
::regedit "%~dp0\bootstrap\remap_capslock.reg"
::echo.
::echo.
::echo.
::echo Please log off from the user session _after the installation_ so that the CAPSLOCK mapping is applied..
::pause

:: Alternative just for the current user (also creates dev\bin dir and adds it to the PATH)
mkdir C:\dev\bin
xcopy "%~dp0\bootstrap\uncap.exe" C:\dev\bin\
:: TODO This is supposed to not need a reboot, but it's not doing it..
powershell "%~dp0\bootstrap\add_to_path.ps1"
xcopy "%~dp0\bootstrap\remap_capslock.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"

call refreshenv.cmd
"%~dp0\bootstrap\remap_capslock.bat"


echo.
echo.
echo.
echo All done!
cd %~dp0
goto:eof


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:errorNoAdmin
echo ERROR: Admin privileges required. Run this script as administrator.
pause
goto:eof

:errorYCMmake
echo ERROR: YCM compilation failed! libclang.dll is not in third_party\ycmd.
pause
goto:eof



