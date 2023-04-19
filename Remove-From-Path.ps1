$OldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path').Path
($OldPath).Split(';')
$Rem = Read-Host -Prompt 'What element of PATH do you want to remove?'
while (-Not $Rem -Or (-Not $OldPath.Split(';').Contains($Rem)))
{
	$Rem = Read-Host -Prompt 'What element of PATH do you want to remove?'
}
$Rem = ';' + $Rem
$NewPath = $OldPath.Replace($Rem, '')
$Result = Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path' -Value $NewPath -PassThru
($Result.Path).Split(';')