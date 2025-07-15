@ECHO OFF

NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Error: pls run with admin permission.
    ECHO.
    PAUSE
    EXIT
)

ECHO Admin permission Granted.
ECHO.

SET "hostsDir=%SystemRoot%\System32\drivers\etc"
SET "hostsFile=%hostsDir%\hosts"
SET "backupFile=%hostsDir%\hosts.bak"
SET "downloadUrl=https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/multi-compressed.txt"
SET "tempFile=%TEMP%\hosts_temp.txt"

ECHO Backing up hosts file to %backupFile%...
COPY /Y "%hostsFile%" "%backupFile%"
IF ERRORLEVEL 1 (
    ECHO Error backing up.
    PAUSE
    EXIT
)
ECHO Backup completed.
ECHO.

ECHO Downloading new hosts file from %downloadUrl%
ECHO.
curl -L -o "%tempFile%" "%downloadUrl%"

IF NOT EXIST "%tempFile%" (
    ECHO Error: download failed.
    PAUSE
    EXIT
)

FINDSTR /R /C:"." "%tempFile%" > NUL
IF ERRORLEVEL 1 (
    ECHO Error: empty file.
    DEL "%tempFile%"
    PAUSE
    EXIT
)

ECHO Downloaded to temp folder.
ECHO.

ECHO Replacing hosts...
MOVE /Y "%tempFile%" "%hostsFile%"
IF ERRORLEVEL 1 (
    ECHO Error: replacing hosts.
    PAUSE
    EXIT
)
ECHO Hosts updated.
ECHO.

ECHO Flush DNS.
ipconfig /flushdns
ECHO DNS Flushed.
ECHO.

ECHO ================================
ECHO All Done.
ECHO ================================
ECHO.
PAUSE