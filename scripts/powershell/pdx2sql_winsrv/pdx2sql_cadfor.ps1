﻿Import-Module 'Carbon'


# Location where SQL dumps will be placed
$sqlExport = "G:\powershell\SQL"
if(!(Test-Path $sqlExport)) {
    New-Item -Path "G:\powershell\SQL" -ItemType "directory"
}

# Location where log file will be placed
$Logfile = "G:\powershell\pdx2sql_Cadfor.log"

# Location where Automa files are located
$automaPath = "D:\automa"

# Array with all the relevant PDX directories currently used
# $subdirs = @("caixa", "cheque", "ESTOQUE", "pagar", "receber")


Function LogWrite
{
    Param ([string]$logstring)
    Add-Content $Logfile -value $logstring
}



### INICIO - Produtos no Estoque ###
LogWrite "-----------------------------------------------------------------"
LogWrite "$(Get-Date -Format 'u') - Inicio de exportacao de Cadastro de Vendedores"

$pdxDb = "$automaPath\pagar\Cadfor.DB"
$outSuffix = $(Get-Date -Format "dd_MM_yyyy")
$outFile = "pagar.Cadfor.sql"
$fullOutPath = "$sqlExport\$outFile"
#$options = "/FILTER:$tmpfile /SORTBY:codcli /MYSQL /DOUBLEQUOTA /nocreatetable"

if (!(Test-Path $pdxDb )){
    LogWrite "$(Get-Date -Format 'u') - Arquivo nao encontrado $pdxDb ... Terminando script!"
    LogWrite "-----------------------------------------------------------------"
    return
}
else {
    LogWrite "$(Get-Date -Format 'u') - ($num) Exportando Paradox $pdxDb Table para MySQL $fullOutPath"
    Write-Host  "$(Get-Date -Format 'u') - ($num) Automa $pdxDb --> MySQL $outFile"
    Set-Location -Path $sqlExport
    & 'G:\ParadoxConverter\pxcnv.exe' ${pdxDb} ${outFile}  /DOUBLEQUOTA /MYSQL /nocreatetable
}

### FIM - Cadastro de Vendedores ###


LogWrite "$(Get-Date -Format 'u') - Fim de todas exportacoes para MySQL"
LogWrite "-----------------------------------------------------------------"