#Get Current Directory from Batch
$scriptpath = $args[0]
$scriptpath.length

#CSV Import Path
$CSVImportPath = ("$scriptpath").Substring(0, $scriptpath.length -1) + '\Import.csv'
$CSVImport = Import-Csv -Path $CSVImportPath -Delimiter ','

#Array Inits
$CSVImportObject =@()
$CMDSKBList = @()
$WindowsKBList = @()
$CSVExportActual = @()
$CSVExportSummaryObject = @()
$tempvarExport = @()

#CSV Export Paths
$CSVExportActualPath = ("$scriptpath").Substring(0, $scriptpath.length -1) + '\' + $PemaName + '_CSVExportActual.csv'
$CSVExportSummaryPath = ("$scriptpath").Substring(0, $scriptpath.length -1) + '\' + $PemaName + '_CSVExportSummary.csv'

$CSVImportObject += [pscustomobject] @{ 
TestCurrentBaseVersion = $CSVImport.CurrentBaseSystemVersion
TestSoftwareAVersion = $CSVImport.SoftwareAVersionCMDS
TestKB = $CSVImport.MicrosoftKBCMDS
TestWinDef = $CSVImport.WinDefSignatureCMDS
TestSoftwareBVersion = $CSVImport.SoftwareB
TestSoftwareC = $CSVImport.SoftwareC
TestSoftwareD = $CSVImport.SoftwareD
}

#CMDS Pull
$CMDReport = 'D:\CMDS\Reports\' + hostname + ' CMDS Report.xml'
[xml]$CMDReportPull = Get-content -Path $CMDReport
$CMDSBASE = $CMDReportPull.report
$CMDSComponents = $CMDReportPull.report.components.Component


#CMDS CHECK
#SYSTEM VERSION
foreach ($CSVValue in $CSVImportObject.TestCurrentBaseVersion){
    if ($CMDSBASE.'current-system-version' -eq $CSVValue){
        Write-Output "$CSVValue Current Base Version equal to Test Value"
        $CMDSBaseResultActual = $CMDSBASE.'current-system-version'
    }
    elseif($CMDSBASE.'current-system-version' -ne $CSVValue -and $CSVValue -ne ""){
        Write-Output "$CSVValue Current Base Version NOT equal to Test Value"
        $CMDSBaseResultActual = $CMDSBASE.'current-system-version'
    }
                                                                }                                                                        
foreach ($Component in $CMDSComponents){
    #SoftwareA
    if ($Component.Name -eq 'Microsoft SoftwareA'){
        foreach ($CSVValue in $CSVImportObject.TestSoftwareAVersion ){
        if ($Component.'current-version' -eq $CSVValue){
            Write-Output "CMDS equal to Test Value"
            $CMDSSoftwareAResultActual = $Component.'current-version'
            $CMDSSoftwareAResultBool = $True
                                                        }
        elseif($Component.'current-version' -ne $CSVValue -and $CSVValue -ne "" ){
            Write-Output "CMDS NOT equal to Test Value"
            $CMDSSoftwareAResultActual = $Component.'current-version'
            $CMDSSoftwareAResultBool = $False
        }
                                                                }
                                            }
    #SoftwareB
    if ($Component.Name -eq 'SoftwareB'){
        foreach ($CSVValue in $CSVImportObject.TestSoftwareBVersion ){
        if ($Component.'current-version' -eq $CSVValue){
            Write-Output "CMDS equal to Test Value"
            $CMDSSoftwareBResultActual = $Component.'current-version'
                                                        }
        elseif($Component.'current-version' -ne $CSVValue -and $CSVValue -ne "" ){
            Write-Output "CMDS NOT equal to Test Value"
            $CMDSSoftwareBResultActual = $Component.'current-version'
        }
                                                                }
                                            }
    #SoftwareC
    if ($Component.Name -eq 'SoftwareC Agent'){
        foreach ($CSVValue in $CSVImportObject.TestSoftwareC ){
        if ($Component.'current-version' -match $CSVValue){
            Write-Output "CMDS equal to Test Value"
            $CMDSSoftwareCResultActual = $Component.'current-version'
            $CMDSSoftwareCResultValue = $True
        #Write-output "$Component.'current-version' + "equal to" + $CSVValue"
                                                        }
        elseif($Component.'current-version' -ne $CSVValue -and $CSVValue -ne "" ){
            Write-Output "CMDS NOT equal to Test Value"
            $CMDSSoftwareCResultActual = $Component.'current-version'
            $CMDSSoftwareCResultValue = $False
        }
        elseif($CSVValue -eq "" -or $null -eq $CSVValue){
            Write-Output "CMDS NOT equal to Test Value"
            $CMDSSoftwareCResultActual = 'N/A'
            $CMDSSoftwareCResultValue = 'N/A'
            }
                                                                }
                                            }                                                                                                       
    #SoftwareD                                                                                                
    if ($Component.Name -eq 'SoftwareD (vApp)'){
        foreach ($CSVValue in $CSVImportObject.TestSoftwareD ){
        if ($Component.'current-version' -eq $CSVValue){
            Write-Output "CMDS equal to Test Value"
            $CMDSSoftwareDResultActual = $Component.'current-version'
            $CMDSSoftwareDResultBool = $true
    }
    elseif($Component.'current-version' -ne $CSVValue -and $CSVValue -ne "" ){
        Write-Output "CMDS NOT equal to Test Value"
        $CMDSSoftwareDResultActual = $Component.'current-version'
        $CMDSSoftwareDResultBool = $false
    }
                                                    }
                                            }                                         
    #WINDEF                                        
    if  ($Component.name -eq 'Windows Defender Signatures'){
        foreach ($CSVValue in $CSVImportObject.TestWinDef ){
            if ($Component.'current-version' -eq $CSVValue){
            $CMDSWinDefResultActual = $Component.'current-version'
            $CMDSWinDefResultBool = $True
            Write-Output "$CMDSWinDefResultActual equal to Test Value, $CMDSWinDefResultBool"
        }
        elseif($Component.'current-version' -ne $CSVValue -and $CSVValue -ne ""){
            $CMDSWinDefResultActual = $Component.'current-version'
            $CMDSWinDefResultBool = $False
            Write-Output "$CMDSWinDefResultActual NOT equal to Test Value, $CMDSWinDefResultBool"
        }
    }                                      
                                        }
    if ($Component.type -eq 'IAVA' -and $Component.name -match '-KB'){
        foreach ($CSVValue in $CSVImportObject.TestKB){
            if ($Component.Name -match $CSVValue){
                Write-Output $Component.Name
                $CMDSKBList += $Component.Name
        }
    }
    Write-Output $CMDSKBList
                                    }
                                }



