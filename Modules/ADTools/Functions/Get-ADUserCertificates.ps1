Function Get-ADUserCertificates
{

    <#

        .SYNOPSIS
        Copy an AD Group from a trusted domain to the domain of this computer.

        .DESCRIPTION
        Copies AD Groups from a trusted domain to the domain that this computer is joined to.

        .PARAMETER $Identity
        Optional: CN/Name/SamAccountName of the AD group to copy

        .PARAMETER $Filter
        Optional: Filter string to search for ADGroups to copy.

        .PARAMETER $LDAPFilter
        Optional: LDAP Filter string to search for ADGroups to copy.

        .PARAMETER $DomainName
        Required: The domain name from where the group will be copied from.

        .PARAMETER $OUPath
        Optional: DN of the Container/OU where the group will be created.

        .INPUTS
        This function accepts either a String or String[] as input.

        .OUTPUTS
        Returns a collection of all the created groups.

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
            Mandatory = $True,
            HelpMessage = "ADUser",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [System.Collections.Generic.List[Microsoft.ActiveDirectory.Management.ADUser]] $ADUsers,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "What type of certificate to get",
            Position = 1,
            ValueFromPipeline = $False
            )
        ]
        [ValidateSet(
            "UserCertificate",
            "MSMQSignCertificates"
            )
        ]
        [System.String] $CertificateType = "UserCertificate"
    )

    Begin
    {
        $Result = [System.Collections.ArrayList]::New()
    }

    Process
    {
        ForEach ($ADUser In $ADUsers)
        {
            $User = $ADUser | Get-ADUser -Properties $CertificateType,DisplayName
            ForEach ($Certificate In ($User | Select-Object -ExpandProperty "$CertificateType"))
            {
                $Cert = ([System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate) | Select-Object -Property EnhancedKeyUsageList, Subject, Issuer, NotAfter, NotBefore, SerialNumber
                $Obj = [PSCustomObject]@{
                    DisplayName = $($User.DisplayName);
                    IssuedTo = $($Cert.Subject);
                    IssuedBy = $($Cert.Issuer);
                    IntendedPurpose = $($Cert.EnhancedKeyUsageList -Join '; ');
                    ExpiredData = $($Cert.NotAfter);
                    SerialNumber = $($Cert.SerialNumber);
                }
                [Void] $Result.Add($Obj)
            }
        }
    }

    End
    {
        Return $Result
    }

}