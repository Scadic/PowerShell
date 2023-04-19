Function Set-PowerPlan
{

    <#

        .SYNOPSIS
        Display the available power plans on this computer.

        .DESCRIPTION
        Displays all the available power plans on this computer.

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

    #CmdletBinding and parameter definitions
    [CmdletBinding()]
    Param
    (

        [Parameter(
            Mandatory = $False,
            HelpMessage = "Name of the power plan to search for.",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [System.Array] $PowerPlan

    )

    Begin
    {

        $Wmi = Get-WmiObject -Class Win32_OperatingSystem -Property BuildNumber,Version

        $PowerModes = (powercfg.exe -L | ? { $_ -Like "Power Scheme GUID:*" }) -Replace 'Power Scheme GUID: ',''
        $PowerPlans = $PowerModes.ForEach({
        [PSCustomObject]@{

            Name="$(($_ -split '\s{2,}')[1].Replace('(','').Replace(')','') -replace '\s{2,}|\*','')";
            GUID=$_.Split(' ')[0];
            Active=$(If ("$(($_ -split '\s{2,}')[1].Replace('(','').Replace(')','') -replace '\s{2,}','')" -Match '\*'){$True}Else{$False})
            
            }

        })
        If (-Not ($PowerPlans | ? {$_.Name -Like "*ultimate*"}) -And $Wmi.Version -Like "10.*" -And [Int]$Wmi.BuildNumber -Ge 17134)
        {
            powercfg -duplicatescheme "e9a42b02-d5df-448d-aa00-03f14749eb61"
        }

    }

    Process
    {

        ForEach ($Plan In $PowerPlan)
        {

            If ($Plan -Is [PSCustomObject])
            {
                $Selected = $PowerPlans | ? {$_.Name -Eq $Plan.Name} | Select-Object -ExpandProperty GUID
            }
            ElseIf ($Plan -Is [System.String])
            {
                $Selected = $PowerPlans | ? {$_.Name -Like "*$($Plan)*"} | Select-Object -ExpandProperty GUID
            }

        }

    }

    End
    {

        powercfg.exe /SETACTIVE "$Selected"
        $PowerModes = (powercfg.exe -L | ? { $_ -Like "Power Scheme GUID:*" }) -Replace 'Power Scheme GUID: ',''
        $PowerPlans = $PowerModes.ForEach({
        [PSCustomObject]@{

            Name="$(($_ -split '\s{2,}')[1].Replace('(','').Replace(')','') -replace '\s{2,}|\*','')";
            GUID=$_.Split(' ')[0];
            Active=$(If ("$(($_ -split '\s{2,}')[1].Replace('(','').Replace(')','') -replace '\s{2,}','')" -Match '\*'){$True}Else{$False})
            
            }

        })
        Return ($PowerPlans | ? {$_.Active -Eq "True"})

    }

}