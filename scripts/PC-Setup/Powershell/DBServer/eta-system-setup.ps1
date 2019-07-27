# ETA DB System Setup Phase 1
#  Note:
#    Execution Policy should have been changed already
#    http://go.microsoft.com/fwlink/?LinkID=135170
#    E.x:
#     Set-ExecutionPolicy Unrestricted
#
Import-Module 'Carbon'



#------------------------------
# ETA Directory Creation
#------------------------------
Write-Host "$(Get-Date -format 'u') - Creating ETA Initial Directories"
Install-Directory -Path "C:\Program Files (x86)\EPS"
Install-Directory -Path 'C:\SpotLogs\LogArchive'
Install-Directory -Path 'C:\ETA'
Install-Directory -Path 'C:\etawww'
Install-Directory -Path 'C:\tmp'
Install-Directory -Path 'C:\BU'



#----------------------------------------
# Checking out SVN Repos
#----------------------------------------

# Checking out SQLCMD
Write-Host "$(Get-Date -format 'u') - Checking out SQLCMD SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SQLCMD C:\ETA\SQLCMD

# Checking out SPOTWeb/WebRoot
Write-Host "$(Get-Date -format 'u') - Checking out SPOTWeb/WebRoot SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SPOTWeb/WebRoot C:\etawww\spot_base

# Checking out nodejs SpotConsole
Write-Host "$(Get-Date -format 'u') - Checking out SpotConsole SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/mobiledevices/trunk/node.js/SpotConsole C:\etawww\spot_node

# Checking out SpotServices (Need UAC turned off to access folders under system folders)
Write-Host "$(Get-Date -format 'u') - Checking out SpotServices SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SpotServices "C:\Program Files (x86)\EPS\SpotServices"

# RedGate: Checking out schema for dbConfig and customer_system databases
Write-Host "$(Get-Date -format 'u') - Checking out dbConfig SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Database/dbConfig C:\ETA\ConfigDBSchema

# RedGate: Checking out schema for dbConfig and customer_system databases
Write-Host "$(Get-Date -format 'u') - Checking out Core SQL Schema SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/tt3/trunk/SRC/Core/SQL/Schema C:\ETA\CustomerDBSchema



# -----------------------------
# Unpacking BackUp Archives
# -----------------------------
Write-Host "$(Get-Date -format 'u') - Extracting BU Archive"
& 'C:\Program Files\7-Zip\7z.exe' x C:\Users\spot\Dropbox\ETA\Installs\BU\BU.7z -oc:\BU -y

# Updating Email Templates (not sure on crash.txt & success_mail_Diff.txt)
Write-Host "$(Get-Date -format 'u') - Updating Hostnames on BU email template files"
$files = ("error_mail.txt","send_error.txt","success_mail.txt")  
ForEach ($filename in $files) { (Get-Content C:\BU\$filename).Replace("NAC03",$env:COMPUTERNAME) | Set-Content C:\BU\$filename } 



# --------------------------------------
# Install ETA TCL Libraries & TestSuite
# --------------------------------------
Write-Host "$(Get-Date -format 'u') - Installing ETA TCL Libraries & TestSuite"
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\twapi -Destination C:\Tcl\lib -Recurse
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\udp1.0.8 -Destination C:\Tcl\lib -Recurse
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\tclhttpd3.5.1 -Destination C:\Tcl\lib -Recurse
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\TestSuite -Destination 'C:\Program Files (x86)\EPS' -Recurse

# Start TestSuite - Not sure how to just open and exit
$objpid = Start-Process -FilePath 'C:\Program Files (x86)\EPS\TestSuite\TestSuiteTk.tcl' -PassThru
Start-Sleep 3
Stop-Process -InputObject $objpid



#-----------------------------
# Setting up Scheduled Tasks
#-----------------------------
# ToDo: List with For Loop
Write-Host "$(Get-Date -format 'u') - Setting up All DB Server Scheduled Tasks"
$spotcreds = New-Credential -User "spot" -Password "sp0tAdm1n"
Install-ScheduledTask -Name "APC2 Update" -TaskXmlFilePath "C:\ETA\SQLCMD\APC2 Update.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "CardScan Update" -TaskXmlFilePath "C:\ETA\SQLCMD\CardScan Update.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "EPC Update" -TaskXmlFilePath "C:\ETA\SQLCMD\EPC Update.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "ETA_ArrivalDeparturePost" -TaskXmlFilePath "C:\ETA\SQLCMD\ETA_ArrivalDeparturePost.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "ETA_HealthMonitor" -TaskXmlFilePath "C:\ETA\SQLCMD\ETA_HealthMonitor.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "LogTablePruneTask" -TaskXmlFilePath "C:\ETA\SQLCMD\LogTablePruneTask.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "Newday" -TaskXmlFilePath "C:\ETA\SQLCMD\Newday.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "SQL Server Diff Backup" -TaskXmlFilePath "C:\ETA\SQLCMD\SQL Server Diff Backup.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "SQL Server Full Backup" -TaskXmlFilePath "C:\ETA\SQLCMD\SQL Server Full Backup.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "Update Vehicle Engine State Summary" -TaskXmlFilePath "C:\ETA\SQLCMD\Update Vehicle Engine State Summary.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "Update Vehicle Idle Time Summary" -TaskXmlFilePath "C:\ETA\SQLCMD\Update Vehicle Idle Time Summary.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "Update Vehicle Mileage Summary" -TaskXmlFilePath "C:\ETA\SQLCMD\Update Vehicle Mileage Summary.xml" -TaskCredential $spotcreds
Install-ScheduledTask -Name "Update Vehicle Speed Summary" -TaskXmlFilePath "C:\ETA\SQLCMD\Update Vehicle Speed Summary.xml" -TaskCredential $spotcreds

# TBD - Stephen
# Update the files under C:\ETA\SQLCMD as necessary
#ADPdbnames.txt - Arrival Departure Post Processing
#APCdbnames.txt - APC processing
#CARDSCANdbnames.txt - Card Scan processing
#EPCdbnames.txt - EPC processing
#HMdbnames.txt - APC health check
#LTPdbnames.txt - Log Table Pruning
#VEdbnames.txt - Vehicle Engine Summary processing
#VIdbnames.txt - Vehicle Idle Summary processing
#VMdbnames.txt - Vehicle Mileage Summary processing
#VSdbnames.txt - Vehicle Speed Summary processing



