# Setting up ETA Spot Logging
Import-Module 'Carbon'

# Create Spot directories
Install-Directory -Path 'C:\SpotLogs\LogArchive'
Install-Directory -Path 'C:\tmp'

# Setup Spot Logging Services 
Start-Process -FilePath "C:\Program Files (x86)\EPS\TCPLogging\LogSvrSvc.exe" -ArgumentList "-install" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\TCPLogging\LogWebSvrSvc.exe" -ArgumentList "-install" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\TCPLogging\LogWatcherSvc.exe" -ArgumentList "-install" -Wait 

# Setting LogWatcherSvc Registry                                                 
# Start-Process -FilePath "C:\Program Files (x86)\EPS\TCPLogging\logwatcherservice.reg" -Wait -Verbose   
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\LogWatcherSvc' -Name "TclScript" -String 'source "C:/Program Files (x86)/EPS/TCPLogging/logWatcher.tcl"'

# Setup Registry Entries with TCL    
C:\Tcl\bin\tclsh.exe 'C:\Program Files (x86)\EPS\TCPLogging\setSvcReg.tcl'
