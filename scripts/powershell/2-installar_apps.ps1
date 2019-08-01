# Instalacao de Apllications (Powershell v3+)
#
# Info:
#   - Mudar Execution-Policy para Bypass antes de executar script
#   - 
#
#




#----------------------------------------------------------
# Verificar Versao do Powershell
#----------------------------------------------------------
if ($PSVersionTable.PSVersion.Major -lt 4) {
  Write-Host "`n Versao de Powershell $PSVersionTable.PSVersion.Major Antiga "
  Write-Host "`n Versao de Powershell deve ser 4+ "
  break
}



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
# Carbon Import
#----------------------------------------------------------
#
Import-Module 'Carbon'
Write-Host "`n"
Write-Host "-----------------------------------INICIO---------------------------------------"



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

# Errors
# Write-Host "$(Get-Date -format 'u') - Instalando AVG Free Anti-Virus"
# choco install avgantivirusfree -y

Write-Host "$(Get-Date -format 'u') - Instalando Avast Free Anti-Virus"
choco install avastfreeantivirus -y

Write-Host "$(Get-Date -format 'u') - Instalando TeamViewer"
choco install teamviewer -y

Write-Host "$(Get-Date -format 'u') - Instalando Office 365 Business"
choco install office365business -y

Write-Host "$(Get-Date -format 'u') - Instalando Slack"
choco install slack -y

#----------------------------------------------------------
# Restaurando 'Execution Policy'
#----------------------------------------------------------
Write-Host "`n"
Write-Host "--------------------------------------------------------------------------------"
Write-Host "$(Get-Date -format 'u') - Mudando 'Execution Policy' para valor original: Restricted"
Set-ExecutionPolicy Restricted



Write-Host "`n"
Write-Host "--------------------------------------------------------------------------------"
Write-Host "-----------------------------------FIM------------------------------------------"
Write-Host "--------------------------------------------------------------------------------"

