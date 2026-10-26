@echo off
echo ========================================================
echo   DropX - Launch App
echo ========================================================
echo.
powershell -ExecutionPolicy Bypass -File .\flutter.ps1 run -d windows
pause
