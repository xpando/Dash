$global:PoshHgSettings = New-Object PSObject -Property @{
    #Before prompt
    BeforeText                = ""
    BeforeForegroundColor     = [ConsoleColor]::Yellow
    BeforeBackgroundColor     = $Host.UI.RawUI.BackgroundColor
    
    #After prompt
    AfterText                 = "`r`n"
    AfterForegroundColor      = [ConsoleColor]::Yellow
    AfterBackgroundColor      = $Host.UI.RawUI.BackgroundColor
    
    # Current branch
    BranchForegroundColor    = [ConsoleColor]::Cyan
    BranchBackgroundColor    = $Host.UI.RawUI.BackgroundColor
    # Current branch when not updated
    Branch2ForegroundColor   = [ConsoleColor]::DarkRed
    Branch2BackgroundColor   = $host.UI.RawUI.BackgroundColor
    
    # Working directory status
    BeforeStatusText          = ""
    BeforeStatusTextColor     = [ConsoleColor]::White
    AfterStatusText           = ""
    AfterStatusTextColor      = [ConsoleColor]::White
    
    AddedForegroundColor      = [ConsoleColor]::Green
    AddedBackgroundColor      = $Host.UI.RawUI.BackgroundColor
    ModifiedForegroundColor   = [ConsoleColor]::Yellow
    ModifiedBackgroundColor   = $Host.UI.RawUI.BackgroundColor
    DeletedForegroundColor    = [ConsoleColor]::Red
    DeletedBackgroundColor    = $Host.UI.RawUI.BackgroundColor
    UntrackedForegroundColor  = [ConsoleColor]::Magenta
    UntrackedBackgroundColor  = $Host.UI.RawUI.BackgroundColor
    MissingForegroundColor    = [ConsoleColor]::DarkGray
    MissingBackgroundColor    = $Host.UI.RawUI.BackgroundColor
    RenamedForegroundColor    = [ConsoleColor]::DarkYellow
    RenamedBackgroundColor    = $Host.UI.RawUI.BackgroundColor
    
    #Tag list
    ShowTags                  = $true
    BeforeTagText             = ' '
    AfterTagText              = ''
    TagForegroundColor        = [ConsoleColor]::Gray
    TagBackgroundColor        = $Host.UI.RawUI.BackgroundColor
    TagSeparator              = " "
    TagSeparatorColor         = [ConsoleColor]::Gray
    
    # MQ Integration
    ShowPatches                   = $false
    BeforePatchText               = ' patches: '
    UnappliedPatchForegroundColor = [ConsoleColor]::DarkGray
    UnappliedPatchBackgroundColor = $Host.UI.RawUI.BackgroundColor
    AppliedPatchForegroundColor   = [ConsoleColor]::DarkYellow
    AppliedPatchBackgroundColor   = $Host.UI.RawUI.BackgroundColor
    PatchSeparator                = ' › '
    PatchSeparatorColor           = [ConsoleColor]::White    
}