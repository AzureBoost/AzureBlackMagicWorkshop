# Definieren der ResourceGroup
$resourcegroupName = "BlackMagicCGN"
# Auslesen der bestehenden Storage Accounts
$storageAccounts = @(Get-AzureRmStorageAccount -ResourceGroupName $resourcegroupName )
# Definieren eines Container Namens
$containerName = "tocopy"

# Durchlaufen aller Storage Accounts
foreach($sa in $storageAccounts){
    # Erstellen eines neuen Containers pro Storage Account
    New-AzureStorageContainer -Name $containerName -Permission Off -Context $sa.Context
}

Get-Command *azure*copy*