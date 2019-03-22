#Author: Zachary Chism

#Escalates to admin rights if not already run as admin
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}


#Checks for share drive access
function checkForGDrive()
    {
 if(Get-PSDrive G -ErrorAction SilentlyContinue)
 {
 Write-host = "G is True"
 $Global:GBool = $True
 }
 else
 {
 New-PSDrive -Name G -PSProvider filesystem -Root NETWORKDRIVE -Persist
 $Global:GBool = $True
 }
    }
 checkforGDrive
 
 function checkPreexistingFiles()
 {
 $InstallFolder = "C:\i3 Install\*"
 $Global:TestBool = Test-Path $InstallFolder -Include "*.msi"
 $TestResultVerbose = "Pre-existing Files check: " + $TestBool
 Write-Host = $TestResultVerbose
 }

 checkPreexistingFiles

 function copyFromG()
 {
    switch($testBool)
    {
    $False {
    Write-Host = "Copying files from G."
    Copy-Item 'G:\NETWORKDRIVE' -Destination 'C:\i3 Install' -Recurse
            Rename-Item 'C:\i3 Install\ICBusinessManagerApps_SU14(SU14-ES_IC-97197).msp' -NewName 'C:\i3 Install\ICBusinessManagerApps_SU14_1.msp'
            Write-Host = "Bu141 set"
            Rename-Item 'C:\i3 Install\ICBusinessManagerApps_SU14(SU14-ES_IC-98380).msp' -NewName 'C:\i3 Install\ICBusinessManagerApps_SU14_2.msp'
             Write-Host = "Bu142 set"
            Rename-Item 'C:\i3 Install\ICUserApps_SU14(SU14-ES_IC-96385).msp' -NewName 'C:\i3 Install\ICUserApps_SU14_1.msp'
             Write-Host = "Su141 set"
            Rename-Item 'C:\i3 Install\ICUserApps_SU14(SU14-ES_IC-98380).msp' -NewName 'C:\i3 Install\ICUserApps_SU14_2.msp'
             Write-Host = "Su142 set"
             Write-host = "Copy done."
            break
           }
    $True{Write-host = "Skipping copy, moving to install."
            break
          }
    }
 }
 copyFromG

function askForInput()
{
Write-Host = "Input number for what version of I3 you need installed. The only input accept is 1, 2, 3, 4, or 5."
Write-Host = "1 is for User Apps.
2 is for  Business Apps.
3 is for Server Apps.
4 is for User and Business Apps.
5 is for User, Business, and Server Apps. "
$Global:caseInput = read-host -Prompt "Which version do you wish to install?"

switch ($caseInput)
    {
    1 {Write-Host = "Installing I3 User Apps."
        break
      }

    2 {Write-Host = "Installing I3 Business Apps."
    break
      }

    3 {Write-Host = "Installing I3 Server Apps."
    break
      }
    4 {Write-Host = "Installing I3 User and Business Apps."
    break
      }
    5 {Write-Host = "Installing I3 User, Business, and Server Apps."
    break
      }

    default {Write-Host = "What you input does not match 1, 2, 3, 4, or 5. Please try again."
    askForInput
    break
            }
#Switch inputs to installer        
    }
}

