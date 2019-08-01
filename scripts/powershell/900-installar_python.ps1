# Instalacao de Apllications (Powershell v3+)
#
# Info:
#   - Mudar Execution-Policy para Bypass antes de executar script
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
# Chocolatey Instalacao de Python & Pip
# Choco Info https://chocolatey.org/packages
#----------------------------------------------------------
#  https://msdn.microsoft.com/en-us/library/windows/desktop/ms681382(v=vs.85).aspx
#  Example: choco install python3 --params "/InstallDir:C:\your\install\path"

Write-Host "$(Get-Date -format 'u') - Instalando Chocolatey Core Extensions`n"
choco install chocolatey-core.extension -y

Write-Host "$(Get-Date -format 'u') - Instalando Python Versao 3.7`n"
choco install python3 --params "/InstallDir:C:\Python3"


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

