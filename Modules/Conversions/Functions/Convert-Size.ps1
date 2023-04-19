Function Convert-Size
{

    <#

        .SYNOPSIS
        Convert folder/file sizes to the nearest possible size.

        .DESCRIPTION
        Convert folder/file sizes to the nearest possible size unit.

        .PARAMETER $Sizes
        Required: Array/List of sizes in Bytes to convert to nearest unit.

        .PARAMETER $DecimalPlaces
        Number of decimal places to round of to. (Default is 2)

        .INPUTS
        Array/List of sizes in Bytes.

        .OUTPUTS
        List of strings with the converted sizes.

        .EXAMPLE
        Convert-Size -Sizes 2448, 1024 -DecimalPlaces 3

        Convert 2448 and 1024 Bytes to nearest size unit.

        .EXAMPLE
        1024, 16384, 66048 | Convert-Size

        Using the pipeline to pass the parameters

    #>

    [CmdletBinding()]
    Param
    (

        [Parameter(
            Mandatory = $True,
            HelpMessage = "Size to convert.",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [Alias("Length")]
        [System.Double[]] $Sizes,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Number of decimal places.",
            Position = 1,
            ValueFromPipeline = 1
            )
        ]
        [System.Int64] $DecimalPlaces = 2

    )

    Begin
    {
        $Result = [System.Collections.Generic.List[System.String]]::New()
    }

    Process
    {
        ForEach ($Size In $Sizes)
        {
            $Count = 0
            While ($Size -Ge 1024)
            {
                $Size = ([Math]::Round($Size/1024, $DecimalPlaces))
                $Count++
            }
            Switch ($Count)
            {
                0 { $Ext = "B" };
                1 { $Ext = "KiB" };
                2 { $Ext = "MiB" };
                3 { $Ext = "GiB" };
                4 { $Ext = "TiB" };
                5 { $Ext = "PiB" };
                6 { $Ext = "EiB" };
                7 { $Ext = "ZiB" };
                8 { $Ext = "YiB" };
                Default { $Ext = "WTF!?" }
            }
            [Void] $Result.Add("$($Size) $($Ext)")
        }
    }

    End
    {
        Return $Result
    }

}