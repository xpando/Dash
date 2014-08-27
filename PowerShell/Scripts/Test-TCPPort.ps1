param(
  [ValidateNotNullOrEmpty()]
  [string] $EndPoint = $(throw "Please specify an EndPoint (Host or IP Address)"),
  [string] $Port = $(throw "Please specify a Port") 
)

$TimeOut = 1000
$IP = [System.Net.Dns]::GetHostAddresses($EndPoint)
$Address = [System.Net.IPAddress]::Parse($IP)
$Socket = New-Object System.Net.Sockets.TCPClient
$Connect = $Socket.BeginConnect($Address,$Port,$null,$null)
if ( $Connect.IsCompleted )
{
  $Wait = $Connect.AsyncWaitHandle.WaitOne($TimeOut,$false)     
  if(!$Wait) 
  {
    $Socket.Close() 
    return $false 
  } 
  else
  {
    $Socket.EndConnect($Connect)
    $Socket.Close()
    return $true
  }
}
else
{
  return $false
}