function installFunction()
{
$ArgumentList = @('/passive /l*v C:\servdiallog.txt' )
#User apps and scripter
$ICUserApps_SU10 = "C:\i3 Install\ICUserApps_SU10.msi"
$ICUserApps_SU14 = "C:\i3 Install\ICUserApps_SU14.msp"
$ICUserApps_SU14_1 = "C:\i3 Install\ICUserApps_SU14_1.msp"
$ICUserApps_SU14_2 = "C:\i3 Install\ICUserApps_SU14_2.msp"
$ICUserApps_Script = "C:\i3 Install\ScripterNet_SU10.msi"
#Business Manager
$ICBusApps_SU10 = "C:\i3 Install\ICBusinessManagerApps_SU10.msi"
$ICBusApps_SU14 = "C:\i3 Install\ICBusinessManagerApps_SU14.msp"
$ICBusApps_SU14_1 = "C:\i3 Install\ICBusinessManagerApps_SU14_1.msp"
$ICBusApps_SU14_2 = "C:\i3 Install\ICBusinessManagerApps_SU14_2.msp"
$ICBusApps_Dial = "C:\i3 Install\ICBusinessManagerApps_DialerPlugins_SU10.msi"
#Server Manager
$ICServerApps_SU10 = "C:\i3 Install\ICServerManagerApps_SU10.msi"
$ICServerApps_SU14 = "C:\i3 Install\ICServerManagerApps_SU14.msp"
$ICServerApps_Dial = "C:\i3 Install\ICServerManagerApps_DialerPlugins_SU10.msi"

switch ($caseInput)
            {
#User Apps install
1 { start-process msiexec.exe -ArgumentList '/i "C:\i3 Install\ICUserApps_SU10.msi" /passive /update "C:\i3 Install\ICUserApps_SU14.msp;C:\i3 Install\ICUserApps_SU14_1.msp;C:\i3 Install\ICUserApps_SU14_2.msp" /l*v C:\I3Userlog.txt' -Wait

    }
  #Business Install
2 { start-process msiexec.exe -ArgumentList '/i "C:\i3 Install\ICBusinessManagerApps_SU10.msi" /passive /update "C:\i3 Install\ICBusinessManagerApps_SU14.msp;C:\i3 Install\ICBusinessManagerApps_SU14_1.msp;C:\i3 Install\ICBusinessManagerApps_SU14_2.msp"/l*v C:\I3Buslog.txt' -Wait
     Start-Process $ICBusApps_Dial  -ArgumentList $ArgumentList -Wait 

   }
   
   #Server Install
3  {Start-Process $ICServerApps_SU10  -ArgumentList $ArgumentList -Wait
     msiexec.exe /p $ICServerApps_SU14 /qb REINSTALLMODE="ecmus" REINSTALL="ALL"
     Write-Host = "SE14"
     start-sleep -Seconds 900    
     Start-Process $ICServerApps_Dial  -ArgumentList $ArgumentList -Wait
    }

    #User and Business
4   {start-process msiexec.exe -ArgumentList '/i "C:\i3 Install\ICUserApps_SU10.msi" /passive /update "C:\i3 Install\ICUserApps_SU14.msp;C:\i3 Install\ICUserApps_SU14_1.msp;C:\i3 Install\ICUserApps_SU14_2.msp" /l*v C:\I3Userlog.txt' -Wait

     start-process msiexec.exe -ArgumentList '/i "C:\i3 Install\ICBusinessManagerApps_SU10.msi" /passive /update "C:\i3 Install\ICBusinessManagerApps_SU14.msp;C:\i3 Install\ICBusinessManagerApps_SU14_1.msp;C:\i3 Install\ICBusinessManagerApps_SU14_2.msp" /l*v C:\I3Buslog.txt' -Wait
     Start-Process $ICBusApps_Dial  -ArgumentList $ArgumentList -Wait 
   

     }

5    #User, Business and Server Install
     {start-process msiexec.exe -ArgumentList '/i "C:\i3 Install\ICUserApps_SU10.msi" /passive /update "C:\i3 Install\ICUserApps_SU14.msp;C:\i3 Install\ICUserApps_SU14_1.msp;C:\i3 Install\ICUserApps_SU14_2.msp" /l*v C:\I3userlog.txt' -Wait

    start-process msiexec.exe -ArgumentList '/i "C:\i3 Install\ICBusinessManagerApps_SU10.msi" /passive /update "C:\i3 Install\ICBusinessManagerApps_SU14.msp;C:\i3 Install\ICBusinessManagerApps_SU14_1.msp;C:\i3 Install\ICBusinessManagerApps_SU14_2.msp" /l*v C:\I3Buslog.txt' -Wait
     Start-Process $ICBusApps_Dial  -ArgumentList $ArgumentList -Wait 

     start-process msiexec.exe -ArgumentList '/i "C:\i3 Install\ICServerManagerApps_SU10.msi" /passive /update "C:\i3 Install\ICServerManagerApps_SU14.msp"  /l*v C:\I3Servlog.txt'   
     Start-Process $ICServerApps_Dial  -ArgumentList $ArgumentList -Wait 
     }
            }
}


askForInput
#Get-Variable -Scope global
installFunction

#uninstall server working
#Start-Process -FilePath msiexec.exe -ArgumentList  @('/uninstall "{959DA3D2-0EE3-483E-B728-919D5F4CDD89}" /qn ')-wait     