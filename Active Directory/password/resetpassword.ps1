#220613
#220722 UI 추가
#scrambledpassword 변수 변경 
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Password Reset'
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
$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()
$msg = New-Object -ComObject WScript.Shell

#random Password
function Get-RandomPassword {
    #param ()
    $uppercase = "ABCDEFGHKLMNOPRSTUVWXYZ".tochararray() 
    $lowercase = "abcdefghiklmnoprstuvwxyz".tochararray() 
    $number = "0123456789".tochararray() 
    $special = "$%&/()=?}{@#*+!".tochararray() 
        For ($i=0; $i -le 10; $i++) {
            $password =($uppercase | Get-Random -count 1) -join ''
            $password +=($lowercase | Get-Random -count 5) -join ''
            $password +=($number | Get-Random -count 1) -join ''
            $password +=($special | Get-Random -count 1) -join ''
            $passwordarray=$password.tochararray() 
            $Randompassword=($passwordarray | Get-Random -Count 8) -join ''
        }
        return $Randompassword
}

#Set-ADAccountPassword
$UPN = "Domain Name"
$notice1 = "Hi "
$notice2 = "The password has been initialized as follows.`n"
$notice3 = "`nThe e-mail will be deleted after 3 months due to the groupware security policy, so please keep it separately."

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $user = $textBox.text
    $sendemail = $user+$UPN
    $scrambledpassword = Get-RandomPassword
    try{
        Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-secureString -AsPlainText $scrambledpassword -Force -ErrorAction Stop)
        #mailSend
        Send-MailMessage -Body $notice1$notice2$scrambledpassword$notice3 -From 'ad_PW <admin@test.com>' -To "$sendemail" -cc 'itadmin <admin@test.com>' -SmtpServer mailserver -Subject ad_PWreset -Encoding utf8
        $msg.POpup($user+" password reset", 5, "ID", 48)
    }
    catch [microsoft.activedirectory.management.adidentitynotfoundexception]
    {
        $msg.POpup($user+" Password initialization failed, please check ID", 5, "ID", 48)
    }
}
