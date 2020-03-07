Import-Module 'Carbon'


# Location where SQL dumps will be placed
$sqlExport = "C:\Users\torch\Downloads\Paradox2SQL\SQL"
if(!(Test-Path $sqlExport)) {
    New-Item -Path "C:\Users\torch\Downloads\Paradox2SQL\SQL" -ItemType "directory"
}

# Location where log file will be placed
$Logfile = "C:\Users\torch\Downloads\Paradox2SQL\pdx2sql_produtos.log"

# Location where Automa files are located
$automaPath = "C:\Backup_06-09-2019\automa"

# Array with all the relevant PDX directories currently used
# $subdirs = @("caixa", "cheque", "ESTOQUE", "pagar", "receber")


Function LogWrite
{
    Param ([string]$logstring)
    Add-Content $Logfile -value $logstring
}



### INICIO - Produtos no Estoque ###
LogWrite "-----------------------------------------------------------------"
LogWrite "$(Get-Date -Format 'u') - Inicio de exportacao de Produtos no Estoque"

$pdxDb = "$automaPath\ESTOQUE\produto.DB"
$outSuffix = $(Get-Date -Format "dd_MM_yyyy")
$outFile = "estoque.produtos.sql"
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
    & 'C:\Program Files (x86)\Paradox Converter\pxcnv.exe' ${pdxDb} ${outFile}  /nocreatetable /DOUBLEQUOTA /MYSQL /FILTER:status_filter.txt   /COLUMNS:Codigo,Tipo,Status,Gramatura,CodFor,CodBar,Classe,RefFor,Fator,Marca,Dt_Compra,Pr_Compra,Qtd_Compra,Pr_Custo,Preco_Medio,DtUlt_Preco,PrUlt_Preco,Dt_Preco,Pr_Preco,Pr_Novo
}

### FIM - Produtos no Estoque ###


LogWrite "$(Get-Date -Format 'u') - Fim de todas exportacoes para MySQL"
LogWrite "-----------------------------------------------------------------"
