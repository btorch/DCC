<?php


      $conn = mysql_connect("localhost", "root", "");
      $db  = mysql_select_db("base_dados");

      $SQL = "insert into justcli (id)";
      $SQL .= " values ('".$_GET['id']."')";
      $query = mysql_query($SQL);
 
      if (mysql_affected_rows($conn) > 0 ) {
         echo "Y";
         } else {
            echo "N";
        }
  
  ?>


