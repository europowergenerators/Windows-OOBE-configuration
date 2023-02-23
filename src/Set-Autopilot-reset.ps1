# Setup Autopilot script
New-Item -ItemType Directory -Path 'C:\scripts' -ErrorAction SilentlyContinue | Out-Null

$manualProvisionScript = @'
# REF; https://techcommunity.microsoft.com/t5/windows-deployment/factory-reset-windows-10-without-user-intervention/m-p/1349038/highlight/true#M559
$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_RemoteWipe"
$methodName = "doWipeMethod"

$session = New-CimSession

$params = New-Object Microsoft.Management.Infrastructure.CimMethodParametersCollection
$param = [Microsoft.Management.Infrastructure.CimMethodParameter]::Create("param", "", "String", "In")
$params.Add($param)

$instance = Get-CimInstance -Namespace $namespaceName -ClassName $className -Filter "ParentID='./Vendor/MSFT' and InstanceID='RemoteWipe'"
# This method HAS TO RUN AS SYSTEM!
$session.InvokeMethod($namespaceName, $instance, $methodName, $params)
'@
Out-File -InputObject $manualProvisionScript -FilePath 'C:\scripts\AutoPilot-reset.ps1' -Force

# Wrap script in task
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-ExecutionPolicy Bypass -File "C:\scripts\Autopilot-reset.ps1"'
$Label = 'Autopilot reset'
$Settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries
Register-ScheduledTask -Action $Action -TaskName $Label -User "NT AUTHORITY\SYSTEM" -Settings $Settings

# Create task shortcut, less clicks required
$ShortcutPath = [Environment]::GetFolderPath('CommonDesktopDirectory') + '\Click to RESET.lnk'
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = 'C:\Windows\System32\schtasks.exe'
$shortcut.Arguments = "/run /tn `"${Label}`""
$shortcut.Save()

# Set the "Run as administrator" bit
# Required because executing tasks that the user doesn't own is forbidden
$bytes = [System.IO.File]::ReadAllBytes($ShortcutPath)
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes($ShortcutPath, $bytes)