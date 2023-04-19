Function ConvertFrom-TimeZone
{
    
    <#
        
        .SYNOPSIS
        Convert the current system time to a timezone.

        .DESCRIPTION
        Convert the current system time to a timezone.

        .PARAMETER $TimeZone
        Required: Name of the time zone to convert to.

        .PARAMETER $DateTimes
        Array/List of Date and/or Times to convert from.

        .INPUTS
        This function accepts either a String or String[] as input.

        .OUTPUTS
        Returns a collection of all the conversions made.

        .EXAMPLE
        ConvertTo-TimeZone -TimeZones 'Eastern Standard Time'

        Convert current system time to the zone Eastern Standard Time (ET, EST)

        .EXAMPLE
        'Eastern Standard Time','Central Standard Time' | ConvertTo-TimeZone

        Using pipe to send an Array of values into the function and show the High and Ultimate performance power plans.

    #>

    [CmdletBinding()]
    Param
    (

        [Parameter(
            Mandatory = $True,
            HelpMessage = "TimeZone to convert to.",
            Position = 0,
            ValueFromPipeline = $True
            )
        ]
        [ValidateSet(
            "Dateline Standard Time",
            "UTC-11",
            "Aleutian Standard Time",
            "Hawaiian Standard Time",
            "Marquesas Standard Time",
            "Alaskan Standard Time",
            "UTC-09",
            "Pacific Standard Time (Mexico)",
            "UTC-08",
            "Pacific Standard Time",
            "US Mountain Standard Time",
            "Mountain Standard Time (Mexico)",
            "Mountain Standard Time",
            "Yukon Standard Time",
            "Central America Standard Time",
            "Central Standard Time",
            "Easter Island Standard Time",
            "Central Standard Time (Mexico)",
            "Canada Central Standard Time",
            "SA Pacific Standard Time",
            "Eastern Standard Time (Mexico)",
            "Eastern Standard Time",
            "Haiti Standard Time",
            "Cuba Standard Time",
            "US Eastern Standard Time",
            "Turks And Caicos Standard Time",
            "Paraguay Standard Time",
            "Atlantic Standard Time",
            "Venezuela Standard Time",
            "Central Brazilian Standard Time",
            "SA Western Standard Time",
            "Pacific SA Standard Time",
            "Newfoundland Standard Time",
            "Tocantins Standard Time",
            "E. South America Standard Time",
            "SA Eastern Standard Time",
            "Argentina Standard Time",
            "Greenland Standard Time",
            "Montevideo Standard Time",
            "Magallanes Standard Time",
            "Saint Pierre Standard Time",
            "Bahia Standard Time",
            "UTC-02",
            "Mid-Atlantic Standard Time",
            "Azores Standard Time",
            "Cape Verde Standard Time",
            "UTC",
            "GMT Standard Time",
            "Greenwich Standard Time",
            "Sao Tome Standard Time",
            "Morocco Standard Time",
            "W. Europe Standard Time",
            "Central Europe Standard Time",
            "Romance Standard Time",
            "Central European Standard Time",
            "W. Central Africa Standard Time",
            "Jordan Standard Time",
            "GTB Standard Time",
            "Middle East Standard Time",
            "Egypt Standard Time",
            "E. Europe Standard Time",
            "Syria Standard Time",
            "West Bank Standard Time",
            "South Africa Standard Time",
            "FLE Standard Time",
            "Israel Standard Time",
            "South Sudan Standard Time",
            "Kaliningrad Standard Time",
            "Sudan Standard Time",
            "Libya Standard Time",
            "Namibia Standard Time",
            "Arabic Standard Time",
            "Turkey Standard Time",
            "Arab Standard Time",
            "Belarus Standard Time",
            "Russian Standard Time",
            "E. Africa Standard Time",
            "Volgograd Standard Time",
            "Iran Standard Time",
            "Arabian Standard Time",
            "Astrakhan Standard Time",
            "Azerbaijan Standard Time",
            "Russia Time Zone 3",
            "Mauritius Standard Time",
            "Saratov Standard Time",
            "Georgian Standard Time",
            "Caucasus Standard Time",
            "Afghanistan Standard Time",
            "West Asia Standard Time",
            "Ekaterinburg Standard Time",
            "Pakistan Standard Time",
            "Qyzylorda Standard Time",
            "India Standard Time",
            "Sri Lanka Standard Time",
            "Nepal Standard Time",
            "Central Asia Standard Time",
            "Bangladesh Standard Time",
            "Omsk Standard Time",
            "Myanmar Standard Time",
            "SE Asia Standard Time",
            "Altai Standard Time",
            "W. Mongolia Standard Time",
            "North Asia Standard Time",
            "N. Central Asia Standard Time",
            "Tomsk Standard Time",
            "China Standard Time",
            "North Asia East Standard Time",
            "Singapore Standard Time",
            "W. Australia Standard Time",
            "Taipei Standard Time",
            "Ulaanbaatar Standard Time",
            "Aus Central W. Standard Time",
            "Transbaikal Standard Time",
            "Tokyo Standard Time",
            "North Korea Standard Time",
            "Korea Standard Time",
            "Yakutsk Standard Time",
            "Cen. Australia Standard Time",
            "AUS Central Standard Time",
            "E. Australia Standard Time",
            "AUS Eastern Standard Time",
            "West Pacific Standard Time",
            "Tasmania Standard Time",
            "Vladivostok Standard Time",
            "Lord Howe Standard Time",
            "Bougainville Standard Time",
            "Russia Time Zone 10",
            "Magadan Standard Time",
            "Norfolk Standard Time",
            "Sakhalin Standard Time",
            "Central Pacific Standard Time",
            "Russia Time Zone 11",
            "New Zealand Standard Time",
            "UTC+12",
            "Fiji Standard Time",
            "Kamchatka Standard Time",
            "Chatham Islands Standard Time",
            "UTC+13",
            "Tonga Standard Time",
            "Samoa Standard Time",
            "Line Islands Standard Time"
        )]
        [System.String[]] $TimeZones,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Date/Time to convert from",
            Position = 1,
            ValueFromPipeline = $True
        )]
        [System.DateTime[]] $DateTimes = (Get-Date),
        [Parameter(
            Mandatory = $False,
            HelpMessage = "InformationLevel",
            Position = 2,
            ValueFromPipeline = $False
            )
        ]
        [ValidateSet(
            'Detailed',
            'Simple'
        )]
        [System.String] $InformationLevel = 'Simple'

    )

    Begin
    {

        $CurrentZone = ([System.TimeZone]::CurrentTimeZone).StandardName | Get-TimeZone
        $Result = [System.Collections.Generic.LinkedList[PSCustomObject]]::New()

    }

    Process
    {
    
        ForEach ($TimeZone In $TimeZones)
        {
            
            $TZ = Get-TimeZone -Id $TimeZone
            ForEach ($DateTime In $DateTimes)
            {

                $Obj = [PSCustomObject]@{
                    FromTime = $DateTime
                    Time = ( $DateTime.Add( $CurrentZone.BaseUtcOffset - ($TZ.BaseUtcOffset) ) );
                    FromTimeZone = $TimeZone;
                    TimeZone = $CurrentZone.Id
                }
                If ($InformationLevel -Eq 'Detailed')
                {
                    [Void] $Result.Add(($Obj | Select-Object -Property Time,TimeZone,FromTime,FromTimeZone))
                }
                Else
                {
                    [Void] $Result.Add(($Obj | Select-Object -Property Time,TimeZone))
                }

            }

        }

    }

    End
    {

        <#ForEach ($Res In $Result)
        {
            Write-Host -Object ($Res | Get-Date -UFormat "%Y/%m/%d %r")
        }#>
        Return $Result

    }

}