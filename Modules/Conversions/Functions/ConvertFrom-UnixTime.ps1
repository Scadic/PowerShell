Function ConvertFrom-UnixTime
{

    <#

        .SYNOPSIS
        TODO

        .DESCRIPTION
        TODO

        .PARAMETER $Time
        Unix timestamp(s) to convert to DateTime.

        .INPUTS
        A single integer or an array of integers of Unix timestamps.

        .OUTPUTS
        A single integer or an array of integers if DateTime objects.

        .EXAMPLE
        TODO

    #>

    [CmdletBinding()]
    Param
    (

        [Parameter(
            Mandatory = $True,
            HelpMessage = "TODO",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [System.Int64[]] $Time

    )

    Begin
    {

        $Result = [System.Collections.Generic.List[DateTime]]::New()

    }

    Process
    {

        ForEach ($T In $Time)
        {
            [Void] $Result.Add(([System.DateTimeOffset]::FromUnixTimeSeconds($T)).DateTime)
        }

    }

    End
    {
        
        Return $Result

    }

}