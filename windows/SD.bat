@echo off

set MONITOR_1_NAME=\\.\DISPLAY1
set MONITOR_2_NAME=\\.\DISPLAY2

echo.
echo [Switch Display]
echo --------------------------------

where MultiMonitorTool.exe >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: MultiMonitorTool.exe not found.
    goto end
)

set TEMP_FILE=%TEMP%\display_status.csv

MultiMonitorTool.exe /scomma "%TEMP_FILE%"

@REM Primary / Name
for /f "skip=1 tokens=8,15 delims=," %%A in (%TEMP_FILE%) do (
    if "%%A"=="Yes" (
        set CURRENT_PRIMARY=%%B
    )
)

if exist "%TEMP_FILE%" del "%TEMP_FILE%"

if not defined CURRENT_PRIMARY (
    echo Error: Could not determine the current primary display.
    goto end
)

echo Current Primary Display: %CURRENT_PRIMARY%

if "%CURRENT_PRIMARY%"=="%MONITOR_1_NAME%" (
    echo Switching to %MONITOR_2_NAME%...
    MultiMonitorTool.exe /SetPrimary %MONITOR_2_NAME%
) else (
    echo Switching to %MONITOR_1_NAME%...
    MultiMonitorTool.exe /SetPrimary %MONITOR_1_NAME%
)

echo --------------------------------
echo Switch completed.
echo.

:end
timeout /t 1 >nul