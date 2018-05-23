# Azure PowerShell Grundlagen
# nur noch mit AzureRM-Befehlen arbeiten, d.h. die Befehle enthalten den Namen: AzureRM

# 0. lade das Azure Module
Import-Module Azure
Import-Module AzureRM

# auflisten ob das Module geladen wurde und für später in welcher Version.
Get-Module
# Tipp: definiere über jedem Skript ein Standart gegen welchen Azure-Module-Version diese Skript erstellt wurde
# bspw: Module: Azure -> 5.1.1

if ((Get-Module -FullyQualifiedName Azure).Version.Major -eq 5)
{
    Write-Output ("Ja, dies ist die Major Modul Version 5")
}


# Wie finde ich einen Befehl
Get-Command *AzureRM*VM*
Get-Command *AzureRM*Storage*

# wie finde ich heraus wie man den Befehl benutzt?
get-help New-AzureRmStorageAccount #nicht so toll :-(
get-help New-AzureRmStorageAccount -Examples # viel cooler
get-help New-AzureRmStorageAccount -Full
get-help New-AzureRmStorageAccount -Online

$resourcegroupName = "BlackMagicCGN"
$location = "North Europe"
$saName = "tecgn00"

# Erstellen einer neuen ResourceGroup
New-AzureRmResourceGroup -Name $resourcegroupName `                         -Location $location

New-AzureRmStorageAccount -ResourceGroupName $resourcegroupName `                        -AccountName "tecgn00" `
                        -Location $location `
                        -SkuName "Standard_LRS"


# Erstellen von Storages Account in einer Schleife
for($i = 1; $i -lt 10;$i++){

    $currentName = $saName + $i
    
    New-AzureRmStorageAccount -ResourceGroupName $resourcegroupName `                            -AccountName $currentName `                            -Location "northeurope" `
                            -SkuName "Standard_LRS"
}

# Löschen der Resource Group
# Remove-AzureRmResourceGroup -Name $resourcegroupName