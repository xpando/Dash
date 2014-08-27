$cmd = "notepad2_x86.exe"
if (Test-Is64bit) {
    $cmd = "notepad2_x64.exe"
}

if (which $cmd) {
    & $cmd $args
}