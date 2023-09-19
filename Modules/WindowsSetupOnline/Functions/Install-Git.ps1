Function Install-Git
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
            "64-bit" {$OSArch = "64-bit"}
            "32-bit" {$OSArch = "32-bit"}
            "64-bit Intel" {$OSArch = "64-bit"}
            "64-bit AMD" {$OSArch = "64-bit"}
            default {$OSArch = "64-bit"}
        }

        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12,Tls13'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Git setup..." -ForegroundColor Yellow
        $Uri = Invoke-WebRequest -Uri "https://git-scm.com/download/win" | Select-Object -ExpandProperty Links | Select-Object -ExpandProperty href | Where-Object -FilterScript {$_ -Match "Git\-.{3,10}\-$($OSArch)"} | Where-Object -FilterScript {$_ -NotMatch "Portable"} | Select-Object -First 1
        Invoke-WebRequest -Uri $Uri -OutFile "$($env:TEMP)\GitSetup.exe" -UseBasicParsing
        Invoke-WebRequest -Uri "http://cdn.scadic.com/git/git.inf" -OutFile "$($env:TEMP)\Git.inf" -UseBasicParsing

        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\GitSetup.exe")
        {
            Write-Host -NoNewline -Object "`rInstalling Git..." -ForegroundColor Green
            Start-Process -FilePath "$($env:TEMP)\GitSetup.exe" -ArgumentList '/VERYSILENT','/ALLUSERS','/NORESTART',"/LOADINF=$($env:TEMP)\git.inf",'/NOICIONS' -WorkingDirectory "$($env:TEMP)" -Wait
            Clear-Line
            Write-Host -Object "`rGit setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install Git as the setup as the setup file cannot be found." -ForegroundColor Red
        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\GitSetup.exe")
        {
            Remove-Item -Path "$($env:TEMP)\GitSetup.exe" -Force
        }
        If (Test-Path -Path "$($env:TEMP)\git.inf")
        {
            Remove-Item -Path "$($env:TEMP)\git.inf" -Force
        }

    }
}