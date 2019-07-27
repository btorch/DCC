# ETA NewDay Archiving Setup 
Import-Module 'Carbon'

# Create SpotLogging Location
Write-Host "$(Get-Date -format 'u') - Creating SpotLogs Directories"
Install-Directory -Path 'C:\SpotLogs\LogArchive'

# Copy FoldersToPurge.txt
Write-Host "$(Get-Date -format 'u') - Setting up NewDay FoldersToPurge.txt"
copy C:\Users\spot\Dropbox\ETA\Powershell\NewDayFiles\FoldersToPurge.txt -Destination 'C:\Program Files (x86)\EPS\NewDay\'

# Copy FilesToRename.txt
Write-Host "$(Get-Date -format 'u') - Setting up NewDay FilesToRename.txt"
copy C:\Users\spot\Dropbox\ETA\Powershell\NewDayFiles\FilesToRename.txt -Destination 'C:\Program Files (x86)\EPS\NewDay\'

# Setting Registry Entries for NewDay (TBD)
Write-Host "$(Get-Date -format 'u') - Setting up NewDay Registry Entries"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "ArchiveBeforeDays" -String "4"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "ArchiveDeleteDays" -String "30"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "LogFileFolder" -String "C:\\SpotLogs"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "ArchiveFolder" -String "C:\\SpotLogs\\LogArchive"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "RecreateFlag" -String "False"

