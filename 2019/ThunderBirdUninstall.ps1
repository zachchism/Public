$EXETEST = Test-path 'C:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe'
$EXERUN = 'C:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe'

function TBUninstall()
{
switch ($EXETEST) {
$true {Start-Process $EXERUN /Silent -Wait 
       }
$false{
       }
                    }
}
TBUninstall

#Start-Process 'C:\Program Files (x86)\Mozilla Thunderbird\uninstall\helper.exe' /Silent -NoNewWindow 
