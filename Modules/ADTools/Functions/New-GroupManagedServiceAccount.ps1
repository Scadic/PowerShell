Function New-GroupManagedServiceAccount
{

    [CmdletBinding()]
    Param
    (
        [Parameter(
            Mandatory = $True,
            HelpMessage = "UserName for the MSA account.",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [System.String[]] $UserNames,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Specify custom group names.",
            Position = 1,
            ValueFromPipeline = $False
            )
        ]
        [System.String[]] $GroupNames
    )

    Begin
    {
        $Result = [System.Collections.ArrayList]::New()
    }

    Process
    {
        If ($GroupNames -And $GroupNames.Count -Ne $UserNames.Count)
        {
            $E = [System.Exception]@{Source="$($MyInvocation.PSCommandPath)"}
            "`a"
            Write-Error -Category InvalidArgument -Exception $E  -Message "The number of custom group names ($($GroupNames.Count)) does match the number of usernames ($($UserNames.Count))!"
            Return $E
        }
        $I = 0
        ForEach ($UserName In $UserNames)
        {
            # Progress
            $UserNamesLoopProgressParameters = @{
                ID                = 0
                Activity          = "Processing User: `"$($UserNames)`""
                Status            = "[$I/$($UserNames.Count)]"
                PercentComplete   = ($I/$UserNames.Count) * 100
                CurrentOperation  = "Processing users"
            }
            Write-Progress @UserNamesLoopProgressParameters
            If ($GroupNames -And $GroupNames[$I])
            {
                Write-Verbose -Message "Creating custom group `"$($GroupNames[$I])`""
                $Group = New-ADGroup -Description "Group of Computers allowed to retrieve the password for $($UserName)" -DisplayName "$($GroupNames[$I])" -GroupCategory Security -GroupScope Universal `
                -Name "$($GroupNames[$I])" -Path $(If (Get-ADOrganizationalUnit -Filter "Name -Like `"*Password Groups`""){$(Get-ADOrganizationalUnit -Filter "Name -Like `"*Password Groups`"" | Select-Object -ExpandProperty DistinguishedName)}Else{$(Get-ADOrganizationalUnit -Filter "Name -Like `"Groups`"" | Select-Object -ExpandProperty DistinguishedName)})`
                -SamAccountName "$($GroupNames[$I])" -PassThru
            }
            Else
            {
                Write-Host -Object "Creating standard group"
                $Group = New-ADGroup -Description "Group of Computers allowed to retrieve the password for $($UserName)" -DisplayName "$($UserName)_PwdGroup" -GroupCategory Security -GroupScope Universal `
                -Name "$($UserName)_PwdGroup" -Path $(If (Get-ADOrganizationalUnit -Filter "Name -Like `"*Password Groups`""){$(Get-ADOrganizationalUnit -Filter "Name -Like `"*Password Groups`"" | Select-Object -ExpandProperty DistinguishedName)}Else{$(Get-ADOrganizationalUnit -Filter "Name -Like `"Groups`"" | Select-Object -ExpandProperty DistinguishedName)})`
                -SamAccountName "$($UserName)_PwdGroup" -PassThru
            }

            If ($Group.Name)
            {
                $User = New-ADServiceAccount -PrincipalsAllowedToRetrieveManagedPassword $Group -Name $UserName -Description "gMSA Account $UserName" -Enabled $True -KerberosEncryptionType RC4,AES128,AES256 -ManagedPasswordIntervalInDays 30 -SamAccountName $UserName -TrustedForDelegation $True -PassThru
            }

            If ($Group.Name -And $User.SamAccountName)
            {
                $Obj = [PSCustomObject]@{
                    ADUser = $User;
                    ADGroup = $Group
                }
                [Void] $Result.Add($Obj)
            }

            Clear-Variable -Name Group,User -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            $I++
            # Progress
            $UserNamesLoopProgressParameters = @{
                ID                = 0
                Activity          = "Processing User: `"$($UserNames)`""
                Status            = "[$I/$($UserNames.Count)]"
                PercentComplete   = ($I/$UserNames.Count) * 100
                CurrentOperation  = "Processing users"
            }
            Write-Progress @UserNamesLoopProgressParameters
        }
    }

    End
    {
        Return $Result
    }

}