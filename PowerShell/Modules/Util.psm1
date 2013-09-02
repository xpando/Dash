Push-Location "$psScriptRoot/Lib"
. .\New-CommandWrapper.ps1
Pop-Location

Export-ModuleMember -Function * -Alias *