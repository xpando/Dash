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

function Write-ChildItemColor($item, $fg = "DarkGray", $bg = $Host.ui.RawUI.BackgroundColor)
{
  if (!$bg) { $bg = $Host.ui.RawUI.BackgroundColor }
  if (!$fg) { $fg = $Host.ui.RawUI.ForegroundColor }

  if ($item -is [System.IO.DirectoryInfo]) {
    Write-Host `
    ( `
      "{0,-5} {1,22} {2,12} {3}" -f `
      $item.Mode, `
      ([String]::Format("{0,10} {1,11}", $item.LastWriteTime.ToString("yyyy-MM-dd"), $item.LastWriteTime.ToString("hh:mm:ss tt"))), `
      "", `
      $item.Name + "/" `
    ) -ForegroundColor $fg -BackgroundColor $bg
  } 
  elseif ($item -is [System.IO.FileInfo]) {
    Write-Host `
    ( `
      "{0,-5} {1,22} {2,12} {3}" -f `
      $item.Mode, `
      ([String]::Format("{0,10} {1,11}", $item.LastWriteTime.ToString("yyyy-MM-dd"), $item.LastWriteTime.ToString("hh:mm:ss tt"))), `
      (Format-ChildItemSize $item), `
      $item.Name `
    ) -ForegroundColor $fg -BackgroundColor $bg
  }
}

# default colors
$global:dir_colors = @{
  default = @{ fg = "DarkGray"; bg = "" }
  dir = @{ fg = "Cyan"; bg = "" }
  files = @{
    '(?ix)\.(7z|zip|tar|gz|rar)$'                        = @{ fg = "DarkCyan";   bg = "" }
    '(?ix)\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$'    = @{ fg = "DarkGreen";  bg = "" }
    '(?ix)\.(doc|docx|ppt|pptx|xls|xlsx|mdb|mdf|ldf)$'   = @{ fg = "Magenta";    bg = "" }
    '(?ix)\.(txt|cfg|conf|config|yml|ini|csv|log|json)$' = @{ fg = "DarkYellow"; bg = "" }
    '(?ix)\.(sln|csproj|sqlproj|proj|targets)$'          = @{ fg = "DarkRed";    bg = "" }
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
      Write-ChildItemColor $_ $global:dir_colors.dir.fg $global:dir_colors.dir.bg
    } elseif ($_ -is [System.IO.FileInfo]) {
      $item = $_

      $type = $global:dir_colors.files.keys |? { $item.Name -match $_ } | select -first 1
      if ($type) {
        $colors = $global:dir_colors.files[$type]
        Write-ChildItemColor $item $colors.fg $colors.bg
      } else {
        Write-ChildItemColor $item $global:dir_colors.default.fg $global:dir_colors.default.bg
      }

#      switch -regex ($item.Name) {
#        "(?ix)\.(7z|zip|tar|gz|rar)$" { 
#          Write-ChildItemColor $item DarkCyan
#        }
#        '(?ix)\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$' { 
#          Write-ChildItemColor $item DarkGreen
#        }
#        '(?ix)\.(doc|docx|ppt|pptx|xls|xlsx|mdb|mdf|ldf)$' { 
#          Write-ChildItemColor $item Magenta
#        }
#        '(?ix)\.(txt|cfg|conf|config|yml|ini|csv|log|json)$' { 
#          Write-ChildItemColor $item DarkYellow
#        }
#        '(?ix)\.(sln|csproj|sqlproj|proj|targets)$' { 
#          Write-ChildItemColor $item DarkRed
#        }
#        default { 
#          Write-ChildItemColor $item DarkGray
#        }
#      }
    }

    # prevent default output
    $_ = $null
  }
} -End {
  Write-Host
}

