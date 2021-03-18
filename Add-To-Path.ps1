$OldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path').Path
$New = Read-Host -Prompt 'What Directory To add to PATH? (Empty selects current directory)'
if ($New)
{
    $New
} else {
    $New = (Get-Location).Path
}
$NewPath = "$OldPath;$New"
$Result = Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path' -Value $NewPath -PassThru
($Result.Path).Split(';')