Function Install-Steam
{

    [CmdletBinding()]

    Param
    (
        # None
    )

    Begin
    {

        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Tls12,Tls13'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Steam setup..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe" -OutFile "$($env:TEMP)\SteamSetup.exe" -UseBasicParsing

        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\SteamSetup.exe")
        {
            Write-Host -NoNewline -Object "`rInstalling Steam..." -ForegroundColor Green
            Start-Process -FilePath "$($env:TEMP)\SteamSetup.exe" -ArgumentList '/S' -Wait
            Clear-Line
            Write-Host -Object "`rSteam setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install Steam as the setup file cannot be found." -ForegroundColor Red
        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\SteamSetup.exe")
        {
            Remove-Item -Path "$($env:TEMP)\SteamSetup.exe" -Force
        }
        If (Test-Path -Path "$($env:WinDir)\Users\Public\Desktop\Steam.lnk")
        {
            Remove-Item -Path "$($env:WinDir)\Users\Public\Desktop\Steam.lnk" -Force
        }

    }

}