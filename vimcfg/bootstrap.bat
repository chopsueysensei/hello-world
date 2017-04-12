@echo off
:: This must be at the beginning in order to have colors
SETLOCAL DisableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)


::
:: Check permissions
::
net session >nul 2>&1
if NOT %errorlevel% == 0 goto errorNoAdmin

::
:: Check for Python on the command line
::
python --version
if NOT %errorlevel% == 0 goto errorNoPython

::
:: Link vim config files in home dir
::
:: TODO Check if this has already been done (or silence the error)
mklink "%HOMEPATH%\.vimrc" "%~dp0\.vimrc"
mklink "%HOMEPATH%\.gvimrc" "%~dp0\.gvimrc"
mklink /d "%HOMEPATH%\.vim" "%~dp0\.vim"

set VIMDIR=%HOMEPATH%\.vim

::
:: Install chocolatey
::
choco --version
if %errorlevel% == 0 goto haveChoco

powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

:haveChoco
::
:: Check for git on the command line
::
git --version
if %errorlevel% == 0 goto haveGit

choco install git

:haveGit
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
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Just check it's in the path
ctags --version
if NOT %errorlevel% == 0 call :ColorText 19 "WARNING: No ctags binary in path!"



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: TODO YouCompleteMe
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Check msbuild is in path
:: msbuild
:: if NOT %errorlevel% == 0 goto errorMsbuildPath

:: Check CMake exists
:: Install CMake
:: Add to path if not in it already

:: Install libclang from http://releases.llvm.org/4.0.0/LLVM-4.0.0-win64.exe (no choco!)

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


::
:: Remap CAPS to ESC and BLOCK-DESP to CAPS
::
regedit "%~dp0\bootstrap\remap_capslock.reg"

echo Please log off from the user session so that the keyboard mapping is applied..

::
:: Make sure at least Vundle submodule is not empty
::
for /F %%i in ('dir /b "%VIMDIR%\bundle\Vundle.vim\*.*" 2^>NUL') do (
  echo 'Vundle.vim' submodule contains files. Skipping submodule downloading..
  goto :skipSUBs
)

echo 'Vundle.vim' submodule is empty. Updating..
cd %~dp0
git submodule init
git submodule update

:skipSUBs
echo Now I'll start vim and tell it to install all plugins.
pause



::
:: Run vim and install all plugins (add '+qall' to make it quit after it's done)
::
call :ColorText 0a "Starting vim..."
vim +PluginInstall

goto:eof


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:errorNoAdmin
call :ColorText 0C "ERROR: Admin privileges required. Run this script as administrator."
pause
goto:eof

:errorNoPython
call :ColorText 0C "ERROR: No python available in the command line!"
pause
goto:eof

:errorYCMmake
call :ColorText 0C "ERROR: YCM compilation failed! libclang.dll is not in third_party\ycmd."
pause
goto:eof



:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: This must be the last thing in the file!
:ColorText
echo off
<nul set /p .=. > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
echo(%DEL%%DEL%%DEL%
del "%~2" > nul 2>&1
goto :eof
