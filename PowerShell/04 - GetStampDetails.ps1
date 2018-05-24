#============================================================================
#	Datei:		04 - GetStampDetails.ps1
#
#	Summary:	Legt man ein Storage Account an, dann wird dieser physikalisch
#               auf einem sogenannten "Stamp" angelegt. Wenn man mit unmanaged
#               Disks arbeitet (was man nicht mehr machen sollte), dann kann 
#               es passieren dass alle Storage Accounts die man nutzt auf einem
#               einzelnen Stamp angelegt werden. Gerade im Zusammenhang mit
#               Verfügbarkeitsgruppen ist dies problematisch da im Fall des 
#               Ausfalls eines Stamps die Platten aller VMs innerhalb der
#               Verfügbarkeitsgruppe ausfallen und somit keine der 
#               Maschinen zur Verfügung steht. Daher zeigt dieses Script wie
#               man auslesen kann welcher Storage Account auf welchem Stamp liegt
#               (über die IP-Adresse). 
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
# 0. Definieren von loaken Variablen
#------------------------------------------------------------------------------
# Name des Storage Accounts Präfix
$basename = "tecgn00"

# Name der ResourceGroup
$resourceGroupName = "BlackMagicCGN"

# Auslesen aller Storage Accounts in der ResourceGroup
$storages = @(Get-AzureRmStorageAccount `
                    -ResourceGroupName $resourceGroupName)

# Anlegen einer HashTable
$StampIpList = @{}

#------------------------------------------------------------------------------
# 1. Prüfen ob ein StorageAccount bereits existiert. SilentlyContinue verhindert 
#    Fehlermeldungen, wenn der StorageAccount noch nicht existiert. Hat aber
#    den Nachteil, dass sämtliche Fehlermeldungen (auch z.B. nicht angemeldet an 
#    Azure) unterdrückt werden.
#------------------------------------------------------------------------------
# $a = Get-AzureRmStorageAccount `
#     -ResourceGroupName $resourceGroupName `
#     -Name "testorcgn04" `
#     -ErrorAction SilentlyContinue

#------------------------------------------------------------------------------
# 2. Durchlaufen alle Storage Account
#------------------------------------------------------------------------------
foreach ($store in $storages)
{
    #Prüfen ob der Storage Account den Präfix beinhaltet
    if ($store.StorageAccountName -like "$($basename)*") 
    { 
        # Erstellen der URL zum Storage Account
        $blobUrl = "$($store.StorageAccountName).blob.core.windows.net"
        # DNS Lookup über die URL
        $dnslookup = [System.Net.Dns]::GetHostAddresses($blobUrl)
        # Auslesen der IP Adresse
        $stampIp = $dnslookup.IPAddressToString
        #Hinzufügen der IP Adressen in das Array
        $StampIpList[$store.StorageAccountName] += @($stampIp) #$blobUrl
    }
 }
 
$result = ($StampIpList.GetEnumerator() | Sort-Object Value)

# Ausgabe des Ergebnisses
Write-Output $result