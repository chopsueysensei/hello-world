if exist dist\ rd dist
md dist
xcopy Clock.ico dist
xcopy template.mustache dist

:: Assume 'python_tools' is located two directories up from us
cxfreeze workhours.py --target-dir=dist --include-path=..\..\ --include-modules=imp,python_tools --base-name=Win32GUI --icon=Clock.ico

if %errorlevel% == 0 goto:eof
pause
