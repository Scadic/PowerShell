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

function Get-SaveFileDialog($InitDir, $DefaultExt, $Title)
{
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FileBrowser = New-Object System.Windows.Forms.SaveFileDialog
    if ($Title)
    {
        $FileBrowser.Title = $Title
    }
    if ($DefaultExt)
    {
        $FileBrowser.DefaultExt = $DefaultExt
    } else {
        $FileBrowser.DefaultExt = 'txt'
    }
    if ($InitDir)
    {
        $FileBrowser.InitialDirectory = $InitDir
    } else {
        $FileBrowser.InitialDirectory = Get-Location
    }
    [void] $FileBrowser.ShowDialog()
    while (-not $FileBrowser.FileName)
    {
        Write-Host 'No filename specified!'
        [void] $FileBrowser.ShowDialog()
    }
    return $FileBrowser.FileName
}

function Get-OpenFileDialog($InitDir, $Title)
{
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    if ($Title)
    {
        $FileBrowser.Title = $Title
    } else {
        $FileBrowser.Title = 'Open File'
    }
    if ($InitDir)
    {
        $FileBrowser.InitialDirectory = $InitDir
    } else {
        $FileBrowser.InitialDirectory = Get-Location
    }
    [void] $FileBrowser.ShowDialog()
    while (-not $FileBrowser.FileName)
    {
        Write-Host 'No filename specified!'
        [void] $FileBrowser.ShowDialog()
    }
    return $FileBrowser.FileName
}


# Select Folder to place result file.
$Path = Get-FolderDialog

# If no folder is selected from the dialog, default to C:\Temp\
if ((-not $Path) -or ($Path -eq '\'))
{
    Write-Host 'No folder selected! Defaulting to C:\Temp\'
    $Path = 'C:\Temp\'
}

# Select file with all NameServer/DNSServers
$NSes = Get-Content -Path (Get-OpenFileDialog -Title 'Open File With NameServers')
# Type in Hostname, Domain or DNSName to resolve
$DNSName = Read-Host -Prompt 'Hostname, Domain or DNSName to lookup'
# Build Path for result file
$Path += 'DNSQueryTest-' + $DNSName + '-' + (Get-Date).ToString() + '.csv'
# Create output file
Out-File -FilePath $Path
$Resolves = [System.Collections.ArrayList] @{}
$Errors = $false
$TroubleMakers = [System.Collections.ArrayList] @{}
foreach ($NS in $NSes)
{
    # Resolve $DNSName on the different servers
    try
    {
        $Resolved = Resolve-DnsName -Name $DNSName -Server $NS -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        $ResolvedAttr = $Resolved | select Server,Name,Type,TTL,Section,IPAddress
        $ResolvedAttr.Server = $NS
        $null = $Resolves.Add($ResolvedAttr)
    } catch [System.ComponentModel.Win32Exception],[System.Management.Automation.RuntimeException] {
        $Errors = $true
        $null = $TroubleMakers.Add($NS)
        $ResolvedAttr = New-Object -TypeName PSCustomObject
        $ResolvedAttr | Add-Member -MemberType NoteProperty -Name 'Server' -Value $NS
        $ResolvedAttr | Add-Member -MemberType NoteProperty -Name 'Name' -Value $DNSName
        $ResolvedAttr | Add-Member -MemberType NoteProperty -Name 'Type' -Value 'Failure'
        $ResolvedAttr | Add-Member -MemberType NoteProperty -Name 'TTL' -Value 0
        $ResolvedAttr | Add-Member -MemberType NoteProperty -Name 'Section' -Value 'ServerError'
        $ResolvedAttr | Add-Member -MemberType NoteProperty -Name 'IPAddress' -Value '0.0.0.0'
        $null = $Resolves.Add($ResolvedAttr)
    }
}

if ($Errors)
{
    # Print out list of servers that could no resolve the $DNSName
    Write-Host 'Errors were encountered during the test. Troublemakers:'
    $TroubleMakers
}

# Export the results to a csv file
$Resolves | Export-Csv -Path $Path -Encoding Unicode -NoTypeInformation
