# Note: If not yet Execution_Policies must be changed http://go.microsoft.com/fwlink/?LinkID=135170 first
# E.x:
#   Set-ExecutionPolicy Unrestricted OR “PowerShell.exe -ExecutionPolicy  Bypass {Script Location}”

# Checking out SQLCMD
svn.exe co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SQLCMD C:\ETA\SQLCMD

# Checking out nodejs SpotConsole
svn.exe co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/mobiledevices/trunk/node.js/SpotConsole C:\etawww\spot_node

# Checking out PublicSiteWS
svn.exe co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/PublicSiteWS C:\etawww\public_base

# Checking out September-PublicWS-Release mobile_base
svn.exe co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert  https://etatransit.svn.cloudforge.com/spot/branch/September-PublicWS-Release/mobile_base C:\etawww\mobile_base

# Checking out SpotServices (Need UAC turned off to access folders under system folders)
svn.exe co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SpotServices "C:\Program Files (x86)\EPS\SpotServices"

# Checking out TCPLogging (Need UAC turned off to access folders under system folders)
svn.exe co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/tcplogger/trunk/SRC/core/TCPLogging "C:\Program Files (x86)\EPS\TCPLogging"
