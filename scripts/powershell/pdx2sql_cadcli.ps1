Import-Module 'Carbon'


# Location where SQL dumps will be placed
$sqlExport = "C:\Users\torch\Downloads\Paradox2SQL\SQL"
if(!(Test-Path $sqlExport)) {
    New-Item -Path "C:\Users\torch\Downloads\Paradox2SQL\SQL" -ItemType "directory"
}

# Location where log file will be placed
$Logfile = "C:\Users\torch\Downloads\Paradox2SQL\pdx2sql_cadcli.log"

# Location where Automa files are located
$automaPath = "C:\Backup_26-08-2019\automa"

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

$CadcliDb = "$automaPath\receber\Cadcli.DB"
$outSuffix = $(Get-Date -Format "dd_MM_yyyy")
$outFile = "receber.Cadcli.$outSuffix.sql"
$fullOutPath = "$sqlExport\$outFile"
# Setting up Filter File
#$filter = "Status:01"
#$tmpfile = New-TemporaryFile
#Add-Content $tmpfile.FullName -Value $filter
#$options = "/FILTER:$tmpfile /SORTBY:codcli /MYSQL /DOUBLEQUOTA /nocreatetable"

LogWrite "$(Get-Date -Format 'u') - ($num) Exportando Paradox Table receber\Cadcli.DB para MySQL $outputName"
Write-Host  "$(Get-Date -Format 'u') - ($num) Automa receber\Cadcli.DB --> MySQL $outpuFile"

Set-Location -Path $sqlExport
& 'C:\Program Files (x86)\Paradox Converter\pxcnv.exe' ${CadcliDb}  $outFile  /COLUMNS:codcli,Status,nomecli,bairro,municipio,estado,cgccli,Area,data,Ult_DtCompra,Ult_VlCompra,Qtd_Valor,Qtd_Atraso,Maior_VlCompra /FILTER:status_filter.txt /SORTBY:codcli /MYSQL /DOUBLEQUOTA

#Remove-Item -Path $tmpfile.FullName 
### FIM - Cadastro de Clientes - RECEBER ###


LogWrite "$(Get-Date -Format 'u') - Fim de todas exportacoes para MySQL"
LogWrite "-----------------------------------------------------------------"
