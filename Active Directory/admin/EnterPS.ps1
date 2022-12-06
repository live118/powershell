$ComputerName = Read-Host "IP or HostName"
#$username = Read-Host "username"
$domain = "admin1@DN"
$Cred = Get-Credential -Credential $domain

Enter-PSSession -ComputerName $ComputerName -Credential $Cred
