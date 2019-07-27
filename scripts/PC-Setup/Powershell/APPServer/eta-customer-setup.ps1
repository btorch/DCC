# ETA Customer Setup
Import-Module 'Carbon'


# Checking out Customer Setup Files
Write-Host "$(Get-Date -format 'u') - Checking out Customer Setup Files"
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/geoqa/Development/branches/naresh/customersetup C:\ETA\CustomerSetup


# Run “npm install” to get modules
Write-Host "$(Get-Date -format 'u') - Running npm install for Customer Setup"
cd C:\ETA\CustomerSetup
& ${env:ProgramFiles(x86)}\nodejs\npm install
cd $env:HOMEPATH

Start-Sleep 5

# Setup SpotCustomerSetup Service
Write-Host "$(Get-Date -format 'u') - Installing & Setting up SpotCustomerSetup Service"
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList "install SpotCustomerSetup ""${env:ProgramFiles(x86)}\nodejs\node.exe"" server.js" -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerSetup AppDirectory "C:\ETA\CustomerSetup"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerSetup AppStderr  "C:\SpotLogs\SpotCustomerSetup.log"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotCustomerSetup AppStdout  "C:\SpotLogs\SpotCustomerSetup.log"' -Wait


Start-Sleep 5
# Setup  C:\ETA\CustomerSetup\config.json
#
# Get Computer name and IP and append it to the file
# $ipv4=Get-IPAddress -v4 | Select-Object IPAddressToString ; $ipv4.IPAddressToString
# (Get-IPAddress -v4).IPAddressToString
#
Write-Host "$(Get-Date -format 'u') - Setting up Customer Setup config.json file"
$jsconfig = "C:\ETA\CustomerSetup\config.json"
$jsconfig_tmp = "C:\ETA\CustomerSetup\config.json.tmp"
.{
"`{"
"`"$env:APP_SERVER_NAME`" : `"$env:DB_SERVER_IP`","
Get-Content -Path $jsconfig | Select-Object -Skip 1
} | Set-Content $jsconfig_tmp
copy -Path $jsconfig_tmp -Destination $jsconfig -Force
del -Path $jsconfig_tmp



Start-Sleep 5
# Setup  C:\ETA\CustomerSetup\siteNamesConfigfile.json
# Create JSON structure with details and overwrite file
Write-Host "$(Get-Date -format 'u') - Setting up Customer Setup siteNamesConfigfile.json file"
$siteconfig = "C:\ETA\CustomerSetup\siteNamesConfigfile.json"
Clear-Content -Path $siteconfig
Add-Content -Path $siteconfig -Encoding Ascii -Value "`{"
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"publicSite`" `: `"spot-public`","
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"mobileSite`" `: `"spot-mobile`","
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"consoleSite`" `: `"spot-console`","
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"publicSiteFileLocation`" `: `"public_base`","
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"mobileSiteFileLocation`" `: `"mobile_base`","
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"NewDayFileLocation`" `: `"C:\\Program Files (x86)\\EPS\NewDay\\FilesToRename.txt`","
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"ServicesToRestart`" `: `"LogSvrSvc,LogWatcherSvc,LogWatcherSvc,SpotApi,AppWatcher2,SpotConsoleSvc`","
Add-Content -Path $siteconfig -Encoding Ascii -Value "`"consoleService`" `: `"SpotConsoleSvc`""
Add-Content -Path $siteconfig -Encoding Ascii -Value "`}"

