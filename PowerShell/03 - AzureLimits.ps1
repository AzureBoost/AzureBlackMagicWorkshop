# Definieren der aktuellen Region
$region = "northeurope"    

# Auslesen der zur Verfügung stehenden Ressourcen in der jeweiligen Subscription und Region
Get-AzureRmVMUsage -Location $region