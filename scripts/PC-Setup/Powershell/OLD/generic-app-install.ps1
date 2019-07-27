# Installing Generic Applications
# Choco PKG Info https://chocolatey.org/packages
Import-Module 'Carbon'

# Install 7-Zip (does it have to be version 7z920-x64.msi ?)
#Install-Msi -Path 'C:\Users\spot\Dropbox\ETA\7-zip\7z920-x64.msi'
# Using choco instead
choco install 7zip --version=9.20 -y

# Install vim using choco
choco install vim-tux -y

# Install TCL https://chocolatey.org/packages/ActiveTcl -- MUST BE 8.4.20
# choco install activetcl --version=8.6.4.1 --ia "--directory ""C:\Tcl""" -y 

# Install TortoiseSVN 1.9.1
choco install tortoisesvn --version=1.9.1 -y 

# Install WinMerge 2.14.0
choco install winmerge -y 

# Install Nodejs (could install from choco)
# choco install nodejs --version=0.10.22 -y
Install-Msi -Path C:\Users\spot\Dropbox\ETA\node-v0.10.22-x86.msi

# Install PHPManagerForIIS 1.1.0
Install-Msi -Path C:\Users\spot\Dropbox\ETA\PHPManagerForIIS-1.1.0-x64.msi
 

