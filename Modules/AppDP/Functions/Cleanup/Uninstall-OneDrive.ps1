$FilePath = Get-ChildItem -Path "$($env:SystemDrive)\" -Filter "Program Files*" | Get-ChildItem -Recurse -File -Filter "OneDriveSetup.exe" -ErrorAction Ignore -WarningAction Ignore | Select-Object -First 1 | Select-Object -ExpandProperty FullName
If ($FilePath){Start-Process -FilePath $FilePath -ArgumentList '/uninstall' -Wait}
Else {Write-Host -Object "No OneDrive installation found."}