Invoke-WebRequest -Uri 'http://appdp.scadic.com/10.0/11/Remove-Packages.ps1' -OutFile "$($env:TEMP)\Remove-Packages.ps1"
Start-Sleep -Seconds 1
If (Test-Path -Path "$($env:TEMP)\Remove-Packages.ps1")
{
    . "$($env:TEMP)\Remove-Packages.ps1"
    Start-Sleep -Seconds 1
    Remove-Item -Path "$($env:TEMP)\Remove-Packages.ps1"
}