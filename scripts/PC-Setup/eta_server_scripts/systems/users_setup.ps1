#
# Setting up some Windows user's
# Change to use Carbon New-Credential
#
Write-Host "$(Get-Date -format 'u') - Setting up Marcelo Martins user"
$secpasswd = ConvertTo-SecureString "R6hAM1290joLMNV3Lp2V5" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("mmartins", $secpasswd)
Install-User -Credential $creds -Description "Marcelo Admin User" -FullName "Marcelo Martins" -Verbose
Add-GroupMember -Name "Administrators" -Member "mmartins" -Verbose
