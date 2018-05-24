#============================================================================
#	Datei:		00 - Login.ps1
#
#	Summary:	Dieses Script demonstriert grundlegende Befehle die für die
#               Arbeit mit PowerShell und Azure notwendig sind. Es wird
#               gezeigt wie man sich per PowerShell in Azure anmeldet,
#               wie man alle Subscriptions auflistet, wie man eine Subscription
#               auswählt und wie man den aktuellen Sicherheitskontext lokal 
#               abspeichert
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

#----------------------------------------------------------------------------
# 0. Anmeldung an Azure
#----------------------------------------------------------------------------
Login-AzureRmAccount

#----------------------------------------------------------------------------
# 1. Auflisten aller Subscriptions
#----------------------------------------------------------------------------
(Get-AzureRmSubscription).Name

#----------------------------------------------------------------------------
# 2. Definieren einer speziellen Subscription
#----------------------------------------------------------------------------
$SubscriptionName = "Visual Studio Ultimate bei MSDN"

#----------------------------------------------------------------------------
# 3. Auswahl der Azure Subscription
#----------------------------------------------------------------------------
Get-AzureRmSubscription `
    -SubscriptionName $SubscriptionName | Set-AzureRmContext
#----------------------------------------------------------------------------
# 5. lokal speichern der aktuellen Sicherheitseinstellungen. 
#    Nähere Informationen unter 
#    https://docs.microsoft.com/en-us/powershell/module/azurerm.profile/save-azurermcontext?view=azurermps-6.0.0
#----------------------------------------------------------------------------
# Save-AzureRmContext `
#    -Path C:\test.json