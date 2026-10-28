@echo off
rem Удаляет автозапуск ARM-OMK из планировщика заданий.
setlocal
set "TASK=ARM-OMK"

schtasks /Delete /TN "%TASK%" /F
echo.
pause
