# Setup Sistema Configuration (Powershell v3+)
#
# Info:
#       Antes de rodar verifique a Execution-Policy do Powershell
#       Tera que ser mudada para poder rodar o script
#
# Para Fazer:
#   - Ler arquivo INI 
#



#----------------------------------------------------------
# Metodos
#----------------------------------------------------------
$Logfile = ".\pc-setup.log"
Function LogWrite
{
    Param ([string]$logstring)
    Add-Content $Logfile -value $logstring
}



#----------------------------------------------------------
# Chocolatey Instalacao
# Chocolatey Instalacao de Pacotes 
# Choco Info https://chocolatey.org/packages
#----------------------------------------------------------
Write-Host "`n"
Write-Host "$(Get-Date -format 'u') - Salvando 'Execution Policy' Original"
$curr_policy = $(Get-ExecutionPolicy)
Write-Host "$(Get-Date -format 'u') - Mudando 'Execution Policy' para Bypass"
Set-ExecutionPolicy Bypass
Start-Sleep 1

Write-Host "$(Get-Date -format 'u') - Instalando Choco para Windows"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$env:Path += ";C:\ProgramData\chocolatey\bin"
Start-Sleep 5



#----------------------------------------------------------
# Agora Instalando Carbon Modulo
#----------------------------------------------------------
#
Write-Host "$(Get-Date -format 'u') - Instalando Carbon Modulo"
choco install carbon -y 
Start-Sleep 5 
Import-Module 'Carbon'



#----------------------------------------------------------
# Coletando dados do arquivo INI
# para configuracao
#----------------------------------------------------------
if ( Test-Path .\win10setup.ini -PathType Leaf) {
  Split-Ini -Path .\win10setup.ini -AsHashtable -CaseSensitive -OutVariable myini
  $d = $myini.Item("")
  $HostName = $d.'GERAL.pc_nome'.Value
  $UserName = $d.'USUARIO.usuario_nome'.Value
  $UserPass = $d.'USUARIO.usuario_senha'.Value
}



#----------------------------------------------------------
# Chocolatey Instalacao de Pacotes 
# Choco Info https://chocolatey.org/packages
#----------------------------------------------------------
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

#Write-Host "$(Get-Date -format 'u') - Instalando Malwarebytes Anti-Malware"
#choco install malwarebytes -y 

#Write-Host "$(Get-Date -format 'u') - Instalando AVG Free Anti-Virus"
#choco install avgantivirusfree -y 

Write-Host "$(Get-Date -format 'u') - Instalando Avast Free Anti-Virus"
choco install avastfreeantivirus -y 

Write-Host "$(Get-Date -format 'u') - Instalando TeamViewer"
choco install teamviewer -y 

Write-Host "$(Get-Date -format 'u') - Instalando Office 365 Business"
choco install office365business -y

Write-Host "$(Get-Date -format 'u') - Instalando Slack"
choco install slack -y



#----------------------------------------------------------
# Configurando Usuarios/Grupos
# Change to use Carbon New-Credential
#----------------------------------------------------------
# Usuario = DICOCEL
if (!$(Test-USer -Username Dicocel)) {
  Write-Host "$(Get-Date -format 'u') - Configurando usuario Dicocel (Admin)"
  $secpasswd = ConvertTo-SecureString "senha@2019.2" -AsPlainText -Force
  $dicocel_creds = New-Object System.Management.Automation.PSCredential ("Dicocel", $secpasswd)
  Install-User -Credential $dicocel_creds -Description "Conta Dicocel Administradora" -FullName "Dicocel Admin" -Verbose
  Add-GroupMember -Name "Administrators" -Member "Dicocel" -Verbose
  Start-Sleep 1
}

if ($UserName){
  if (!$(Test-USer -Username $UserName)) {
    Write-Host "$(Get-Date -format 'u') - Configurando Usuario $UserName (Users)"
    $ecsecpasswd = ConvertTo-SecureString "$UserPass" -AsPlainText -Force
    $eccreds = New-Object System.Management.Automation.PSCredential ($UserName, $ecsecpasswd)
    Install-User -Credential $eccreds -Description "$UserName Usuario Local" -FullName "$UserName" -Verbose
    Add-GroupMember -Name "Users" -Member "$UserName" -Verbose
    Start-Sleep 1
  }
}


#----------------------------------------------------------
# Agendamento de Tarefas
#----------------------------------------------------------
# $spotcreds = New-Credential -User "spot" -Password "sp0tAdm1n"
# Write-Host "$(Get-Date -format 'u') - Configurando Agendamento de Tarefas"
# Install-ScheduledTask -Name "APC2 Update" -TaskXmlFilePath "C:\ETA\SQLCMD\APC2 Update.xml" -TaskCredential $dicocel_creds



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
if {$hostname) {
  Write-Host "$(Get-Date -format 'u') - Configurando Nome do PC: $HostName"
  Write-Host "$(Get-Date -format 'u') - Necessario Reiniciar o Windows"
  Rename-Computer -NewName "$HostName" -LocalCredential $dicocel_creds -Verbose -Restart
}



#----------------------------------------------------------
# Restaurando 'Execution Policy'
#----------------------------------------------------------
Write-Host "$(Get-Date -format 'u') - Mudando 'Execution Policy' para valor original: Restricted"
Set-ExecutionPolicy Restricted

