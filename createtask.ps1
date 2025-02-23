# Create a scheduled task to ensure SRM, WinRM, and WMI services are enabled
# Requires: Administrative privileges

# First, create the script content that will be executed by the scheduled task
$scriptContent = @'
# Enable WinRM
Enable-PSRemoting -Force -SkipNetworkProfileCheck
Set-Service WinRM -StartupType Automatic
Start-Service WinRM

# Enable WMI
Set-Service Winmgmt -StartupType Automatic
Start-Service Winmgmt

# Configure Windows Remote Management
winrm quickconfig -quiet
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Log the execution
$logPath = "C:\Logs\ServicesCheck.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logMessage = "$timestamp - Services check completed. WinRM and WMI services verified."

# Create log directory if it doesn't exist
if (-not (Test-Path "C:\Logs")) {
    New-Item -ItemType Directory -Path "C:\Logs"
}

Add-Content -Path $logPath -Value $logMessage
'@

# Save the script to a file
$scriptPath = "C:\Scripts\Enable-RemoteServices.ps1"

# Create Scripts directory if it doesn't exist
if (-not (Test-Path "C:\Scripts")) {
    New-Item -ItemType Directory -Path "C:\Scripts"
}

# Save the script content
Set-Content -Path $scriptPath -Value $scriptContent

# Create the scheduled task
$taskName = "Enable-RemoteServices"
$taskDescription = "Ensures WinRM and WMI services are enabled and properly configured (runs every 10 minutes)"

# Create task action
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# Create task trigger (runs every 10 minutes)
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration ([TimeSpan]::MaxValue)

# Create task principal (run with highest privileges)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Create task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName $taskName `
    -Description $taskDescription `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Force

# Verify task creation
$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($task) {
    Write-Host "Task '$taskName' created successfully" -ForegroundColor Green
    Write-Host "Schedule: Every 10 minutes" -ForegroundColor Green
    Write-Host "Script location: $scriptPath" -ForegroundColor Green
    Write-Host "Log file will be created at: C:\Logs\ServicesCheck.log" -ForegroundColor Green
} else {
    Write-Host "Failed to create task" -ForegroundColor Red
}