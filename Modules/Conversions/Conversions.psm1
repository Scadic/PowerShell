<#

    Written by Truls H. Skadberg

    The functions in this can be used to do conversions.

#>

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
