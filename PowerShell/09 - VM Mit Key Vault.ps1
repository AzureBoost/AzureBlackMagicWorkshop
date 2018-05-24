# Example 2: Create a virtual machine with key-vault

    # Variables   

    ## Global
    $ResourceGroupName = "KeyVaultTestRS"
    $Location = "WestEurope"

    ## Storage
    $StorageName = "kvstor01"
    $StorageType = "Standard_LRS"
   
    ## Network
    $InterfaceName = "ServerInterface06"
    $VNetName = "VNet09"
    $Subnet1Name = "Subnet1"
    $VNetAddressPrefix = "10.0.0.0/16"
    $VNetSubnetAddressPrefix = "10.0.0.0/24"

    ## Compute
    $VMName = "VirtualMachine12"
    $ComputerName = "Server22"
    $VMSize = "Standard_A2"
    $OSDiskName = $VMName + "OSDisk"
    $keyVaultName = "azurebmwkeyvault2"

    # Anmelden
    Login-AzureRmAccount

    # Subscription wählen
    Select-AzureRmSubscription `
        -SubscriptionId "ec925902-1e8a-4569-9861-55a6a8c95e47"

    # Resource Group
    New-AzureRmResourceGroup `
        -Name $ResourceGroupName `
        -Location $Location

    # Azure Key Vault
    New-AzureRmKeyVault `
    -VaultName $keyVaultName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location

    # Key Vault Policy setzen
    Set-AzureRmKeyVaultAccessPolicy `
        -VaultName $keyVaultName `
        -EnabledForDeployment

   Set-AzureRmKeyVaultAccessPolicy `
        -VaultName $keyVaultName `
        -ResourceGroupName $resourceGroupName `
        -UserPrincipalName 'geislerfrank@hotmail.com' `
        -PermissionsToCertificates all `
        -PermissionsToKeys all `
        -PermissionsToSecrets all

    # Admin-Kennwort im Key Vault speichern
    Set-AzureKeyVaultSecret `
        -VaultName $keyVaultName `
        -Name "AdminPassword" `
        -SecretValue (Get-Credential).Password
   
    # Storage
    $StorageAccount = New-AzureRmStorageAccount `
                          -ResourceGroupName $ResourceGroupName `
                          -Name $StorageName `
                          -Type $StorageType `
                          -Location $Location
   
    # Network
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

    # Compute

    ## Setup local VM object
    $password = Get-AzureKeyVaultSecret `
                    -VaultName $keyvaultname `
                    -Name "AdminPassword"

    $Credential = New-Object `
                     -TypeName System.Management.Automation.PSCredential `
                     -ArgumentList ("vmadmin", $password.SecretValue)


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

    $OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"

    $VirtualMachine = Set-AzureRmVMOSDisk `
                        -VM $VirtualMachine `
                        -Name $OSDiskName `
                        -VhdUri $OSDiskUri `
                        -CreateOption FromImage

    ## Create the VM in Azure
    New-AzureRmVM `
        -ResourceGroupName $ResourceGroupName `
        -Location $Location `
        -VM $VirtualMachine