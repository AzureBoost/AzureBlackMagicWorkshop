#============================================================================
#	Datei:		07 - Azure Metadata.ps1
#
#	Summary:	In diesem Script wird gezeigt wie man unterschiedliche
#               Azure Meta-Informationen auslesen kann um diese dann ggf.
#               in Scripten für die weitere Steuerung des Programmflusses
#               nutzen kann. Es werden folgende Informationen ausgelesen
#                   
#                 * Alle VM Größen pro Region auslesen
#                 * Alle Regionen auslesen
#                 * Alle Publisher
#                 * Alle Offers
#
#               Die ermittelten Informationen werden in separaten CSV-Dateien
#               gespeichert. 
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
# 0. Alle VM Größen pro Region auslesen
#----------------------------------------------------------------------------
Get-AzureRmVMSize `
    -Location 'West US'

#----------------------------------------------------------------------------
# 1. Erstellen eines temporären Ordners
#----------------------------------------------------------------------------
$path = "C:\Temp\"
if(!(Test-Path `
        -Path "$($path)AzureMetaData\" )) 
{ 
    New-Item `
        -ItemType directory `
        -Path "$($path)AzureMetaData\" 
}

#----------------------------------------------------------------------------
# 2. Auslesen aller Regionen
#----------------------------------------------------------------------------
# Auslesen aller Regionen
$location = Get-AzureRMLocation
# Speichern der Locations als CSV Datei
$location | Export-Csv  `
                -LiteralPath "$($path)AzureMetaData\location.csv" `
                -Delimiter ";" `
                -NoTypeInformation

#----------------------------------------------------------------------------
# 3. Schleife die alle Metainformationen ermittelt und in CSV-Dateien 
#    speichert
#----------------------------------------------------------------------------
# Schleife zum Durchlaufen aller Regionen
# Dauert sehr lange, wenn diese option aktiviert ist
#foreach ($loc in $location)
#{
    #$location = $loc.Location
    $location = "northeurope"

    # Auslesen aller VM Größen
    $vmsize = Get-AzureRmVMSize `
                -Location $location

    # Speichern der VM Größen als CSV Datei
    $vmsize | Export-Csv `
                -LiteralPath "$($path)AzureMetaData\vmsize.csv" `
                -Delimiter ";" `
                -NoTypeInformation -Append
    
    # Auslesen aller Publisher
    $publisher = Get-AzureRmVMImagePublisher `
                    -Location $location
    
    # Speichern der Publisher als CSV Datei
    $publisher | Export-Csv `
                    -LiteralPath "$($path)AzureMetaData\publisher.csv" `
                    -Delimiter ";" `
                    -NoTypeInformation `
                    -Append

    # Durchlaufen aller Publisher
    # Dauert sehr lange, wenn diese Option aktiviert ist
    #foreach ($pub in $publisher)
    #{
        #$publisherName = $pub.PublisherName
        $publisherName = "MicrosoftSQLServer"
        
        # Auslesen aller ImageOffer des Publisher
        $offer = Get-AzureRmVMImageOffer `
                    -Location $location `
                    -PublisherName $publisherName

        # Speichern der ImageOffer als CSV Datei
        $offer | Export-Csv `
                    -LiteralPath "$($path)AzureMetaData\offer.csv" `
                    -Delimiter ";" `
                    -NoTypeInformation `
                    -Append

        # Durchlaufen aller Offer
        # Dauert sehr lange wenn diese Option aktiviert ist
        #foreach ($off in $offer)
        #{
            #$offer = $off.Offer
            $offer = "SQL2017-WS2016"
            # Auslesen der möglichem ImageSKU
            $sku = Get-AzureRmVMImageSku `
                        -Location $location `
                        -PublisherName $publisherName `
                        -Offer $offer
            
                        # Speichern der ImageSKU in einer CSV Datei
            $sku | Export-Csv `
                        -LiteralPath "$($path)AzureMetaData\sku.csv" `
                        -Delimiter ";" `
                        -NoTypeInformation `
                        -Append
        #}
    #}
#}