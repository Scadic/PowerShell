Function Install-PaintDotNet
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
            "64-bit" {$OSArch = "x64"}
            "32-bit" {$OSArch = "x86"}
            "64-bit Intel" {$OSArch = "x64"}
            "64-bit AMD" {$OSArch = "x64"}
            default {$OSArch = "x64"}
        }

        $OldProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        $OldSecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol
        $AllProtocols = [System.Net.SecurityProtocolType]'Tls12,Tls13'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

        Write-Host -NoNewline -Object "`rAttempting to download Paint.net setup..." -ForegroundColor Yellow
        If ($OSArch -Eq "x64")
        {
            $Request = [System.Net.WebRequest]::Create("https://github.com/paintdotnet/release/releases/latest")
            $Request.AllowAutoRedirect = $True
            $Resp = $Request.GetResponse()
            $Version = Split-Path $Resp.ResponseUri -Leaf
            $Uri = "https://github.com/paintdotnet/release/releases/download/$($Version)/paint.net.$($Version.SubString(1)).install.$($OSArch).zip"
            Invoke-WebRequest -Uri $Uri -OutFile "$($env:TEMP)\PaintDotNetSetup.zip" -UseBasicParsing
        }

        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\PaintDotNetSetup.zip")
        {
            Write-Host -NoNewline -Object "`rUnpacking Paint.net setup..." -ForegroundColor Yellow
            Expand-Archive -Path "$($env:TEMP)\PaintDotNetSetup.zip" -DestinationPath "$($env:TEMP)\PaintDotNet"
            Clear-Line
            Write-Host -NoNewline  -Object "`rInstallin Paint.net..." -ForegroundColor Green
            Start-Process -FilePath $(Get-ChildItem -Path "$($env:TEMP)\PaintDotNet\*.exe" -File | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName) -ArgumentList ('/auto DESKTOPSHORTCUT=0 JPGPNGBMPEDITOR=1 TGAEDITOR=1' -Split '\s') -Wait
            Clear-Line
            Write-Host -Object "`rPaint.net setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install Paint.net as the setup file cannot be found." -ForegroundColor Red
        }

    }

    End
    {

        If (Test-Path -Path "$($env:TEMP)\PaintDotNetSetup.zip")
        {
            Remove-Item -Path "$($env:TEMP)\PaintDotNetSetup.zip" -Force
        }
        If (Test-Path -Path "$($env:TEMP)\PaintDotNet")
        {
            Remove-Item -Path "$($env:TEMP)\PaintDotNet" -Recurse -Force
        }

    }

}