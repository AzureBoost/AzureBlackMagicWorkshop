<#.Synopsis
	
	Creates a new Azure Resource Manager VM based on a SKU

.DESCRIPTION

	This function creates a new Azure Resource Manager VM which is based on a SKU.
    
    Azure Black Magic Workshop
    Tillmann Eitelberg
    Frank Geisler

.EXAMPLE
	
	New-AzureRmVmFromSku `
		-vmName MyVM `
		-computerName MyComputer
		-resourcegroup myrs `
		-location "North Europe"

.NOTES


#>

function New-AzureRmVmFromSku
{
	param
	(
		# This is the name of the New Azure Resource Manager VM
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$vmName,

		# This is the computer name of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=1)]
		[string]$computerName = $vmName,

		# This is the name of user of the New Azure Resource Manager VM
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=2)]
		[string]$user,

		# This is the password to the New Azure Resource Manager VM
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=3)]
		[string]$password,

		# This is the size of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=4)]
		[string]$vmSize = "Standard_A2",

		# This is the name of OSDisk of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=5)]
		[string]$managedDisks = $true,

		# This is the name of OSDisk of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=5)]
		[string]$osDiskName = $vmName + "OSDisk",

		# This is the name of resource group of the New Azure Resource Manager VM
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=6)]
		[string]$resourceGroupName,

		# This is the location of the New Azure Resource Manager VM
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=7)]
		[string]$location,

		# This is the name of the storage account of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=9)]
		[string]$storageName = $vmName + "strg",

		# This is the storage type of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=10)]
		[string]$storageType = "Standard_LRS",

		# This is the interfacename of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=11)]
		[string]$interfaceName = $vmName + "if01",

		# This is the Public IP of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=12)]
		[string]$pipName = $vmName + "pip01",

		# This is the subnet name of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=13)]
		[string]$subnet1Name = "default",

		# This is the vnet name of the New Azure Resource Manager VM
		[Parameter(Mandatory=$False, ValueFromPipelineByPropertyName=$true,Position=14)]
		[string]$vNetName = "Vnet01",

		# This is the vnet name of the New Azure Resource Manager VM
		[Parameter(Mandatory=$False, ValueFromPipelineByPropertyName=$true,Position=14)]
		[string]$vNetResourceGroupName = $resourceGroupName,

		# This is the vnet address prefix of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=15)]
		[string]$vNetAddressPrefix = "10.0.0.0/16",

		# This is the vnet subnet address prefix of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=16)]
		[string]$vNetSubnetAddressPrefix = "10.0.0.0/24",

		# This is the publisher name of the SKU
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=17)]
		[string]$publisherName = "MicrosoftWindowsServer",

		# This is the offer of the SKU
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=18)]
		[string]$offer = "WindowsServer",

		# This is the sku name
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=19)]
		[string]$skus = "2012-R2-Datacenter",

		# This is the version of sku
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=20)]
		[string]$version = "latest",

		# This is the IP address the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=17)]
		[string]$ipAddress,

        # This is the IP address Type of the New Azure Resource Manager VM
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=18)]
		[string]$ipAddressType = "static"
	)

	$secPassword = ConvertTo-SecureString $password -AsPlainText -Force 

	# Resource Group
    $resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName `
											-Location $Location `
											-ErrorAction SilentlyContinue
    	
    if(!$resourceGroup){
            $resourceGroup = New-AzureRmResourceGroup -Name $ResourceGroupName `                                                      -Location $Location;
    }

	# Storage

	if(!$managedDisks)
	{
		$StorageAccount = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
							-Name $StorageName `                            -ErrorAction SilentlyContinue;

		if( !$StorageAccount ){
			 $StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
								                         -Name $StorageName `                                                         -Type $StorageType `                                                         -Location $Location;
		}
	}

	# Network
	$PIp = Get-AzureRmPublicIpAddress -Name $pipName `
			                          -ResourceGroupName $ResourceGroupName `                                       -ErrorAction SilentlyContinue;
    
    if ( !$PIp ){
	    $PIp = New-AzureRmPublicIpAddress -Name $pipName `
			    -ResourceGroupName $ResourceGroupName `
			    -Location $Location `
			    -AllocationMethod Dynamic;
    }

    # Virtual Network definition
    $VNet = Get-AzureRmVirtualNetwork -Name $VNetName `
									  -ResourceGroupName $vNetResourceGroupName `
									  -ErrorAction SilentlyContinue;

    if(!$VNet){
    
    	$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet1Name `
					-AddressPrefix $VNetSubnetAddressPrefix;


        $VNet = New-AzureRmVirtualNetwork -Name $VNetName `
			                                -ResourceGroupName $VNetResourceGroupName `
			                                -Location $Location `
			                                -AddressPrefix $VNetAddressPrefix `
			                                -Subnet $SubnetConfig;
    }
    else{
        $SubnetConfig = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNet `
                                                        -Name $Subnet1Name;    
    }

	$Interface = New-AzureRmNetworkInterface -Name $InterfaceName `
					-ResourceGroupName $ResourceGroupName `
					-Location $Location `
					-SubnetId $VNet.Subnets[0].Id `
					-PublicIpAddressId $PIp.Id


	## Setup local VM object
	$Credential = New-Object System.Management.Automation.PSCredential ($user, $secPassword)

    $VirtualMachine = Get-AzureRmVM -Name $vmName `
					-ResourceGroupName $resourceGroupName `
					-ErrorAction SilentlyContinue;

    if( !$VirtualMachine ){

		$VirtualMachine = New-AzureRmVMConfig -VMName $VMName `
								-VMSize $VMSize
		
        Write-Host "Set-AzureRmVMOperatingSystem "
	    $VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine `
						    -Windows `
						    -ComputerName $ComputerName `
						    -Credential $Credential `
						    -ProvisionVMAgent;

        Write-Host "Set-AzureRmVMSourceImage "
	    $VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine `
						    -PublisherName $publisherName `
						    -Offer $offer `
						    -Skus $skus `
						    -Version $version;
                     
        Write-Host "Add-AzureRmVMNetworkInterface "
	    $VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine `
						    -Id $Interface.Id

		if(!$managedDisks)
		{
			$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
		
			Write-Host "Set-AzureRmVMOSDisk "
			$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine `
								-Name $OSDiskName `
								-VhdUri $OSDiskUri `
								-CreateOption FromImage
		}

		Write-Host "New-AzureRmVM "
	    New-AzureRmVM -ResourceGroupName $ResourceGroupName `
					    -Location $Location `
					    -VM $VirtualMachine;

		#if($ipAddress) 
		#{		
		#	$nic = Get-AzureRmNetworkInterface -Name $interfaceName `
		#						-ResourceGroupName $resourceGroupName
		#	$nic.IpConfigurations[0].PrivateIpAllocationMethod = $ipAddressType
		#	$nic.IpConfigurations[0].PrivateIpAddress = $ipAddress
		#	Set-AzureRmNetworkInterface -NetworkInterface $nic
		#}

    }
}