#============================================================================
#	Datei:		DiskPart.ps1
#
#	Summary:	Diese Script legt eine Best-Practices Plattenkonfiguration
#               für einen SQL Server an. Es werden 5 Platten benötigt.
#               die erste Platte wird als Basisfestplatte für die tempDB
#               verwendet. Die nächsten drei Platten werden als Stripe Set
#               für die Datenbankdateien genutzt. Die letzte Platte wird
#               als Platte für Transaktionsprotokolle verwendet. 
#               Nachdem die Platten konfiguriert wurden werden 
#               Standardverzeichnisse für die Datenbankdateien angelegt.
#               
#
#	Datum:		2018-05-24
#
#	PowerShell Version: 5.1
#   Azure Version: 5.1.1
#------------------------------------------------------------------------------
#	Geschrieben von 
#       Tillmann Eitelberg, oh22information services GmbH 
#       Frank Geisler, GDS Business Intelligence GmbH
#       Patrick Heyde, Microsoft GmbH
#
#   Dieses Script ist nur zu Lehr- bzw. Lernzwecken gedacht
#  
#   DIESER CODE UND DIE ENTHALTENEN INFORMATIONEN WERDEN OHNE GEWÄHR JEGLICHER 
#   ART ZUR VERFÜGUNG GESTELLT, WEDER AUSDRÜCKLICH NOCH IMPLIZIT, EINSCHLIESSLICH, 
#   ABER NICHT BESCHRÄNKT AUF FUNKTIONALITÄT ODER EIGNUNG FÜR EINEN BESTIMMTEN 
#   ZWECK. SIE VERWENDEN DEN CODE AUF EIGENE GEFAHR.
#============================================================================*/

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
