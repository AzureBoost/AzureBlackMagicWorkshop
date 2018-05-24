# Add Unmanaged Disc to VM

$resourceGroupName = "BlackMagicCGNVM"
$vmName = "VirtualMachine12"

$StorageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `                                            -Name "bmcgnstor01"

$vm = Get-AzureRMVM -ResourceGroupName $resourceGroupName `                    -Name $vmName

$DataDiscUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + "$vmName-DataDisc-1" + ".vhd"
$DataDiscUri2 = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + "$vmName-DataDisc-2" + ".vhd"

$VirtualMachine = Add-AzureRmVMDataDisk -VM $vm `                                        -Name "datadisc1" `                                        -VhdUri $DataDiscUri `                                        -CreateOption Empty `                                        -DiskSizeInGB 1023 `                                        -Lun 3

$VirtualMachine = Add-AzureRmVMDataDisk -VM $vm `                                        -Name "datadisc2" `                                        -VhdUri $DataDiscUri2 `                                        -CreateOption Empty `                                        -DiskSizeInGB 1023 `                                        -Lun 4

update-azurermvm -VM $VirtualMachine -ResourceGroupName $resourceGroupName



# Add Managed Disc to VM

$resourceGroupName = "BlackMagicCGNVM"
$vmName = "mdvm1"
$diskName = "DataDisk"
$diskSize = 1023

$localPath = "C:\Users\tillm\OneDrive\Vorträge\Azure Black Magic\BlackMagicWorkshop\BlackMagicWorkshop\"
. "$($localPath)\Functions\New-AzureRmManagedDisk.ps1"
New-AzureRmManagedDisk -diskname $diskName `
                       -diskSize $diskSize `
                       -vmName $vmName `
                       -resourceGroup $resourceGroupName `
                       -location $Location

