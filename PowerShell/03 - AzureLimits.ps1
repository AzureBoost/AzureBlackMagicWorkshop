#============================================================================
#	Datei:		03 - AzureLimits.ps1
#
#	Summary:	In diesem Script wird gezeigt wie man die Ressourcen-Limits
#               in einer Subscription und in einer bestimmten Region auslesen 
#               kann. 
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
# 0. Definieren der aktuellen Region
#------------------------------------------------------------------------------
$region = "northeurope"    

#------------------------------------------------------------------------------
# 1. Auslesen der zur Verfügung stehenden Ressourcen in der jeweiligen 
#    Subscription und Region
#------------------------------------------------------------------------------
Get-AzureRmVMUsage `
    -Location $region