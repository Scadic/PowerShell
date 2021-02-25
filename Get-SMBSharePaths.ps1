$MediaExt = ".flac",".mp3",".wav"

function Loop-Directory($Path)
{
    $Children = Get-ChildItem -Path $Path
    foreach ($Child in $Children)
    {
        $ChildPath = $Path + '\' + $Child.ToString()
        if ((Get-Item -Path $ChildPath) -is [System.IO.DirectoryInfo])
        {
            Loop-Directory -Path $ChildPath
        }
        $ChildPathExt = Get-Item $ChildPath | select Extension
        foreach ($Ext in $MediaExt)
        {
            if ($ChildPathExt.Extension -ieq $Ext.ToLower())
            {
                #$ChildPath
                $SMBString = Get-SMBString -Path $ChildPath
                Build-PlaylistFile -CacheMs '750' -SMBPath $SMBString -File $File
            }
        }
    }
}

function Get-SMBString($Path)
{
    $PathCollection = $Path.Split('\', [System.StringSplitOptions]::RemoveEmptyEntries)
    $SMBPath = 'smb:/'
    foreach ($PathElement in $PathCollection)
    {
        $SMBPath += '/' + $PathElement
    }
    return $SMBPath
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

function Build-PlaylistFile($CacheMs, $SMBPath, $File)
{
    if (-not $CacheMs)
    {
        $Cache = '#EXTVLCOPT:network-caching=750'
    } else {
        $Cache = '#EXTVLCOPT:network-caching=' + $CacheMs.ToString()
    }
    $EXTINF = '#EXTINF'
    Add-Content -Value $EXTINF -Path $File -Encoding UTF8 -PassThru
    Add-Content -Value $Cache -Path $File -Encoding UTF8 -PassThru
    Add-Content -Value $SMBPath -Path $File -Encoding UTF8 -PassThru
}

$ServerName = Read-Host -Prompt 'Server Name for the share'
$ShareName = Read-Host -Prompt 'Share Name'
$OldLocation = Get-Location
$Path = '\\' + $ServerName + '\' + $ShareName
$File = Get-SaveFileDialog -DefaultExt 'm3u8' -Title 'Save m3u8 playlist file'
Out-File -FilePath $File
Loop-Directory -Path $Path