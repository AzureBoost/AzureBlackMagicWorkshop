#============================================================================
#	Datei:		10 - AttachDataDiscToExistingVM.ps1
#
#	Summary:	In diesem Script wird eine unmanaged Disk an eine bereits
#               vorhandene Azure VM angehängt 
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
# 0. Unmanaged Disk manuell an eine VM hängen
#------------------------------------------------------------------------------
$resourceGroupName = "BlackMagicCGNVM"
$vmName = "VirtualMachine12"

$StorageAccount = Get-AzureRmStorageAccount `
                    -ResourceGroupName $resourceGroupName `
                    -Name "bmcgnstor01"

$vm = Get-AzureRMVM `
        -ResourceGroupName $resourceGroupName `
        -Name $vmName

$DataDiscUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + "$vmName-DataDisc-1" + ".vhd"
$DataDiscUri2 = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + "$vmName-DataDisc-2" + ".vhd"

$VirtualMachine = Add-AzureRmVMDataDisk `
                    -VM $vm `
                    -Name "datadisc1" `
                    -VhdUri $DataDiscUri `
                    -CreateOption Empty `
                    -DiskSizeInGB 1023 `
                    -Lun 3

$VirtualMachine = Add-AzureRmVMDataDisk `
                    -VM $vm `
                    -Name "datadisc2" `
                    -VhdUri $DataDiscUri2 `
                    -CreateOption Empty `
                    -DiskSizeInGB 1023 `
                    -Lun 4

Update-AzureRmVm `
    -VM $VirtualMachine `
    -ResourceGroupName $resourceGroupName

#------------------------------------------------------------------------------
# 1. Unmanaged Disk über Funktion an VM hängen
#------------------------------------------------------------------------------
$resourceGroupName = "BlackMagicCGNVM"
$vmName = "mdvm1"
$diskName = "DataDisk"
$diskSize = 1023

$localPath = ".\"
. "$($localPath)\Functions\New-AzureRmManagedDisk.ps1"
New-AzureRmManagedDisk `
    -diskname $diskName `
    -diskSize $diskSize `
    -vmName $vmName `
    -resourceGroup $resourceGroupName `
    -location $Location