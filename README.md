# dosMarkable
CMD.exe Batch script for the reMarkable tablet for Windows (tested on Windows 10)

This script uses only system commands to deal with the reMarkable tablet.

It uses SSH over USB. You need to set up a SHH access (guide at [remarkablewiki](https://remarkablewiki.com/tech/ssh))

It includes the following functions:
- Upload and rename PDFs from a folder
- Backup the document folder from the reMarkable tablet via SSH
- Backup templates and splashscreens from the reMarkable tablet via SSH
- SSH into the reMarkable tablet via SSH
- reboot the reMarkable tablet via SHH

**USE AT OWN RISK. There are some commands that uses delete *.*! So be carefull!**
**It also overwrites some files on the reMarkable. So be carefull again!**

My skills in creating .bat files are limited, so improvements are highly welcome.
Also still searching for a way to download all documents from the reMarkable tablet just with windows system tools.

---
## Installation:

1) Create a folder on your harddrive, for an example: C:\Users\USERNAME\PROGRAMMFOLDER\dosMarkable\
- within this folder create the following folders:
  - Backup
  - Splashscreens
  - Templates
  - Upload
2) Copy dosMarkable.bat where ever you want. Maybe in dosMarkable folder.
3) Create a Alias for the dosMarkable.bat (if you like)
4) Add the programm path (step 1) to the setting in the dosMarkable.bat
- SET _workfolder=C:\Users\USERNAME\PROGRAMMFOLDER\dosMarkable\

---
## Screenshot
![Screenshot](screenshot.jpg)

