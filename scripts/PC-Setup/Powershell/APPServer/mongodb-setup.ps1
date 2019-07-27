# Installing ETA Applications
Import-Module 'Carbon'

# Create Mongo Data Directories
Write-Host "$(Get-Date -format 'u') - Creating Mongodb data directory"
Install-Directory -Path "C:\data\db"
Install-Directory -Path "C:\data\log"

# Installing MongoDB 2.6.11
# Out-Null as a simple way to make sure the rest of the script waits for the MSI to finish installing.
# msiexec.exe /q /i 'C:\Users\spot\Dropbox\ETA\Installs\mongodb-win32-x86_64-2008plus-2.6.11-signed.msi' "ADDLOCAL=ALL" INSTALLLOCATION="""C:\Program Files\MongoDB-2.6"""| Out-Null
Write-Host "$(Get-Date -format 'u') - Installing Mongodb 2.6.11"
msiexec.exe /q /i 'C:\Users\spot\Dropbox\ETA\Installs\mongodb-win32-x86_64-2008plus-2.6.11-signed.msi' "ADDLOCAL=ALL" | Out-Null

# Copy MongoDB Config
Write-Host "$(Get-Date -format 'u') - Setting up Mongodb config"
copy C:\Users\spot\Dropbox\ETA\Powershell\Mongodb\mongod.cfg -Destination 'C:\Program Files\MongoDB 2.6 Standard'

# Setup MongoDB as a Service
Write-Host "$(Get-Date -format 'u') - Enabling and Starting Mongodb as a service"
&"$Env:ProgramFiles\MongoDB 2.6 Standard\bin\mongod.exe" --config "$Env:ProgramFiles\MongoDB 2.6 Standard\mongod.cfg" --install
Set-Service -Name MongoDB -StartupType Automatic
Start-Service -Name MongoDB

