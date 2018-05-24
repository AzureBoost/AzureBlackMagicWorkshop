# Alle VM Größen pro Region auslesen
Get-AzureRmVMSize -Location 'West US'

# Ersellen eines temporären Ordners
$path = "C:\Temp\"
if(!(Test-Path -Path "$($path)AzureMetaData\" )) 
{ 
    New-Item -ItemType directory `             -Path "$($path)AzureMetaData\" 
}

# Auslesen aller Regionen
$location = Get-AzureRMLocation
# Speichern der Locations als CSV Datei
$location | Export-Csv  -LiteralPath "$($path)AzureMetaData\location.csv" `                        -Delimiter ";" `                        -NoTypeInformation


# Schleife zum druchlaufen aller Regionen
# Dauert sehr lange, wenn diese option aktiviert ist
#foreach ($loc in $location)
#{
    #$location = $loc.Location
    $location = "northeurope"

    # Auslesen aller VM Größen
    $vmsize = Get-AzureRmVMSize -Location $location
    # Speichern der VM Größen als CSV Datei
    $vmsize | Export-Csv -LiteralPath "$($path)AzureMetaData\vmsize.csv" `                         -Delimiter ";" `                         -NoTypeInformation -Append
    
    # Auslesen aller Publisher
    $publisher = Get-AzureRmVMImagePublisher -Location $location
    # Speichern der Publisher als CSV Datei
    $publisher | Export-Csv -LiteralPath "$($path)AzureMetaData\publisher.csv" `                            -Delimiter ";" `                            -NoTypeInformation `                            -Append

    # Durchlaufen aller Publisher
    # Dauert sehr lange, wenn diese Option aktiviert ist
    #foreach ($pub in $publisher)
    #{
        #$publisherName = $pub.PublisherName
        $publisherName = "MicrosoftSQLServer"
        # Auslesen aller ImageOffer des Publisher
        $offer = Get-AzureRmVMImageOffer -Location $location `                                         -PublisherName $publisherName
        # Speichern der ImageOffer als CSV Datei
        $offer | Export-Csv -LiteralPath "$($path)AzureMetaData\offer.csv" `                            -Delimiter ";" `                            -NoTypeInformation `                            -Append

        # Durchlaufen aller Offer
        # Dauert sehr lange wenn diese Option aktiviert ist
        #foreach ($off in $offer)
        #{
            #$offer = $off.Offer
            $offer = "SQL2017-WS2016"
            # Auslesen der möglichem ImageSKU
            $sku = Get-AzureRmVMImageSku -Location $location `                                         -PublisherName $publisherName `                                         -Offer $offer
            # Speichern der ImageSKU in einer CSV Datei
            $sku | Export-Csv -LiteralPath "$($path)AzureMetaData\sku.csv" `                              -Delimiter ";" `                              -NoTypeInformation `                              -Append
        #}
    #}
#}