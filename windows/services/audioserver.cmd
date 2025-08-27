@echo off
REM I reccomend adding this to startup with "highest" permissions in Windows "Task Scheduler"
title Auto-Restart Service Monitor
set ServiceName=audiosrv
set LogFile=%~dp0service_monitor.log

:loop
sc query "%ServiceName%" | find "RUNNING" >nul
if errorlevel 1 (
    echo [%date% %time%] %ServiceName% is not running, restarting... >> "%LogFile%"
    net start "%ServiceName%" >> "%LogFile%" 2>&1
)

timeout /t 30 /nobreak >nul
goto loop
