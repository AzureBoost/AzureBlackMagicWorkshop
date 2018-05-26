#============================================================================
#	Datei:		11 - VM Mit Key Vault erstellen.ps1
#
#	Summary:	In diesem Script wird wieder eine virtuelle Maschine erstellt
#               In diesem Fall wird der Azure Key Vault verwendet um die
#               Informationen zum Kennwort außerhalb der virtuellen Maschine
#               zu speichern. 
#
#               ACHTUNG! Unten muss noch die GUID der eigenen Subscription 
#               und der Benutzer der berechtigt werden soll ergänzt werden. 
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
# 0. Variablen definieren
#------------------------------------------------------------------------------
 
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

## KeyVault
$keyVaultName = "azurebmwkeyvault2"

#------------------------------------------------------------------------------
# 1. Bei Azure anmelden und Subscription setzen
# ACHTUNG! Hier muss noch die Subscription-ID eingetragen werden
#------------------------------------------------------------------------------
Login-AzureRmAccount

Select-AzureRmSubscription `
    -SubscriptionId "<mysubscription>"

#------------------------------------------------------------------------------
# 2. Ressource Group anlegen
#------------------------------------------------------------------------------
New-AzureRmResourceGroup `
    -Name $ResourceGroupName `
    -Location $Location

#------------------------------------------------------------------------------
# 3. Neuen Azure Key Vault anlegen
#    Dies muss nur ein Mal gemacht werden und nicht für jede VM
#------------------------------------------------------------------------------
New-AzureRmKeyVault `
    -VaultName $keyVaultName `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location

#------------------------------------------------------------------------------
# 4. Policy für den Key Vault setzen. Damit bestimmt man wozu der Key Vault
#    genutzt werden kann. 
#------------------------------------------------------------------------------
Set-AzureRmKeyVaultAccessPolicy `
    -VaultName $keyVaultName `
    -EnabledForDeployment

#------------------------------------------------------------------------------
# 5. Benutzertzugriff festlegen. Hier wird bestimmt was welcher Benutzer
#    mit dem Key Vault machen kann.  
#------------------------------------------------------------------------------
Set-AzureRmKeyVaultAccessPolicy `
    -VaultName $keyVaultName `
    -ResourceGroupName $resourceGroupName `
    -UserPrincipalName '<user@azure.com>' `
    -PermissionsToCertificates all `
    -PermissionsToKeys all `
    -PermissionsToSecrets all

#------------------------------------------------------------------------------
# 6. Kennwort des Admins im Key Vault speichern. Das Kennwort wird über einen
#    Anmelde-Dialog eingegeben  
#------------------------------------------------------------------------------
Set-AzureKeyVaultSecret `
    -VaultName $keyVaultName `
    -Name "AdminPassword" `
    -SecretValue (Get-Credential).Password
   
#------------------------------------------------------------------------------
# 7. Storage Account anlegen  
#------------------------------------------------------------------------------
$StorageAccount = New-AzureRmStorageAccount `
                          -ResourceGroupName $ResourceGroupName `
                          -Name $StorageName `
                          -Type $StorageType `
                          -Location $Location
   
#------------------------------------------------------------------------------
# 8. Netzwerk anlegen  
#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
# 9. Vorbereitungen für die virtuelle Maschine einrichten  
#------------------------------------------------------------------------------

# Kennwort aus dem Key Vault holen
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

#------------------------------------------------------------------------------
# 10. Virtuelle Maschine anlegen  
#------------------------------------------------------------------------------
New-AzureRmVM `
    -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -VM $VirtualMachine