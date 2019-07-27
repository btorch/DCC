# Installing UnixTools & PHP
Import-Module 'Carbon'

# Install UnixTools
copy C:\Users\spot\Dropbox\ETA\UnxTools -Destination C:\UnxTools -Recurse

# Extract PHP.7z & PHP5310.7z into C:\ (ETA\NewNACServer)
& 'C:\Program Files\7-Zip\7z.exe' x C:\Users\spot\Dropbox\ETA\NewNACServer\PHP5310.7z -oc:\ -y
& 'C:\Program Files\7-Zip\7z.exe' x C:\Users\spot\Dropbox\ETA\NewNACServer\PHP.7z -oc:\ -y

# Set System Environments 
Set-Variable -Name "NewPath" -Value "C:\PHP5310\;C:\PHP5310\PEAR\;$env:Path;C:\UnxTools"
Set-EnvironmentVariable -Name "Path" -Value "$NewPath" -ForComputer

