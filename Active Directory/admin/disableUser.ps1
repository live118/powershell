$logonDate = (get-date).AddDays(-14)
Get-ADUser -Filter {lastLogon -le $logonDate} | Select-Object SamAccountName | export-Csv -Path "$env:USERPROFILE\Desktop\$Date`_USER_Report.csv"
Import-Csv -Path "$env:USERPROFILE\Desktop\$Date`_USER_Report.csv" | ForEach-Object {Set-ADUser -Identity $_.’User-Name’ -Enabled $false}
