#Author: Zachary Chism

#MUST BE RUN AS USER
#Asks for input from user, sets backup location
Write-Host $env:USERNAME

function askForInput() {
Write-Host "Do you want to backup $env:USERNAME 's files to the Z drive?"
$userInput = Read-Host -Prompt "Please Enter Y or N for Z drive backup."
$userInput = $userInput.toUpper() 

switch ($userInput) {

Y { try {

Write-Host "Copying to Z Drive" 
$script:copyDest = "Z:\BACKUP" 
New-Item -Path $CopyDest -ItemType Directory 
break} 
catch {Write-Error "$_."}
}

N {try {
Write-Host "Copying to C:\Users\$env:USERNAME\BACKUP" 
$script:copyDest = "C:\Users\$env:USERNAME\BACKUP"
New-Item -Path $CopyDest -ItemType Directory
break}
catch {Write-Error "$_."}
}
default {Write-Host "Something went wrong with the input." 
exit}

                    }

}
#Copies Desktop, documents, favorites from user's profile. 

function userFolderBackup(){
try {
Copy-Item "C:\Users\$env:USERNAME\Desktop\" -Recurse -Destination $copyDest
Copy-Item "C:\Users\$env:USERNAME\Documents\" -Recurse -Destination $copyDest
Copy-Item "C:\Users\$env:USERNAME\Favorites\" -Recurse -Destination $copyDest
 Write-Host "$copydest"
}
catch {Write-Error "$_."}
}

#Captures firefox bookmarks and passwords.
function firefoxBackup{
try {
$MozillaProfileFolder = Get-ChildItem "C:\Users\$env:USERNAME\AppData\Roaming\Mozilla\Firefox\Profiles\"| Where {$_.Extension -ceq ".default"}
 $MoProfile = $MozillaProfileFolder.name
 Write-Host "$copydest"
} 
catch {Write-Error "$_."}
try {
New-Item -Path "$copyDest\AppData\Roaming\Mozilla\Firefox\Profiles\$MoProfile" -ItemType Directory
}
catch {Write-Error "$_."}
try {
Copy-Item "C:\Users\$env:USERNAME\AppData\Roaming\Mozilla\Firefox\Profiles\$MoProfile\key4.db" -Recurse -Destination "$copyDest\AppData\Roaming\Mozilla\Firefox\Profiles\$MoProfile"
}
catch {Write-Error "$_."}
try {
Copy-Item "C:\Users\$env:USERNAME\AppData\Roaming\Mozilla\Firefox\Profiles\$MoProfile\Logins.json"  -Destination "$copyDest\AppData\Roaming\Mozilla\Firefox\Profiles\$MoProfile"
}
catch {Write-Error "$_."}
try{
Copy-Item "C:\Users\$env:USERNAME\AppData\Roaming\Mozilla\Firefox\Profiles\$MoProfile\bookmarkbackups\" -Recurse -Destination "$copyDest\AppData\Roaming\Mozilla\Firefox\Profiles\$MoProfile"
}catch {Write-Error "$_."}
}

#Captures Chrome bookmarks
function chromeBackup (){
try {
New-Item -Path "$copyDest\AppData\Local\Google\Chrome\User Data\Default\" -ItemType Directory
}
catch {Write-Error "$_."}
try{
Copy-Item "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\Bookmarks*" -Destination "$copyDest\AppData\Local\Google\Chrome\User Data\Default\"
}
catch {Write-Error "$_."}
}


#Renames backup destination folder to have today's date at the end
function dateInsert(){
$DateStringF1 = (Get-Date).ToString('dd_MM_yyyy')
try{
Rename-Item -Path "$copyDest" -NewName "Backup $DateStringF1"
}
catch {Write-Error "$_."}
}

askforInput
userFolderBackup
firefoxBackup
chromeBackup
dateInsert
