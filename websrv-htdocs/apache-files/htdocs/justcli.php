<?php





      $conn = mysql_connect("localhost", "root", "");
      $db  = mysql_select_db("base_dados");

      $SQL = "insert into justcli (id,codven,data,hora,codjust)";
      $SQL .= " values ('".$_GET['id']."','".$_GET['codven']."','".$_GET['data']."','".$_GET['hora']."','".$_GET['codjust']."')";
      $query = mysql_query($SQL);
 
      if (mysql_affected_rows($conn) > 0 ) {
         echo "Y";
         } else {
            echo "N";
        }


  
  ?>