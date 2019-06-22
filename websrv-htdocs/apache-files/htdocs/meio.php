<?php

   //abre conexao com o banco
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
   }

   if (!mysql_select_db("base_dados")){
      exit(mysql_erro());
   }

      $sql=mysql_query("select * from meio");
       while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
       print(json_encode($result));
       mysql_close();

	
?>
 