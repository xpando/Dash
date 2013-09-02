Enable-GitColors

function gitp {
    # Reset color, which can be messed up by Enable-GitColors
    #$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    # Git Prompt
    $realLASTEXITCODE = $LASTEXITCODE
    $status = Get-GitStatus
    $LASTEXITCODE = $realLASTEXITCODE

    if ($status.GitDir) {
        Write-Host (" on ") -nonewline -foregroundcolor white
        Write-Host ("git: ") -nonewline -foregroundcolor green
        Write-Host ($status.Branch) -nonewline -foregroundcolor cyan
    }
}

function hgp {
    $status = Get-HgStatus

    if ($status) {
        Write-Host (" on ") -nonewline -foregroundcolor white
        Write-Host ("mercurial: ") -nonewline -foregroundcolor green
        Write-Host ($status.Branch) -nonewline -foregroundcolor cyan
    }
}

function prompt {
    # Blank line for padding
    Write-Host

    # Current date time
    Write-Host (get-date -Format "yyyy-MM-dd hh:mm:ss tt") -foregroundcolor white

    # User and machine info
    if ($env:userdomain.ToUpper() -ne $env:computername.ToLower()) {
        Write-Host ($env:userdomain.ToUpper()) -nonewline -foregroundcolor green
        Write-Host (".") -nonewline -foregroundcolor white
        Write-Host ($env:username.ToUpper()) -nonewline -foregroundcolor green
        Write-Host (" at ") -nonewline -foregroundcolor white
        Write-Host ($env:computername.ToUpper()) -nonewline -foregroundcolor cyan
    } else {
        Write-Host ($env:username.ToUpper()) -nonewline -foregroundcolor green
        Write-Host (" at ") -nonewline -foregroundcolor white
        Write-Host ($env:computername.ToUpper()) -nonewline -foregroundcolor cyan
    }

    # Current path info
    Write-Host " in " -nonewline -foregroundcolor white
    Write-Host $pwd -nonewline -foregroundcolor gray

    # DVCS status
    gitp
    hgp

    # Command prompt
    Write-Host
    Write-Host "≡>" -nonewline -foregroundcolor red
    # Write-Host("â–º") -nonewline -foregroundcolor red

    return " "
}