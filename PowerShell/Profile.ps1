$scriptFile = $MyInvocation.MyCommand.Definition
$scriptDir = Split-Path $scriptFile -Parent 

Push-Location $scriptDir

Import-Module ".\modules\Environment"   -DisableNameChecking
Import-Module ".\modules\VisualStudio"  -DisableNameChecking
Import-Module ".\modules\Util"          -DisableNameChecking
Import-Module ".\modules\Git"           -DisableNameChecking
Import-Module ".\modules\Hg"            -DisableNameChecking

Add-Path @(
  ".\Scripts",
  "..\bin"
)

if ((Get-OSArchitecture).Architecture -eq "64-Bit")
{
}

Set-Alias zip "7za.exe"
Set-Alias edit "$($Env:ProgramFiles)\Sublime Text 2\sublime_text.exe"

. .\DirColors.ps1
. .\Prompt.ps1

Pop-Location

#cd $env:userprofile