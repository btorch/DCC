# Installing ETA Applications
Import-Module 'Carbon'

# Setting IIS localhost entries
Set-HostsEntry -IPAddress 127.0.0.1 -HostName 'spot-console.etaspot.com'
Set-HostsEntry -IPAddress 127.0.0.1 -HostName 'spot-public.etaspot.net'
Set-HostsEntry -IPAddress 127.0.0.1 -HostName 'spot-mobile.etaspot.net'

