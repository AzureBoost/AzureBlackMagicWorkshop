#============================================================================
#	Datei:		09 - New-AzureRmVM2.ps1
#
#	Summary:	In diesem Script wird mit Hilfe der Funktion New-AzureRmVmFromSku
#               eine neue virtuelle Maschine angelegt. 
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
# 0. Script mit der Funktion laden
#----------------------------------------------------------------------------
$localPath = ".\"

. "$($localPath)Functions\New-AzureRmVmFromSku.ps1"

#----------------------------------------------------------------------------
# 1. Funktion zum Erstellen einer neuen Maschine anlegen
#----------------------------------------------------------------------------
New-AzureRmVmFromSku `
    -vmName "mdvm1" `
    -resourceGroupName "BlackMagicCGNVM" `
    -user "mdvmuser" `
    -password "<PASSWORD>" `
    -location "northeurope"
    # -managedDisks $true `
    # -storageType "Standard_LRS" `
    # -vmSize "Standard_E4_v3" `
    # -publisherName "MicrosoftWindowsServer" `
    # -offer "WindowsServer" `
    # -sku "2016-Datacenter" `
    # -version "latest"