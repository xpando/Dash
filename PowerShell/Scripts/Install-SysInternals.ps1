$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

if ($Host.Version.Major -lt 3) {
    throw "Powershell v3 or greater is required."
}

Push-Location $PSScriptRoot

$downloadDir = "$ENV:ConEmuDir\Apps"
if (!(Test-Path $downloadDir)) {
    md $downloadDir | Out-Null
}

Push-Location $downloadDir

if (!(Test-Path .\SysInternals)) {
    md SysInternals | Out-Null
}

Push-Location .\SysInternals

Write-Host "Downloading SysInternals..."
Invoke-WebRequest 'http://download.sysinternals.com/files/SysinternalsSuite.zip' -UseBasicParsing -UseDefaultCredentials -OutFile .\sysinternals.zip
Write-Host "done." -ForegroundColor Green

Write-Host "Extracting SysInternals..."
7z.exe x sysinternals.zip
del sysinternals.zip
Write-Host "done." -ForegroundColor Green

Add-Path @('.')

Pop-Location

Pop-Location

Pop-Location
