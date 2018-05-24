#============================================================================
#	Datei:		01 - Azure Basics.ps1
#
#	Summary:	In diesem Script werden PowerShell Grundlagen für Azure 
#               behandelt. Es wird gezeigt wie man Azure-Module importiert,
#               wie man anzeigen kann ob die Module korrekt importiert worden
#               sind, wie man die Version der geladenen Azure Module abfragt,
#               wie man Befehle unter PowerShell findet, wie man Hilfe zu den
#               Befehlen bekommt. Danach wird gezeigt wie man eine Ressoucegruppe
#               und ein Speicherkonto erstellt.  
#               
#               Tipp: nur noch mit AzureRM-Befehlen arbeiten, d.h. die Befehle 
#                     enthalten im Namen den Text "AzureRM". Bei den Befehlen 
#                     handelt es sich um Befehle die das neue Azure 
#                     Breitstellungsmodell "Resource Manager" verwenden. 
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

#----------------------------------------------------------------------------
# 0. lade die Azure Module
#----------------------------------------------------------------------------
Import-Module Azure
Import-Module AzureRM

#----------------------------------------------------------------------------
# 1. auflisten ob die Module geladen wurden und für später in welcher Version.
#    Tipp: definiere über jedem Skript ein Standart für welchen Azure-Module-Version 
#          diese Skript erstellt wurde, z.B.: Module: Azure -> 5.1.1
#----------------------------------------------------------------------------
Get-Module

if ((Get-Module -FullyQualifiedName Azure).Version.Major -eq 5)
{
    Write-Output ("Ja, dies ist die Major Modul Version 5")
}


#----------------------------------------------------------------------------
# 2. Wie finde ich einen Befehl?
#----------------------------------------------------------------------------
Get-Command *AzureRM*VM*
Get-Command *AzureRM*Storage*

#----------------------------------------------------------------------------
# 3. Wie finde ich heraus wie man den Befehl benutzt?
#----------------------------------------------------------------------------
Get-Help New-AzureRmStorageAccount #nicht so toll :-(
Get-Help New-AzureRmStorageAccount -Examples # viel cooler, zeigt Beispiele
Get-Help New-AzureRmStorageAccount -Full
Get-Help New-AzureRmStorageAccount -Online

#----------------------------------------------------------------------------
# 4. Erstellen einer neuen ResourceGroup
#----------------------------------------------------------------------------
$resourcegroupName = "BlackMagicCGN"
$location = "North Europe"
$saName = "tecgn00"

New-AzureRmResourceGroup `
    -Name $resourcegroupName `
    -Location $location

#----------------------------------------------------------------------------
# 5. Erstellen eines einzelnen Storage Accounts
#----------------------------------------------------------------------------
New-AzureRmStorageAccount `
    -ResourceGroupName $resourcegroupName `
    -AccountName "tecgn00" `
    -Location $location `
    -SkuName "Standard_LRS"

#----------------------------------------------------------------------------
# 6. Erstellen von Storages Account in einer Schleife
#----------------------------------------------------------------------------
for($i = 1; $i -lt 10;$i++){

    $currentName = $saName + $i
    
    New-AzureRmStorageAccount `
        -ResourceGroupName $resourcegroupName `
        -AccountName $currentName `
        -Location "northeurope" `
        -SkuName "Standard_LRS"
}

#----------------------------------------------------------------------------
# 7. Löschen der Resource Group
#----------------------------------------------------------------------------
# Remove-AzureRmResourceGroup -Name $resourcegroupName