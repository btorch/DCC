# Setting up Spot Console Service
Import-Module 'Carbon'

# Install & Setup SpotConsoleSvc Service
Write-Host "$(Get-Date -format 'u') - Installing & Setting up SpotConsoleSvc Service"
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'install SpotConsoleSvc C:\Program" "Files" "(x86)\nodejs\node.exe app.js 7777 1' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotConsoleSvc AppDirectory C:\etawww\spot_node' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotConsoleSvc AppStderr  C:\SpotLogs\SpotConsoleSvc.log' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotConsoleSvc AppStdout  C:\SpotLogs\SpotConsoleSvc.log' -Wait

# Start SpotConsoleSvc Service
# Start-Process -FilePath C:\Windows\System32\net.exe -ArgumentList 'start SpotConsoleSvc'
Write-Host "$(Get-Date -format 'u') - Enabling and Starting up SpotConsoleSvc Service"
Set-Service -Name SpotConsoleSvc -StartupType Automatic
Start-Service -Name SpotConsoleSvc

