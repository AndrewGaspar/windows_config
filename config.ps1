if(!(( `
    [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")))
{
    Start-Process powershell.exe $PSScriptRoot -Verb runAs
    return
}

function IsCommandAvailable($command) {
    return $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}

function IsChocolateyAvailable { IsCommandAvailable choco.exe }


function IsChocolateyPackageInstalled($package) {
    return !!(choco.exe list $package -l | ? { ($_ -match "^(?<package>[\w\.-]+)\s") -and ($Matches["package"] -eq $package) })
}

function InstallPackageIfNotInstalled($package) {
    if(!(IsChocolateyPackageInstalled $package)) {
        choco.exe install $package -y
    }
}

Set-ExecutionPolicy RemoteSigned

if(!(IsChocolateyAvailable)) {
    # install chocolatey
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

if(!(IsChocolateyAvailable)) {
    Write-Error "Chocolatey wasn't available in the current process scope immediately - restart shell and re-run the script"
    return
}

@("git", "visualstudiocode", "f.lux", "github", "hexchat") | % { InstallPackageIfNotInstalled $_ }

Install-Module posh-git

Copy-Item "$PSScriptRoot\vs_code_settings.json" "~\AppData\Roaming\Code\User\settings.json"
Copy-Item "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" $profile
