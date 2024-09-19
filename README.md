# PowerShell
Repo for my miscellaneous PowerShell stuff.
  
```powershell
# Get-DirectoryTree
[CmdletBinding()]

Param
(
    [Parameter(
        Mandatory = $False,
        HelpMessage = "Path",
        Position = 0,
        ValueFromPipeline = $True
        )
    ]
    [System.String[]] $Path,
    [Parameter(
        Mandatory = $False,
        HelpMessage = "Depth of Get-ChildItem",
        Position = 1,
        ValueFromPipeline = $False
        )
    ]
    [Int64] $Depth = 1
)

Begin
{
    $WhiteSpace = "   "
    $SubDirs = "¦"
    $SubDir = "+---"
    $TotalResult = [System.Collections.Generic.List[Object]]::New()
    $Location = Get-Location
}

Process
{
    $I = 0
    ForEach ($P In $Path)
    {
        # Process paths
        Set-Location -Path $P
        $Result = [System.Collections.Generic.List[String]]::New()
        [Void] $Result.Add("$(($P | Resolve-Path | Select-Object -ExpandProperty Path).Replace('Microsoft.PowerShell.Core\FileSystem::',''))\")
        $Items = Get-ChildItem -Path $P -Depth $Depth -Recurse -Directory | Sort-Object -Property FullName
        #Write-Host -Object "$SubDir$($P)"

        ForEach ($Item In $Items)
        {

            $String = ""
            #$Separators = 0
            If ($Item.Parent.FullName.Equals(((Get-Location | Select-Object -ExpandProperty Path).Replace('Microsoft.PowerShell.Core\FileSystem::',''))))
            {
                $String += "$SubDir$($Item.Name)\"
                Write-Verbose -Message "$($Item.FullName)"
            }
            ElseIf ($Item.Parent.FullName -Ne ((Get-Location | Select-Object -ExpandProperty Path).Replace('Microsoft.PowerShell.Core\FileSystem::','')))
            {
                $Count = (($Item.Parent.FullName | Resolve-Path -Relative) -Split '\\' | Measure-Object | Select-Object -ExpandProperty Count) - 1
                $String += (" $WhiteSpace" * ($Count))
                $String += "$($SubDir)$($Item.Name)\"
                Write-Verbose -Message "$($Item.FullName)"
            }
            If ("" -Ne $String){[Void] $Result.Add($String)}

        }

        # Append Result to TotalResult
        [Void] $TotalResult.Add($Result)
    }
}

End
{
    $ResultString = ""
    ForEach ($Result In $TotalResult){ForEach ($Res In $Result){Write-Verbose -Message $Res; $ResultString += "$($Res)`n"}; $ResultString += "`n"}
    $Location | Set-Location
    Return $ResultString
}
```