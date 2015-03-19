Push-Location $PSScriptRoot

Import-Module ".\Modules\Util" -DisableNameChecking

Set-Alias which Get-Command
Set-Alias l Get-ChildItem

Add-Path @(
 ".\Scripts",
 "..\Tools", 
 "..\Apps",
 "..\Apps\figlet",
 "..\Apps\Sysinternals"
)

if (!(Test-Path ENV:NODE_PATH) -and (Test-Path ..\Apps\Node)) {
  $ENV:NODE_PATH = Resolve-Path ..\Apps\Node\node_modules
  Add-Path @("..\Apps\Node")
}

if (!(Test-Path ENV:GOROOT) -and (Test-Path "..\Apps\Go")) {
  $ENV:GOROOT = Resolve-Path "..\Apps\Go"
  Add-Path @("..\Apps\Go\bin")
}

if (!(which git -ErrorAction Ignore) -and (Test-Path ..\Apps\Git\bin)) {
  Add-Path @('..\Apps\Git\bin', '..\Apps\Git\cmd')
}

if (which git -ErrorAction Ignore) {
    Import-Module ".\Modules\Git" -DisableNameChecking
}

. .\DirColors.ps1
. .\Prompt.ps1

cls # HACK: Gets rid of pink background when starting admin mode (su)

# Print out a fancy PowerShell Banner :)
if (which figlet -ErrorAction Ignore) {
    Write-Host (figlet -f slant "PowerShell $($Host.Version.ToString(2))" | Out-String) -ForegroundColor Cyan
}

#$PSVersionTable

Pop-Location