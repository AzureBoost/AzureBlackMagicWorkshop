#============================================================================
#	Datei:		12 - CustomScriptExtension.ps1
#
#	Summary:	In diesem Script wird die Festplatte einer Azure VM mit Hilfe
#               eines Scriptes das über die Custom Script Extension an die
#               Maschine gegeben wird initialisiert und formaiert.
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

#------------------------------------------------------------------------------
# 0. Variablen initialisieren
#------------------------------------------------------------------------------
$resourceGroup = "BlackMagicCGNVM"
$vmName = "mdvm1"
$scriptName = "NewDisk"
$fileName = "NewDisk.ps1"
$location = "northeurope"
$storageAccountName = "blackmagicscripts"
$containerName = "scripts"
$localFile = ".\NewDisk.ps1"

#------------------------------------------------------------------------------
# 1. Storage Account holen, oder, wenn es diesen nicht gibt anlegen
#------------------------------------------------------------------------------
$storageAccount = Get-AzureRmStorageAccount `
                    -ResourceGroupName $resourceGroup `
                    -Name $storageAccountName `
                    -ErrorAction SilentlyContinue

if(!$storageAccount)
{
    $storageAccount = New-AzureRmStorageAccount `
                        -ResourceGroupName $resourceGroup `
                        -Name $storageAccountName `
                        -SkuName Standard_LRS `
                        -Location $location `
                        -Kind Storage;
}

$storageAccountKey = (Get-AzureRmStorageAccountKey `
                        -ResourceGroupName $resourceGroup `
                        -Name $storageAccountName).Value[0];

$context = New-AzureStorageContext `
                -StorageAccountName $storageAccountName `
                -StorageAccountKey $storageAccountKey

#------------------------------------------------------------------------------
# 2. neuen Storage Container anlegen
#------------------------------------------------------------------------------
New-AzureStorageContainer `
    -Name $containerName `
    -Context $context

#------------------------------------------------------------------------------
# 3. lokale Datei in Storage Container hochladen
#------------------------------------------------------------------------------
Set-AzureStorageBlobContent  ´
    -File $localFile `
    -Container $containerName `
    -Blob $fileName `
    -Context $context `
    -Force

#------------------------------------------------------------------------------
# 4. Hochgeladene Datei als Custom Script Extension festlegen
#------------------------------------------------------------------------------
Set-AzureRmVMCustomScriptExtension  `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -VMName $vmName `
    -StorageAccountName $storageAccountName `
    -StorageAccountKey $storageAccountKey `
    -ContainerName $containerName `
    -Name $scriptName `
    -FileName $fileName `
    -Run $fileName
