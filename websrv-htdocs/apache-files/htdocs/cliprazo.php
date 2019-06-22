<?php

   
    $codven = $_REQUEST['codven'];

   //abre conexao com o banco
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
   }

   if (!mysql_select_db("base_dados")){
      exit(mysql_erro());
   }

  // Sql de consulta
    $sql=("select * from cliprazo where codven = '".$_REQUEST['codven']."' ");
    $resultado=mysql_query($sql);
    if (mysql_num_rows($resultado) > 0) {
       $sql= mysql_query("select * from cliprazo where codven = '".$_REQUEST['codven']."' ");
       while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
       print(json_encode($result));
       mysql_close();}
         
   
?>

 