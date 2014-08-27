param(  
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [String]$UserName
) 

$u = New-Object System.Security.Principal.NTAccount($UserName)
$sid = $u.Translate([System.Security.Principal.SecurityIdentifier])
$sid.Value
