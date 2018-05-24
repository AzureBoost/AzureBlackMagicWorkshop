$localPath = "C:\Users\tillm\OneDrive\Vorträge\Azure Black Magic\BlackMagicWorkshop\BlackMagicWorkshop\"
. "$($localPath)Functions\New-AzureRmVmFromSku.ps1"

$newVm = New-AzureRmVmFromSku -vmName "mdvm1" `
                                -resourceGroupName "BlackMagicCGNVM" `
                                -user "mdvmuser" `
                                -password "<PASSWORD>" `
                                -location "northeurope"

                                #-managedDisks $true `
                                #-storageType "Standard_LRS" `
                                #-vmSize "Standard_E4_v3" `
                                #-publisherName "MicrosoftWindowsServer" `
                                #-offer "WindowsServer" `
                                #-sku "2016-Datacenter" `
                                #-version "latest"