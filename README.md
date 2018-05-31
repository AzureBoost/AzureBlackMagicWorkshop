# Azure Black Magic Workshop

In diesem Repository findet Ihr alle PowerShell Scripte und Präsentationen zu den Azure Black Magic Workshops, die im Mai 2018 von der Microsoft Deutschland GmbH in Zusammenarbeit mit der [oh22information Services GmbH](https://www.oh22.is/) und der [GDS Business Intelligence GmbH](https://www.gdsbi.de) durchgeführt worden sind. 

## Nützliche Links
In diesem Abschnitt gibt es eine Liste mit nützlichen Links die wärend des Workshops gezeigt wurden.

- [Chocolatly](https://chocolatey.org/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Azure Arm Quickstart Templates](https://github.com/Azure/azure-quickstart-templates)
- [Eine virtuelle Maschine unter Azure mit Key Vault und PowerShell erstellen](http://www.gds-business-intelligence.de/de/2018/05/19/eine-virtuelle-maschine-unter-azure-mit-key-vault-und-powershell-erstellen/)
- [Einen SQL Server 2014 aus einem Resource Manager Template in Azure über Visual Studio Team Services Deployen](http://www.gds-business-intelligence.de/de/2016/03/17/einen-sql-server-2014-aus-einem-ressource-manager-template-in-azure-ueber-visual-studio-team-services-deployen/)
- [Modulare Entwicklung von PowerShell](http://www.gds-business-intelligence.de/de/2015/06/04/modulare-entwicklung-von-powershell/)
- [Virtuelle Maschinen unter Azure automatisch starten und stoppen](http://www.gds-business-intelligence.de/de/2016/12/05/virtuelle-maschinen-unter-azure-automatisch-starten-und-stoppen/)
- [Blog von Patrick Heyde](https://blogs.technet.microsoft.com/patrick_heyde/)
- [Using PowerShell to Select physical disks for use with storage spaces](https://blogs.technet.microsoft.com/josebda/2015/02/08/using-powershell-to-select-physical-disks-for-use-with-storage-spaces/)

## Referenz der verwendeten Azure Cmdlets
In diesem Abschnitt haben wir eine Referenz der PowerShell Cmdlets zusammengestellt die wir in den Scripten verwendet haben. Über die Cmdlets kann man dann auf die entsprechende Seite der Online Hilfe kommen.

- Login-AzureRmAccount
- [Get-AzureRmSubscription](https://docs.microsoft.com/en-us/powershell/module/azurerm.profile/get-azurermsubscription?view=azurermps-6.1.0)
- [Save-AzureRmContext](https://docs.microsoft.com/en-us/powershell/module/azurerm.profile/save-azurermcontext?view=azurermps-6.1.0)
- [Import-Module](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module?view=powershell-6)
- [Get-Module](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-module?view=powershell-6)
- [Write-Output](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-output?view=powershell-6)
- [Get-Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-command?view=powershell-6)
- [Get-Help](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help?view=powershell-6)
- [New-AzureRmResourceGroup](https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermresourcegroup?view=azurermps-6.1.0)
- [New-AzureRmStorageAccount](https://docs.microsoft.com/en-us/powershell/module/azurerm.storage/new-azurermstorageaccount?view=azurermps-6.1.0)
- [Where-Object](https://technet.microsoft.com/de-de/library/ee177028.aspx)
- [Measure-Object](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/measure-object?view=powershell-6)
- [Get-AzureRmVMUsage](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/get-azurermvmusage?view=azurermps-6.1.0)
- [New-AzureStorageContainer](https://docs.microsoft.com/en-us/powershell/module/azure.storage/new-azurestoragecontainer?view=azurermps-6.1.0)
- [Read-Host](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/read-host?view=powershell-6)
- [Get-AzureRmStorageAccountKey](https://docs.microsoft.com/en-us/powershell/module/azurerm.storage/get-azurermstorageaccountkey?view=azurermps-6.1.0)
- [New-AzureStorageContext](https://docs.microsoft.com/en-us/powershell/module/azure.storage/new-azurestoragecontext?view=azurermps-6.1.0)
- [Get-AzureStorageBlob](https://docs.microsoft.com/en-us/powershell/module/azure.storage/get-azurestorageblob?view=azurermps-6.1.0)
- [Start-AzureStorageBlobCopy](https://docs.microsoft.com/en-us/powershell/module/azure.storage/start-azurestorageblobcopy?view=azurermps-6.1.0)
- [Get-AzureStorageBlobCopyState](https://docs.microsoft.com/en-us/powershell/module/azure.storage/get-azurestorageblobcopystate?view=azurermps-6.1.0)
- [Get-AzureRmVMSize](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/get-azurermvmsize?view=azurermps-6.1.0)
- [Get-AzureRMLocation](https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/get-azurermlocation?view=azurermps-6.1.0)
- [Export-Csv](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv?view=powershell-6)
- [Get-AzureRmVMImagePublisher](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/get-azurermvmimagepublisher?view=azurermps-6.1.0)
- [Get-AzureRmVMImageOffer](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/get-azurermvmimageoffer?view=azurermps-6.1.0)
- [Get-AzureRmVMImageSku](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/get-azurermvmimagesku?view=azurermps-6.1.0)
- [New-AzureRmPublicIpAddress](https://docs.microsoft.com/en-us/powershell/module/azurerm.network/new-azurermpublicipaddress?view=azurermps-6.1.0)
- [New-AzureRmVirtualNetworkSubnetConfig](https://docs.microsoft.com/en-us/powershell/module/azurerm.network/new-azurermvirtualnetworksubnetconfig?view=azurermps-6.1.0)
- [New-AzureRmVirtualNetwork](https://docs.microsoft.com/en-us/powershell/module/azurerm.network/new-azurermvirtualnetwork?view=azurermps-6.1.0)
- [New-AzureRmNetworkInterface](https://docs.microsoft.com/en-us/powershell/module/azurerm.network/new-azurermnetworkinterface?view=azurermps-6.1.0)
- [Get-Credential](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-6)
- [Set-AzureRmVMOperatingSystem](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/set-azurermvmoperatingsystem?view=azurermps-6.1.0)
- [Set-AzureRmVMSourceImage](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/set-azurermvmsourceimage?view=azurermps-6.1.0)
- [Add-AzureRmVMNetworkInterface](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/add-azurermvmnetworkinterface?view=azurermps-6.1.0)
- [Set-AzureRmVMOSDisk](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/set-azurermvmosdisk?view=azurermps-6.1.0)
- [New-AzureRmVM](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/new-azurermvm?view=azurermps-6.1.0)
- [Get-AzureRMVM](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/get-azurermvm?view=azurermps-6.1.0)
- [Add-AzureRmVMDataDisk](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/add-azurermvmdatadisk?view=azurermps-6.1.0)
- [Update-AzureRmVm](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/update-azurermvm?view=azurermps-6.1.0)
- New-AzureRmManagedDisk
- [New-AzureRmKeyVault](https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/new-azurermkeyvault?view=azurermps-6.1.0)
- [Set-AzureRmKeyVaultAccessPolicy](https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/set-azurermkeyvaultaccesspolicy?view=azurermps-6.1.0)
- [Set-AzureKeyVaultSecret](https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/set-azurekeyvaultsecret?view=azurermps-6.1.0)
- [Set-AzureRmVMCustomScriptExtension](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/set-azurermvmcustomscriptextension?view=azurermps-6.1.0)

