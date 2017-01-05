:: Check permissions
net session >nul 2>&1
if NOT %errorlevel% == 0 goto errorNoAdmin

:: Check for git on the command line
git --version
if errorlevel 1 goto errorNoGit

:: Link vim config files in home dir
mklink "%HOMEPATH%\.vimrc" "%~dp0\.vimrc"
mklink "%HOMEPATH%\.gvimrc" "%~dp0\.gvimrc"
mklink /d "%HOMEPATH%\.vim" "%~dp0\.vim"

:: Remap CAPS to ESC and BLOCK-DESP to CAPS
regedit "%~dp0\remap_capslock.reg"

@echo Please log off from the user session so that the keyboard mapping is applied..

:: Run vim and install all plugins (add '+qall' to make it quit after it's done)
vim +PluginInstall

goto:eof


:errorNoAdmin
echo Error: Admin privileges required. Run this script as administrator.
@pause
goto:eof

:errorNoGit
echo Error^: Git not available in the command line.
@pause
goto:eof
