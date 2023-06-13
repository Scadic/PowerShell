<#

    Written by Truls H. Skadberg (https://github.com/Scadic)

    The functions in this can be used to setup essential applications on new and existing Windows systems.

#>

If (($PSVersionTable.PSVersion.Major -Le 2 -And $PSVersionTable.PSVersion.Minor -Le 0) -Or -Not ($PSScriptRoot))
{
    $PSScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
}

# Set FunctionPath
$FunctionPath = "$PSScriptRoot\Functions\"

# Get a list of all function file names
$FunctionList = Get-ChildItem -Path "$($PSScriptRoot)\Functions\" -Recurse -Filter "*.ps1"

# Loop over all the function files and dot source them into memory
ForEach ($Function in $FunctionList)
{

    . $($Function.FullName)

}

Export-ModuleMember -Alias * -Function *
