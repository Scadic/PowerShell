Function Install-Discord
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
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Discord setup..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86" -OutFile "$($env:TEMP)\DiscordSetup.exe" -UseBasicParsing
        
        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\DiscordSetup.exe")
        {
            Write-Host -NoNewline -Object "`rInstalling Discord..." -ForegroundColor Green
            Start-Process -FilePath "$($env:TEMP)\DiscordSetup.exe" -ArgumentList '-s' -Wait -WindowStyle Minimized
            Clear-Line
            Write-Host -Object "`rDiscord setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install Discord as the setup file cannot be found." -ForegroundColor Red
        }
        Get-ChildItem -Path "$($env:SystemDrive)\Users\*\*Desktop" -Force -Recurse -Filter "Discord**" -ErrorAction Ignore -WarningAction Ignore | Remove-Item -Force -ErrorAction Ignore -WarningAction Ignore | Out-Null

    }

    End
    {

        If (Test-Path "$($env:TEMP)\DiscordSetup.exe")
        {

            Remove-Item -Path "$($env:TEMP)\DiscordSetup.exe" -Force

        }

    }

}