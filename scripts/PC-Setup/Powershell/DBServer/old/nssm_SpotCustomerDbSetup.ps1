# ETA Customer Setup
Import-Module 'Carbon'

# Setup SpotCustomerDbSetup Service
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList "install SpotCustomerDbSetup ""${env:ProgramFiles(x86)}\nodejs\node.exe"" index.js" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerDbSetup AppDirectory "C:\ETA\CustomerDbSetup"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerDbSetup AppStderr  "C:\SpotLogs\SpotCustomerDbSetup.log"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerDbSetup AppStdout  "C:\SpotLogs\SpotCustomerDbSetup.log"' -Wait


# Start SpotCustomerDbSetup Service
Start-Process -FilePath C:\Windows\System32\net.exe -ArgumentList 'start SpotCustomerDbSetup'

# Setup  C:\ETA\CustomerDbSetup\config.json
#
# Get Computer name and IP and append it to the file
# $ipv4=Get-IPAddress -v4 | Select-Object IPAddressToString ; $ipv4.IPAddressToString
# (Get-IPAddress -v4).IPAddressToString
#
# Then commit it back into svn (maybe)

