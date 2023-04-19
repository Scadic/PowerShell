Function Get-ADPasswordExpiryDate
{

    <#
        
        .SYNOPSIS
        Get the computed AD Account Password expiry date.

        .DESCRIPTION
        Get the computed Active Directory Account Password expiry date.

        .PARAMETER $UserName
        Required: Name of the time zone to convert to.

        .INPUTS
        This function accepts either a String or String[] as input.

        .OUTPUTS
        Returns a collection of all the password expiry dates.

        .EXAMPLE
        Get-ADPasswordExpiryDate -UserName Administrator

        Get password expiry date for Administrator

        .EXAMPLE
        'Administrator','john' | Get-ADPasswordExpiryDate

        Using pipe to send an Array of values into the function and get password expiry dates for 2 users.

    #>

    [CmdletBinding()]
    Param
    (
        
        [Parameter(
            Mandatory = $False,
            HelpMessage = "UserName(s) to check.",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [Alias("SamAccountName")]
        [System.String[]] $UserName = $env:USERNAME

    )

    Begin
    {
        $Result = [System.Collections.Generic.List[PSCustomObject]]::New()
    }

    Process 
    {
        $I = 0
        ForEach ($User In $UserName)
        {
            # Progress
            $UserLoopProgressParameters = @{
                Activity          = "Processing User: `"$($User.SamAccountName)`""
                Status            = "[$I/$($UserName.Count)]"
                PercentComplete   = ($I/$UserName.Count) * 100
                CurrentOperation = "Processing users"
                ID                = 0
            }
            Write-Progress @UserLoopProgressParameters

            # Process
            Write-Verbose -Message "UserName: $User"
            $ADUser = Get-ADUser -Filter "SamAccountName -Like `"$($User)`"" -Properties PasswordLastSet,'msDS-UserPasswordExpiryTimeComputed'
            If ($ADUser)
            {
                $Obj = @{
                    SamAccountName = $ADUser.SamAccountName;
                    PasswordLastSet = $ADUser.PasswordLastSet;
                    PasswordExpiryDate = [DateTime]::FromFileTime($ADUser.'msDS-UserPasswordExpiryTimeComputed')
                }
                [Void] $Result.Add($Obj)
                Clear-Variable -Name ADUser
            }

            # Update Progress
            $I++
            $UserLoopProgressParameters = @{
                Activity          = "Processing User: `"$($User.SamAccountName)`""
                Status            = "[$I/$($UserName.Count)]"
                PercentComplete   = ($I/$UserName.Count) * 100
                CurrentOperation = "Processing users"
                ID                = 0
            }
            Write-Progress @UserLoopProgressParameters
        }
    }

    End
    {
        Return $Result
    }

}