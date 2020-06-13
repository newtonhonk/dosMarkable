mode con:cols=100 lines=32
@ECHO off
SETLOCAL EnableDelayedExpansion

:: USB IP-Adress and Version
SET _IPUSB=10.11.99.1
SET _name=dosMarkable
SET _version=1.001

:: Folders on PC
SET _workfolder=C:\Users\USERNAME\PROGRAMMFOLDER\dosMarkable\
SET _uploadfolder=%_workfolder%Upload
SET _backupfolder=%_workfolder%Backup
SET _templatefolder=%_workfolder%Templates
SET _splashfolder=%_workfolder%Splashscreens

:: Folders on reMarkable
SET _rmtemplates=/usr/share/remarkable/templates
SET _rmsplash=/usr/share/remarkable/
SET _rmdocs=/home/root/.local/share/remarkable/xochitl/

:: Main Menu
:home
CLS
ECHO  =================================================================================================
ECHO  %_name%							                           v %_version%
ECHO  =================================================================================================
echo.  
echo  Select a task:
echo  ___________________________
echo.
echo  1) Upload PDF
echo  2) Clear Upload-FOLDER
echo. 
echo  3) Download PDFs
echo.
echo  4) Backup Documents
echo  5) Backup Templates and Splash-Screens
echo.
echo  6) Upload Templates
echo  7) Upload Splashscreens
echo.
echo  8) Tools
echo.
echo  9) EXIT
echo  ___________________________
echo.
CHOICE /C 123456789 /M "Choose: "

if %ERRORLEVEL% EQU 1 goto rmupload
if %ERRORLEVEL% EQU 2 goto rmdelete
if %ERRORLEVEL% EQU 3 goto rmdownload
if %ERRORLEVEL% EQU 4 goto rmdbackup
if %ERRORLEVEL% EQU 5 goto rmtsbackup
if %ERRORLEVEL% EQU 6 goto rmtemplate
if %ERRORLEVEL% EQU 7 goto rmsplash
if %ERRORLEVEL% EQU 8 goto rmtools
if %ERRORLEVEL% EQU 9 EXIT

goto home

:: Tools Menu
:rmtools
CLS
ECHO  =================================================================================================
ECHO  %_name% - tools						                           v %_version%
ECHO  =================================================================================================
echo.  
echo  Select a task:
echo  ___________________________
echo.
echo  1) Open Folder
echo. 
echo  2) SSH reMarkable
echo.
echo  3) Reboot reMarkable
echo.
echo  9) Main Menu
echo  ___________________________
echo.
CHOICE /C 1239 /M "Choose: "

if %ERRORLEVEL% EQU 1 goto rmfolder
if %ERRORLEVEL% EQU 2 goto rmssh
if %ERRORLEVEL% EQU 3 goto rmreboot
if %ERRORLEVEL% EQU 9 goto home

goto home

:: Upload PDF
:rmupload

CD %_uploadfolder%

FOR %%f in (*.*) do (
	ECHO .
	ECHO FILENAME:
	ECHO %%f
	ECHO.
	SET /P _new=New Filename [x for no change]: 
	IF "!_new!"=="x" ( SET _new=%%f )
	ECHO %%f 
	ECHO -renamed in:-
	ECHO !_new!
	CURL "http://%_IPUSB%/upload" -H "Origin: http://%_IPUSB%.1" -H "Accept: */*" -H "Referer: http://%_IPUSB%/" -H "Connection: keep-alive" -F "file=@%%f;filename=!_new!;type=application/pdf"	
	ECHO.
)

ECHO.

PAUSE

goto home

:: Clear Upload Folder - Carefull!!!
:rmdelete

echo.
CD %_uploadfolder%
del *.*

goto home

:: Start Browser with reMarkable web server
:rmdownload

start http://%_IPUSB%
goto home

:: Backups Document folder
:rmdbackup

ECHO BACKUP Documents:
MKDIR %_backupfolder%\D_%date%
scp -r "root@%_IPUSB%:%_rmdocs%" "%_backupfolder%/D_%date%"
ECHO.
PAUSE
goto home

:: Backups Templates and Splashscreens
:rmtsbackup

ECHO BACKUP Templates, Splashscreens, templates.json:
MKDIR %_backupfolder%\T_%date%
MKDIR %_backupfolder%\S_%date%
scp "root@%_IPUSB%:%_rmtemplates%/*" "%_backupfolder%/T_%date%"
scp "root@%_IPUSB%:%_rmsplash%/*.png" "%_backupfolder%/S_%date%"
ECHO.
PAUSE
goto home

:: Upload templates
:rmtemplate
ECHO UPLOAD Templates
scp "%_templatefolder%\*" "root@%_IPUSB%:/%_rmtemplates%/"
ECHO.
PAUSE
GOTO home

:: Upload splashscreens
:rmsplash
ECHO UPLOAD Templates
scp "%_splashfolder%\*" "root@%_IPUSB%:/%_rmsplash%/"
ECHO.
PAUSE
GOTO home

:: Open Programm Folder
:rmfolder
ECHO OPEN FOLDER
START %_workfolder%
GOTO home

:: SSH into reMarkable
:rmssh
ECHO SSH reMarkable
ECHO.
ECHO on
ssh root@%_IPUSB%
ECHO off
ECHO.
GOTO home

:: Reboot reMarkable with SSH
:rmreboot
ECHO Reboot reMarkable
ECHO.
ssh -t root@%_IPUSB% "/sbin/reboot"
ECHO.
GOTO home
