######################################################################################################
# Project: Azure Black Magic Workshop                                                                #
# DiskPart Script                                                                                    #
# Copyright: OH22IS (http://www.oh22.is)                                                             #
######################################################################################################

$t = @"
SELECT DISK 2
Clean
Convert Dynamic
create volume simple disk=2
format fs=NTFS Label='TempDb' UNIT=65536 QUICK
assign letter=F
SELECT DISK 3
Clean
Convert GPT
Convert Dynamic
SELECT DISK 4
Clean
Convert GPT
Convert Dynamic
SELECT DISK 5
Clean
Convert GPT
Convert Dynamic
create volume stripe disk=3,4,5
format fs=NTFS Label='Data' UNIT=65536 QUICK
assign letter=G
SELECT DISK 6
Clean
Convert Dynamic
create volume simple disk=6
format fs=NTFS Label='Log' UNIT=65536 QUICK
assign letter=H
"@

$t | diskpart

# Create Default Folders for TempDB, Data & Log Files
New-Item -ItemType Directory -Force -Path F:\TempDb
New-Item -ItemType Directory -Force -Path F:\TempLog
New-Item -ItemType Directory -Force -Path G:\Data
New-Item -ItemType Directory -Force -Path H:\Log
