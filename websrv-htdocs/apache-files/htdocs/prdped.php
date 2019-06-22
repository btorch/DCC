<?php
      if (@mysql_connect("localhost", "root", "")) {
		
	} else {
		echo "N";
                exit;
	}


      $conn = mysql_connect("localhost", "root", "");
      $db  = mysql_select_db("base_dados");

      $sql=("delete from prdped where id = '".$_GET['id']."' and codven = '".$_GET['codven']."' and cdpro = '".$_GET['cdpro']."' ");
      $query = mysql_query($sql);


      $SQL = "insert into prdped (id,data,codcli,codven,cdpro,qtd,prunit,desconto,total)";
      $SQL .= " values ('".$_GET['id']."','".$_GET['data']."','".$_GET['codcli']."','".$_GET['codven']."','".$_GET['cdpro']."','".$_GET['qtd']."','".$_GET['prunit']."','".$_GET['desconto']."','".$_GET['total']."')";
      $query = mysql_query($SQL);
      if (mysql_affected_rows($conn) > 0 ) {
         echo "Y";
         } else {
            echo "N";
        }
 
  ?>


