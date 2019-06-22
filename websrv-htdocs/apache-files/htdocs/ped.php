<?php
if (@mysql_connect("localhost", "root", "")) {
      $conn = mysql_connect("localhost", "root", "");
      $db  = mysql_select_db("base_dados");
      $SQL = "insert into pedido (id,data,codcli,codven,condpgto,formpgto,totped,status,obs)";
      $SQL .= " values ('".$_GET['id']."','".$_GET['data']."', '".$_GET['codcli']."', '".$_GET['codven']."', '".$_GET['condpgto']."','".$_GET['formpgto']."','".$_GET['totped']."','".$_GET['status']."','".$_GET['obs']."')";
      $query = mysql_query($SQL);
      if (mysql_affected_rows($conn) > 0 ) {
         echo "Y";
         } else {
            echo "N";
        }
   }
      else { 
          echo "N";   

        }    
  ?>


