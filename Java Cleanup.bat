wmic product where (Name like 'Java _ Update%%' OR Name like 'Java_TM_ _ Update%%' AND NOT Name Like 'Java 8 Update 191 _64-bit_') call uninstall /nointeractive

Start /wait \\SCCMSERVER\jre-8u191-windows-x64.exe /s
