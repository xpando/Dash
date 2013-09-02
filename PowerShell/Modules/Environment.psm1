function Add-Path([string[]] $items) {
  $paths = $env:path -split ";"
  $items = $items | ? { $paths -notcontains $_ }
  $paths = ($items + $paths) | ? { ![string]::IsNullOrEmpty($_) -and (Test-Path $_ -PathType Container) } | % { Resolve-Path $_ }
  $env:path = $paths -join ";"
}

function Remove-Path([string[]] $items) {
  $paths = $env:path -split ";"
  $paths = $paths | ? { $items -notcontains $_ }
  $env:path = $paths -join ";"
}

function Get-OSArchitecture {
  [cmdletbinding()]
  param(
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string[]]$ComputerName = $env:computername
  )

  process {
    foreach ($Computer in $ComputerName) {
      if (Test-Connection -ComputerName $Computer -Count 1 -ea 0) {
        Write-Verbose "$Computer is online"            
        $OS  = (Get-WmiObject -computername $computer -class Win32_OperatingSystem ).Caption            
        if ((Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer -ea 0).OSArchitecture -eq '64-bit') {            
          $architecture = "64-Bit"            
        } else  {            
          $architecture = "32-Bit"            
        }            

        $OutputObj  = New-Object -Type PSObject            
        $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer.ToUpper()            
        $OutputObj | Add-Member -MemberType NoteProperty -Name Architecture -Value $architecture            
        $OutputObj | Add-Member -MemberType NoteProperty -Name OperatingSystem -Value $OS            
        $OutputObj            
      }
    }
  }
}

Export-ModuleMember -Function * -Alias *