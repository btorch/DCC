<?php

   
    $codven = $_REQUEST['codven'];

   //abre conexao com o banco
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
   }

   if (!mysql_select_db("base_dados")){
      exit(mysql_erro());
   }

    $sql=("select * from mensagem where codven = '".$_REQUEST['codven']."' ");

    $resultado=mysql_query($sql);


    if (mysql_num_rows($resultado) > 0) {

       $sql= mysql_query("delete from mensagem where codven = '".$_REQUEST['codven']."'");
       mysql_close();}

    
?>

