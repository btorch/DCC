# Setup Initial System Configuration (Powershell v3+)
#
# Note:
#      The following Variable should be set on powershell before running this script.
#      ETA-SERVER-NAME=
#
Import-Module 'Carbon'

Write-Host "$(Get-Date -format 'u') - Starting System Config Setup"
Start-Sleep 2


Write-Host "$(Get-Date -format 'u') - Setting up spot user"
# Setting up spot user (Change to use Carbon New-Credential)
$spotsecpasswd = ConvertTo-SecureString "sp0tAdm1n" -AsPlainText -Force
$spotcreds = New-Object System.Management.Automation.PSCredential ("spot", $spotsecpasswd)
Install-User -Credential $spotcreds -Description "Spot Local User" -FullName "spot" -Verbose
Add-GroupMember -Name "Administrators" -Member "spot" -Verbose
Start-Sleep 3

Write-Host "$(Get-Date -format 'u') - Setting up ecartman user"
# Setting up ecartman user (Change to use Carbon New-Credential)
$ecsecpasswd = ConvertTo-SecureString "EcArtAdm1n" -AsPlainText -Force
$eccreds = New-Object System.Management.Automation.PSCredential ("ecartman", $ecsecpasswd)
Install-User -Credential $eccreds -Description "Ecartman Local User" -FullName "ecartman" -Verbose
Add-GroupMember -Name "Administrators" -Member "ecartman" -Verbose
Start-Sleep 3


Write-Host "$(Get-Date -format 'u') - Setting up Autologon Registry"
# Setting Registry to enable AutoLogin                                
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name "AdminAutoLogon" -String 1


Write-Host "$(Get-Date -format 'u') - Setting up Windows Port Increase & TcpTimedWaitDelay Registry"
# Setup Windows Port Increase & TcpTimedWaitDelay Registry
# "MaxUserPort"=dword:0000fffe
# "TcpTimedWaitDelay"=dword:0000001e
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters' -Name "MaxUserPort" -DWord 65534
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters' -Name "TcpTimedWaitDelay" -DWord 30


# Firewall Rules
# Win2k8R2 - netsh advfirewall firewall show rule name=all
#            https://technet.microsoft.com/en-us/library/dd734783.aspx 
# Win2k12 - https://technet.microsoft.com/library/jj554906(v=wps.630).aspx
# App Server allow 3000 TCP/UDP port Inbound for 10.30.120.0/24
#
#Write-Host "$(Get-Date -format 'u') - Adding ETA AppSrv port 3000 rule"
#netsh advfirewall firewall add rule name = 'ETA AppSrv 3000' dir=in Action=allow profile=any localip=10.30.120.0/24 localport=3000 protocol=tcp description='ETA Firewall Rules'
Write-Host "$(Get-Date -format 'u') - Allowing all traffic to flow over localnet"
netsh advfirewall firewall add rule name = 'ETA Localnet In' dir=in Action=allow profile=any localip=10.30.120.0/24 remoteip=10.30.120.0/24 protocol=any description='ETA Localnet FW Rules'
netsh advfirewall firewall add rule name = 'ETA Localnet Out' dir=out Action=allow profile=any localip=10.30.120.0/24 remoteip=10.30.120.0/24 protocol=any description='ETA Localnet FW Rules'
Start-Sleep 5

# Set Computer Name (Applies once restarted)
# e.x: Set-EnvironmentVariable -Name 'ETA-SERVER-NAME' -Value 'ETA-APP-AWS00' -ForProcess
Write-Host "$(Get-Date -format 'u') - Renaming Computer & Rebooting"
Start-Sleep 3
$hostpc = ${env:ETA-SERVER-NAME}
Rename-Computer -NewName "$hostpc" -LocalCredential $spotcreds -Verbose -Restart


