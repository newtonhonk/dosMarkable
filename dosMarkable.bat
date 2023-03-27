@echo off
SETLOCAL EnableDelayedExpansion

:: USB IP-Adress and Version
SET _IPUSB=10.11.99.1
SET _name=dosMarkable
SET _version=2.002

:: Folders on PC
SET _workfolder=%USERPROFILE%\dosMarkable\
:: Folder to install file
SET _uploadfolder=%USERPROFILE%\Desktop\CHANGE-TO-FOLDER-FOR-UPLOADS
SET _pdfimportantfolder=CHANGE-TO-FOLDER-FOR-IMPORTANT-PDF
SET _pdfallfolder=CHANGE-TO-FOLDER-FOR-BACKUP-ALL-PDF
SET _backupfolder=%_workfolder%Backup
SET _templatefolder=%_workfolder%Templates
SET _splashfolder=%_workfolder%Splash

:: Folders on reMarkable
SET _rmtemplates=/usr/share/remarkable/templates
SET _rmsplash=/usr/share/remarkable/
SET _rmdocs=/home/root/.local/share/remarkable/xochitl/

::Menu
:home
cd /d %_workfolder%
CLS
ECHO.
ECHO ============== %_name% (%_version%) ==============
ECHO -------------------------------------------------
ECHO   # UPLOAD
echo   1 - Upload PDF
echo   2 - Clear Upload-FOLDER
ECHO -------------------------------------------------
Echo   # DOWNLOAD
ECHO   3 - Download via browser
ECHO   4 - Download important stuff
ECHO   5 - Download all as PDF
ECHO -------------------------------------------------
Echo   # DEVICE
echo   6 - Backup Device
echo   7 - Clear Trash
ECHO -------------------------------------------------
Echo   # TOOLS
echo   8 - Upload Templates and Splashscreens
echo   9 - SSH reMarkable
echo   0 - Open Folder 
ECHO -------------------------------------------------
ECHO =============== PRESS 'Q' TO QUIT ===============
ECHO.

SET INPUT=
SET /P INPUT= Please select a option:

IF /I '%INPUT%'=='1' GOTO rmupload
IF /I '%INPUT%'=='2' GOTO rmdelete
IF /I '%INPUT%'=='3' GOTO rmdownload
IF /I '%INPUT%'=='4' GOTO rmstuff
IF /I '%INPUT%'=='5' GOTO rmall
IF /I '%INPUT%'=='6' GOTO rmdbackup
IF /I '%INPUT%'=='7' GOTO rmclean
IF /I '%INPUT%'=='8' GOTO rmtemplate
IF /I '%INPUT%'=='9' GOTO rmssh
IF /I '%INPUT%'=='0' GOTO rmfolder

IF /I '%INPUT%'=='Q' exit /b

CLS

ECHO ============INVALID INPUT============
ECHO -------------------------------------
ECHO Please select a number from the Main
ECHO Menu or select 'Q' to quit.
ECHO -------------------------------------
ECHO ======PRESS ANY KEY TO CONTINUE======

PAUSE > NUL
GOTO home

:: Upload PDF
:rmupload

cd /d %_uploadfolder%

FOR %%f in (*.*) do (
	ECHO.
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
cd /d %_uploadfolder%
del *.*

goto home

:: Start Browser with reMarkable web server
:rmdownload

start http://%_IPUSB%
goto home

:: Downloads important Stuff
:rmstuff

echo.

if not exist %_pdfimportantfolder% mkdir %_pdfimportantfolder%

cd /d %_pdfimportantfolder%

:: ADD DIRECT URLS TO DOWNLOAD FROM REMARKABLE - Change NAME and UUID
curl -o NAME.pdf http://10.11.99.1/download/UUID/pdf

goto home

:: Download all as PDF
:rmall

ssh -t -q root@%_IPUSB% "ls ~/.local/share/remarkable/xochitl/ | grep -v 'local' | grep -v 'content' | grep -v 'metadata' | grep -v 'pagedata' | grep -v 'thumbnails' | grep -v 'pdf' | grep -v 'highlights' | grep -v 'textconversion' | grep -v 'tombstone'" >> %_workfolder%/uuid.tmp

if not exist %_pdfallfolder% mkdir %_pdfallfolder%

cd /d %_pdfallfolder%

Echo.
Echo Downloading:
set count=0
for /f "tokens=*" %%x in (%_workfolder%\uuid.tmp) do (
	curl --remote-name --remote-header-name --write-out "%%{filename_effective}" --silent http://%_IPUSB%/download/%%x/placeholder
	echo.
)

del %_workfolder%\uuid.tmp

goto home

:: Backups Document folder
:rmdbackup

ECHO BACKUP Documents:
MKDIR %_backupfolder%\D_%date%
scp -r "root@%_IPUSB%:%_rmdocs%" "%_backupfolder%/D_%date%"
ECHO.
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
echo.
ECHO UPLOAD Splashscreens
scp "%_splashfolder%\*" "root@%_IPUSB%:/%_rmsplash%/"
ssh -t root@%_IPUSB% "systemctl restart xochitl"
ECHO.
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

:: Clean trash
:rmclean
ECHO Clear Trash
ECHO.
ssh -t -q root@%_IPUSB% "rm -R ~/.local/share/remarkable/xochitl/*.tombstone"
ssh -t -q root@%_IPUSB% "systemctl restart xochitl"
ECHO.
GOTO home
