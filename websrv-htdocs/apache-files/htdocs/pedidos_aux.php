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
    $sql=("select * from pedido where codven = '".$_REQUEST['codven']."' ");

    $resultado=mysql_query($sql);
    if (mysql_num_rows($resultado) > 0) {
       $sql= mysql_query("select pedido.id,pedido.data,pedido.codcli,cliente.nomecli,pedido.codven,pedido.formpgto,pedido.condpgto,pedido.totped,pedido.status,pedido.obs from pedido,cliente  where pedido.codcli = cliente.id and pedido.codven = '".$_REQUEST['codven']."' ");

       while($linha=mysql_fetch_assoc($sql))  $result[]=$linha;
       print(json_encode($result));
       mysql_close();}

   
?>
 

