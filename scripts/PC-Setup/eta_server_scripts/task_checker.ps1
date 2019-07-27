# Script for checking on some of the ETA tasks
# Sends an email out in case the task has a Disabled State
# Only for Powershell V4 and Windows 2012
#
# The below needs to be setup first 
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  -Scope CurrentUser

$eta_tasks = @("APC2 Update","CardScan Update","EPC Update","ETA_ArrivalDeparturePost","ETA_HeatlhMonitor","LogTablePruneTask","Newday"," Resolve APC","Resolve Card Scans","SQL Server Diff Backup","SQL Sever Full Backup","Updae Vehicle Engine State Summary","Updae Vehicle Idle Time Summary","Updae Vehicle Mileage Summary","Updae Vehicle Speed Summary")

foreach ($task in $eta_tasks)
{

$task_state = Get-ScheduledTask -TaskPath "\" -TaskName "$task" | select State

if ($task_state.State -eq "Disabled")
{
$MailFile = "C:\temp\task_disabled_email.txt"
"From: support@etatransit.com" | Out-File $MailFile 
"To: btorch@gmail.com" | Out-File $MailFile -Append
"Subject: Warnning - " + $task + " is currently Disabled" | Out-File $MailFile -Append
"." | Out-File $MailFile -Append
"Warnning - " + $task + " is currently Disabled" | Out-File $MailFile -Append
"." | Out-File $MailFile -Append

cat $MailFile | C:\BU\sendmail\sendmail.exe -t 
}

}
