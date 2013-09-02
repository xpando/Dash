function New-AesKey {
  $algorithm = [System.Security.Cryptography.SymmetricAlgorithm]::Create("Rijndael")
  $keybytes = $algorithm.get_Key()
  $key = [System.Convert]::ToBase64String($keybytes)
  Write-Output $key
}