function Get-FolderDialog($InitDir, $Title)
{
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $DirBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $DirBrowser.RootFolder = 'MyComputer'
    if ($InitDir)
    {
        $DirBrowser.SelectedPath = $InitDir
    } else {
        $DirBrowser.SelectedPath = Get-Location
    }
    [void] $DirBrowser.ShowDialog()
    while (-not $DirBrowser.SelectedPath)
    {
        Write-Host 'No folder specified!'
        [void] $DirBrowser.ShowDialog()
    }
    return $DirBrowser.SelectedPath + '\'
}

function Add-ListArguments()
{
    $List = [System.Collections.ArrayList] @{}
    do
    {
        $Arg = Read-Host -Prompt 'Name to add'
        [void] $List.Add($Arg)
    } while ($Arg)
    $List = $List.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
    $List = [System.Array] $List
    return $List
}

function Get-DNSServerZones($ServerName, $ZoneName)
{
    $Zones = [System.Collections.ArrayList] @{}
    $DNSZones = Get-DnsServerZone -ComputerName BGO-INFRA168
    foreach ($DNSZone in $DNSZones)
    {
        if ($DNSZone.ZoneName -Like "*$ZoneName*")
        {
            $Zone = $DNSZone | Select-Object -Property *
            [void] $Zones.Add($Zone)
        }
    }
    return $Zones
}

function Set-DNSServerCFMasterServers($ServerName, $Zones, $MasterServers)
{
    $ZoneSets = [System.Collections.ArrayList] @{}
    foreach ($Zone in $Zones)
    {
        $ZoneSet = Set-DnsServerConditionalForwarderZone -Name $Zone.ZoneName -ComputerName $ServerName -MasterServers $MasterServers -PassThru
        $ZoneSet = $ZoneSet | Select-Object -Property *
        [void] $ZoneSets.Add($ZoneSet)
    }
    return $ZoneSets
}

# Main Block

# Get ServerName to do the operation on
$ServerName = Read-Host -Prompt 'DNS Server name'

# Search for specific DNS name i.e. google.com will be searched as "*google.com*"
$ZoneName = Read-Host -Prompt 'Zone Name to search for'

# Add IP addresses for the Conditional Forwarders Master Servers
$MasterServers = Add-ListArguments

# Build Paths for csv files
$Path = (Get-FolderDialog -InitDir 'C:\' -Title 'Select folder for result file.')
$Path1 = $Path + "Pre-$ZoneName-MasterServers-" + (Get-Date).ToString() + '.csv'
$Path2 = $Path + "Post-$ZoneName-MasterServers-" + (Get-Date).ToString() + '.csv'

# Get The Zones with a ZoneName like $ZoneName
Write-Host "Searching DNS Server: $ServerName for zones like $ZoneName please be patient..."
$DNSZones = Get-DNSServerZones -ServerName $ServerName -ZoneName $ZoneName
# Set MasterServers property of all zones in $DNSZones
$PostSet = Set-DNSServerCFMasterServers -ServerName $ServerName -Zones $DNSZones -MasterServers $MasterServers

# Export Results to csv files
$DNSZones | Export-Csv -Path $Path1 -Encoding Unicode -NoTypeInformation
$PostSet | Export-Csv -Path $Path2 -Encoding Unicode -NoTypeInformation

$DNSZones
