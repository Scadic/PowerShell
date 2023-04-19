<#

    Written by Truls H. Skadberg

    The functions in this can be used to view and select Power Plans in Windows OSes.

#>

$PSVersion = $PSVersionTable.PSVersion
If ($PSVersion.Major -Le 2 -And $PSVersion.Minor -Le 0)
{
    $PSScriptRoot = $MyInvocation.MyCommand
}

# Set FunctionPath
$FunctionPath = "$PSScriptRoot\Functions\"

# Get a list of all function file names
$FunctionList = Get-ChildItem -Path $FunctionPath -Name

# Loop over all the function files and dot source them into memory
ForEach ($Function in $FunctionList)
{

    . ($FunctionPath + $Function)

}

Export-ModuleMember -Alias * -Function *
