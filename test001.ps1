Param(
)

function Find-MachingWord {
    param (
        [array]
        $arr
    )
    $arr | ForEach-Object {
        $substr = for ($s = 0; $s -lt $_.length; $s++) {
            for ($l = 1; $l -le ($_.length - $s); $l++) {
                $_.substring($s, $l);
            }
        } 
        $substr | ForEach-Object { $_.toLower() } | Select-Object -unique
    } | Group-Object | Where-Object { $_.count -eq $arr.length } | Sort-Object { $_.name.length } | Select-Object -expand name -l 1
}


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
    if ('"' -eq $address[0] -and '"' -eq $address[$address.Length - 1]) {
        $address = $address.SubString(1, ($address.Length - 2))
    }
    if (Test-Path -LiteralPath $address) {
        $names = (Get-ChildItem -LiteralPath $address -File).Name
        $MatchResult = Find-MachingWord ($names)
    }
    
    $buf = $None
    Write-Host -Object "Target String (Default is """ -NoNewline
    Write-Host -Object $MatchResult -ForegroundColor Blue -NoNewline
    $buf = Read-Host -Prompt """.)"
    if ($buf -ne "") {
        $target = $buf
    }
    else {
        $target = $MatchResult
    }
    $buf = $None
    $buf = Read-Host -Prompt "Destination String"
    if ($buf -ne $None) {
        $destination = $buf
    }
    # $target=[regex]::Escape($target)
    # $destination=[regex]::Escape($destination)
    
    Write-Host '################ Start Preview #################' -ForegroundColor Blue
    
    (Get-ChildItem -LiteralPath $address -File).Name -replace $('^(.*)' + [regex]::Escape($target) + '(.*)$'), $('${1}' + $target + '${2}' + ' -> ' + '${1}' + $destination + '${2}')
    
    Write-Host '################ End of Preview ################' -ForegroundColor Blue
    
    Write-Host 'Please Check Preview.'
    $lastconfirm = $(Read-Host -Prompt "is This OK ? ([y]/n)").ToLower()
} while ($lastconfirm -eq 'n')
    
Get-ChildItem -LiteralPath $address -File | Rename-Item -NewName { $_.Name -replace $('(.*)' + [regex]::Escape($target) + '(.*)'), $('${1}' + $destination + '${2}') }

# Modify [CmdletBinding()] to [CmdletBinding(SupportsShouldProcess=$true)]
$paths = @()
foreach ($aPath in $Path) {
    if (!(Test-Path -LiteralPath $aPath)) {
        $ex = New-Object System.Management.Automation.ItemNotFoundException "Cannot find path '$aPath' because it does not exist."
        $category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
        $errRecord = New-Object System.Management.Automation.ErrorRecord $ex, 'PathNotFound', $category, $aPath
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
Write-Host " Finish " -ForegroundColor Green

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