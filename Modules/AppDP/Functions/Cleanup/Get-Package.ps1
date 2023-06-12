[CmdletBinding()]
Param
(
    #None
)

Begin
{
    Invoke-WebRequest -Uri 'http://appdp.scadic.com/10.0/11/Remove-Packages.ps1' -OutFile "$($env:TEMP)\Remove-Packages.ps1"
}

Process
{
    . "$($env:TEMP)\Remove-Packages.ps1"
}

End
{
    Start-Sleep -Seconds 1
    Remove-Item -Path "$($env:TEMP)\Remove-Packages.ps1"
}