# Instalacao de Apllications (Powershell v3+)
#
# Info:
#   - Mudar Execution-Policy para Bypass antes de executar script
#   - Favor configurar arquivo INI
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
# Coletando dados do arquivo INI
# para configuracao
#----------------------------------------------------------
if ( Test-Path .\win10setup.ini -PathType Leaf) {
  Split-Ini -Path .\win10setup.ini -AsHashtable -CaseSensitive -OutVariable myini
  $d = $myini.Item("")
  $HostName = $d.'GERAL.pc_nome'.Value

  # ADM
  $AdmUserName = $d.'USUARIO-ADM.adm_nome'.Value
  $AdmUserPass = $d.'USUARIO-ADM.adm_senha'.Value

  # User Normal
  $UserName = $d.'USUARIO.user_nome'.Value
  $UserPass = $d.'USUARIO.user_senha'.Value
}



#----------------------------------------------------------
# Configurando Usuarios/Grupos
# Change to use Carbon New-Credential
#----------------------------------------------------------
# Usuario = DICOCEL
if ($AdmUserName) {
  if (!$(Test-USer -Username $AdmUserName)) {
    Write-Host "`n"
    Write-Host "$(Get-Date -format 'u') - Configurando usuario $AdmUserName (Admin)"
    $secpasswd = ConvertTo-SecureString "$AdmUserPass" -AsPlainText -Force
    $dicocel_creds = New-Object System.Management.Automation.PSCredential ($AdmUserName, $secpasswd)
    Install-User -Credential $dicocel_creds -Description "Conta Dicocel Administradora" -FullName "Dicocel Admin" -Verbose
    Add-GroupMember -Name "Administrators" -Member "$AdmUserName" -Verbose
    Start-Sleep 1
  }
}
else {
  Write-Host "$(Get-Date -format 'u') - Nenhum usuario administrador para configurar"
}

if ($UserName){
  if (!$(Test-USer -Username $UserName)) {
    Write-Host "`n"
    Write-Host "$(Get-Date -format 'u') - Configurando Usuario $UserName (Users)"
    $ecsecpasswd = ConvertTo-SecureString "$UserPass" -AsPlainText -Force
    $eccreds = New-Object System.Management.Automation.PSCredential ($UserName, $ecsecpasswd)
    Install-User -Credential $eccreds -Description "$UserName Usuario Local" -FullName "$UserName" -Verbose
    Add-GroupMember -Name "Users" -Member "$UserName" -Verbose
    Start-Sleep 1
  }
}
else {
  Write-Host "`n"
  Write-Host "$(Get-Date -format 'u') - Nenhum usuario Local para configurar"
}



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

