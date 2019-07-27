# Installing ETA Applications
Import-Module 'Carbon'

# Setup Windows Port Increase & TcpTimedWaitDelay Registry
# "MaxUserPort"=dword:0000fffe
# "TcpTimedWaitDelay"=dword:0000001e
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters' -Name "MaxUserPort" -DWord 65534
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters' -Name "TcpTimedWaitDelay" -DWord 30


