Get-ADUser -Filter * -Properties "LastLogonDate" | where-object {$_.Enabled -eq $false} | Move-ADObject -TargetPath "OU=퇴사자 ,OU=OU"
