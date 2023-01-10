Param(
    [array]$ServersToQuery = (hostname),
    [datetime]$StartTime = "January 1, 1970"
)

$Date = (Get-Date -Format s) -replace ":", "."
$FilePath = "C:\$Date`_ADuser.csv"

Get-ADUser -Filter * -SearchBase "OU=OU" | Where { $_.Enabled -eq $True} | Format-Table name, SamAccountName, Enabled | Out-File $FilePath
