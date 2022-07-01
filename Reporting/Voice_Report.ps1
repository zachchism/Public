$VoiceServer="VOICESERVER"
$VoiceFolder= "PATH"
$RecordingExport =@()
$ServiceArray=@("SERVICES")
$date = Get-Date -format "MM/dd/yyyy"
[int]$voicenum=0
$DriveCapacityPull = Get-Volume -DriveLetter C 
#return ($DriveCapacityPull.Size)/1TB


$colItems = Get-ChildItem $VoiceFolder | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
foreach ($i in $colItems)
{
    $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    #$i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
    $FolderNameInitial = ($i.FullName).Substring(20)
         
$RecordingExport += [pscustomobject] @{
Server = $VoiceServer
"DriveCapacity (TB)" = ($DriveCapacityPull.Size)/1TB
RecordingFolder = ($FolderNameInitial).Substring(0,3).ToUpper() + ($FolderNameInitial).Substring(3)
Service=$ServiceArray[$voicenum]
"Folder Size (TB)" = "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
Date = $Date
                                        }
$voicenum++

}

$RecordingExport | Export-csv -Path C:\temp\ExportRecording.csv -NoTypeInformation
