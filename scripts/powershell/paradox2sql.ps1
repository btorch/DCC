Import-Module 'Carbon'


$pdxPath = "C:\Users\torch\Downloads\Paradox2SQL"
$Logfile = "C:\Users\torch\Downloads\Paradox2SQL\pdx2sql.log"

# Array with all the relevant PDX directories currently used
$PdxLocations = @("C:\automa-stg2")



Function LogWrite
{
    Param ([string]$logstring)
    Add-Content $Logfile -value $logstring
}



LogWrite "-----------------------------------------------------------------"
LogWrite "$(Get-Date -Format 'u') - Inicio de analise de exportacao PDX2SQL"



Foreach ($dbpath in $PdxLocations)
{
    $contents = Get-ChildItem -Path "$dbpath" -Filter "*.DB" | Where-Object {$_.LastWriteTime -gt "01/01/2019"}
    #$contents.Name
    $num = 0
    foreach ($name in $contents.Name) 
    { 
        $num++
        LogWrite "$(Get-Date -Format 'u') - ($num) Exportando Paradox $name para MySQL $pdxPAth\automa2_$name.sql"
        &'C:\Program Files (x86)\Paradox Converter\pxcnv.exe' $dbpath\$name $pdxPAth\automa_$name.sql /MYSQL /DOUBLEQUOTA
        Start-Sleep 1
    }
}


LogWrite "$(Get-Date -Format 'u') - Fim de analise de exportacao PDX2SQL"
LogWrite "-----------------------------------------------------------------"

