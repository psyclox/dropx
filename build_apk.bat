@echo off
echo ========================================================
echo   DropX - Android APK Build (.apk)
echo ========================================================
echo.
powershell -ExecutionPolicy Bypass -File .\flutter.ps1 build apk --debug
echo.
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo [SUCCESS] Android APK built at:
    echo %CD%\build\app\outputs\flutter-apk\app-debug.apk
) else (
    echo [INFO] If build stopped with Android SDK requirement:
    echo 1. Install OpenJDK 17: winget install Microsoft.OpenJDK.17
    echo 2. Install Android Studio: winget install Google.AndroidStudio
)
pause
