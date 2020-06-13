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

**USE AT OWN RISK. There are some commands that delete the upload folder with delete *.*! So be carefull!**

---
## Installation:

1) Set up folders, for an example: c:/Users/Username/Programs/dosMarkable
- within this folder create the following folders:
  - Backup
  - Splashscreens
  - Templates
  - Upload
2) Copy dosMarkable.bat where ever you want. Maybe in dosMarkable folder.
3) Create a Alias for the dosMarkable.bat (if you like)

