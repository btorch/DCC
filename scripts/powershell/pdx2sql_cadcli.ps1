Import-Module 'Carbon'


# Location where SQL dumps will be placed
$sqlExport = "C:\Users\torch\Downloads\Paradox2SQL\SQL"
if(!(Test-Path $sqlExport)) {
    New-Item -Path "C:\Users\torch\Downloads\Paradox2SQL\SQL" -ItemType "directory"
}

# Location where log file will be placed
$Logfile = "C:\Users\torch\Downloads\Paradox2SQL\pdx2sql_cadcli.log"

# Location where Automa files are located
$automaPath = "C:\Backup_06-09-2019\automa"

# Array with all the relevant PDX directories currently used
# $subdirs = @("caixa", "cheque", "ESTOQUE", "pagar", "receber")


Function LogWrite
{
    Param ([string]$logstring)
    Add-Content $Logfile -value $logstring
}



### INICIO - Cadastro de Clientes - RECEBER ###
LogWrite "-----------------------------------------------------------------"
LogWrite "$(Get-Date -Format 'u') - Inicio de exportacao Cadastro de Clientes"

$pdxDb = "$automaPath\receber\Cadcli.DB"
$outSuffix = $(Get-Date -Format "dd_MM_yyyy")
$outFile = "receber.Cadcli.sql"
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
    & 'C:\Program Files (x86)\Paradox Converter\pxcnv.exe' ${pdxDb}  ${outFile}  /nocreatetable /FILTER:status_filter.txt /SORTBY:codcli /MYSQL /DOUBLEQUOTA /COLUMNS:codcli,Status,nomecli,bairro,municipio,estado,cgccli,Area,data,Ult_DtCompra,Ult_VlCompra,Maior_DtCompra,Maior_VlCompra,Qtd_Valor,Qtd_Atraso,Maior_Atraso
}   
 
### FIM - Cadastro de Clientes - RECEBER ###


LogWrite "$(Get-Date -Format 'u') - Fim de todas exportacoes para MySQL"
LogWrite "-----------------------------------------------------------------"
