# Installing ETA Applications
Import-Module 'Carbon'

# Create ETA directories
Install-Directory -Path "C:\Program Files (x86)\EPS"

# Install AppWacther2setup
#Install-Msi -Path 'C:\Users\spot\Dropbox\ETA\Installs\AppWatcher2\AppWatcher2Setup.msi' 
msiexec.exe /i 'C:\Users\spot\Dropbox\ETA\Installs\AppWatcher2\AppWatcher2Setup.msi' TARGETDIR="""C:\Program Files (x86)\EPS\AppWatcher2""" /q
# Setting Registry Entries for AppWacther2                                        
Set-RegistryKeyValue -Path 'hklm:\SYSTEM\CurrentControlSet\services\AppWatcher2\Parameters' -Name 'UserAccount' -String 'spot'


# Extract BU Archive (ETA\Installs\BU)
Install-Directory -Path 'C:\BU'
& 'C:\Program Files\7-Zip\7z.exe' x C:\Users\spot\Dropbox\ETA\Installs\BU\BU.7z -oc:\BU -y

# Install ETA TCL Libraries & TestSuite (ETA\Installs\TCL)
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\twapi -Destination C:\Tcl\lib -Recurse
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\udp1.0.8 -Destination C:\Tcl\lib -Recurse
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\tclhttpd3.5.1 -Destination C:\Tcl\lib -Recurse
copy C:\Users\spot\Dropbox\ETA\Installs\TCL\TestSuite -Destination 'C:\Program Files (x86)\EPS' -Recurse

# Start TestSuite - Not sure how to just open and exit
#Start-Process -FilePath 'C:\Program Files (x86)\EPS\TestSuite\TestSuiteTk.tcl' -Verbose -Wait
