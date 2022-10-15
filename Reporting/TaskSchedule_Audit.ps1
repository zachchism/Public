$TaskList = Get-ScheduledTask -TaskName * | Where-object {$_.Author -eq '[USERNAME]'}
$ExportList=@()

Foreach ($task in $TaskList) {
$TaskDetails = Get-ScheduledTaskInfo -InputObject $Task
write-output $Task | Format-Table -Property TaskName, Author, Description

#Assign var
$TaskAuthor = $task.Author
$TaskTitle = $Task.TaskName
$TaskDescription = $Task.Description
$TaskLastRun = $TaskDetails.LastRunTime
$TaskLastResult = $TaskDetails.LastTaskResult
$TaskNextRun = $TaskDetails.NextRunTime
$TaskMissed = $TaskDetails.NumberOfMissedRuns

#Object creation
$Export = New-Object psObject -Property @{'TaskAuthor'=$TaskAuthor; 'TaskTitle' = $TaskTitle; 'TaskDescription' = $TaskDescription; 'LastRunTime' = $TaskLastRun;`
'LastRunResult' = $TaskLastResult; 'TaskNextRun' = $TaskNextRun; 'MissedRuns' = $TaskMissed}

#Export member add from properties
$Export | Add-Member -MemberType NoteProperty -name "TaskAuthor" -Value $TaskAuthor -Force
$Export | Add-member -MemberType NoteProperty -name "TaskTitle" -Value $TaskTitle -Force
$Export | Add-Member -MemberType NoteProperty -Name "TaskDescription" -Value $TaskDescription -force
$Export | Add-Member -MemberType NoteProperty -Name "LastRunTime" -Value $TaskLastRun -Force
$Export | Add-Member -MemberType NoteProperty -Name "LastRunResult" -Value $TaskLastResult -Force
$Export | Add-member -MemberType NoteProperty -Name "TaskNextRun" -Value $TaskNextRun -Force
$Export | Add-Member -MemberType NoteProperty -Name "MissedRuns" -Value $TaskMissed -Force


#Add members to final ExportList
$ExportList += $Export
}


$ExportList | select TaskAuthor, TaskTitle, TaskDescription, LastRunTime, LastRunResult, TaskNextRun, MissedRuns | Export-CSV -Path '[FILEPATH]' -NoTypeInformation



