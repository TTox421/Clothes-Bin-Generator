@echo off
title alt:V clothes.bin Generator
chcp 65001 >nul
cd /d "%~dp0"

echo ================================================================================
echo           Launching alt:V clothes.bin Generator ^& Synchronizer
echo ================================================================================
echo.

python generator.py
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Process terminated with an error code: %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
)

echo.
pause
