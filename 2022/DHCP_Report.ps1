$ServerList = "SERVERLIST"
$date = Get-Date -format "yyyy-MM-dd"
$FileName = "C:\temp\" + $date + "_MonthlyReport" + ".csv"

foreach ($Server in $ServerList){
$ScopePull = Get-DhcpServerv4Scope -ComputerName $Server | Select ScopeID,Name

    foreach ($DHCPScope in $ScopePull){

    $Tempvar = Get-DhcpServerv4OptionValue -ComputerName $Server -ScopeId $DHCPScope.ScopeId -all | select @{Name=’Name’;Expression={[string]::join(“;”, ($_.Name))}}, @{Name=’Value’;Expression={[string]::join(“;”, ($_.Value))}}
    $TempvarObject = [PSCustomObject]$TempVar

    
    $TempVarObject | Add-Member -MemberType NoteProperty -Name 'ScopeName' -Value $DHCPScope.Name -Force
    $TempVarObject | Add-Member -MemberType NoteProperty -Name 'ScopeID' -Value $DHCPScope.ScopeID -Force
    $TempVarObject | Add-Member -MemberType NoteProperty -Name 'ServerName' -Value $Server -Force


    $TempVarObject | Export-csv -Path C:\temp\export.csv -NoTypeInformation -Append
                                        }
                              }
