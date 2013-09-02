function Format-ChildItemSize($item) {
  if ($item -is [System.IO.DirectoryInfo]) {
    ""
  }
  elseif ($item.Length -lt 1KB) {
    (($item.Length.ToString("n0")) + " B ")
  }
  elseif ($item.Length -lt 1MB ) {
    ((($item.Length/1KB).ToString("n0")) + " KB")
  }
  elseif ($item.Length -lt 1GB ) {
    ((($item.Length/1MB).ToString("n0")) + " MB")
  }
  else {
    ((($item.Length/1GB).ToString("n0")) + " GB")
  }
}

function Write-ChildItemColor($item, $color = "DarkGray")
{
  if ($item -is [System.IO.DirectoryInfo]) {
    Write-Host `
    ( `
      "{0,-5} {1,22} {2,12} {3}" -f `
      $item.Mode, `
      ([String]::Format("{0,10} {1,11}", $item.LastWriteTime.ToString("yyyy-MM-dd"), $item.LastWriteTime.ToString("hh:mm:ss tt"))), `
      "", `
      $item.Name + "/" `
    ) -ForegroundColor $color
  } 
  elseif ($item -is [System.IO.FileInfo]) {
    Write-Host `
    ( `
      "{0,-5} {1,22} {2,12} {3}" -f `
      $item.Mode, `
      ([String]::Format("{0,10} {1,11}", $item.LastWriteTime.ToString("yyyy-MM-dd"), $item.LastWriteTime.ToString("hh:mm:ss tt"))), `
      (Format-ChildItemSize $item), `
      $item.Name `
    ) -ForegroundColor $color
  }
}

New-CommandWrapper Out-Default -Process {
  if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo])) {
    if(-not ($notfirst)) {
      Write-Host
      #Write-Host "Directory: " -nonewline
      #Write-Host "$(pwd)`n" -ForegroundColor Cyan
      Write-Host "Mode  Last Write Time                Size Name"
      Write-Host "----  ---------------                ---- ----"
      #           d---- 2013-08-24 11:06:41 AM     1,000 MB foo.dat
      $notfirst=$true
    }

    if ($_ -is [System.IO.DirectoryInfo]) {
      Write-ChildItemColor $_ Cyan
    } elseif ($_ -is [System.IO.FileInfo]) {
      $item = $_
      switch -regex ($item.Name) {
        "(?ix)\.(7z|zip|tar|gz|rar)$" { 
          Write-ChildItemColor $item DarkRed
        }
        '(?ix)\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$' { 
          Write-ChildItemColor $item Green
        }
        '(?ix)\.(txt|cfg|conf|ini|csv|log)$' { 
          Write-ChildItemColor $item White
        }
        default { 
          Write-ChildItemColor $item DarkGray
        }
      }
    }

    # prevent default output
    $_ = $null
  }
} -end {
  Write-Host
}

del alias:dir
del alias:ls
function dir { Get-ChildItem $args -ea silentlycontinue | sort @{e={$_.PSIsContainer}; desc=$true},@{e={$_.Name}; asc=$true} } 
Set-Alias ls "dir"