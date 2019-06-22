<?php

if (@mysql_connect("localhost", "root", "")) {
	
	} else {
		echo "N";
                exit;
	} 

   $codven = $_REQUEST['codven'];

   //abre conexao com o banco
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
   }

   if (!mysql_select_db("base_dados")){
      exit(mysql_erro());
   }

  // Sql de consulta

    $sql=mysql_query("select * from rota where codven = '".$_REQUEST['codven']."' ");
    while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
    print(json_encode($result));
    mysql_close();
    

?>
 
 