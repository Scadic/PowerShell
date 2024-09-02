Function Get-RandomCharacters
{

    <#

        .SYNOPSIS
        Generate a random string.

        .DESCRIPTION
        Uses a selection of characters from a string to generate a random string/password.

        .PARAMETER $Length
        Length of the string/password.

        .PARAMETER $Characthers
        Optional: A string of all the characters available in the selection.

        .INPUTS
        An integer for the number of characters in the string/password and a string of all the characters to be available in the selection.

        .OUTPUTS
        A string of the length specified.

        .EXAMPLE
        Get-RandomCharacters -Length 20

        Generate a string of length 20.

    #>

    [CmdletBinding()]
    Param
    (

        [Parameter(
            Mandatory = $False,
            HelpMessage = "NumberOfCharacters",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [System.Int64] $Length = 16,

        [Parameter(
            Mandatory = $False,
            HelpMessage = "Which characters to use.",
            Position = 1,
            ValueFromPipeline = $False
        )
        ]
        [System.String] $Characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`~!@#$%^&*()-_=+[]{}\|"/?.,<>;:'

    )

    Begin
    {

    }

    Process
    {

    }

    End
    {
        $Random = 1..$Length | ForEach-Object {
            Get-Random -Maximum $Characters.Length
        }
        $Private:ofs=""
        Return [String]$Characters[$Random]
    }
}
