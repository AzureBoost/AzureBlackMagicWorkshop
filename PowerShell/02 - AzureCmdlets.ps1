#============================================================================
#	Datei:		02 - AzureCmdlets.ps1
#
#	Summary:	In diesem Script werden weitere PowerShell Grundlagen für 
#               Azure gezeigt. Es wird eine Variable erstellt, dann werden
#               alle Module ausgelesen die "Azure" im Namen haben. Danach
#               wird gezählt wie viele Cmdlets in den einzelnen Modulen
#               enthalten sind.  
#               behandelt. Es wird gezeigt wie man Azure-Module importiert,
#               wie man anzeigen kann ob die Module korrekt importiert worden
#               sind, wie man die Version der geladenen Azure Module abfragt,
#               wie man Befehle unter PowerShell findet, wie man Hilfe zu den
#               Befehlen bekommt. Danach wird gezeigt wie man eine Ressoucegruppe
#               und ein Speicherkonto erstellt. Außerdem wird die Gesamtzahl der
#               Azure Cmdlets angezeigt. 
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
# 0. Initialisieren einer Variable
#------------------------------------------------------------------------------
$AzureCmdlets = 0

#------------------------------------------------------------------------------
# 1. Auslesen aller Module die Azure im Namen haben
#------------------------------------------------------------------------------
$modules = Get-Module `
             -ListAvailable | Where-Object { $_.Name -like "*Azure*"}

#------------------------------------------------------------------------------
# 2. Durchlaufen aller Azure Module und zählen der dazugehörigen Cmdltes
#------------------------------------------------------------------------------
foreach ($module in $modules){
    Import-Module $module.Name
    $TmpCmdlets = Get-Command `
                    -Module $module.Name | Measure-Object
    $AzureCmdlets += $TmpCmdlets.Count
    Write-Host "Cmdlets: $($TmpCmdlets.Count)  Module: $($module.Name)"
}

#------------------------------------------------------------------------------
# 3. Anzahl der zur Verfügung stehenden Azure Cmdlets
#------------------------------------------------------------------------------
Write-Host "Total Azure cmdlets: $($AzureCmdlets)" 