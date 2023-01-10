$logonDate = (get-date).AddDays(-30)

Get-ADUser -Filter{lastLogon -le $logonDate} | export-Csv -Path "$env:USERPROFILE\Desktop\$Date`_USER_Report.csv"
