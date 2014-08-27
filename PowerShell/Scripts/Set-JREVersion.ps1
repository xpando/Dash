param($version = "7")

$JAVA_HOME = Resolve-Path "$ENV:ConEmuDir\Apps\JRE$version"
$ENV:JRE_HOME = "$JAVA_HOME"
$ENV:JAVA_HOME = "$JAVA_HOME"
Add-Path @("$JAVA_HOME\bin")
