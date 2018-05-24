#============================================================================
#	Datei:		08 - New-AzureRMVM.ps1
#
#	Summary:	In diesem Script wird gezeigt wie man eine einfache
#               virtuelle Maschine in Azure unter PowerShell anlegen kann 
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

#----------------------------------------------------------------------------
# 0. Erstellen einer virtuellen Maschine
#----------------------------------------------------------------------------
    
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
New-AzureRmResourceGroup `
    -Name $ResourceGroupName `
    -Location $Location

#----------------------------------------------------------------------------
# Storage
#----------------------------------------------------------------------------
$StorageAccount = New-AzureRmStorageAccount `
                    -ResourceGroupName $ResourceGroupName `
                    -Name $StorageName `
                    -Type $StorageType `
                    -Location $Location
#----------------------------------------------------------------------------
# Network
#----------------------------------------------------------------------------
$PIp = New-AzureRmPublicIpAddress `
            -Name $InterfaceName `
            -ResourceGroupName $ResourceGroupName `
            -Location $Location `
            -AllocationMethod Dynamic

$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig `
                    -Name $Subnet1Name `
                    -AddressPrefix $VNetSubnetAddressPrefix

$VNet = New-AzureRmVirtualNetwork `
            -Name $VNetName `
            -ResourceGroupName $ResourceGroupName `
            -Location $Location `
            -AddressPrefix $VNetAddressPrefix `
            -Subnet $SubnetConfig

$Interface = New-AzureRmNetworkInterface `
                -Name $InterfaceName `
                -ResourceGroupName $ResourceGroupName `
                -Location $Location `
                -SubnetId $VNet.Subnets[0].Id `
                -PublicIpAddressId $PIp.Id

#----------------------------------------------------------------------------
# Compute
#----------------------------------------------------------------------------
    ## Setup local VM object
$Credential = Get-Credential
$VirtualMachine = New-AzureRmVMConfig `
                    -VMName $VMName `
                    -VMSize $VMSize

$VirtualMachine = Set-AzureRmVMOperatingSystem `
                    -VM $VirtualMachine `
                    -Windows `
                    -ComputerName $ComputerName `
                    -Credential $Credential `
                    -ProvisionVMAgent `
                    -EnableAutoUpdate

$VirtualMachine = Set-AzureRmVMSourceImage `
                    -VM $VirtualMachine `
                    -PublisherName MicrosoftWindowsServer `
                    -Offer WindowsServer `
                    -Skus 2012-R2-Datacenter `
                    -Version "latest"

$VirtualMachine = Add-AzureRmVMNetworkInterface `
                    -VM $VirtualMachine `
                    -Id $Interface.Id

$OSDiskUri = "$($StorageAccount.PrimaryEndpoints.Blob.ToString())vhds/$($OSDiskName).vhd"

$VirtualMachine = Set-AzureRmVMOSDisk `
                    -VM $VirtualMachine `
                    -Name $OSDiskName `
                    -VhdUri $OSDiskUri `
                    -CreateOption FromImage

#----------------------------------------------------------------------------
# Erstellen der VM in Azure
#----------------------------------------------------------------------------
New-AzureRmVM `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -VM $VirtualMachine