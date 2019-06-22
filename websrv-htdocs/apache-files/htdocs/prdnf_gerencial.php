<?php
 
if (@mysql_connect("localhost", "root", "")) {

   //abre conexao com o banco
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
    mysql_set_charset('utf8');
   }

   if (!mysql_select_db("base_dados")){
      exit(mysql_erro());
   }

    $sql=("select * from prdnf");

    $resultado=mysql_query($sql);

    if (mysql_num_rows($resultado) > 0) {

       $sql= mysql_query("select * from prdnf");
       while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
       print(json_encode($result));
       mysql_close();}
         
   }
      else { 
          echo "N";   

        }    

?>

  