<?php
   
if (@mysql_connect("localhost", "root", "")) {

    $codven = $_REQUEST['codven'];

   //abre conexao com o banco
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
   }

   if (!mysql_select_db("base_dados")){
      exit(mysql_erro());
   }

  // Sql de consulta

    $sql=("select * from cliven where codven = '".$_REQUEST['codven']."' ");
    $resultado=mysql_query($sql);
    if (mysql_num_rows($resultado) > 0) {
       $sql= mysql_query("select  cliente.id,cliente.tipo,cliente.nomecli,cliente.fantasia,cliente.endereco,cliente.nro,
                                  cliente.compl,cliente.bairro,cliente.cep,cliente.cidade,cliente.estado,cliente.dtcad,cliven.codven,cliven.rota,
                                  cliente.fone,cliente.cnpj,cliente.insccli,cliente.ultcompra from cliente,cliven
                                  where cliente.id = cliven.codcli and cliven.codven = '".$_REQUEST['codven']."' ");
       while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
       print(json_encode($result));
       mysql_close();}

    }
      else { 
          echo "N";   

        }

?>


 