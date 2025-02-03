@SETLOCAL
@ECHO OFF

SET EXIT_RC=0

ECHO Test 1: Create and verify an archive
DEL archive.yata 2>NUL:
SET MY_RC=0
yata -c -d .\in_data
SET /A MY_RC=%MY_RC%+%ERRORLEVEL%
CALL :COMPARE_FILE in_data\archive.yata archive.yata
IF %MY_RC% NEQ 0 ECHO Test failed
IF %MY_RC% EQU 0 ECHO Test passed
SET /A EXIT_RC=%EXIT_RC%+%MY_RC%
DEL archive.yata 2>NUL:

ECHO Test 2: Extract and verify an archive
RMDIR /Q/S out_data 2>NUL:
MKDIR out_data
SET MY_RC=0
yata -x -f in_data\archive.yata -d .\out_data
SET /A MY_RC=%MY_RC%+%ERRORLEVEL%
FOR %%F in (in_data\*.exec) DO CALL :COMPARE_FILE "in_data\%%~nxF" "out_data\%%~nxF"
FOR %%F in (out_data\*.exec) DO CALL :COMPARE_FILE "in_data\%%~nxF" "out_data\%%~nxF"
RMDIR /Q/S out_data 2>NUL:
IF %MY_RC% NEQ 0 ECHO Test failed
IF %MY_RC% EQU 0 ECHO Test passed
SET /A EXIT_RC=%EXIT_RC%+%MY_RC%

EXIT /B %EXIT_RC%

:COMPARE_FILE
comp /m /a "%~1" "%~2"
SET /A MY_RC=%MY_RC%+%ERRORLEVEL%
GOTO :EOF