#WINDOWS CHECK
#SoftwareA
$SoftwareAPath=  "C:\SoftwareA.exe"
$WindowsVersionSoftwareA = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($SoftwareAPath).FileVersion
foreach ($CSVValue in $CSVImportObject.TestSoftwareAVersion){
    if ($CSVValue -eq $WindowsVersionSoftwareA){
        $WindowsVersionSoftwareABool = $True
    }
    elseif ($CSVValue -ne $WindowsVersionSoftwareA -and $CSVValue -ne ""){
        $WindowsVersionSoftwareABool = $False
                                                                    }
}
#SoftwareB
$SoftwareBPath = "C:\SoftwareB.exe"
$WindowsVersionSoftwareB = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($SoftwareBPath).FileVersion

#SoftwareC
$SoftwareCPath = "C:\SoftwareC.exe"
if (Test-path -Path $SoftwareCPath){
    $WindowsVersionSoftwareC = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($SoftwareCPath).FileVersion
    foreach ($CSVValue in $CSVImportObject.TestSoftwareC[0]){
        if ($CSVValue -eq $WindowsVersionSoftwareC){
            $WindowsVersionSoftwareCValue = $True
        }
        elseif ($CSVValue -ne $WindowsVersionSoftwareC -and $CSVValue -ne ""){
            $WindowsVersionSoftwareCValue = $False
                                                                        }
        elseif ("" -eq $CSVValue){
            $WindowsVersionSoftwareCValue = 'N/A'
        }
                                                            }
    }else{
        $WindowsVersionSoftwareC = 'N/A'
        $WindowsVersionSoftwareCValue = 'N/A'
    }
