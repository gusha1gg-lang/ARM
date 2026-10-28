@echo off
rem Рабочий запуск ARM-OMK (waitress). Окно закрывать нельзя — это и есть сервер.
cd /d "%~dp0"

set PYTHONIOENCODING=utf-8
set PYTHONUTF8=1

set "PY=python"
python -c "import sys" >nul 2>nul || set "PY=py -3"

if not exist "vendor\flask" (
    echo.
    echo ОШИБКА: не найден каталог vendor\ - библиотеки не скопированы.
    echo Скопируйте проект целиком, включая папку vendor.
    echo.
    pause
    exit /b 1
)

%PY% serve.py
echo.
echo Сервер остановлен.
pause
