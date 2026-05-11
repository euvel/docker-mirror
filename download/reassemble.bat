@echo off
echo 🔧 Reassembling: tele-mirror-win-x64.zip

:: Combine chunks
copy /b tele-mirror-win-x64.zip.part.* tele-mirror-win-x64.zip > nul

if not exist tele-mirror-win-x64.zip (
    echo ❌ Failed to reassemble file
    exit /b 1
)

:: Verify checksum
echo Verifying integrity...
certutil -hashfile tele-mirror-win-x64.zip SHA256 | findstr /v "certutil" | findstr /v "SHA256" > temp_hash.txt

set /p actual=<temp_hash.txt
set /p expected=<tele-mirror-win-x64.zip.sha256
set expected=%expected: =%

if "%actual%"=="%expected%" (
    echo ✅ Success! File: tele-mirror-win-x64.zip
    for %%A in ("tele-mirror-win-x64.zip") do echo Size: %%~zA bytes
    echo.
    echo 🧹 Cleaning up chunks...
    del tele-mirror-win-x64.zip.part.*
    del temp_hash.txt
    echo ✅ Chunks deleted. Only the final file remains.
) else (
    echo ❌ Checksum verification failed!
    del tele-mirror-win-x64.zip
    del temp_hash.txt
    exit /b 1
)
