# Instalacao de Apllications (Powershell v3+)
#
# Info:
#   - Mudar Execution-Policy para Bypass antes de executar script
#     cmd: Set-ExecutionPolicy Bypass
#     cmd: Get-ExecutionPolicy
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
# Chocolatey Instalacao
# Chocolatey Instalacao de Pacotes 
# Choco Info https://chocolatey.org/packages
#----------------------------------------------------------
Write-Host "`n"
Write-Host "--------------------------------------------------------------------------------"
Write-Host "$(Get-Date -format 'u') - Salvando 'Execution Policy' Original"
$curr_policy = $(Get-ExecutionPolicy)
Write-Host "$(Get-Date -format 'u') - Mudando 'Execution Policy' para Bypass"
Set-ExecutionPolicy Bypass
Start-Sleep 1

Write-Host "`n"
Write-Host "--------------------------------------------------------------------------------"
Write-Host "$(Get-Date -format 'u') - Instalando Choco para Windows"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$env:Path += ";C:\ProgramData\chocolatey\bin"
Start-Sleep 5



#----------------------------------------------------------
# Agora Instalando Carbon Modulo
#----------------------------------------------------------
#
Write-Host "`n"
Write-Host "--------------------------------------------------------------------------------"
Write-Host "$(Get-Date -format 'u') - Instalando Carbon Modulo"
choco install carbon -y 
Start-Sleep 5 



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
