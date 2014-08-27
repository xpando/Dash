param
(
  $cyphertext
)

[System.Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null
$content = [Convert]::FromBase64String($cyphertext)
$env = New-Object Security.Cryptography.Pkcs.EnvelopedCms
$env.Decode($content)
$env.Decrypt()
$utf8content = [text.encoding]::UTF8.GetString($env.ContentInfo.Content)
Write-Host $utf8content
