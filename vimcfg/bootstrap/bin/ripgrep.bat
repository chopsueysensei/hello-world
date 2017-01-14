@echo off

set dir=%1
set xdir=%dir:\=/%

:: Throw the first parameter away
shift
set params=%1
:loop
shift
if [%1]==[] goto afterloop
set params=%params% %1
goto loop
:afterloop


rg %xdir% %params%
