if (Get-Module posh-git) { return }

Push-Location "$psScriptRoot/Lib/PoshGit"
.\CheckVersion.ps1 > $null
. ./Utils.ps1
. ./GitUtils.ps1
. ./GitPrompt.ps1
Pop-Location

if (!$Env:HOME) { $Env:HOME = "$Env:HOMEDRIVE$Env:HOMEPATH" }
if (!$Env:HOME) { $Env:HOME = "$Env:USERPROFILE" }

Export-ModuleMember -Function @(
  'Enable-GitColors', 
  'Get-GitStatus', 
  'Get-GitDirectory',
  'Start-SshAgent',
  'Stop-SshAgent',
  'Add-SshKey'
)

