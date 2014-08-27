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

if (Test-Path .\git) {
    $path = Resolve-Path git
    Pop-Location
    Pop-Location
    throw "$path already exists!"
}

md git | Out-Null
Push-Location .\git

Write-Host "Downloading Git..."
Invoke-WebRequest 'https://github.com/msysgit/msysgit/releases/download/Git-1.9.4-preview20140815/PortableGit-1.9.4-preview20140815.7z' -UseBasicParsing -UseDefaultCredentials -OutFile .\git.zip
Write-Host "done." -ForegroundColor Green

Write-Host "Extracting git..."
7z.exe x git.zip
del git.zip
Write-Host "done." -ForegroundColor Green

if (!(which git -ErrorAction Ignore)) {
  Add-Path @('.\bin')
  Add-Path @('.\cmd')
  Import-Module "..\..\PowerShell\Modules\Git" -DisableNameChecking
}

Pop-Location

Pop-Location

Pop-Location
