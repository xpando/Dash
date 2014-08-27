param
(
  $certPath,
  $plaintext
)


$cert = gi $certPath
[System.Reflection.Assembly]::LoadWithPartialName("System.Security") | Out-Null 
$thumbprint = $cert.Thumbprint 
$contentInfo = New-Object Security.Cryptography.Pkcs.ContentInfo -ArgumentList (,[Text.Encoding]::UTF8.GetBytes($plaintext)) 
$envelope = New-Object Security.Cryptography.Pkcs.EnvelopedCms $contentInfo
$envelope.Encrypt((New-Object System.Security.Cryptography.Pkcs.CmsRecipient($cert))) 
$cyphertext = [Convert]::ToBase64String($envelope.Encode())
Write-Host $cyphertext

