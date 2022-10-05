Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'add-localadmin'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Input Active Directory ID :'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)
$msg = New-Object -ComObject WScript.Shell
$dns = 'Domain NAME' #input Domain Name
$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()
$edition = Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption 

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $textBox.text
    try
    {
    Add-LocalGroupMember -Group administrators -Member $x@bodyfriend.co.kr -ErrorAction Stop
    $msg.POpup($resultuser + 
    "Add local admin complet" +
    "Please check if it is on the list above.", 0, "netplwiz", 48)
    $resultuser = Get-LocalGroupMember -Name administrators | where {$PSItem.PrincipalSource -eq 'ActiveDirectory' -and $PSItem.ObjectClass -eq 'user'}  | Out-String
    }
    catch [System.Management.Automation.ActionPreferenceStopException]
    {
    $resultuser = Get-LocalGroupMember -Name administrators | where {$PSItem.PrincipalSource -eq 'ActiveDirectory' -and $PSItem.ObjectClass -eq 'user'}  | Out-String
    $msg.POpup($resultuser + "It has already been added or you have entered it incorrectly. DomainName0/ActiveDirectoryID" + "Check", 5, "ID", 48)
    $DomainResult =  Get-ComputerInfo | select -ExpandProperty CsDomain
        if ($DomainResult -eq $dns )
        {
            #$msg.POpup("Domain Join Complet. Reboot.", 5, "ID", 48)
        }
        else {
            $msg.POpup("Domain Join Fail.", 5, "ID", 48)
            sysdm.cpl
        }
    }
    Finally
    {
        #$comname = Get-ComputerInfo | Select-Object -Property csname
        $msg.POpup( "" +
        "When the task is complete, log in as a different user." +
        " ", 5, "netplwiz", 48)    
        $ipadress = Get-NetIPAddress | Select-Object -Property IPAddress | where {$PSItem.IPAddress -like "172.30.*"} | Out-String
        $resultuser = Get-LocalGroupMember -Name administrators | where {$PSItem.PrincipalSource -eq 'ActiveDirectory' -and $PSItem.ObjectClass -eq 'user'}  | Out-String 
        $userinfo = "Active Directory ID : " + $x | Out-String
        $domainjoin = "Domain : " + $DomainResult
        $systemedition = "`nEdition : " + $edition
        Send-MailMessage -Body $resultuser$ipadress$userinfo$domainjoin$systemedition -From 'ADUSER <ID@Gmail.com>' -to 'admin <ID@Gmail.com>' -SmtpServer smtp.server.com -Subject ADUserjoin
        #Invoke-RestMethod -Uri "https://api.telegram.org/chaid/id"
    }
}

