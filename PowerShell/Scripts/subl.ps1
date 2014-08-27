if (Test-Path "$PSScriptRoot\Apps\SublimeText\sublime_text.exe") {
    & "$PSScriptRoot\Apps\SublimeText\sublime_text.exe" $args
} elseif (Test-Path "$ENV:ProgramFiles\Sublime Text 2\sublime_text.exe") {
    & "$ENV:ProgramFiles\Sublime Text 2\sublime_text.exe" $args
}
