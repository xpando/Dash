param($version = "7")

$JAVA_HOME = Resolve-Path "$ENV:ConEmuDir\Apps\JDK$version"
$ENV:JRE_HOME = "$JAVA_HOME\jre"
$ENV:JAVA_HOME = "$JAVA_HOME"
Add-Path @("$JAVA_HOME\bin")
