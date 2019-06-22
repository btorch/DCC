<?php

  

  
    if(!mysql_connect("localhost","root","")){
      exit(mysql_error());
      }

    if (!mysql_select_db("base_dados")){
       exit(mysql_erro());
      }

    $sql=("select * from prdped where codven = '".$_REQUEST['codven']."' ");

    $resultado=mysql_query($sql);
    if (mysql_num_rows($resultado) > 0) {
       $sql= mysql_query("select prdped.id,prdped.data,prdped.codcli,prdped.codven,prdped.cdpro,produto.nomepro,prdped.qtd,prdped.prunit,prdped.desconto,prdped.total from prdped,produto where produto.id = prdped.cdpro and prdped.codven = '".$_REQUEST['codven']."' ");

       while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
       print(json_encode($result));
       mysql_close();}
     


?>
 

