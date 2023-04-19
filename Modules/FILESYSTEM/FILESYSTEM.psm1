<#

    Written By Truls Hansen Skadberg

    This code is mainly focused for FileSystem operations.
    
#>

# Set FunctionPath
$FunctionPath = $PSScriptRoot + "\Functions\"

# Get a list of all function file names
$FunctionList = Get-ChildItem -Path $FunctionPath -Name

# Loop over all the function files and dot source them into memory
foreach ($Function in $FunctionList)
{
    . ($FunctionPath + $Function)
}