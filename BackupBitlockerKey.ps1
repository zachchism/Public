 #Author: Zachary Chism
   
#Checks for TPM chip
function TPMCheck(){
$Script:TPMStatus = Get-TPM

switch ($Script:TPMStatus.TPMPresent) {
$true {$RestartCheck = Initialize-Tpm
        switch ($RestartCheck.RestartRequired) {
        $true {Write-host = "Restart is required to continue Bitlocker Process.";
        ;PAUSE;exit}
        $false{Write-Host = "Continuing Bitlocker Process.";
        ;break} 
                                                }
       } 
$false {Write-Host = "TPM Chip is not detected in this machine. Please check BIOS.";
        ;Pause;exit }
                                        }
}

#Checks to see if secondary drive is available to backup recovery key to

function driveBackupCheck(){

[String]$Global:DriveCheck = Get-SupportedFileSystems -DriveLetter D -ErrorAction SilentlyContinue
    if ($DriveCheck -like "*NTFS*" )
                                    {
    [Bool]$Script:DriveStatus = $true
                                    }
    else
                                  {
    [Bool]$Script:DriveStatus = $false
    Write-Host "WARNING: No secondary drive to save key to. Will not save key locally without secondary drive."
                                  }
}

#Asks tech for asset tag for backup
function assetInput()
{ do {
$Script:userInput = Read-Host -Prompt "What is the asset tag of the machine you are encrypting?"
$InputValue = $Script:userInput -as [Int]
$InputAccept = $InputValue -ne $null
$InputLength = $InputValue.toString().length
write-Host $InputLength


if ($InputLength -cne '6'){
Write-Host = "Asset Tag invalid length. Please input asset tag of only 6 characters."
$InputAccept = $Null}
if (-not $InputAccept) {write-host "You must enter a valid value."}
}
until ($InputAccept)
write-Host = "You entered: $InputValue"
Write-Host = "Confirmed asset tag of $Script:userInput"

}

#Bitlocker enable and key backup
function keyBackup()
{
Enable-BitLocker -MountPoint C: -RecoveryPasswordProtector -EncryptionMethod AES256 -SkipHardwareTest -UsedSpaceOnly
$BK = Get-BitLockerVolume -MountPoint "C:"
$BKey = $BK.Keyprotector[1] 
$BPass = $Bkey.RecoveryPassword
$TagAdd = "_ASSET#"
$keyName = $BKey.KeyProtectorId

#Bitlocker flavor text

$BitlockerFlavorText = "BitLocker Drive Encryption recovery key 




To verify that this is the correct recovery key, compare the start of the following identifier with the identifier value displayed on your PC.

Identifier: $keyName 

If the above identifier matches the one displayed by your PC, then use the following key to unlock your drive.

Recovery Key: $BPass

If the above identifier doesnt match the one displayed by your PC, then this isnt the right key to unlock your drive.
Try another recovery key, or refer to https://go.microsoft.com/fwlink/?LinkID=260589 for additional assistance." 

#Adds asset tag input from earlier to end of Recovery key backup
Start-Sleep -s 2
if ($Script:DriveStatus = $true)
    {
New-Item -path D:\ -Name "Bitlocker Recovery Key $keyName $TagAdd $Script:UserInput.txt" -ItemType 'File' -value $BitlockerFlavorText -ErrorAction SilentlyContinue
    }
else
    {
New-Item -path C:\ -Name "Bitlocker Recovery Key $keyName $TagAdd $Script:UserInput.txt" -ItemType 'File' -value $BitlockerFlavorText
    }

}

TPMCheck
driveBackupCheck
assetInput
keyBackup



