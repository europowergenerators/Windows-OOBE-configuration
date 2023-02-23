# Setup Autopilot script
New-Item -ItemType Directory -Path 'C:\HWID' -ErrorAction SilentlyContinue | Out-Null

$manualProvisionScript = @'
$LogFile = 'C:\HWID\autopilot-log.txt'
& {
Start-Service W32Time
W32tm /resync /force
Write-Host 'Time sync DONE'

Set-Location -Path "C:\HWID"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force
Install-Script -Name Get-WindowsAutopilotInfo -Force
Write-Host 'Preparation DONE'

Get-WindowsAutopilotInfo -Online
Write-Host 'Enrollment DONE'
} *>&1 | Tee-Object -Append -FilePath $LogFile
'@
Out-File -InputObject $manualProvisionScript -FilePath 'C:\HWID\Launch-AutoPilot.ps1' -Force

# Make it run after logon
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-ExecutionPolicy Bypass -File "C:\HWID\Launch-Autopilot.ps1"'
$Trigger = New-ScheduledTaskTrigger -AtLogon
$Label = 'Manual Autopilot enrollment'
$User = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $Label -Principal $User -Settings $Settings
