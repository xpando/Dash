if (Get-Module posh-hg) { return }

Push-Location "$psScriptRoot/Lib/PoshHg"
. ./HgUtils.ps1
Pop-Location

Export-ModuleMember -Function @(
  'Get-HgStatus'
)