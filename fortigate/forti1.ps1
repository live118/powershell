
$getdate1 = Get-Date -Format "yyMMdd"
$subnet1 = "/32"
$subnet2 = "set subnet "
$edit1 = "_"
$ahnlab = "_ahnlab"
New-Item D:\$getdate1$ahnlab.txt
$Exportfw = "D:\$getdate1$ahnlab.txt" #경로에 변수 추가 건 쌍따옴표
Add-Content -Path $Exportfw -Value "config firewall address"

Import-Csv -Path D:\addr.csv -Header IP1 -Encoding Default | ForEach-Object {
    $ipadd1 = $_.IP1
    $getdate2 = Get-Date -Format "yyMMdd"
    Add-Content -Path $Exportfw -Value "edit $getdate2$edit1$ipadd1"
    Add-Content -Path $Exportfw "set type ipmask"
    Add-Content -Path $Exportfw "$subnet2$ipadd1$subnet1"
    Add-Content -Path $Exportfw "set associated-interface OUTSIDE"
    Add-Content -Path $Exportfw "next"
}
Add-Content -Path $Exportfw "end"
