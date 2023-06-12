Function Copy-ADGroupFromDomain
{

    <#

    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Identity",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [System.String[]] $Identity,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Filter",
            Position = 1,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $Filter,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "LDAPFilter",
            Position = 2,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $LDAPFilter,
        [Parameter(
            Mandatory = $True,
            HelpMessage = "DomainName",
            Position = 3,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $DomainName,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "OUPath",
            Position = 4,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $OUPath = (Get-ADObject -Filter "Name -Eq `"Groups`" -And (ObjectClass -Eq `"organizationalUnit`" -Or ObjectClass -Eq `"container`")" | Select-Object -ExpandProperty DistinguishedName)
    )

    Begin
    {
        $Result = [System.Collections.ArrayList]::New()
        $NewGroups = [System.Collections.ArrayList]::New()
    }#Begin

    Process
    {
        If ($Identity)
        {
            ForEach ($Id In $Identity)
            {
                $Obj = $Id | Get-ADGroup -Server $DomainName -Properties *
                [Void] $Result.Add($Obj)
            }
        }#If Identity
        ElseIf ($Filter)
        {
            $Objs = Get-ADGroup -Filter $Filter -Server $DomainName -Properties *
            ForEach ($Obj In $Objs){[Void] $Result.Add($Obj)}
        }#ElseIf Filter
        ElseIf ($LDAPFilter)
        {
            $Objs = Get-ADGroup -LDAPFilter $LDAPFilter -Server $DomainName -Properties *
            ForEach ($Obj In $Objs){[Void] $Result.Add($Obj)}
        }#ElseIf LDAPFilter
        Write-Verbose -Message "Found $($Result.Count) Groups to add"
        ForEach ($Res In $Result)
        {
            Write-Verbose -Message "Attempting to create group `"$($Res.Name)"
            $Group = New-ADGroup -Description $Res.Description -DisplayName $Res.DisplayName -GroupCategory $Res.GroupCategory -GroupScope $Res.GroupScope -Name $Res.Name -Path $OUPath -SamAccountName $Res.SamAccountName -PassThru -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            [Void] $NewGroups.Add($Group)
        }
    }#Process

    End
    {
        $Result | % {Write-Verbose -Message $_.Name; Write-Verbose -Message $($_.Members -Join "`n"); Write-Verbose -Message "`n"}
        $NewGroups | Format-Table -AutoSize
        Return $NewGroups
    }#End

}