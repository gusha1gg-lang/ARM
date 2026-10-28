@echo off
rem Удаляет автозапуск ARM-OMK из планировщика заданий.
rem ВНИМАНИЕ: файл сохранён в кодировке cp866 (OEM). При правке пересохраняйте в cp866.
setlocal
set "TASK=ARM-OMK"

schtasks /Delete /TN "%TASK%" /F
echo.
pause
