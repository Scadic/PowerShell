function Get-FolderDialog 
{
    <#
        .SYNOPSIS
        Opens a OpenFolderDialogWindow to select a folder to use for output-files.

        .DESCRIPTION
        Open a OpenFolderDialogWindow to select a folder to use.

        .PARAMETER $InitDir
        Optional: Start directory to start browsing from

        .INPUTS
        This function does not support piping.

        .OUTPUTS
        Returns the full path of the selected folder.

        .EXAMPLE
        $Path = Get-FolderDialog -InitDir 'C:\'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [System.String]$InitDir
    )
    
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $DirBrowser = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
    $DirBrowser.RootFolder = 'MyComputer'
    if ($InitDir)
    {
        $DirBrowser.SelectedPath = $InitDir
    } else {
        $DirBrowser.SelectedPath = (Get-Location).Path
    }
    [void] $DirBrowser.ShowDialog()
    while (-Not $DirBrowser.SelectedPath)
    {
        Write-Host -Object "No folder specified!"
        [void] $DirBrowser.ShowDialog()
    }
    return $DirBrowser.SelectedPath
}