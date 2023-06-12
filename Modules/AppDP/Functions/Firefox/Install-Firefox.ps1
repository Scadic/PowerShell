Function Install-Firefox
{

    [CmdletBinding()]

    Param
    (

        [Parameter(
            Mandatory = $False,
            HelpMessage = "Please select language.",
            Position = 0,
            ValueFromPipeline = $False
            )
        ]
        [ValidateSet(
            "en-AU",
            "en-CA",
            "en-IE",
            "en-NZ",
            "en-US",
            "nb-NO",
            "nn-NO"
            )
        ]
        [System.String] $Lang = "en-US",
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Override OS Architecture.",
            Position = 1,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $OSArch = "$(Get-WmiObject -Class "Win32_OperatingSystem" -Property "OSArchitecture" | Select-Object -ExpandProperty "OSArchitecture")"

    )

    Begin
    {

        Switch ($OSArch)
        {

            "64-bit" {$OSArch = "win64"}
            "32-bit" {$OSArch = "win"}
            "64-bit Intel" {$OSArch = "win64"}
            "64-bit AMD" {$OSArch = "win64"}
            default {$OSArch = "win64"}

        }
        
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Firefox setup..." -ForegroundColor Yellow

        Invoke-WebRequest -Uri "https://download.mozilla.org/?product=firefox-latest&os=$($OSArch)&lang=$($Lang)" -OutFile "$($env:TEMP)\FirefoxSetup.exe"
        
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line
    
        If (Test-Path -Path "$($env:TEMP)\FirefoxSetup.exe")
        {

            Write-Host -NoNewline -Object "`rInstalling Firefox..." -ForegroundColor Green
            Start-Process -FilePath "$($env:TEMP)\FirefoxSetup.exe" -ArgumentList '/StartMenuShortcuts','/DesktopShortcut=false','/TaskbarShortcut=false','/S' -Wait -WindowStyle Maximized
            Clear-Line
            Write-Host -Object "`rFirefox setup completed!" -ForegroundColor Cyan

        }
        Else
        {

            Write-Host -Object "`rUnable to install Firefox as the setup file cannot be found." -ForegroundColor Red

        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\FirefoxSetup.exe")
        {

            Remove-Item -Path "$($env:TEMP)\FirefoxSetup.exe" -Force

        }

    }

}