#============================================================================
#	Datei:		NewDisk.ps1
#
#	Summary:	Diese Script initialisiert eine neue Festplatte, erstellt auf ihr
#               eine neue Partition mit maximaler Größe, Formatiert die
#               Platte dann und nennt sie "Data".
#               
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
Get-Disk | Where-Object partitionstyle `
            -eq 'raw' | Initialize-Disk `
                            -PartitionStyle GPT -PassThru | New-Partition `
                                                                -AssignDriveLetter `
                                                                -UseMaximumSize | Format-Volume `
                                                                                    -FileSystem NTFS `
                                                                                    -NewFileSystemLabel "DATA" `
                                                                                    -Force