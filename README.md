Dash
====

Custom PowerShell environment built on ConEmu

![ScreenShot](https://raw.github.com/xpando/Dash/screenshots/Screenshot.png)

# Installation

To Install ConEmu right click on Install.ps1 and select "Run with PowerShell"

### Installing Apps

```PowerShell
# Install the Go programming language from google
Install-Go
```

```PowerShell
# Install figlet for creating ASCII art banners :)
Install-Figlet
```

```PowerShell
# Install msys git
Install-Git
```

```PowerShell
# Install Sysinternals from Microsoft
Install-Sysinternals
```

To get a full list of all the install scripts:
```PowerShell
Get-Command Install-* | ? { $_.CommandType -eq 'ExternalScript' }
```

I'll be adding more install scripts in the future.