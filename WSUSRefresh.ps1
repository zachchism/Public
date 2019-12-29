$LocationLong = @([LOCATIONLIST])
$LocationShort = @([LOCATIONLISTSHORT])
$ServerArray = @([SERVERARRAY])
[int]$Num = 0

foreach($Server in $ServerArray)
{
    $WSUSUpdate = Get-WsusServer -Name $ServerArray[$Num] -PortNumber 8530 | Get-WsusUpdate -Classification Security -Approval Approved -Status Any 
    $ExportList=@()
#Get all approved updates for each server in array

    foreach ($Update in $WSUSUpdate) {
    $UpdateTitle = $update.Update.Title
    [int]$ComputersNeeded = $Update.ComputersNeedingThisUpdate
    [int]$ComputersInstalled = $Update.ComputersInstalledOrNotApplicable
    [int]$ComputerError = $Update.ComputersWithErrors
    [int]$ComputerNoStatus = $Update.ComputersWithNoStatus
#Return number of pcs in each status for each update approved, per server


    [int]$ComputerCount = $ComputersNeeded + $ComputersInstalled + $ComputerError + $ComputerNoStatus
    [string]$ComputerComplete = [int](($ComputersInstalled / $ComputerCount) * 100)
    $CompleteString = $ComputerComplete + "%"
#Return Percentage of installed/notinstalled

    $Export = New-Object psObject -Property @{'Title'=$UpdateTitle; ;'Needed'=$ComputersNeeded;'Installed'=$ComputersInstalled; 'Complete' = $CompleteString }
    $Export | Add-Member -MemberType NoteProperty -name "UpdateTitle" -Value $UpdateTitle -Force 
    $Export | Add-Member -MemberType NoteProperty -name " " -Value ' ' -Force
    $Export | Add-Member -MemberType NoteProperty -name "Needed" -Value $ComputersNeeded -Force
    $Export | Add-Member -MemberType NoteProperty -name "Installed" -Value $ComputersInstalled -Force
    $Export | Add-Member -MemberType NoteProperty -name "Complete" -Value $CompleteString -Force
#Format for the CSV file about to be used for exporting data

    $ExportList += $Export
    }

      $FileName = "[FILEPATH]" + $LocationShort[$Num] + "-Report-Updates" + ".csv"
    $ExportList | select $LocationLong[$Num], Title, " ", Needed, Installed, Complete | Export-CSV -Path $Filename -NoTypeInformation
    $Num+=1
#Exports to the file, does one per server and then restarts the loop
}
