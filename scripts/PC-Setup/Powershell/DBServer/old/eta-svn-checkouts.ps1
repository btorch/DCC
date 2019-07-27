# Note: If not yet Execution_Policies must be changed http://go.microsoft.com/fwlink/?LinkID=135170 first
# E.x:
#   Set-ExecutionPolicy Unrestricted OR “PowerShell.exe -ExecutionPolicy  Bypass {Script Location}”

# Checking out SQLCMD
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SQLCMD C:\ETA\SQLCMD

# Checking out SPOTWeb/WebRoot
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SPOTWeb/WebRoot C:\etawww\spot_base

# Checking out nodejs SpotConsole
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/mobiledevices/trunk/node.js/SpotConsole C:\etawww\spot_node

# Checking out SpotServices (Need UAC turned off to access folders under system folders)
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Files/SpotServices "C:\Program Files (x86)\EPS\SpotServices"

# RedGate: Checking out schema for dbConfig and customer_system databases
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/spot/trunk/Database/dbConfig C:\ETA\ConfigDBSchema

# RedGate: Checking out schema for dbConfig and customer_system databases
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/tt3/trunk/SRC/Core/SQL/Schema C:\ETA\CustomerDBSchema

# DB Server Setup
& 'C:\Program Files\TortoiseSVN\bin\svn.exe' co --username mmartins --password CtMmYpdsvtN29f --non-interactive --trust-server-cert https://etatransit.svn.cloudforge.com/geoqa/Development/branches/naresh/dbserversetup C:\ETA\CustomerDbSetup

