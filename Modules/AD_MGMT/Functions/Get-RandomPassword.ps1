Function Get-RandomPassword
{

    <#

        .SYNOPSIS
        Generate a random password.

        .DESCRIPTION
        Uses a random word api hosted on heroku to generate a password.

        .PARAMETER $NumberOfWords
        Optional: Number of words to be requested for the password.

        .PARAMETER $Simplify
        Optional: Simplify the password to reduce the number of special character in the selection.

        .INPUTS
        An integer for the number of words in the password and a Switch (optional) to simplfy the password.

        .OUTPUTS
        A string of the generated password.

        .EXAMPLE
        Get-RandomPassword -NumberOfWords 2 -Simplify

        Generate a simple password of 2 words.

    #>

    [CmdletBinding()]
    Param
    (

        [Parameter(
            Mandatory = $False,
            HelpMessage = "Number of words for the password.",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [System.Int64] $NumberOfWords = 3,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Simplify password.",
            Position = 1,
            ValueFromPipeline = $False
            )
        ]
        [Switch] $Simplify

    )

    Begin
    {
        $ApiUrl = "https://random-word-api.herokuapp.com/word?number=$($NumberOfWords)"
    }

    Process
    {

    }

    End
    {

        $Words = (Invoke-WebRequest -Uri $ApiUrl | Select-Object -ExpandProperty Content).Replace('[','').Replace(']','').Replace('"','') -Split ','
        $Words = [System.Collections.ArrayList] $Words
        If ($Simplify){$Special = ".!()"}
        Else {$Special = ",./<>?!@#$%^&*()=+;:'`"[]{}\|"}
        For ($I = 0; $I -Lt $Words.Count; $I++)
        {

            $Wrd = $Words[$I]
            $RIndex = Get-Random -Minimum 0 -Maximum ($Wrd.Length - 1)
            $Wrd = $Wrd.Replace( $Wrd[$RIndex], ([System.String] $Wrd[$RIndex]).ToUpper() ) + [System.String] ($Special[(Get-Random -Minimum 0 -Maximum ($Special.Length-1))])
            $Words[$I] = $Wrd

        }
        $Words = $Words -Join "$(Get-Random -Minimum 0 -Maximum 99)-"
        $Words += "_$(Get-Random -Minimum 0 -Maximum 99)"

        Return $Words

    }
}
