@echo off
echo ========================================================
echo   DropX - Windows Desktop Build (.exe)
echo ========================================================
echo.
powershell -ExecutionPolicy Bypass -File .\flutter.ps1 build windows --release
echo.
if exist "build\windows\x64\runner\Release\dropx.exe" (
    echo [SUCCESS] Windows executable built at:
    echo %CD%\build\windows\x64\runner\Release\dropx.exe
) else (
    echo [INFO] If build stopped with Visual Studio requirement, please ensure
    echo "Desktop development with C++" is completed in Visual Studio Installer.
)
pause
