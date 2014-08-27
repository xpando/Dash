Push-Location "$psScriptRoot/Lib"
. .\New-CommandWrapper.ps1
Pop-Location

function su {
  powershell.exe -new_console:a -nologo -noexit -executionpolicy bypass -file "$ENV:ConEmuDir\PowerShell\Profile.ps1"
}

function Test-IsAdmin {
  ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

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

function Test-Is64Bit {
  (Get-OSArchitecture).Architecture -eq "64-Bit"
}

function Import-Environment($file) {
  $cmd = "`"$file`" & set"
  cmd /c $cmd | % {
    $p, $v = $_.split('=')
    Set-Item -path env:$p -value $v
  }
}

function Enable-VisualStudio($version = "12.0") {
  if ([intptr]::size -eq 8) {
    $key = "HKLM:SOFTWARE\Wow6432Node\Microsoft\VisualStudio\" + $version
  }
  else {
    $key = "HKLM:SOFTWARE\Microsoft\VisualStudio\" + $version
  }

  if (Test-Path $key) {
    $VsKey = Get-ItemProperty $key
    if ($VsKey -and $VsKey.InstallDir -and (Test-Path $VsKey.InstallDir)) {
      $VsInstallPath = [System.IO.Path]::GetDirectoryName($VsKey.InstallDir)
      $VsToolsDir = [System.IO.Path]::GetDirectoryName($VsInstallPath)
      $VsToolsDir = [System.IO.Path]::Combine($VsToolsDir, "Tools")
      $BatchFile = [System.IO.Path]::Combine($VsToolsDir, "vsvars32.bat")
      
      Import-Environment $BatchFile
      
      [System.Console]::Title = "Visual Studio " + $version + " Windows Powershell"
    }
    else {
      Write-Host "Visual Studio $version is not installed."
    }
  }
  else {
    Write-Host "Visual Studio $version is not installed."
  }
}

function Clean-VSProject {
  [cmdletbinding()]
  param(
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [string]$path = "."
  )
  
  Push-Location $path

  $vars = Get-ChildItem -recurse | where { $_.GetType().Name.ToString() -eq "DirectoryInfo" -and $_.Name -eq "bin" -or $_.Name -eq "obj" }
  
  if ($vars.Length -gt 0) {
    $vars | %{ Write-Host "Cleaning " $_.FullName }
    $vars | %{ Remove-Item -recurse -path $_.FullName -force }
  }
  else { 
    Write-Host "Solution is clean"
  }

  Pop-Location
}

Set-Alias vs Enable-VisualStudio

Export-ModuleMember -Function * -Alias *