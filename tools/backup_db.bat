@echo off
rem Резервная копия БД + uploads/ + Slegenie/ (для планировщика заданий).
cd /d "%~dp0.."
set PYTHONIOENCODING=utf-8
set PYTHONUTF8=1

set "PY=python"
python -c "import sys" >nul 2>nul || set "PY=py -3"

if not exist "_backup\logs" mkdir "_backup\logs"
%PY% tools\backup_db.py --with-files >> "_backup\logs\backup.log" 2>&1
exit /b %errorlevel%
