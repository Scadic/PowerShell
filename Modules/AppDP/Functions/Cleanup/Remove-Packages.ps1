[CmdletBinding()]
Param
(
    [Parameter(
        Mandatory = $False,
        HelpMessage = "Path to AppxPackages.",
        Position = 0,
        ValueFromPipeline = $True
        )
    ]
    [System.String] $Path = "$($PSScriptRoot)\AppxPackages.txt"
)

Begin
{
    If (-Not (Test-Path -Path "$($PSScriptRoot)\AppxPackages.txt"))
    {
        $Packages = Invoke-RestMethod -Method Get -Uri 'http://appdp.scadic.com/10.0/11/AppxPackages.txt'
        If ($Packages.Length -Gt 0)
        {
            $Packages = $Packages -Split '\n'
        }
    }
    Else
    {
        $Packages = Get-Content -Path $Path
    }
}

Process
{
    ForEach ($Package In $Packages)
    {
        Write-Host -Object "Attempting to remove: $Package"
        Get-AppxPackage -Name $Package -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Remove-AppxPackage -AllUsers -Confirm:$False -ErrorAction Continue -WarningAction Continue
    }
}

End
{

}