Import-Module 'Carbon'


# Location where SQL dumps will be placed
$pdxPath = "C:\Users\torch\Downloads\Paradox2SQL\SQL-26"

# Location where log file will be placed
$Logfile = "C:\Users\torch\Downloads\Paradox2SQL\pdx2sql.log"

# Location where Automa files are located
$automaPath = "C:\Backup_26-08-2019\automa"

# Array with all the relevant PDX directories currently used
#$PdxLocations = @("C:\automa-bk", "C:\automa-bk\caixa", "C:\automa-bk\cheque", "C:\automa-bk\ESTOQUE", "C:\automa-bk\pagar", "C:\automa-bk\receber")
$subdirs = @("caixa", "cheque", "ESTOQUE", "pagar", "receber")
#$subdirs = @("caixa")



Function LogWrite
{
    Param ([string]$logstring)
    Add-Content $Logfile -value $logstring
}



LogWrite "-----------------------------------------------------------------"
LogWrite "$(Get-Date -Format 'u') - Inicio de analise de exportacao PDX2SQL"


# Checking parent Directory
#$baseName = (Get-Item $automaPath).BaseName
$contents = Get-ChildItem -Path "$automaPath" -Filter "*.DB" | Where-Object {$_.LastWriteTime -gt "01/01/2019"}
$num = 0
    foreach ($name in $contents.Name) 
    { 
        $num++
        $tableName = $name.Split(".")[0]
        LogWrite "$(Get-Date -Format 'u') - ($num) Exportando Paradox Table $automaPath\$tableName para MySQL automa.$tableName.sql"
        Write-Host  "$(Get-Date -Format 'u') - ($num) Automa $automaPath\$tableName -> automa.$tableName.sql"
        &'C:\Program Files (x86)\Paradox Converter\pxcnv.exe' $automaPath\$name $pdxPath\automa.$tableName.sql /MYSQL /DOUBLEQUOTA
        Start-Sleep 1
    }



Foreach ($subdir in $subdirs)
{

    $fullPath = "$automaPath\$subdir"
    #$baseName = (Get-Item $dbpath).BaseName
    $contents = Get-ChildItem -Path "$fullPath" -Filter "*.DB" | Where-Object {$_.LastWriteTime -gt "01/01/2019"}

    LogWrite "$(Get-Date -Format 'u') -  Starting process for subdir $fullPath"
    Write-Host  "$(Get-Date -Format 'u') - Starting process for subdir $fullPath"

    $num = 0
    foreach ($name in $contents.Name) 
    { 
        $num++
        $tableName = $name.Split(".")[0]
        LogWrite "$(Get-Date -Format 'u') - ($num) Exportando Paradox Table $tableName in $fullPath para MySQL automa.$subdir.$tableName.sql"
        Write-Host  "$(Get-Date -Format 'u') - ($num) Automa $fullPath $tableName -> automa.$subdir.$tableName.sql"
        &'C:\Program Files (x86)\Paradox Converter\pxcnv.exe' $fullPath\$name $pdxPath\automa.$subdir.$tableName.sql /MYSQL /DOUBLEQUOTA
        Start-Sleep 1
    }
}

LogWrite "$(Get-Date -Format 'u') - Fim de analise de exportacao PDX2SQL"
LogWrite "-----------------------------------------------------------------"

