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

if (Test-Path .\go) {
    $path = Resolve-Path go
    Pop-Location
    throw "$path already exists!"
}

Write-Host "Downloading Go..."
if (Test-Is64Bit) {
    Invoke-WebRequest 'https://storage.googleapis.com/golang/go1.3.1.windows-amd64.zip' -UseBasicParsing -UseDefaultCredentials -OutFile .\go.zip
} else {
    Invoke-WebRequest 'https://storage.googleapis.com/golang/go1.3.1.windows-386.zip' -UseBasicParsing -UseDefaultCredentials -OutFile .\go.zip
}
Write-Host "done." -ForegroundColor Green


Write-Host "Extracting Go..."
7z.exe x go.zip
del go.zip
Write-Host "done." -ForegroundColor Green

$ENV:GOROOT = Resolve-Path ".\Go"
Add-Path @(".\Go\bin")

Pop-Location

Pop-Location
