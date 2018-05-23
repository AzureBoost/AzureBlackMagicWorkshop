#Anmeldung an Azure
Login-AzureRmAccount

#Auflisten aller Subscriptions
(Get-AzureRmSubscription).Name

#Definieren einer speziellen Subscription
$SubscriptionName = "Visual Studio Ultimate bei MSDN"

# Azure Subscription Selection
Get-AzureRmSubscription -SubscriptionName $SubscriptionName | Set-AzureRmContext

# https://docs.microsoft.com/en-us/powershell/module/azurerm.profile/save-azurermcontext?view=azurermps-6.0.0
# Save-AzureRmContext -Path C:\test.json