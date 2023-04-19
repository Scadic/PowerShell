Function Test-IsPSVersion3
{

    <#

        .SYNOPSIS
        Test if the version of the current PowerShell session is Version 3.

        .DESCRIPTION
        Test if the version of the current PowerShell session is Version 3.

        .PARAMETER $MinorVersion
        Specify Minor version(s) of PowerShell v3.x, default is 0.

        .INPUTS
        None

        .OUTPUTS
        Boolean

        .EXAMPLE
        Test-IsPSVersion3

        Run the test to check if the version is v3.0

    #>

    [CmdletBinding()]

    Param
    (
        
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Specify minor version.",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [ValidateScript(
            {
                $_ -Is [System.Int16] -Or $_ -Is [System.Int32] -Or $_ -Is [System.Int64] -Or $_ -Is [System.Double]
            })
        ]
        [System.Int64] $MinorVersion = 0

    )

    Begin
    {

    }

    Process
    {

    }

    End
    {
        Return ($PSVersionTable.PSVersion.Major -Eq 3 -And $PSVersionTable.PSVersion.Minor -Eq $MinorVersion)
    }

}