# Installing Generic Applications for Windows DB System used by ETA
Import-Module 'Carbon'

#----------------------------------------------------------
# Chocolatey Packages Installation
# Choco Info https://chocolatey.org/packages
#----------------------------------------------------------
Write-Host "$(Get-Date -format 'u') - Chocolatey Packages Installation Startup"
Start-Sleep 3

# Install 7-Zip (does it have to be version 7z920-x64.msi ?)
# Install-Msi -Path 'C:\Users\spot\Dropbox\ETA\7-zip\7z920-x64.msi'
Write-Host "$(Get-Date -format 'u') - Installing 7zip 9.22.0"
choco install 7zip --version=9.22 -y

# Install vim using choco
Write-Host "$(Get-Date -format 'u') - Installing Vim-Tux Suite"
choco install vim-tux -y

# Install WinSCP 5.7.5
Write-Host "$(Get-Date -format 'u') - Installing WinSCP 5.7.5"
choco install winscp --version=5.7.5 -y

# Install TortoiseSVN 1.9.1
Write-Host "$(Get-Date -format 'u') - Installing TortoiseSVN v1.9.1"
choco install tortoisesvn --version=1.9.1 -y 

# Install WinMerge 2.14.0
Write-Host "$(Get-Date -format 'u') - Installing WinMerge"
choco install winmerge -y 


#----------------------------------------------------------
# MSI Package Installations
# http://www.advancedinstaller.com/user-guide/msiexec.html
#----------------------------------------------------------

# Install Nodejs (could install from choco)
# choco install nodejs --version=0.10.22 -y
# Update System variable to have node path
Write-Host "$(Get-Date -format 'u') - Installing Node-Js v0.10.22"
Install-Msi -Path C:\Users\spot\Dropbox\ETA\node-v0.10.22-x86.msi | Out-Null


#----------------------------------------------------------
# Pre-Compiled sources
#----------------------------------------------------------

# Install UnixTools
Write-Host "$(Get-Date -format 'u') - Setting up UnixTools"
copy C:\Users\spot\Dropbox\ETA\UnxTools -Destination C:\UnxTools -Recurse

# Extract PHP5310.7z into C:\ 
Write-Host "$(Get-Date -format 'u') - Extracting PHP archives"
& 'C:\Program Files\7-Zip\7z.exe' x C:\Users\spot\Dropbox\ETA\NewNACServer\PHP5310.7z -oc:\ -y

# Set System Environments
Write-Host "$(Get-Date -format 'u') - Updating Path System Variable"
Set-Variable -Name "NewPath" -Value "C:\PHP5310\;C:\PHP5310\PEAR\;$env:Path;C:\UnxTools;${env:ProgramFiles(x86)}\nodejs"
Set-EnvironmentVariable -Name "Path" -Value "$NewPath" -ForComputer

