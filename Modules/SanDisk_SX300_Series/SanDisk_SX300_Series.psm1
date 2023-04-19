<#

    Written by Truls H. Skadberg

    The functions in this can be used to view and select Power Plans in Windows OSes.

#>

If (Test-Path -Path "$env:ProgramFiles\Common Files\VSL Utils\fio-*.exe")
{

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

}
Else
{

    $E = [System.Exception]@{Sourve = "$($MyInvocation.PSCommandPath)"}
    Write-Error -Category ReadError -Message "Fio System util not found in `"$env:ProgramFiles\Common Files\VSL Utils`"" -Exception $E

}