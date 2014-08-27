$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

if ($Host.Version.Major -lt 3) {
    throw "Powershell v3 or greater is required."
}

Push-Location $PSScriptRoot

if (!(which go -ErrorAction Ignore)) {
    throw "Missing Go prgramming language. Use Install-Go before installing figlet."
}

$downloadDir = "$ENV:ConEmuDir\Apps"
if (!(Test-Path $downloadDir)) {
    md $downloadDir | Out-Null
}

Push-Location $downloadDir

if (Test-Path .\figlet) {
    $path = Resolve-Path figlet
    Pop-Location
    Pop-Location    
    throw "$path already exists!"
}


Write-Host "Downloading figlet..."
Invoke-WebRequest 'https://github.com/lukesampson/figlet/archive/master.zip' -UseBasicParsing -UseDefaultCredentials -OutFile .\figlet.zip
Write-Host "done." -ForegroundColor Green

Write-Host "Unzipping figlet..."
7z.exe x figlet.zip
del figlet.zip
Write-Host "done." -ForegroundColor Green

Write-Host "Compiling figlet..."
if (!(Test-Path figlet)) {
    md figlet | Out-Null
}
Push-Location .\figlet-master
.\build.ps1
mv fonts.exe ..\figlet\figlet.exe
mv fonts ..\figlet
Pop-Location
del -Force -Recurse .\figlet-master
Write-Host "done." -ForegroundColor Green

Pop-Location

Pop-Location
