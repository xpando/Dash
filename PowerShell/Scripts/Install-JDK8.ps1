$ErrorActionPreference = "Stop"
if ($Host.Version.Major -lt 3) {
    throw "Powershell v3 or greater is required."
}

Push-Location $PSScriptRoot

$downloadDir = "$ENV:ConEmuDir\Apps"
if (!(Test-Path $downloadDir)) {
    md $downloadDir | Out-Null
}

Push-Location $downloadDir

if (Test-Path .\JDK8) {
    $path = Resolve-Path JDK8
    Pop-Location
    Pop-Location
    throw "$path already exists!"
}

md JDK8 | Out-Null
Push-Location .\JDK8

$downloadPage = 'http://www.oracle.com/'
$downloadUrl = 'http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-windows-i586.exe'
if (Test-Is64Bit) {
    $downloadUrl = 'http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-windows-x64.exe'
}

Write-Host "Downloading JDK 8..."
$bak = $ProgressPreference 
$ProgressPreference = "SilentlyContinue"
Invoke-WebRequest $downloadPage -UseBasicParsing -UseDefaultCredentials -SessionVariable s | Out-Null
$c = New-Object System.Net.Cookie("oraclelicense", "accept-securebackup-cookie", "/", ".oracle.com")
$s.Cookies.Add($downloadPage, $c)
Invoke-WebRequest $downloadUrl -UseBasicParsing -UseDefaultCredentials -WebSession $s -OutFile .\jdk.exe
$ProgressPreference = $bak
Write-Host "done." -ForegroundColor Green

Write-Host "Extracting JDK 8..."
7z.exe x jdk.exe
del jdk.exe
7z.exe x tools.zip
del tools.zip
cmd /C 'for /r %x in (*.pack) do .\bin\unpack200 -r "%x" "%~dpnx.jar"'
Write-Host "done." -ForegroundColor Green

Pop-Location

Pop-Location

Pop-Location