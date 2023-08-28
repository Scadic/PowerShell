Function Install-MSEdge
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
            "64-bit" {$OSArch = "X64"}
            "32-bit" {$OSArch = "X86"}
            "64-bit Intel" {$OSArch = "X64"}
            "64-bit AMD" {$OSArch = "X64"}
            default {$OSArch = "X64"}
        }

        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12,Tls13'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Edge setup..." -ForegroundColor Yellow
        If ($OSArch -Eq "X64"){Invoke-WebRequest -Uri "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/d91317ab-96f4-46b7-a048-4762507d8713/MicrosoftEdgeEnterprise$($OSArch).msi" -OutFile "$($env:TEMP)\EdgeSetup.msi" -UseBasicParsing}
        ElseIf ($OSArch -Eq "X86"){Invoke-WebRequest -Uri "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/a3c2f2d4-e553-4ea6-830d-24f0d80d384a/MicrosoftEdgeEnterprise$($OSArch).msi" -OutFile "$($env:TEMP)\EdgeSetup.msi" -UseBasicParsing}

        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line
        
        If (Test-Path -Path "$($env:TEMP)\EdgeSetup.msi")
        {
            Write-Host -NoNewline -Object "`rInstallin Edge..." -ForegroundColor Green
            Start-Process -FilePath "$($env:WinDir)\System32\msiexec.exe" -ArgumentList '/i',"$($env:TEMP)\EdgeSetup.msi",'DONOTCREATEDESKTOPSHORTCUT=true','DONOTCREATETASKBARSHORTCUT=true','/qn' -Wait
            Clear-Line
            Write-Host -Object "`rEdge setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install Edge as the setup file cannot be found." -ForegroundColor Red
        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\EdgeSetup.msi")
        {
            Remove-Item -Path "$($env:TEMP)\EdgeSetup.msi" -Force
        }

    }

}