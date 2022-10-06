$getdate1 = Get-Date -Format "yyMMdd"
$edit1 = "_"
$group = "_addgrp"
New-Item D:\$getdate1$group.txt
$Exportfw = "D:\$getdate1$group.txt"
Add-Content -Path $Exportfw -Value "config firewall addrgrp"
Add-Content -Path $Exportfw "edit ahnlab_$getdate1"
Add-Content -Path $Exportfw "set member " -NoNewline

Import-Csv -Path D:\addr.csv -Header IP1 -Encoding Default | ForEach-Object {
    $ipadd1 = $_.IP1
    $getdate2 = Get-Date -Format "yyMMdd"
    Add-Content -Path $Exportfw "$getdate2$edit1$ipadd1 " -NoNewline 
}
Add-Content -Path $Exportfw "`nend"
