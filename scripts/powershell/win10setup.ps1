# Setup Sistema Configuration (Powershell v3+)
#
# Info:
#      Configure o paramentro abaixo no powershell antes
#      de rodar o script
#      WINPC_NOME="XXXX"
#
Import-Module 'Carbon'



#----------------------------------------------------------
# Coletando dados do arquivo INI
# para configuracao
#----------------------------------------------------------
Carbon_IniFile HostName
{
  Path = 'C:\pc-setup.ini'
  Section = 'GERAL';
  Name = 'pc_nome';
  Ensure = 'Absent';
}

Carbon_IniFile UserName
{
  Path = 'C:\pc-setup.ini'
  Section = 'USUARIO';
  Name = 'usuario_nome';
  Ensure = 'Absent';
}

Carbon_IniFile UserPass
{
  Path = 'C:\pc-setup.ini'
  Section = 'USUARIO';
  Name = 'usuario_senha';
  Ensure = 'Absent';
}



#----------------------------------------------------------
# Chocolatey Instalacao
# Chocolatey Instalacao de Pacotes 
# Choco Info https://chocolatey.org/packages
#----------------------------------------------------------
Write-Host "`n"
Write-Host "$(Get-Date -format 'u') - Salvando 'Execution Policy' Original"
$curr_policy = $(Get-ExecutionPolicy)
Write-Host "$(Get-Date -format 'u') - Mudando 'Execution Policy' para RemoteSigned"
Set-ExecutionPolicy RemoteSigned
Start-Sleep 1

Write-Host "$(Get-Date -format 'u') - Instalando Choco para Windows"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$env:Path += ";C:\ProgramData\chocolatey\bin"
Start-Sleep 5

# Install vim using choco
# Write-Host "$(Get-Date -format 'u') - Instalando Vim-Tux Suite"
# choco install vim-tux -y

Write-Host "$(Get-Date -format 'u') - Instalando Adobe PDF"
choco install adobereader -y

Write-Host "$(Get-Date -format 'u') - Instalando Google Chrome"
choco install googlechrome -y 

Write-Host "$(Get-Date -format 'u') - Instalando Adobe Flash Player Plugin"
choco install flashplayerplugin -y 

Write-Host "$(Get-Date -format 'u') - Instalando Java JRE 8"
choco install jre8 -y

Write-Host "$(Get-Date -format 'u') - Instalando WinRaR"
choco install winrar -y

Write-Host "$(Get-Date -format 'u') - Instalando Skype"
choco install skype -y

Write-Host "$(Get-Date -format 'u') - Instalando PDF Creator"
choco install pdfcreator -y 

Write-Host "$(Get-Date -format 'u') - Instalando Malwarebytes Anti-Malware"
choco install malwarebytes -y 

Write-Host "$(Get-Date -format 'u') - Instalando TeamViewer"
choco install teamviewer -y 

Write-Host "$(Get-Date -format 'u') - Instalando Office 365 Business"
choco install office365business -y

Write-Host "$(Get-Date -format 'u') - Mudando 'Execution Policy' para valor original: $curr_policy"
Set-ExecutionPolicy $curr_policy



#----------------------------------------------------------
# Configurando Usuarios/Grupos
# Change to use Carbon New-Credential
#----------------------------------------------------------
# Usuario = DICOCEL
Write-Host "$(Get-Date -format 'u') - Configurando usuario DICOCEL (Admin)"
$secpasswd = ConvertTo-SecureString "Dicocel@2019-V2.0" -AsPlainText -Force
$dicocel_creds = New-Object System.Management.Automation.PSCredential ("DICOCEL", $secpasswd)
Install-User -Credential $dicocel_creds -Description "Conta Dicocel Administradora" -FullName "DICOCEL Admin" -Verbose
Add-GroupMember -Name "Administrators" -Member "DICOCEL" -Verbose
Start-Sleep 1

# Usuario = 
# Write-Host "$(Get-Date -format 'u') - Configurando Usuario $UserName (Users)"
# $ecsecpasswd = ConvertTo-SecureString "$UserPass" -AsPlainText -Force
# $eccreds = New-Object System.Management.Automation.PSCredential ($UserName, $ecsecpasswd)
# Install-User -Credential $eccreds -Description "$UserName Local User" -FullName "$UserName" -Verbose
# Add-GroupMember -Name "Users" -Member "$UserName" -Verbose
# Start-Sleep 1



#----------------------------------------------------------
# Firewall Rules
#----------------------------------------------------------
# Win2k8R2 - netsh advfirewall firewall show rule name=all
#            https://technet.microsoft.com/en-us/library/dd734783.aspx
# Win2k12 - https://technet.microsoft.com/library/jj554906(v=wps.630).aspx
############################################################################
# Write-Host "$(Get-Date -format 'u') - Adding AppSrv port 3000 rule"
# netsh advfirewall firewall add rule name = 'AppSrv 3000' dir=in Action=allow profile=any localip=10.30.120.0/24 localport=3000 prot  ocol=tcp description='Firewall Rules'
# Write-Host "$(Get-Date -format 'u') - Allowing all traffic to flow over localnet"
# netsh advfirewall firewall add rule name = 'Localnet In' dir=in Action=allow profile=any localip=10.30.120.0/24 remoteip=10.30.120.0  /24 protocol=any description='Localnet FW Rules'
# netsh advfirewall firewall add rule name = 'Localnet Out' dir=out Action=allow profile=any localip=10.30.120.0/24 remoteip=10.30.120  .0/24 protocol=any description='Localnet FW Rules'
# Start-Sleep 5



#----------------------------------------------------------
# Setting IIS localhost entries
#----------------------------------------------------------
Write-Host "$(Get-Date -format 'u') - Configurando arquivo Host do Windows"
Write-Host "$(Get-Date -format 'u') - 192.168.1.99 -> servidor01.dicocel.com.br (Win 2k8R2)"
Write-Host "$(Get-Date -format 'u') - 192.168.1.200 -> servidor02.dicocel.com.br (Win 2k8R2)"
Write-Host "$(Get-Date -format 'u') - 192.168.1.201 -> websrv01.dicocel.com.br (Linux VM)"
Set-HostsEntry -IPAddress 192.168.1.99  -HostName 'servidor01.dicocel.com.br'
Set-HostsEntry -IPAddress 192.168.1.200 -HostName 'servidor02.dicocel.com.br'
Set-HostsEntry -IPAddress 192.168.1.201 -HostName 'websrv01.dicocel.com.br'
# cat $(Get-PathToHostsFile) | tail -n 5



#----------------------------------------------------------
# Configura Nome do PC (Reboot)
# e.x: Set-EnvironmentVariable -Name 'ETA-SERVER-NAME' -Value 'ETA-APP-AWS00' -ForProcess
#----------------------------------------------------------
# Write-Host "$(Get-Date -format 'u') - Configurando Nome do PC: $HostName & Reiniciando"
# Rename-Computer -NewName "$HostName" -LocalCredential $dicocel_creds -Verbose -Restart
#


