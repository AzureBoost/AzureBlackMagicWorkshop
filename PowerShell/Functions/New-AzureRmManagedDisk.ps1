<#.Synopsis
	
	Creates a new Azure RM Managed Disk

.DESCRIPTION

	This function creates a new Azure RM Managed Disk.
    
    Azure Black Magic Workshop
    Tillmann Eitelberg
    Frank Geisler

.EXAMPLE
	
	New-AzureRmManagedDisk

.NOTES


#>

function New-AzureRmManagedDisk
{
	param
	(
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$diskName,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$vmName,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$resourceGroup,

		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$location,
	
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$diskSize = "128",

		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$createOption = "Empty",
	
		[Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=0)]
		[string]$accountType = "Standard_LRS"
	)

	# Create a GUID	
	$guid = (([guid]::NewGuid()).ToString()).Replace("-","")

	# Get the VM
	$vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $resourceGroup 

	# Get the maximum Lun
	$lun = $vm.StorageProfile.DataDisks | Measure-Object -Property Lun -Maximum
	$nextLun = $lun.Maximum + 1
	$dataDiskName = "$($vmName)_$($diskName)_$($guid)"

	Write-Host "New-AzureRmDiskConfig "
	$diskConfig = New-AzureRmDiskConfig -Location $location `
						-DiskSizeGB $diskSize `
						-Sku $accountType `
						-CreateOption $createOption `
						-EncryptionSettingsEnabled $encryption `
						-Verbose

	Write-Host "New-AzureRmDisk "
	$dataDisk = New-AzureRmDisk -DiskName $dataDiskName `
								 -Disk $diskConfig `
								 -ResourceGroupName $resourceGroup `
								 -Verbose

	Write-Host "Add-AzureRmVMDataDisk "
	$vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun $nextLun

	Write-Host "Update-AzureRmVM "
	Update-AzureRmVM -VM $vm -ResourceGroupName $resourceGroup
}