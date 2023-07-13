Function Install-Npp
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
        [System.String] $OSArch = "$(Get-WmiObject -Class "Win32_OperatingSystem" -Property "OSArchitecture" | Select-Object -ExpandProperty "OSArchitecture")"

    )

    Begin
    {

        Switch ($OSArch)
        {
            "64-bit" {$OSArch = ".x64"}
            "32-bit" {$OSArch = ""}
            "64-bit Intel" {$OSArch = ".x64"}
            "64-bit AMD" {$OSArch = ".x64"}
            default {$OSArch = ".x64"}
        }

        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Npp setup..." -ForegroundColor Yellow

        $Req = Invoke-WebRequest -Uri "https://notepad-plus-plus.org/downloads"
        $Uri = "https://notepad-plus-plus.org/downloads" + $($Req.Links | Where-Object -FilterScript {$_.outerText -Like "Current Version *"} | Select-Object -ExpandProperty href) -Replace '/downloads/downloads/','/downloads/'
        $Req = Invoke-WebRequest -Uri $Uri
        $Uri = $Req.Links | Where-Object -FilterScript {$_.outerText -Eq "Installer"} | Where-Object -FilterScript {$_.href -Like "*/npp.*.Installer$($OSArch).exe"} | Select-Object -ExpandProperty href
        Invoke-WebRequest -Uri $Uri -OutFile "$($env:TEMP)\NppSetup.exe" -UseBasicParsing

        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\NppSetup.exe")
        {
            Write-Host -NoNewline -Object "`rInstalling Npp..." -ForegroundColor Green
            Start-Process -FilePath "$($env:TEMP)\NppSetup.exe" -ArgumentList '/S' -Wait -WindowStyle Maximized
            New-Item -ItemType Directory -Path "$($env:ProgramFiles)\Notepad++" -Name themes -ErrorAction Ignore -WarningAction Ignore | Out-Null
            Invoke-WebRequest -Uri 'http://cdn.scadic.com/npp/Dracula.xml' -OutFile "$($env:ProgramFiles)\Notepad++\themes\Dracula.xml"
            Clear-Line
            Write-Host -Object "`rNpp setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install npp as the setup file cannot be found." -ForegroundColor Red
        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\NppSetup.exe")
        {

            Remove-Item -Path "$($env:TEMP)\NppSetup.exe" -Force

        }

    }

}