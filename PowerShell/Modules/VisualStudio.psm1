function Import-Environment($file) {
  $cmd = "`"$file`" & set"
  cmd /c $cmd | % {
    $p, $v = $_.split('=')
    Set-Item -path env:$p -value $v
  }
}

function Enable-VisualStudio($version = "11.0") {
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

Export-ModuleMember -Function Enable-VisualStudio, Clean-VSProject -Alias vs