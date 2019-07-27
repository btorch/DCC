# Installing ETA Applications
Import-Module 'Carbon'

# Setup SpotApi Service
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'install SpotApi C:\Program" "Files" "(x86)\nodejs\node.exe app.js 9933 2 3' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotApi AppDirectory "C:\etawww\spot_node"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotApi AppStderr  "C:\SpotLogs\SpotApi.log"' -Wait
Start-Process -FilePath "C:\Program Files (x86)\EPS\SpotServices\nssm.exe" -ArgumentList 'set SpotApi AppStdout  "C:\SpotLogs\SpotApi.log"' -Wait

# Start SpotApi Service
Start-Process -FilePath C:\Windows\System32\net.exe -ArgumentList 'start SpotApi'
