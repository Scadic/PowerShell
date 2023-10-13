Function Install-VLC
{

    [CmdletBinding()]

    Param
    (

        [Parameter(
            Mandatory = $False,
            HelpMessage = "Override OS Architecture.",
            Position = 0,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $OSArch = "$(Get-WmiObject -Class "Win32_OperatingSystem" -Property "OSArchitecture" | Select-Object -ExpandProperty "OSArchitecture")",
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Select a different version than last? I.e. 3.0.17.4 or 3.0.18",
            Position = 0,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $Version = '3.0.19'

    )

    Begin
    {

        Switch ($OSArch)
        {
            "64-bit" {$OSArch = "win64"}
            "32-bit" {$OSArch = "win32"}
            "64-bit Intel" {$OSArch = "win64"}
            "64-bit AMD" {$OSArch = "win64"}
            default {$OSArch = "win64"}
        }
        
        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download VLC Media Player setup..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri 'http://cdn.scadic.com/vlc/vlcrc.txt' -OutFile "$($env:TEMP)\vlcrc" -UseBasicParsing
        $Req = Invoke-WebRequest -Uri "https://download.videolan.org/pub/videolan/vlc/$($Version)/$($OSArch)"
        $Uri = "https://download.videolan.org/pub/videolan/vlc/$($Version)/$($OSArch)/$($Req.Links | Where-Object -FilterScript {$_.outerText -Like "vlc-*-$($OSArch).exe"} | Select-Object -ExpandProperty href)"
        Invoke-WebRequest -Uri $Uri -OutFile "$($env:TEMP)\VLCSetup.exe" -UseBasicParsing
        
        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\VLCSetup.exe")
        {
            Write-Host -NoNewline -Object "`rInstalling VLC Media Player..." -ForegroundColor Green
            If (-Not (Test-Path -Path "$($env:APPDATA)\vlc")){
                New-Item -ItemType Directory -Path "$($env:APPDATA)" -Name "vlc" | Out-Null
                Copy-Item -Path "$($env:TEMP)\vlcrc" -Destination "$($env:APPDATA)\vlc\vlcrc" -Force
            }
            If (-Not (Test-Path -Path "C:\Users\Default\AppData\Roaming\vlc")){
                New-Item -ItemType Directory -Path "C:\Users\Default\AppData\Roaming" -Name "vlc" | Out-Null
                Copy-Item -Path "$($env:TEMP)\vlcrc" -Destination "C:\Users\Default\AppData\Roaming\vlc\vlcrc" -Force
            }
            Start-Process -FilePath "$($env:TEMP)\VLCSetup.exe" -ArgumentList '/L=1033','/S','/NCRC','/DESKTOPSHORTCUT=0' -Wait -WindowStyle Maximized
            Clear-Line
            Write-Host -Object "`rVLC Media Player setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install VLC as the setup file cannot be found." -ForegroundColor Red
        }
        Get-ChildItem -Path "$($env:SystemDrive)\Users\*\*Desktop" -Force -Recurse -Filter "VLC**" -ErrorAction Ignore -WarningAction Ignore | Remove-Item -Force | Out-Null

    }

    End
    {

        If (Test-Path "$($env:TEMP)\VLCSetup.exe")
        {

            Remove-Item -Path "$($env:TEMP)\VLCSetup.exe" -Force

        }

    }

}