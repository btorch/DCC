# Setting up spot & ecartman users
Import-Module 'Carbon'

# Could have used Carbon New-Credential
$spotsecpasswd = ConvertTo-SecureString “sp0tAdm1n” -AsPlainText -Force
$spotcreds = New-Object System.Management.Automation.PSCredential (“spot”, $spotsecpasswd)
Install-User -Credential $spotcreds -Description "Spot Local User" -FullName "spot" -Verbose
Add-GroupMember -Name "Administrators" -Member "spot" -Verbose

# Could have used Carbon New-Credential
$ecsecpasswd = ConvertTo-SecureString “EcArtAdm1n” -AsPlainText -Force
$eccreds = New-Object System.Management.Automation.PSCredential (“ecartman”, $ecsecpasswd)
Install-User -Credential $eccreds -Description "Ecartman Local User" -FullName "ecartman" -Verbose
Add-GroupMember -Name "Administrators" -Member "ecartman" -Verbose

# Setting Registry to enable AutoLogin                                
Set-RegistryKeyValue -Path 'hklm:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name "AdminAutoLogon" -String 1
