@echo off
rem Открывает порт сайта ARM-OMK в брандмауэре Windows.
rem Запускать ОТ ИМЕНИ АДМИНИСТРАТОРА: правый щелчок по файлу ->
rem "Запуск от имени администратора".
rem
rem Без аргумента открывается порт 80 (сайт без порта в адресе).
rem Другой порт:  install_firewall.bat 5000
rem
rem ВНИМАНИЕ: файл сохранён в кодировке cp866 (OEM), иначе Windows
rem показывает русский текст кракозябрами. При правке пересохраняйте в cp866.

setlocal
set "PORT=%~1"
if "%PORT%"=="" set "PORT=80"
set "RULE=ARM-OMK web %PORT%"

net session >nul 2>&1
if errorlevel 1 (
    echo.
    echo ОШИБКА: нужны права администратора.
    echo Закройте окно, нажмите на install_firewall.bat правой кнопкой
    echo мыши и выберите "Запуск от имени администратора".
    echo.
    pause
    exit /b 1
)

netsh advfirewall firewall show rule name="%RULE%" >nul 2>&1
if not errorlevel 1 (
    echo Правило "%RULE%" уже существует - менять ничего не нужно.
    echo.
    pause
    exit /b 0
)

netsh advfirewall firewall add rule name="%RULE%" dir=in action=allow ^
    protocol=TCP localport=%PORT% profile=domain,private
if errorlevel 1 (
    echo.
    echo Не удалось создать правило.
    echo Проверьте, что брандмауэр Windows включён.
    echo.
    pause
    exit /b 1
)

echo.
echo Готово: входящие подключения на порт %PORT% разрешены
echo для профилей сети "домен" и "частная".
echo.
echo Адрес сайта: http://IP-этого-компьютера/    (IP смотреть в ipconfig)
echo.
pause
