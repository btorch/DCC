# Installing Generic Applications
# Choco PKG Info https://chocolatey.org/packages
Import-Module 'Carbon'




# Activate Redgate SQL Components
# & 'C:\Program Files (x86)\Red Gate\SQL Compare 12\SQLCompare.exe' /activateSerial:xxxxx-xxxx
# & 'C:\Program Files (x86)\Red Gate\SQL Data Compare 12\SQLDataCompare.exe'  /activateSerialxxxxxx-xxxxx


# RedGate Synchronization
Write-Host "$(Get-Date -format 'u') - Connecint to SQL & Creating dbConfig Database"
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
$srv = new-Object Microsoft.SqlServer.Management.Smo.Server("(local)")
$db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, "dbConfig")
$db.Create()
Write-Host "$(Get-Date -format 'u') - Starting RedGate SQLCompare Synchronization for ConfigDBSchema"
& 'C:\Program Files (x86)\Red Gate\SQL Compare 12\SQLCompare.exe' /scr1:"C:\ETA\ConfigDBSchema" /db2:dbConfig /sync
Start-Sleep 5 

Write-Host "$(Get-Date -format 'u') - Starting RedGate SQLDataCompare Synchronization for ConfigDBSchema"
& 'C:\Program Files (x86)\Red Gate\SQL Data Compare 12\SQLDataCompare.exe' /scr1:"C:\ETA\ConfigDBSchema" /db2:dbConfig /sync

Write-Host "$(Get-Date -format 'u') - User tims Update"
$db.ExecuteNonQuery("sp_change_users_login 'Update_One','tims','tims'")

#*** This I would do before setting up the CustomerDbSetup service if possible. And Yes, I know you did say that already ;-)

