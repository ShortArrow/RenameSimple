Param(
    # [Parameter()]
    [switch]
    $NeedPassword,
    # [Parameter()]
    [switch]
    $zip
    )

function myInputBox {
    param (
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = '7zipMuluti'
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
    $label.Text = 'Please type a password'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)

    $form.Topmost = $true

    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $x = $textBox.Text
        return $x
    }
}

# Set-PSDebug -Trace 0
$7zpath=$env:ProgramFiles+"\7-zip\7z.exe"
$x001=(Get-ChildItem ".\7zm-input")
[string]$PressPassword
if ($NeedPassword) {
    $x001=(Get-ChildItem ".\7zm-input-with-password")
    $PressPassword = Read-Host -Prompt "Please Type Password"
}

# [System.IO.FileInfo]$y001
foreach ($y001 in $x001) {
    if (("",".ps1",".cmd",".zip",".7z") -notcontains $y001.Extension -and !($y001.PSIsContainer) -and ($y001.Extension -ne $y001.Name) -and ($y001.Name -ne "readme.md")) {
        $z001=$(Join-Path ".\7zm-output" $($([System.IO.Path]::GetFileNameWithoutExtension("`"$y001`""))+".7z"))
        if ($null -eq $PressPassword) {
            $status=Start-Process -FilePath $7zpath -ArgumentList 'a', "-t7z", "`"$z001`"", "`"$y001`"" -NoNewWindow -Wait
        }else {
            $status=Start-Process -FilePath $7zpath -ArgumentList 'a', "-t7z", "`"$z001`"", "-p$PressPassword", "-mhe", "`"$y001`"" -NoNewWindow -Wait
        }
        Write-Host $z001" <-- "$y001 "status $status"
    }
}

Write-Host "Finish" -BackgroundColor Green -ForegroundColor White

if ([environment]::OSVersion.Version.Major -ge 10 ) {
    $ToastModulePath=$env:USERPROFILE+"\Documents\PowerShell\Modules\BurntToast"
    if (!(Test-Path $ToastModulePath)) {
        Copy-Item -Destination $ToastModulePath -LiteralPath ".\BurntToast" -Force -Recurse
    }
    Import-Module BurntToast
    # $toastParams = @{
    #     AppLogo = C:\7zip.png 
    #     Text = "圧縮が終わりました！"
    #     Header = (New-BTHeader -Id 1 -Title "7zip Muluti")
    # }
    # New-BurntToastNotification @toastParams
    New-BurntToastNotification -AppLogo $($(Get-Location).Path+"\7zip.png") -Text "7zip Muluti",'Mision Completed, Celebrate!'
}
else {
    $ws = New-Object -com Wscript.Shell
    $ws.Popup("圧縮が完了しました",0,"7zipMuluti",0)
}