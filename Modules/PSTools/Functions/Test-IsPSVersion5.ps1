Function Test-IsPSVersion5
{

    <#

        .SYNOPSIS
        Test if the version of the current PowerShell session is Version 5.

        .DESCRIPTION
        Test if the version of the current PowerShell session is Version 5.

        .PARAMETER $MinorVersion
        Specify Minor version(s) of PowerShell v5.x, default is 1.

        .INPUTS
        None

        .OUTPUTS
        Boolean

        .EXAMPLE
        Test-IsPSVersion4

        Run the test to check if the version is v5.1

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
        [System.Int64] $MinorVersion = 1

    )

    Begin
    {

    }

    Process
    {

    }

    End
    {
        Return ($PSVersionTable.PSVersion.Major -Eq 5 -And $PSVersionTable.PSVersion.Minor -Eq $MinorVersion)
    }

}