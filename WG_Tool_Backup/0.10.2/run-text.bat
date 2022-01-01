@echo off

REM TODO: check and fix relative path (by .lnk)
REM TODO: check whatever inputFolder exists
set /p inputFolder="Enter your mod root folder (full path): "
set /p outputFolder="Enter packet geometry destanation (full path): "


echo %inputFolder% "->" %outputFolder%
geometrypack.exe --tree %inputFolder% %outputFolder%
pause
