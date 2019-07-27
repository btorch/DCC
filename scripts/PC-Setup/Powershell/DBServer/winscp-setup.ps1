# WinSCP Files Setup 
Import-Module 'Carbon'


# Updating Original SID with the new spot user SID
#  Orig SID: S-1-5-21-1186280436-360388084-2336886322-1009
#
# PS way:
# $objUser = New-Object System.Security.Principal.NTAccount("spot")
# $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
# $strSID.Value
#
# Using Carbon
Write-Host "$(Get-Date -format 'u') - Updating spot user SID on WIN_SCP.reg file"
$orig_sid = "S-1-5-21-1186280436-360388084-2336886322-1009"
$spot_sid = (Resolve-Identity -Name "spot").Sid.Value
$orig_file = "C:\Users\spot\Dropbox\ETA\Powershell\WinSCP\WIN_SCP.reg"
$temp_file = "C:\Users\spot\Documents\WinSCP.newsid.reg"
(Get-Content $orig_file).Replace("$orig_sid","$sid") | Set-Content $temp_file 

Write-Host "$(Get-Date -format 'u') - Importing New WIN_SCP.reg file"
& regedit /s $temp_file


# HostKey issue for WINSCP:
# Section "Verifying the Host Key or Certificate in Script"
# https://winscp.net/eng/docs/scripting#hostkey
# https://winscp.net/eng/docs/faq_hostkey#automatic_host_key_verification
# https://winscp.net/eng/docs/ui_generateurl
# https://winscp.net/eng/docs/scriptcommand_open#examples



# Follow the directions in the README_FIRST_SCP.txt file to set up WinSCP
# Update the WIN_SCP reg file and Apply to the Registry
#
# Sed NAC03 to another friendly name (AWS DB)

#Edit the error_mail.txt file, changing NAC03 to the computer name

# Run WinScp application and Connect with the etabu account (manually)
# Select “Update” when prompted that the host key has changed
