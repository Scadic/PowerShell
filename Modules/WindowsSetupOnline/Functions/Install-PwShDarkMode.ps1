Function Install-PwShDarkMode
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

        Write-Host -NoNewline -Object "`rAttempting to download ColorTool setup..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waf/dracula-cmd/master/dist/ColorTool.zip" -OutFile "$($env:TEMP)\ColorTool.zip" -UseBasicParsing

        $ProgressPreference = $OldProgressPreference
        [System.Net.ServicePointManager]::SecurityProtocol = $OldSecurityProtocol

    }

    Process
    {

        Clear-Line

        If (Test-Path -Path "$($env:TEMP)\ColorTool.zip")
        {
            # Updating PSReadline
            Write-Host -NoNewline -Object "`rUpgrading PSReadline..." -ForegroundColor Green
            Start-Process -FilePath C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ArgumentList '-NoProfile','-Command "Install-Module -Name PSReadline -Force -SkipPublisherCheck -Scope AllUsers"' -Wait -WindowStyle Maximized
            Clear-Line
            Write-Host -NoNewline -Object "`rUnpacking ColorTool..." -ForegroundColor Yellow
            Expand-Archive -Path "$($env:TEMP)\ColorTool.zip" -DestinationPath "$($env:TEMP)\ColorTool"
            Clear-Line
            Write-Host -NoNewline -Object "`rInstalling ColorTool..." -ForegroundColor Green
            If (-Not (Test-Path -Path "$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\Windows PowerShell"))
            {
                New-Item -ItemType Directory -Force -Path "$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\Windows PowerShell" | Out-Null
            }
            Copy-Item -Path "$($env:TEMP)\ColorTool\ColorTool\install\*.lnk" -Destination "$($env:ALLUSERSPROFILE)\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\" -Force
            Copy-Item -Path "$($env:TEMP)\ColorTool\ColorTool\ColorTool.exe" -Destination "$($env:WinDir)\System32\" -Force
            Start-Process -FilePath "$($env:WinDir)\System32\reg.exe" -ArgumentList 'import',"$($env:TEMP)\ColorTool\ColorTool\install\Remove Default Console Overrides.reg" -Wait -WindowStyle Hidden
            Start-Process -FilePath "$($env:WinDir)\System32\ColorTool.exe" -ArgumentList '-b',"$($env:TEMP)\ColorTool\ColorTool\install\Dracula-ColorTool.itermcolors" -Wait -WindowStyle Hidden
            Clear-Line
            Write-Host -Object "`rColorTool and PwSh Dark mode setup completed!" -ForegroundColor Cyan
        }
        Else
        {
            Write-Host -Object "`rUnable to install ColorTool and PwSh Dark mode as the setup files cannot be found." -ForegroundColor Red
        }

    }

    End 
    {
        If (Test-Path -Path "$($env:TEMP)\ColorTool.zip")
        {
            Remove-Item -Path "$($env:TEMP)\ColorTool.zip" -Force
        }
        If (Test-Path -Path "$($env:TEMP)\ColorTool")
        {
            Remove-Item -Path "$($env:TEMP)\ColorTool" -Recurse -Force
        }
    }

}