Function Install-Audacity
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
        [System.String] $OSArch = "$(Get-WmiObject -Class "Win32_OperatingSystem" -Property "OSArchitecture" | Select-Object -ExpandProperty "OSArchitecture")"<#,
        [Paramater(
            Mandatory = $False,
            HelpMessage = "True/False include FFmpeg for Audacity.",
            Position = 1,
            ValueFromPipeline = $False
            )
        ]
        [ValidateSet(
            $True,$False
        )]
        [System.Boolean] $IncludeFFmpeg = $True#>

    )

    Begin
    {

        Switch ($OSArch)
        {
            "64-bit" {$OSArch = "x64"}
            "32-bit" {$OSArch = "x32"}
            "64-bit Intel" {$OSArch = "x64"}
            "64-bit AMD" {$OSArch = "x64"}
            default {$OSArch = "x64"}
        }

        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12,Tls13'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Audacity setup..." -ForegroundColor Yellow
        $Uri = Invoke-WebRequest -Uri "https://www.audacityteam.org/download/windows" | Select-Object -ExpandProperty Links | Select-Object -ExpandProperty href | Where-Object -FilterScript {$_ -Match "audacity\-.{1,}\-$($OSArch)\.exe"} | Where-Object -FilterScript {$_ -NotMatch "Portable"} | Select-Object -First 1
        Invoke-WebRequest -Uri $Uri -OutFile "$($env:TEMP)\AudacitySetup.exe" -UseBasicParsing
        <#If ($IncludeFFmpeg)
        {
            Switch ($OSArch)
            {
                "x64" {$FFmpegArch = "win64"}
                "x32" {$FFmpegArch = "win32"}
            }
            $Uri = Invoke-WebRequest -Uri "https://github.com/BtbN/FFmpeg-Builds/releases/tag/latest" -Method Get -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)' | Select-Object -ExpandProperty Links | Select-Object -ExpandProperty href | Where-Object -FilterScript {$_ -Match "FFmpeg_.{1,}_$($FFmpegArch)\.exe"} | Select-Object -First 1
            Invoke-WebRequest -Uri "$($Url)/$($Uri)" -Method Get -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)' -UseBasicParsing -OutFile "$($env:TEMP)\FFmpegSetup.exe"
        }#>

        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol
    
    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\AudacitySetup.exe")
        {
            Write-Host -NoNewline -Object "`rInstalling Audacity..." -ForegroundColor Green
            Start-Process -FilePath "$($env:TEMP)\AudacitySetup.exe" -ArgumentList ('/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /MERGETASKS="!desktopicon"' -Split '\s') -Wait
            Clear-Line
            Write-Host -Object "`rAudacity setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install Audacity as the setup file cannot be found." -ForegroundColor Red
        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\AudacitySetup.exe")
        {
            Remove-Item -Path "$($env:TEMP)\AudacitySetup.exe" -Force
        }

    }

}