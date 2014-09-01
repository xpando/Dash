$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

if ($Host.Version.Major -lt 3) {
    throw "Powershell v3 or greater is required."
}

Push-Location $PSScriptRoot

Write-Host "Downloading ConEmu..."
Invoke-WebRequest 'https://conemu.codeplex.com/downloads/get/891710' -OutFile .\ConEmu.7z
Write-Host "done." -ForegroundColor Green

Write-Host "Extracting ConEmu..."
.\Tools\7za.exe x -y .\ConEmu.7z
del .\ConEmu.7z
Write-Host "done." -ForegroundColor Green

Pop-Location