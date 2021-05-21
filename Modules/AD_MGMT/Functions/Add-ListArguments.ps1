function Add-ListArguments 
{
    <#
        .SYNOPSIS
        Adds a bunch of arguments to an ArrayList an returns it.

        .DESCRIPTION
        Continuously asks you to add arguments to an ArrayList until you just press enter.

        .PARAMETER $Prompt
        Mandatory: Prompt when running the function.

        .INPUTS
        This function does not support piping.

        .OUTPUTS
        Returns an ArrayList of the arguments provided when running.

        .EXAMPLE
        $Arguments = Add-ListArguments -Prompt 'Name(s) to add'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]        
        [System.String]$Prompt
    )
    $List = [System.Collections.ArrayList] @{}
    do
    {
        $Arg = Read-Host -Prompt $Prompt
        [void] $List.Add($Arg)
    } while ($Arg)
    $List = $List.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
    return $List
}