@echo off
setlocal enabledelayedexpansion

echo 🔧 Reassembling: tele-mirror-win-x64.zip

:: Combine chunks
copy /b "tele-mirror-win-x64.zip.part.*" "tele-mirror-win-x64.zip" > nul 2>&1

if not exist "tele-mirror-win-x64.zip" (
    echo ❌ Failed to reassemble file
    exit /b 1
)

:: Verify checksum
echo Verifying integrity...

:: Extract hash from certutil output (line 2, remove spaces)
for /f "skip=1 tokens=* delims=" %%h in ('certutil -hashfile "tele-mirror-win-x64.zip" SHA256') do (
    set "actual=%%h"
    goto :got_actual
)
:got_actual
set "actual=%actual: =%"

:: Read expected hash from file
set /p expected=<"tele-mirror-win-x64.zip.sha256"
for /f "tokens=1" %%a in ("%expected%") do set "expected=%%a"
set "expected=%expected: =%"

:: Compare (case-insensitive)
if /i "%actual%"=="%expected%" (
    echo ✅ Success! File: tele-mirror-win-x64.zip
    for %%A in ("tele-mirror-win-x64.zip") do echo Size: %%~zA bytes
    echo.
    echo 🧹 Cleaning up chunks...
    del "tele-mirror-win-x64.zip.part.*" 2>nul
    del "tele-mirror-win-x64.zip.sha256" 2>nul
    echo ✅ Chunks deleted. Only the final file remains.
) else (
    echo ❌ Checksum verification failed!
    echo Expected: %expected%
    echo Actual:   %actual%
    del "tele-mirror-win-x64.zip" 2>nul
    exit /b 1
)

endlocal
