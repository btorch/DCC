# Setting up ETA Spot Logging
Import-Module 'Carbon'

# Copy FoldersToPurge.txt 
copy C:\Users\spot\Dropbox\ETA\Powershell\NewDayFiles\FoldersToPurge.txt -Destination 'C:\Program Files (x86)\EPS\NewDay\'

# Copy FilesToRename.txt
copy C:\Users\spot\Dropbox\ETA\Powershell\NewDayFiles\FilesToRename.txt -Destination 'C:\Program Files (x86)\EPS\NewDay\'

# Setting Registry Entries for NewDay (TBD)                                          
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "ArchiveBeforeDays" -String "4"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "ArchiveDeleteDays" -String "30"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "LogFileFolder" -String "C:\\SpotLogs"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "ArchiveFolder" -String "C:\\SpotLogs\\LogArchive"
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Wow6432Node\VBApps\NewDay' -Name "RecreateFlag" -String "False"

