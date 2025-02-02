@SETLOCAL
@ECHO OFF

SET RC=0

ECHO Test 1: Create and verify an archive
DEL archive.yata 2>NUL:
yata -c -d .\in_data
IF %ERRORLEVEL% NEQ 0 ECHO Test failed - yata RC=%ERRORLEVEL%
SET /A RC=%RC%+%ERRORLEVEL%
CALL :COMPARE_FILE in_data\archive.yata archive.yata
DEL archive.yata 2>NUL:

ECHO Test 2: Extract and verify an archive
RMDIR /Q/S out_data 2>NUL:
MKDIR out_data
yata -x -f in_data\archive.yata -d .\out_data
IF %ERRORLEVEL% NEQ 0 ECHO Test failed - yata RC=%ERRORLEVEL%
SET /A RC=%RC%+%ERRORLEVEL%
FOR %%F in (in_data\*.exec) DO CALL :COMPARE_FILE "in_data\%%~nxF" "out_data\%%~nxF"
FOR %%F in (out_data\*.exec) DO CALL :COMPARE_FILE "in_data\%%~nxF" "out_data\%%~nxF"
RMDIR /Q/S out_data 2>NUL:

EXIT /B %RC%

:COMPARE_FILE
comp /m /a "%~1" "%~2"
IF %ERRORLEVEL% NEQ 0 ECHO Test failed - files differ
SET /A RC=%RC%+%ERRORLEVEL%
GOTO :EOF
