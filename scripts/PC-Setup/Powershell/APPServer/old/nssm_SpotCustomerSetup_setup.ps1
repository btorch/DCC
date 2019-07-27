# ETA Customer Setup
Import-Module 'Carbon'

# Setup SpotCustomerSetup Service
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList "install SpotCustomerSetup ""${env:ProgramFiles(x86)}\nodejs\node.exe"" server.js" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerSetup AppDirectory "C:\ETA\CustomerSetup"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerSetup AppStderr  "C:\SpotLogs\SpotCustomerSetup.log"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerSetup AppStdout  "C:\SpotLogs\SpotCustomerSetup.log"' -Wait


# Setup  C:\ETA\CustomerSetup\config.json
#
# Get Computer name and IP and append it to the file
# $ipv4=Get-IPAddress -v4 | Select-Object IPAddressToString ; $ipv4.IPAddressToString
# (Get-IPAddress -v4).IPAddressToString
#
# Then commit it back into svn (maybe)

# Setup  C:\ETA\CustomerSetup\siteNamesConfigfile.json
# Create JSON structure with details and overwrite file
#
#{
#  "publicSite" : "spot-public"
#  ,"mobileSite" : "spot-mobile"
#  ,"consoleSite" : "spot-console"
#  ,"publicSiteFileLocation" : "C:\etawww\public_base"
#  ,"mobileSiteFileLocation" : "C:\etawww\mobile_base"
#  ,"NewDayFileLocation" : "C:\Program Files (x86)\EPS\NewDay\FilesToRename.txt"
#  ,"ServicesToRestart" : "LogSvrSvc,LogWatcherSvc,LogWatcherSvc,SpotApi,AppWatcher2,SpotConsoleSvc"
#  ,"consoleService" : "SpotConsoleSvc"
#}


# Setup inbound traffic port 3000 TCP 
