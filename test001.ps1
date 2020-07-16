Param(
)

[string]$address = ''
[string]$target = ''
[string]$destination = ''
[string]$lastconfirm = 'y'
do {
    $None = 'None'
    $buf = $None
    $buf = Read-Host -Prompt "Target Address"
    if ($buf -ne $None) {
        $address = $buf
    }
    $buf = $None
    $buf = Read-Host -Prompt "Target String"
    if ($buf -ne $None) {
        $target = $buf
    }
    $buf = $None
    $buf = Read-Host -Prompt "Destination String"
    if ($buf -ne $None) {
        $destination = $buf
    }
    
    Write-Host '################################################'
    Write-Host '################ Start Preview #################'
    Write-Host '################################################'
    
    (Get-ChildItem -LiteralPath $address -File).Name -replace $('^(.*)' + $target + '(.*)$'), $('${1}' + $target + '${2}' + ' -> ' + '${1}' + $destination + '${2}')
    
    Write-Host '################################################'
    Write-Host '################ End of Preview ################'
    Write-Host '################################################'
    
    Write-Host 'Please Check Preview.'
    $lastconfirm = $(Read-Host -Prompt "is This OK ? ([y]/n)").ToLower()
} while ($lastconfirm -eq 'n')
    
Get-ChildItem -LiteralPath $address -File | Rename-Item -NewName { $_.Name -replace $('(.*)' + $target + '(.*)'), $('${1}' + $destination + '${2}') }

# Modify [CmdletBinding()] to [CmdletBinding(SupportsShouldProcess=$true)]
$paths = @()
foreach ($aPath in $Path) {
    if (!(Test-Path -LiteralPath $aPath)) {
        $ex = New-Object System.Management.Automation.ItemNotFoundException "Cannot find path '$aPath' because it does not exist."
        $category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
        $errRecord = New-Object System.Management.Automation.ErrorRecord $ex,'PathNotFound',$category,$aPath
        $psCmdlet.WriteError($errRecord)
        continue
    }

    # Resolve any relative paths
    $paths += $psCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($aPath)
}

foreach ($aPath in $paths) {
    if ($pscmdlet.ShouldProcess($aPath, 'Operation')) {
        # Process each path
        
    }
}
Write-Host ''
Write-Host " Finish " -BackgroundColor Green -ForegroundColor Black

if ([environment]::OSVersion.Version.Major -ge 10 ) {
    $ToastModulePath = $env:USERPROFILE + "\Documents\PowerShell\Modules\BurntToast"
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
    New-BurntToastNotification -AppLogo $($(Get-Location).Path + "\ren.png") -Text "SimpleRenamer", 'Mision Completed, Celebrate!'
}
else {
    $ws = New-Object -com Wscript.Shell
    $ws.Popup("Rename Complete!!", 0, "RenameSimple", 0)
}