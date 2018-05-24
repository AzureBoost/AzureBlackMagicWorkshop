#============================================================================
#	Datei:		05 - Create-ContainerOfStorageAccounts.ps1
#
#	Summary:	In diesem Scipt wird innerhalb jedes Storage Accounts
#               jeweils ein Container angelegt der den in der Variablen
#               am Anfang definierten Namen hat.
#               Am Ende wird noch mal geschaut welche Befehle es unter
#               Azure zum Kopieren gibt. 
#               
#	Date:		2018-05-24
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
#============================================================================

#------------------------------------------------------------------------------
# 0. Definieren der Variablen
#------------------------------------------------------------------------------
# Definieren der ResourceGroup
$resourcegroupName = "BlackMagicCGN"
# Auslesen der bestehenden Storage Accounts
$storageAccounts = @(Get-AzureRmStorageAccount `
                        -ResourceGroupName $resourcegroupName)
# Definieren eines Container Namens
$containerName = "tocopy"

#------------------------------------------------------------------------------
# 1. Durchlaufen aller Storage Accounts
#------------------------------------------------------------------------------
foreach($sa in $storageAccounts){
    # Erstellen eines neuen Containers pro Storage Account
        New-AzureStorageContainer `
            -Name $containerName `
            -Permission Off `
            -Context $sa.Context
}

#------------------------------------------------------------------------------
# 2. Schauen welche Befehle es unter Azure zum Kopieren gibt
#------------------------------------------------------------------------------
Get-Command *azure*copy*