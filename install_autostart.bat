@echo off
rem Регистрирует автозапуск ARM-OMK при входе пользователя в Windows.
rem Запускать от имени администратора (правый клик -> «Запуск от имени администратора»).
setlocal
set "TASK=ARM-OMK"
set "SCRIPT=%~dp0start_server.bat"

schtasks /Create /TN "%TASK%" /TR "\"%SCRIPT%\"" /SC ONLOGON /RL HIGHEST /DELAY 0000:30 /F
if errorlevel 1 (
    echo.
    echo Не удалось создать задание. Запустите файл от имени администратора.
) else (
    echo.
    echo Автозапуск создан: задание "%TASK%" при входе пользователя в Windows.
    echo Проверить: schtasks /Query /TN "%TASK%"
)
echo.
pause
