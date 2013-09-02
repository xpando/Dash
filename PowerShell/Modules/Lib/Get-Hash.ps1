<# 
.SYNOPSIS 
   Creates a Hash of a file and prints the hash   
.DESCRIPTION 
    Uses System.Security.Cryptography.HashAlgorithm and members to create the hash 
    Also uses System.Text.AsciiEncoding to convert string to byte array. 
    Created as a Module. 
.NOTES 
    File Name  : Get-Hash.PSM1 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell V2 CTP3 
    Thanks to the #PowerShell Twitter Posse for help figuring out -verbose. 
    http://www.pshscripts.blogspot.com 
    Based on  
    http://tinyurl.com/aycszb written by Bart De Smet 
.PARAMETER Algorithm 
    The name of one of the hash Algorithms defined at 
    http://msdn.microsoft.com/en-us/library/system.security.cryptography.hashalgorithm.aspx 
.PARAMETER File 
    The name of a file to provide a hash for. 
.EXAMPLE 
    PS C:\foo> ls *.txt | where {!$_.psiscontainer}| Get-Hash sha1 -verbose:$true 
    OK - I'll be chatty 
 
    Processing C:\foo\asciifile.txt 
    sha1 hash of file C:\foo\asciifile.txt is "3529f51d2dd9c3c45e539eee5b42b07a8b74f9f5" 
 
    Processing C:\foo\log.txt 
    sha1 hash of file C:\foo\log.txt is "89dd3b94d3cb7f645498925e77346aa9218d7ffe" 
 
    Processing C:\foo\sites.txt 
    sha1 hash of file C:\foo\sites.txt is "2e434f1c2c16fc1060cd9f2e0226e142ea450ce4" 
 
    Processing C:\foo\test.txt 
    File C:\foo\test.txt can not be hashed 
 
    Processing C:\foo\test.txt.txt 
    File C:\foo\test.txt.txt can not be hashed  
 
    Processing C:\foo\test2.txt 
    File C:\foo\test2.txt can not be hashed 
 
    Processing C:\foo\unicodefile.txt 
    sha1 hash of file C:\foo\unicodefile.txt is "3529f51d2dd9c3c45e539eee5b42b07a8b74f9f5" 
.EXAMPLE 
    PS C:\foo> ls *.txt | where {!$_.psiscontainer}| Get-Hash sha1 
    3529f51d2dd9c3c45e539eee5b42b07a8b74f9f5 
    89dd3b94d3cb7f645498925e77346aa9218d7ffe 
    2e434f1c2c16fc1060cd9f2e0226e142ea450ce4 
    3529f51d2dd9c3c45e539eee5b42b07a8b74f9f5 
.EXAMPLE 
    PS C:\foo> Get-Hash  md5 asciifile.txt -verbose:$true 
    OK - I'll be chatty 
 
    Processing asciifile.txt 
    md5 hash of file asciifile.txt is "b5fe789f9d497f8022d47f620de25499" 
.EXAMPLE 
    PS C:\foo> Get-Hash  md5 asciifile.txt 
    b5fe789f9d497f8022d47f620de25499 
#> 
function Get-Hash { 
  [CmdletBinding()] 
  param ( 
    [Parameter(Position=0, mandatory=$true)] 
    [string] $Algorithm, 
    [Parameter(Position=1, mandatory=$true, valuefrompipeline=$true)] 
    [string] $File 
  ) 
 
  begin { 
    if ($VerbosePreference.Value__ -eq 0) {$verbose=$false} else {$verbose=$true} 
    if ($verbose) {"OK - I'll be chatty";""} 
  } 
  
  process { 
    if ($verbose) { "Processing $file" } 
    $Algo=[System.Security.Cryptography.HashAlgorithm]::Create($algorithm) 
    if ($Algo) {
      $Fc = Get-Content $File 
      if ($fc.count -gt 0) { 
        $Encoding = New-Object System.Text.ASCIIEncoding 
        $Bytes = $Encoding.GetBytes($fc)     
        # Now compute hash 
        $Hash = $Algo.ComputeHash($bytes)    
        $Hashstring ="" 
        foreach ($byte in $hash) { $hashstring += $byte.tostring("x2") } 
        # pass hash string on 
        if ($verbose) { 
          "{0} hash of file {1} is `"{2}`"" -f $algorithm, $file, $hashstring 
          "" 
        } 
        else { 
         $Hashstring 
        } 
      } 
      else { 
        if ($verbose) { "File {0} can not be hashed" -f $file ; "" }  
      }
    } 
    else { 
      "Algorithm {0} not found" -f $algorithm 
    } 
  }
}