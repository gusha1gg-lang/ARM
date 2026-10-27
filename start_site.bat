@echo off
chcp 65001 > nul
cd /d "%~dp0"

if exist "venv\Scripts\activate.bat" (
    call "venv\Scripts\activate.bat"
)

taskkill /IM python.exe /F >nul 2>&1
timeout /t 2 >nul

start "" /min cmd /k "cd /d "%~dp0" && python run.py"

timeout /t 5 >nul
start "" "http://127.0.0.1:5000/Login.aspx"
