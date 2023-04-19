<#

    Written by Truls H. Skadberg

    The functions in this can be used to view and select Power Plans in Windows OSes.

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

New-Alias -Name gpwp -Value Get-PowerPlan -Description "Get list of power plans on the system." -Option AllScope
New-Alias -Name spwp -Value Set-PowerPlan -Description "Set the power plan of the system." -Option AllScope
Export-ModuleMember -Alias * -Function *
