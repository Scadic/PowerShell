Function Install-VSCode
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
            "64-bit" {$OSArch = "-x64"}
            "32-bit" {$OSArch = ""}
            "64-bit Intel" {$OSArch = "-x64"}
            "64-bit AMD" {$OSArch = "-x64"}
            default {$OSArch = "-x64"}
        }
        
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download VSCode setup..." -ForegroundColor Yellow
        If (Get-WmiObject -Query "SELECT * FROM Win32_OperatingSystem WHERE Caption LIKE `"Microsoft Windows 7%`" OR Caption LIKE `"Microsoft Windows Server 2008 R2%`"")
        {
            Invoke-WebRequest -Uri "https://update.code.visualstudio.com/1.70.3/win32$($OSArch)/stable" -OutFile "$($env:TEMP)\VSCodeSetup.exe"
        }
        ElseIf (Get-WmiObject -Query "SELECT * FROM Win32_OperatingSystem WHERE Caption LIKE `"Microsoft Windows 10%`" OR Caption LIKE `"Microsoft Windows Server 201%`" OR Caption LIKE `"Microsoft Windows Server 202%`"")
        {
            Invoke-WebRequest -Uri "https://code.visualstudio.com/sha/download?build=stable&os=win32$($OSArch)" -OutFile "$($env:TEMP)\VSCodeSetup.exe"
        }

        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {
        
        If (Test-Path -Path "$($env:TEMP)\VSCodeSetup.exe")
        {
            Write-Host -NoNewline -Object "`rInstalling VSCode..." -ForegroundColor Green
            Start-Process -FilePath "$($env:TEMP)\VSCodeSetup.exe" -ArgumentList "/VERYSILENT","/NORESTART","TASK=addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath","/MERGETASKS=!runcode" -Wait
            Clear-Line
            Write-Host -Object "`rVSCode setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install VSCode as the setup file cannot be found." -ForegroundColor Red
        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\VSCodeSetup.exe")
        {

            Remove-Item -Path "$($env:TEMP)\VSCodeSetup.exe" -Force

        }

    }

}