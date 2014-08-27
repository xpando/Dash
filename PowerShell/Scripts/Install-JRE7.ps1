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

if (Test-Path .\JRE7) {
    $path = Resolve-Path JRE7
    Pop-Location
    Pop-Location    
    throw "$path already exists!"
}

$downloadPage = 'http://www.oracle.com/'
$downloadUrl = 'http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jre-7u67-windows-i586.tar.gz'
if (Test-Is64Bit) {
    $downloadUrl = 'http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jre-7u67-windows-x64.tar.gz'
}

Write-Host "Downloading JRE 7..."
$bak = $ProgressPreference 
$ProgressPreference = "SilentlyContinue"
Invoke-WebRequest $downloadPage -UseBasicParsing -UseDefaultCredentials -SessionVariable s | Out-Null
$c = New-Object System.Net.Cookie("oraclelicense", "accept-securebackup-cookie", "/", ".oracle.com")
$s.Cookies.Add($downloadPage, $c)
Invoke-WebRequest $downloadUrl -UseBasicParsing -UseDefaultCredentials -WebSession $s -OutFile .\jre.tgz
$ProgressPreference = $bak
Write-Host "done." -ForegroundColor Green

Write-Host "Extracting JRE 7..."
7z.exe x jre.tgz
del jre.tgz
7z.exe x *.tar
del *.tar
ren -Force 'jre1.7.0_67' JRE7
Write-Host "done." -ForegroundColor Green

Pop-Location

Pop-Location