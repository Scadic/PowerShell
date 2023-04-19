Function Get-FioStatus
{

    <#

        .SYNOPSIS
        Show satus of Fusion IO devices.

        .DESCRIPTION
        Displays the status of Fusion IO devices.

        .PARAMETER $Name
        Optional: Search by name of the power plan.

        .PARAMETER $GUID
        Optional: Search by GUID of the power plan.

        .INPUTS
        This function accepts either a String or an Array as input.

        .OUTPUTS
        Returns the available power plans with the applied filter if any.

        .EXAMPLE
        Get-PowerPlan -Name 'Balanced'

        Show the Balanced power plan.

        .EXAMPLE
        'High performance','Ultimate performance' | Get-PowerPlan

        Using pipe to send an Array of values into the function and show the High and Ultimate performance power plans.

    #>


    [CmdletBinding()]
    Param
    (

        

    )

    Begin
    {
        $FioStatus = fio-status.exe -a
    }

    Process
    {
        For ($I = 0; $I -Lt $FioStatus.Count; $I++)
        {
             If ($FioStatus[$I] -Like "Found * VSL driver package*")
             {
                $Obj = [PSCustomObject]@{
                    DriverVersion = ($FioStatus[($I+1)] -Replace '\s{2,}', '').Replace("Storport Driv*", "");
                    Loaded = "$(($FioStatus[($I+1)] -Split ':\s')[1].ToUpper()[0]; ($FioStatus[($I+1)] -Split ':\s')[1].ToLower()[1..(($FioStatus[2] -Split ':\s')[1].Length - 1)])" -Join "" -Replace '\s' ,''
                }
                $Obj
             }
        }
    }

}