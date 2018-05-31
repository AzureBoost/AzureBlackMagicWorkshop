#============================================================================
#	Datei:		StoragePool.ps1
#
#	Summary:	Diese Script initialisiert eine neue Festplatte, erstellt auf ihr
#               eine neue Partition mit maximaler Größe, Formatiert die
#               Platte dann und nennt sie "Data".
#               
#
#	Datum:		2018-05-31
#
#	PowerShell Version: 5.1
#   Azure Version: 5.1.1
#------------------------------------------------------------------------------
#	Geschrieben von 
#       Tillmann Eitelberg, oh22information services GmbH 
#       Frank Geisler, GDS Business Intelligence GmbH
#       Patrick Heyde, Microsoft GmbH
#       Dirk Hondong
#
#   Dieses Script ist nur zu Lehr- bzw. Lernzwecken gedacht
#  
#   DIESER CODE UND DIE ENTHALTENEN INFORMATIONEN WERDEN OHNE GEWÄHR JEGLICHER 
#   ART ZUR VERFÜGUNG GESTELLT, WEDER AUSDRÜCKLICH NOCH IMPLIZIT, EINSCHLIESSLICH, 
#   ABER NICHT BESCHRÄNKT AUF FUNKTIONALITÄT ODER EIGNUNG FÜR EINEN BESTIMMTEN 
#   ZWECK. SIE VERWENDEN DEN CODE AUF EIGENE GEFAHR.
#============================================================================*/

#----------------------------------------------------------------------------
# 0. lade das Azure Modul für Storage
#----------------------------------------------------------------------------
Import-Module Storage

#----------------------------------------------------------------------------
# 1. Schauen welche Disks zum Pooling verfügbar sind
#    https://blogs.technet.microsoft.com/josebda/2015/02/08/using-powershell-to-select-physical-disks-for-use-with-storage-spaces/
#----------------------------------------------------------------------------
Get-PhysicalDisk `
    -CanPool $true 

#----------------------------------------------------------------------------
# 2. Ersten StoragePool anlegen
#----------------------------------------------------------------------------
$disks = Get-PhysicalDisk `
            -CanPool $true | Sort-Object `
                                -Property PhysicalLocation | Select-Object `
                                                                -First 2

New-StoragePool `
    -FriendlyName "DataPool" `
    -StorageSubSystemUniqueId (Get-StorageSubSystem `
                                    -FriendlyName "*Storage*").UniqueId `
    -PhysicalDisks $disks

New-VirtualDisk `
    -FriendlyName "DataVirtDisk" `
    -StoragePoolFriendlyName "DataPool" `
    -UseMaximumSize  `
    -ProvisioningType Fixed `
    -ResiliencySettingName Simple

$virtdisk = Get-VirtualDisk `
                -FriendlyName "DataVirtDisk" | Get-Disk

initialize-disk $virtdisk.DiskNumber

New-Partition `
    -DiskNumber $virtdisk.DiskNumber  `
    -UseMaximumSize `
    -DriveLetter "G"

Format-Volume ´
    -DriveLetter G `
    -FileSystem NTFS `
    -NewFileSystemLabel "Data" `
    -AllocationUnitSize 65536  #64k alloc size - gut für SQL Server

#----------------------------------------------------------------------------
# 3. Zweiten StoragePool anlegen
#----------------------------------------------------------------------------
$disks = Get-PhysicalDisk `
            -CanPool $true | Sort-Object `
                                -Property PhysicalLocation |Select-Object `
                                                                -First 2

New-StoragePool `
    -FriendlyName "LogPool" `
    -StorageSubSystemUniqueId (Get-StorageSubSystem `
                                    -FriendlyName "*Storage*").UniqueId `
    -PhysicalDisks $disks

New-VirtualDisk `
    -FriendlyName "LogVirtDisk" `
    -StoragePoolFriendlyName "LogPool" `
    -UseMaximumSize  `
    -ProvisioningType Fixed `
    -ResiliencySettingName Simple

$virtdisk = Get-VirtualDisk `
                -FriendlyName "LogVirtDisk" | Get-Disk

initialize-disk $virtdisk.DiskNumber

New-Partition `
    -DiskNumber $virtdisk.DiskNumber `
    -UseMaximumSize `
    -DriveLetter "H"

Format-Volume `
    -DriveLetter H `
    -FileSystem NTFS `
    -NewFileSystemLabel "Log" `
    -AllocationUnitSize 65536  #64k alloc size - gut für SQL Server
