#============================================================================
#	Datei:		06 - Copy-ArmStorageAccountContainerContent.ps1
#
#	Summary:	Dieses Script zeigt wie man alle Blobs aus einem Storage
#               Container in einen anderen Storage Container kopieren kann. 
#               Außerdem wird gezeigt wie man ein einfaches, textbasiertes
#               Menü in PowerShell aufbauen kann. 
#               
#	Date:		2018-05-24
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
#============================================================================

#------------------------------------------------------------------------------
# 0. Auslesen aller Storage Accounts
#------------------------------------------------------------------------------
$storageAccounts = @(Get-AzureRmStorageAccount)

for ($i=0; $i -lt $storageAccounts.Length; $i++){
    write-host $i " -- " $storageAccounts[$i].StorageAccountName "-" $storageAccounts[$i].Location
}

#------------------------------------------------------------------------------
# 1. Definieren des Quell Storage Account
#    Abfrage des Quell Storage Accounts vom User
#------------------------------------------------------------------------------
$storageAccountLine = Read-Host "select your Source-StorageAccount. Enter Line Number (e.g. 1)"

# Auslesen des Storage Accounts aus dem Array
$storageAccount = $storageAccounts[$storageAccountLine]
# Auslesen des Storage Account Keys
$storageAccountKeys = Get-AzureRmStorageAccountKey `
                        -Name $storageAccount.StorageAccountName `
                        -ResourceGroupName $storageAccount.ResourceGroupName

#------------------------------------------------------------------------------
# 2. Destination Storage Account
#    Eingabe des Ziel Storage Accounts vom User
#------------------------------------------------------------------------------
$targetStorageAccountLine = Read-Host "select your Target-StorageAccount. Enter Line Number (e.g. 1)"

# Auslesen des Storage Accounts aus dem Array
$targetStorageAccount = $storageAccounts[$targetStorageAccountLine]
# Auslesen des Storage Account Keys
$targetStorageAccountKeys = Get-AzureRmStorageAccountKey `
                                -Name $targetStorageAccount.StorageAccountName `
                                -ResourceGroupName $targetStorageAccount.ResourceGroupName

# Auslesen der Quellinformationen
$srcStorageAccount =  $storageAccount.StorageAccountName
$srcStorageAccountKey = $storageAccountKeys[0].Value

# Setzen des aktuellen Storage Account Context
$srcContext = New-AzureStorageContext `
                -StorageAccountName $srcStorageAccount `
                -StorageAccountKey $srcStorageAccountKey

# Auslesen der bestehenden Storage Container aus dem aktuellen Context
$sourceContainers = @(Get-AzureStorageContainer `
                        -Context $srcContext)

for ($i=0; $i -lt $sourceContainers.Length; $i++){
    write-host $i " - " $sourceContainers[$i].Name
}

#------------------------------------------------------------------------------
# 3. Eingabe des Quell Containers
#------------------------------------------------------------------------------
$srcContainerLine = Read-Host "Enter the Source-Container Line No. (e.g.0)"
$srcContainerName = $sourceContainers[$srcContainerLine].Name

#------------------------------------------------------------------------------
# 4. Auslesen der Informationen über den Ziel Container
#------------------------------------------------------------------------------
$destStorageAccount =  $targetStorageAccount.StorageAccountName
$destStorageAccountKey = $targetStorageAccountKeys[0].Value

# Setzen des Storage Context für den Ziel Storage Account
$destContext = New-AzureStorageContext `
                    -StorageAccountName $destStorageAccount `
                    -StorageAccountKey $destStorageAccountKey 

# Auslesen aller Storage Container im Ziel Storage Account
$targetContainers = @(Get-AzureStorageContainer -Context $destContext)

# Eingabe für den Ziel Container
for ($i=0; $i -lt $targetContainers.Length; $i++){
    write-host $i " - " $targetContainers[$i].Name
}
$destContainerLine = Read-Host "Enter the Target-Container Line No. (e.g.0)"
$targetContainerName = $targetContainers[$destContainerLine].Name

#------------------------------------------------------------------------------
# 5. Temp Variable für den Copy Status 
#------------------------------------------------------------------------------
$tempCopyStates = @()

#------------------------------------------------------------------------------
# 6. Kopieren aller Blobs
#------------------------------------------------------------------------------
# Liste aller Blobs die kopiert werden sollen
$allBlobs = Get-AzureStorageBlob `
                -Container $srcContainerName `
                -Context $srcContext

# Kopieren aller Blobs
foreach ($blob in $allBlobs)
{
    # Definieren einer Variable mit dem Namen und Pfad und Erstellen der URI
    $blobName = $blob.Name
    $mediaLink = "$($storageAccount.PrimaryEndpoints.Blob)$srcContainerName/$blobName"
    $targetUri = $targetStorageAccount.PrimaryEndpoints.Blob + $targetContainerName + "/" + $blobName
   
    # Kopieren des Blobs zum neuen Storage
    $tempCopyState = Start-AzureStorageBlobCopy -AbsoluteUri $mediaLink `
                                        -DestContext $destContext `
                                        -DestContainer $targetContainerName `
                                        -DestBlob $blobName `
                                        -Context $srcContext
    $tempCopyStates += $tempCopyState

    write-host "copied: $mediaLink -> $targetUri"
}

$wait = $TRUE

#------------------------------------------------------------------------------
# 7. Falls mehrer Terrabyte von einem Kontinent in einen anderen kopiert 
#    werden sollen, ist eine kleine Ausgabe während des Kopiervorgangs ganz 
#    nett
#------------------------------------------------------------------------------
while ($wait)
{
    # Warten bis die Kopier-Operationen in den neuen Container abgeschlossen 
    # sind
    foreach ($copyState in $tempCopyStates)
    {
        
        $wait = $FALSE
        $status = $copyState | Get-AzureStorageBlobCopyState
        $totalBytes = $status.TotalBytes
        $bytesCopied = $status.BytesCopied

        # Erstellen einer Status Ausgabe in Prozent
        if ($status.Status -notlike '*Success*')
        {
            $wait = $TRUE
            Start-Sleep -Seconds 5
            $name = $copyState.ICloudBlob.Name
            $percent = "{0:N0}" -f (100 / $totalBytes * $bytesCopied)
            Write-Host "$percent% $name BytesCopied: $bytesCopied"
            break
        }
    }
}