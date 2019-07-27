# Script for checking on some of the ETA tasks
# Sends an email out in case the task has a Disabled State
# Only for Powershell V4 and Windows 2012
#
# Task Scheduler Action Setup:
#   - Name: ETA_AllTasks_Monitor
#   - Action: Start a Program
#   - Program/Script: PowerShell.exe
#   - Add Arguments: -ExecutionPolicy Bypass  -File "C:\BU\powershell\task_monitor.ps1"
#

$eta_tasks = @("APC2 Update","CardScan Update","EPC Update","ETA_ArrivalDeparturePost","ETA_HealthMonitor","LogTablePruneTask","Newday","Resolve APC","Resolve Card Scans","SQL Server Diff Backup","SQL Sever Full Backup","Update Vehicle Engine State Summary","Update Vehicle Idle Time Summary","Update Vehicle Mileage Summary","Update Vehicle Speed Summary")

foreach ($task in $eta_tasks)
{

# Debug ...  Write-Host "TASK: $($task)"

$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $task }

if($taskExists) { 
  $task_state = Get-ScheduledTask -TaskPath "\" -TaskName "$task" | select State

# Debug ...   Write-Host "Checking : $($task)"
# Debug ...   Write-Host "State: $($task_state.State)"

  if ($task_state.State -eq "Disabled")
  {
    $MailFile = "C:\temp\task_disabled_email.txt"
    "From: support@etatransit.com" | Out-File $MailFile
    "To: alerts@etaphisystems.com" | Out-File $MailFile -Append
    "Subject: Warnning - " + $task + " is currently Disabled on $(hostname)" | Out-File $MailFile -Append
    " " | Out-File $MailFile -Append 
    "--- TASK ISSUE FOUND --- " | Out-File $MailFile -Append
    "WARNNING - " + $task + " is currently Disabled on $(hostname) ... $(date)" | Out-File $MailFile -Append
    " " | Out-File $MailFile -Append
    "." | Out-File $MailFile -Append

    cat $MailFile | C:\BU\sendmail\sendmail.exe -t
    # Debug ... cat $MailFile
  }

# Debug ... } else {
# Debug ...   Write-Host "Not Exit: $($task)"
}

}

