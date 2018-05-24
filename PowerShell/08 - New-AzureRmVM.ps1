# Beispiel 1: Erstellen einer virtuellen Maschine
    
    # Variables    
    ## Global
    $ResourceGroupName = "BlackMagicCGNVM"
    $Location = "Northeurope"
    
    ## Storage
    $StorageName = "tecgnvm0"
    $StorageType = "Standard_LRS"
    
    ## Network
    $InterfaceName = "tecgnServerInterface"
    $VNetName = "tecgnVNet"
    $Subnet1Name = "tecgnSubnet"
    $VNetAddressPrefix = "10.0.0.0/16"
    $VNetSubnetAddressPrefix = "10.0.0.0/24"
    
    ## Compute
    $VMName = "tecgnVirtualMachine"
    $ComputerName = "tecgnServer"
    $VMSize = "Standard_A2"
    $OSDiskName = $VMName + "OSDisk"
    
# Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName `                        -Location $Location
    
# Storage
$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `                                    -Name $StorageName `                                    -Type $StorageType `                                    -Location $Location
    
# Network
$PIp = New-AzureRmPublicIpAddress -Name $InterfaceName `                                  -ResourceGroupName $ResourceGroupName `                                  -Location $Location `                                  -AllocationMethod Dynamic

$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name `                                                      -AddressPrefix $VNetSubnetAddressPrefix

$VNet = New-AzureRmVirtualNetwork -Name $VNetName `                                  -ResourceGroupName $ResourceGroupName `                                  -Location $Location `                                  -AddressPrefix $VNetAddressPrefix `                                  -Subnet $SubnetConfig

$Interface = New-AzureRmNetworkInterface -Name $InterfaceName `                                         -ResourceGroupName $ResourceGroupName `                                         -Location $Location `                                         -SubnetId $VNet.Subnets[0].Id `                                         -PublicIpAddressId $PIp.Id

    
# Compute
    
## Setup local VM object
$Credential = Get-Credential
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName `                                      -VMSize $VMSize

$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine `                                               -Windows `                                               -ComputerName $ComputerName `                                               -Credential $Credential `                                               -ProvisionVMAgent `                                               -EnableAutoUpdate

$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine `                                           -PublisherName MicrosoftWindowsServer `                                           -Offer WindowsServer `                                           -Skus 2012-R2-Datacenter `                                           -Version "latest"

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine `                                                -Id $Interface.Id

$OSDiskUri = "$($StorageAccount.PrimaryEndpoints.Blob.ToString())vhds/$($OSDiskName).vhd"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine `                                      -Name $OSDiskName `                                      -VhdUri $OSDiskUri `                                      -CreateOption FromImage
    
## Esrtellen der VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName `              -Location $Location `              -VM $VirtualMachine