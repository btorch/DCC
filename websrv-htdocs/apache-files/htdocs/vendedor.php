<?php

   //abre conexao com o banco
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
   }

   if (!mysql_select_db("base_dados")){
      exit(mysql_erro());
   }

  // Sql de consulta
    $sql=mysql_query("select * from vendedor");
    while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
    print(json_encode($result));
    mysql_close();
   }
     
?>
 
