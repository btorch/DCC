# Installing ETA Applications
Import-Module 'Carbon'

# Setting IIS localhost entries
Write-Host "$(Get-Date -format 'u') - Setting up spot local domain entries on hosts file"
Write-Host "$(Get-Date -format 'u') - 127.0.0.1 -> spot-console.etaspot.com, spot-public.etaspot.net, spot-mobile.etaspot.net"
Set-HostsEntry -IPAddress 127.0.0.1 -HostName 'spot-console.etaspot.com'
Set-HostsEntry -IPAddress 127.0.0.1 -HostName 'spot-public.etaspot.net'
Set-HostsEntry -IPAddress 127.0.0.1 -HostName 'spot-mobile.etaspot.net'
cat $(Get-PathToHostsFile) | tail -n 5

