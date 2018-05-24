#============================================================================
#	Datei:		10 - VM Mit Key Vault erstellen.ps1
#
#	Summary:	In diesem Script wird wieder eine virtuelle Maschine erstellt
#               In diesem Fall wird der Azure Key Vault verwendet um die
#               Informationen zum Kennwort außerhalb der virtuellen Maschine
#               zu speichern. 
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