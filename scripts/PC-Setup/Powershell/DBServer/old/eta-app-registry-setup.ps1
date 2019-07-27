# Installing ETA Applications
Import-Module 'Carbon'

# Setup Windows Port Increase & TcpTimedWaitDelay Registry
# "MaxUserPort"=dword:0000fffe
# "TcpTimedWaitDelay"=dword:0000001e
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters' -Name "MaxUserPort" -DWord 65534
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters' -Name "TcpTimedWaitDelay" -DWord 30

# For WinSCP (TBD)
# Need to copy and WIN_SCP.reg somewhere and then sed it to replace old SID with new SID
# Then actually run the .reg file
# $objUser = New-Object System.Security.Principal.NTAccount("spot")
# $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
# $strSID.Value


