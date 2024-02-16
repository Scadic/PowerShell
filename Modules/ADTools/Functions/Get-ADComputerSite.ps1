Function Get-ADComputerSite
{

    <#

        .SYNOPSIS
        Get which AD Site this computer is in.

        .DESCRIPTION
        Get which AD Site this computer is in with nltest /dsgetsite.

        .PARAMETER $ComputerName
        Optional: CN/Name/SamAccountName of the AD Computer(s) to get the AD Site for

        .INPUTS
        This function accepts either a String or String[] as input.

        .OUTPUTS
        Returns a collection of the AD Site for each computer(s).

        .EXAMPLE
        Copy-ADGroupFromDomain -Identity 'ServiceAccounts' -DomainName contoso.com -OUPath 'OU=Groups,OU=contoso,DC=contoso,DC=com'

        Copy the group 'ServiceAccounts' to the Groups OU in the contoso.com domain.

        .EXAMPLE
        'Remote Users','OnPrem Users' | Copy-ADGroupFromDomain -DomainName contoso.local -OUPath 'CN=Users,DC=contoso,DC=local'

        Using pipe to send an Array of values into the function to find and create two new ADGroups.

    #>

    [CmdletBinding()]

    Param
    (
        [Parameter(
            Mandatory         = $False,
            HelpMessage       = "Which computer to run against.",
            Position          = 0,
            ValueFromPipeline = $True
            )
        ]
        [Alias("ComputerNames")]
        [System.String[]] $ComputerName = $env:COMPUTERNAME,
        [Parameter(
            Mandatory         = $False,
            HelpMessage       = "Include IP of the machine (from DNS)",
            Position          = 1,
            ValueFromPipeline = $False
            )
        ]
        [Switch] $IncludeIP
    )

    Begin 
    {
        If (-Not (Test-Path -Path "$($env:WinDir)\System32\nltest.exe"))
        {
            Return $Null
        }
        $Result = [System.Collections.ArrayList]::New()
    }

    Process
    {
        If ($ComputerName.Count -Eq 1 -And $ComputerName[0] -Eq $env:COMPUTERNAME)
        {
            $Object = [PSCustomObject]@{
                Computer = $ComputerName[0]
                Site     = (nltest /Server:"$($ComputerName[0])" /DSGetSite | findstr /i /v 'The Command ')
            }
            If ($IncludeIP){$Object | Add-Member -MemberType NoteProperty -Name IPAddress -Value $(Resolve-DnsName -Name $env:COMPUTERNAME -Type A | Select-Object -ExpandProperty IPAddress)}
            [Void] $Result.Add($Object)
        }
        Else
        {
            ForEach ($Computer In $ComputerName)
            {
                $Object = [PSCustomObject]@{
                    Computer = $Computer
                    Site     = (nltest /Server:"$($Computer)" /DSGetSite | findstr /i /v 'The Command ')
                }
                If ($IncludeIP){$Object | Add-Member -MemberType NoteProperty -Name IPAddress -Value $(Resolve-DnsName -Name $Computer -Type A | Select-Object -ExpandProperty IPAddress)}
                [Void] $Result.Add($Object)
            }
        }
    }

    End
    {
        #Return (nltest /dsgetsite | findstr /i /v 'The command')
        Return $Result
    }

}