#SoftwareD
$SoftwareDPath = "D:\SoftwareD.exe"
if (Test-path -Path $SoftwareDPath){
$WindowsVersionSoftwareD = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($SoftwareDPath).FileVersion
foreach ($CSVValue in $CSVImportObject.TestSoftwareD[0]){
    if ($CSVValue -eq $WindowsVersionSoftwareD){
        $WindowsVersionSoftwareDValue = $True
    }
    elseif ($CSVValue -ne $WindowsVersionSoftwareD -and $CSVValue -ne ""){
        $WindowsVersionSoftwareDValue = $False
                                                                    }
    elseif ("" -eq $CSVValue){
        $WindowsVersionSoftwareDValue = 'N/A'
    }
                                                }
}else{
    $WindowsVersionSoftwareD = 'N/A'
    $WindowsVersionSoftwareDValue = 'N/A'
}
#KBs
$KBInstalledList = (get-wmiobject -class win32_quickfixengineering).HotFixID
foreach ($KBInstalled in $KBInstalledList){
    foreach ($CSVValue in $CSVImportObject.TestKB ){
        if ($CSVValue -eq $KBInstalled){
            $WindowsKBList += $CSVValue
                                        }
                                                }
}
#WINDEF
$WindowsVersionDEF = (Get-MpComputerStatus).AntivirusSignatureVersion
foreach ($CSVValue in $CSVImportObject.TestWinDef){
    if ($CSVValue -eq $WindowsVersionDEF){
        Write-Output "$CSVValue windows defender version"
    $WindowsVersionDEFBool = $True
    }
    elseif ($CSVValue -ne $WindowsVersionDEF -and $CSVValue -ne ""){
        $WindowsVersionDEFBool = $False
}
}
#BANNER
$BannerValueRaw = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\NetBanner\' -name CustomDisplayText
$BannerValueRaw.Length
$BannerVersion = $BannerValueRaw.substring(16,$BannerValueRaw.Length - 16)

#ACTIVATION
Start-Process -FilePath 'C:\windows\System32\slmgr' -ArgumentList '/dli'

#CSVEXPORT
#CSV Actual Values Export
$CSVExportActual += [pscustomobject]@{
    CurrentBaseSystemVersion = $CMDSBaseResultActual
    VersionBanner = $BannerVersion
    SoftwareAVersionCMDS = $CMDSSoftwareAResultActual
    SoftwareAVersionWindows = $WindowsVersionSoftwareA
    MicrosoftKBCMDS = ($CMDSKBList) -join ", "
    MicrosoftKBWindows = ($WindowsKBList) -join ", "
    WinDefSignatureCMDS = $CMDSWinDefResultActual
    WinDefSignatureWindows = $WindowsVersionDEF
    SoftwareBVersionCMDS = $CMDSSoftwareBResultActual
    SoftwareBVersionWindows = $WindowsVersionSoftwareB
    SoftwareCVersionCMDS = $CMDSSoftwareCResultActual
    SoftwareCVersionWindows = $WindowsVersionSoftwareC
    SoftwareDVersionCMDS = $CMDSSoftwareDResultActual
    SoftwareDVersionWindows = $WindowsVersionSoftwareD
}
$CSVExportActual | Export-csv -Path $CSVExportActualPath  -NoTypeInformation

#CSV Summary Merge
$Loops = 0..1
$SideList = "CMDS","Windows"
$SideVersionList = "$CMDSBaseResultActual", "$BannerVersion"
$SideSoftwareAList = "$CMDSSoftwareAResultBool", "$WindowsVersionSoftwareABool"
$SideKBList = "$CMDSKBList", "$WindowsKBList"
$SideWinDefList = "$CMDSWinDefResultBool", "$WindowsVersionDEFBool"
$SideSoftwareBList = "$CMDSSoftwareBResultActual", "$WindowsVersionSoftwareB"
$SideSoftwareCList = "$CMDSSoftwareCResultValue", "$WindowsVersionSoftwareCValue"
$SideSoftwareDList = "$CMDSSoftwareDResultBool", "$WindowsVersionSoftwareDValue"


#CSV Bool Values Export
foreach($i in $loops){
Write-output $i
$CSVExportSummaryObject = new-object PSObject
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'Side' -Value $SideList[$i] -Force
Write-output $SideList[$i]
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'Version' -Value $SideVersionList[$i] -Force
Write-output $SideVersionList[$i]
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'SoftwareA' -Value $SideSoftwareAList[$i] -Force
Write-output $SideSoftwareAList[$i]
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'KBs' -Value $SideKBList[$i] -Force
Write-output $SideKBList[$i]
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'WinDef' -Value $SideWinDefList[$i] -Force
Write-output $SideWinDefList[$i]
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'SoftwareB' -Value $SideSoftwareBList[$i] -Force
Write-output $SideSoftwareBList[$i]
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'SoftwareC' -Value $SideSoftwareCList[$i] -Force
Write-output $SideSoftwareCList[$i]
$CSVExportSummaryObject | Add-Member -MemberType NoteProperty -Name 'SoftwareD' -Value $SideSoftwareDList[$i] -Force
Write-output $SideSoftwareDList[$i]
$CSVExportSummary += $CSVExportSummaryObject
}
#Remove CSV Export if exists, otherwise this will append ontop
if(test-path $CSVExportSummaryPath){
Remove-Item -Path $CSVExportSummaryPath
}
$CSVExportSummary | Export-csv -Path $CSVExportSummaryPath -NoTypeInformation -Append



