function Clear-AllEventLogs {
  Get-EventLog -list | % {
    Write-Host "Clearing $($_.Log)"
    Clear-EventLog -log $_.Log 
  }
}