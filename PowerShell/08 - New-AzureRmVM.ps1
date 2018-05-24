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
New-AzureRmResourceGroup -Name $ResourceGroupName `
    
# Storage
$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
    
# Network
$PIp = New-AzureRmPublicIpAddress -Name $InterfaceName `

$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name `

$VNet = New-AzureRmVirtualNetwork -Name $VNetName `

$Interface = New-AzureRmNetworkInterface -Name $InterfaceName `

    
# Compute
    
## Setup local VM object
$Credential = Get-Credential
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName `

$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine `

$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine `

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine `

$OSDiskUri = "$($StorageAccount.PrimaryEndpoints.Blob.ToString())vhds/$($OSDiskName).vhd"

    
## Esrtellen der VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName `