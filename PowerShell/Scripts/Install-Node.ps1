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

if (Test-Path .\Node) {
    $path = Resolve-Path Node
    Pop-Location
    throw "$path already exists!"
}

md Node
Push-Location .\Node

Write-Host "Downloading node..."
if (Test-Is64Bit) {
    Invoke-WebRequest 'http://nodejs.org/dist/v0.10.29/x64/node.exe' -UseBasicParsing -UseDefaultCredentials -OutFile .\node.exe
} else {
    Invoke-WebRequest 'http://nodejs.org/dist/v0.10.29/node.exe' -UseBasicParsing -UseDefaultCredentials -OutFile .\node.exe
}
Write-Host "done." -ForegroundColor Green

Write-Host "Downloading npm..."
Invoke-WebRequest 'http://nodejs.org/dist/npm/npm-1.4.10.zip' -UseBasicParsing -UseDefaultCredentials -OutFile .\npm.zip

Write-Host "Extracting npm..."
7z.exe x npm.zip
del npm.zip
Write-Host "done." -ForegroundColor Green

$ENV:NODE_PATH = Resolve-Path .\node_modules
Add-Path @(".")

Pop-Location

Pop-Location

Pop-Location
