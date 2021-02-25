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
    return $List
}


$ServerName = Read-Host -Prompt 'DNS Server name'
$List = Add-ListArguments
$DNSRecords = [System.Collections.ArrayList] @{}
$Zone = Read-Host -Prompt 'What is the name of the zone?'
foreach ($Arg in $List)
{
    $Data = Read-Host -Prompt "What is the data for $Arg"
    $DNSEntry = New-Object -TypeName PSCustomObject
    $DNSEntry | Add-Member -MemberType NoteProperty -Name 'Name' -Value $Arg
    $DNSEntry | Add-Member -MemberType NoteProperty -Name 'Data' -Value $Data
    [void] $DNSRecords.Add($DNSEntry)
}


$AddedRecords = [System.Collections.ArrayList] @{}
foreach ($DNSEntry in $DNSRecords)
{
    $Result = Add-DnsServerResourceRecordA -ComputerName $ServerName -Name $DNSEntry.Name -IPv4Address $DNSEntry.Data -ZoneName $Zone -TimeToLive 01:00:00 -PassThru
    [void] $AddedRecords.Add($Result)
}


$Path = Get-FolderDialog

if ((-not $Path) -or ($Path -eq '\'))
{
    Write-Host 'No folder selected! Defaulting to C:\Temp\'
    $Path = 'C:\Temp\'
}
$Path += 'DNSRecordAdded-' + (Get-Date).ToString() + '.csv'
Out-File -FilePath $Path
$AddedRecords | Export-Csv -Path $Path -Encoding Unicode -NoTypeInformation
