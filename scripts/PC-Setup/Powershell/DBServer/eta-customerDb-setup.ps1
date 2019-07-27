# ETA Customer DB Setup
Import-Module 'Carbon'


# Checking out Customer DB Setup Files
Write-Host "$(Get-Date -format 'u') - Checking out Customer DB Setup Files"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/geoqa/Development/branches/naresh/dbserversetup C:\ETA\CustomerDbSetup

# Run “npm install” to get modules
Write-Host "$(Get-Date -format 'u') - Running npm install for Customer Setup"
cd C:\ETA\CustomerDbSetup
& ${env:ProgramFiles(x86)}\nodejs\npm install
cd $env:HOMEPATH

Start-Sleep 20



# Setup SpotCustomerDbSetup Service
Write-Host "$(Get-Date -format 'u') - Installing & Setting up SpotCustomerDbSetup Service"
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList "install SpotCustomerDbSetup ""${env:ProgramFiles(x86)}\nodejs\node.exe"" index.js" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerDbSetup AppDirectory "C:\ETA\CustomerDbSetup"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerDbSetup AppStderr  "C:\SpotLogs\SpotCustomerDbSetup.log"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerDbSetup AppStdout  "C:\SpotLogs\SpotCustomerDbSetup.log"' -Wait



# Setup  C:\ETA\CustomerDbSetup\config.json
#
# Get Computer name and IP and append it to the file
# $ipv4=Get-IPAddress -v4 | Select-Object IPAddressToString ; $ipv4.IPAddressToString
# (Get-IPAddress -v4).IPAddressToString
#
Write-Host "$(Get-Date -format 'u') - Setting up Customer DB Setup config.json file"
$jsconfig = "C:\ETA\CustomerDbSetup\config.json"
$jsconfig_tmp = "C:\ETA\CustomerDbSetup\config.json.tmp"
.{
"`{"
"`"$env:DB_SERVER_NAME`" : `"$env:APP_SERVER_IP`","
Get-Content -Path $jsconfig | Select-Object -Skip 1
} | Set-Content $jsconfig_tmp
copy -Path $jsconfig_tmp -Destination $jsconfig -Force
del -Path $jsconfig_tmp

Start-Sleep 5


# Start SpotCustomerDbSetup Service
Write-Host "$(Get-Date -format 'u') - Starting SpotCustomerDbSetup Service"
Start-Process -FilePath C:\Windows\System32\net.exe -ArgumentList 'start SpotCustomerDbSetup'


