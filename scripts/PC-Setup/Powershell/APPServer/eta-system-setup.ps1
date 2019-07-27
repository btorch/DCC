# ETA App System Setup Phase 1
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
Install-Directory -Path 'C:\etawww'
Install-Directory -Path 'C:\ETA'
Install-Directory -Path 'C:\tmp'
Install-Directory -Path 'C:\BU'



#----------------------------------------
# Checking out SVN Repos
#----------------------------------------

# Checking out SQLCMD
Write-Host "$(Get-Date -format 'u') - Checking out SQLCMD SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SQLCMD C:\ETA\SQLCMD

# Checking out nodejs SpotConsole
Write-Host "$(Get-Date -format 'u') - Checking out SpotConsole SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/mobiledevices/trunk/node.js/SpotConsole C:\etawww\spot_node

# Checking out PublicSiteWS
Write-Host "$(Get-Date -format 'u') - Checking out PublicSiteWS SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/PublicSiteWS C:\etawww\public_base

# Checking out September-PublicWS-Release mobile_base
Write-Host "$(Get-Date -format 'u') - Checking out September-PublicWS-Release mobile_base SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert  https://etatransit.svn.cloudforge.com/spot/branch/September-PublicWS-Release/mobile_base C:\etawww\mobile_base

# Checking out SpotServices (Need UAC turned off to access folders under system folders)
Write-Host "$(Get-Date -format 'u') - Checking out SpotServices SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SpotServices "C:\Program Files (x86)\EPS\SpotServices"

# Checking out TCPLogging (Need UAC turned off to access folders under system folders)
Write-Host "$(Get-Date -format 'u') - Checking out TCPLogging SVN Repository"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/tcplogger/trunk/SRC/core/TCPLogging "C:\Program Files (x86)\EPS\TCPLogging"



# -----------------------------
# Unpacking BackUp Archives 
# -----------------------------
Write-Host "$(Get-Date -format 'u') - Extracting BU Archive"
& 'C:\Program Files\7-Zip\7z.exe' x C:\Users\spot\Dropbox\ETA\Installs\BU\BU.7z -oc:\BU -y



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



# -----------------------------
# Install & Setup AppWacther2
# -----------------------------
Write-Host "$(Get-Date -format 'u') - Installing and Setting up AppWacther2"
msiexec.exe /i 'C:\Users\spot\Dropbox\ETA\Installs\AppWatcher2\AppWatcher2Setup.msi' TARGETDIR="""C:\Program Files (x86)\EPS\AppWatcher2""" /q
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\AppWatcher2\Parameters' -Name 'UserAccount' -String 'spot'



#----------------------------------
# Setup ETA Spot Console js Config
#----------------------------------
# Should get the DB IP from an Env Variable
Write-Host "$(Get-Date -format 'u') - Settting up ETA Spot Node js Config"
$jsconfig = "C:\etawww\spot_node\config\$env:COMPUTERNAME-CONF.js"
$jsconfig_contents = @"
var config = { "dbServer":"$env:DB_SERVER_IP" };
module.exports = config;
"@
$jsconfig_contents | Out-File -FilePath $jsconfig -Encoding ASCII



#----------------------------------
# Setup ETA Spot Public php Config
#----------------------------------
# Should get the DB IP from an Env Variable
Write-Host "$(Get-Date -format 'u') - Settting up ETA Spot Public php Config"
$phpconfig = "C:\etawww\public_base\etaphi\config\$env:COMPUTERNAME-CONF.php"
$phpconfig_contents = @"
<?php
// use this to set server specific config.
$appDBServer = "$env:DB_SERVER_IP";
?>
"@
$phpconfig_contents | Out-File -FilePath $phpconfig -Encoding ASCII



#----------------------------------
# Install & Setup ETA Spot Logging
#----------------------------------

# Install Spot Logging Services 
Write-Host "$(Get-Date -format 'u') - Installing Spot TCPLogging Services (LogSvrSvc, LogWebSvrSvc, LogWatcherSvc)"
Start-Process -FilePath "C:\Program Files (x86)\EPS\TCPLogging\LogSvrSvc.exe" -ArgumentList "-install" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\TCPLogging\LogWebSvrSvc.exe" -ArgumentList "-install" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\TCPLogging\LogWatcherSvc.exe" -ArgumentList "-install" -Wait 

# Setting LogWatcherSvc Service Registry
Write-Host "$(Get-Date -format 'u') - Setting LogWatcherSvc Service Registry"
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\LogWatcherSvc' -Name "TclScript" -String 'source "C:/Program Files (x86)/EPS/TCPLogging/logWatcher.tcl"'

# Setting up other Spot Log Registry Entries with TCL
Write-Host "$(Get-Date -format 'u') - Setting other Spot Log Registry Entries with TCL script"
C:\Tcl\bin\tclsh.exe 'C:\Program Files (x86)\EPS\TCPLogging\setSvcReg.tcl'



#-----------------------------
# Setting up Scheduled Tasks
#-----------------------------
Write-Host "$(Get-Date -format 'u') - Setting up Check SPOT Services & Newday Scheduled Tasks"
$spotcreds = New-Credential -User "spot" -Password "sp0tAdm1n"
Install-ScheduledTask -Name "Check SPOT Services" -TaskXmlFilePath "C:\ETA\SQLCMD\Check SPOT Services.xml" -TaskCredential $spotcreds -Wait
Install-ScheduledTask -Name "Newday" -TaskXmlFilePath "C:\ETA\SQLCMD\Newday.xml" -TaskCredential $spotcreds -Wait


