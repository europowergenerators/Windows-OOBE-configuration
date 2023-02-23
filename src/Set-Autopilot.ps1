# Setup Autopilot script
New-Item -ItemType Directory -Path 'C:\HWID' -ErrorAction SilentlyContinue | Out-Null

$manualProvisionScript = @'
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
Start-Transcript -OutputDirectory 'C:\HWID' -NoClobber -IncludeInvocationHeader

Start-Service W32Time
W32tm /resync /force
Write-Host 'Time sync DONE'

# InputLocale 0813:00000813 is the code for nl-BE:Belgium (Point)
Set-WinUserLanguageList -LanguageList nl-BE -Force
Write-Host 'Keyboard config DONE'

$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force
Install-Script -Name Get-WindowsAutopilotInfo -Force
Write-Host 'Autopilot preparation DONE'

Set-Location -Path "C:\HWID"
Get-WindowsAutopilotInfo -Online
Write-Host 'Autopilot registration DONE'

Stop-Transcript
'@
Out-File -InputObject $manualProvisionScript -FilePath 'C:\HWID\Launch-AutoPilot.ps1' -Force

# Make it run after logon
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-ExecutionPolicy Bypass -File "C:\HWID\Launch-Autopilot.ps1"'
$Trigger = New-ScheduledTaskTrigger -AtLogon
$Label = 'Manual Autopilot enrollment'
$User = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $Label -Principal $User -Settings $Settings
