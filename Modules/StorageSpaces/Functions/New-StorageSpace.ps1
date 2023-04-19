Function New-StorageSpace
{

    <#

        .SYNOPSIS
        TODO

        .DESCRIPTION
        TODO

        .PARAMETER $
        TODO

        .INPUTS
        TODO

        .OUTPUTS
        TODO

        .EXAMPLE
        TODO

    #>

    [CmdletBinding(SupportsShouldProcess = $True)]
    Param
    (
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Select disks to use for the Storage Pool",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [CimInstance[]] $Disks, # Disk objects to use in the Storage Pool
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Name of the Storage Pool",
            Position = 1,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $StoragePoolName = "My Storage Pool", # Name of the Storage Pool
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Name the Tiered Virtual Disk",
            Position = 2,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $TieredDiskName = "My Tiered VirtualDisk", # Name of the Tiered Disk
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Name the HDD Tier",
            Position = 3,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $HDDTierName = "HDDTier", # HDD Tier Name
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Name the SSD Tier",
            Position = 4,
            ValueFromPipeline = $False
            )
        ]
        [System.Object[]] $SSDTierName = "SSDTier", # SSD Tier Name
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Select  a Drive Tier Resiliency level",
            Position = 5,
            ValueFromPipeline = $False
            )
        ]
        [ValidateSet(
                'Simple',
                'Mirror',
                'Parity'
            )
        ]
        [System.String] $DriveTierResiliency = 'Mirror', # Drive Tier Resiliency, RAID level (Simple=RAID0),(Mirror=RAID1),(Parity=RAID5|RAID6)
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Drive letter to assign to the Tiered Virtual Disk",
            Position = 6,
            ValueFromPipeline = $False
            )
        ]
        [ValidateScript(
            {
                (Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Name) -INotContains $_ -And $_.Length -Eq 1
            })
        ]
        [System.String] $TieredDriveLetter, # Drive letter to use for the Tiered Drive
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Label for the Tiered Virtual Drive",
            Position = 7,
            ValueFromPipeline = $False
            )
        ]
        [System.String] $TieredDriveLabel = "StorageDrive", # Label for the Tiered Drive
        # Override the default sizing here, useful if you have two different size SSDs or HDDs. Set to smallest of the pair.
        # SSD: cache, HDD: data
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Set usable disk space ratio [0.01, 1.00]",
            Position = 8,
            ValueFromPipeline = $False
            )
        ]
        [Float] $UsableSpace = 0.99, # Drives cannot always be fully allocated - probably broken for drives < 10 GiB
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Set size of the HDD tier",
            Position = 9,
            ValueFromPipeline = $False
            )
        ]
        $HDDTierSize = $Null, # Set to Null so copy/paste to command prompt doesn't have previous run values
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Set size of the SSD tier",
            Position = 10,
            ValueFromPipeline = $False
            )
        ]
        $SSDTierSize = $Null, # Set to Null so copy/paste to command prompt doesn't have previous run values
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Select storage sub system",
            Position = 11,
            ValueFromPipeline = $False
            )
        ]
        [CimInstance] $StorSubSysName = (Get-StorageSubSystem) # 
    )

    Begin
    {
        $PhysicalDisks = [System.Collections.Generic.List[CimInstance]]::New()
        $NewPool = New-Object -TypeName Object
    }

    Process
    {
        ForEach ($Disk In $Disks)
        {
            [Void] $PhysicalDisks.Add($Disk)
        }
        #$DisksToChange | Format-Table -AutoSize -Property FriendlyName, OperationalStatus, Size, MediaType #| Write-Host -ForegroundColor Green -BackgroundColor DarkMagenta
        $NewPool = New-StoragePool -StorageSubSystemFriendlyName $($StorSubSysName.FriendlyName) -FriendlyName $StoragePoolName -PhysicalDisks $PhysicalDisks 
        $NewPoolDisks = Get-StoragePool -FriendlyName $StoragePoolName | Get-PhysicalDisk
        $NewPool | Set-ResiliencySetting -Name $DriveTierResiliency -AutoNumberOfColumns
        # Create 2 storage tiers
        $HDDTier = New-StorageTier -StoragePoolFriendlyName $StoragePoolName -FriendlyName $HDDTierName -MediaType HDD
        $SSDTier = New-StorageTier -StoragePoolFriendlyName $StoragePoolName -FriendlyName $SSDTierName -MediaType SSD

        
    }

    End
    {
        Return $PhysicalDisks
    }

}