<?php
  
  if (@mysql_connect("localhost", "root", "")) {
		
	} else {
		echo "N";
                exit;
	}

    function converteData($data){
    return (preg_match('/\//',$data)) ? implode('-', array_reverse(explode('/', $data))) : implode('/', array_reverse(explode('-', $data)));
    }

      $conn = mysql_connect("localhost", "root", "");
      $db  = mysql_select_db("base_dados");

      $sql=("delete from pedido where id = '".$_GET['id']."' and codven = '".$_GET['codven']."' ");
      $query = mysql_query($sql);


      $SQL = "insert into pedido (id,dta_lanc,data,codcli,codven,condpgto,formpgto,totped,status,obs)";
      $SQL .= " values ('".$_GET['id']."',NOW() , '".$_GET['data']."', '".$_GET['codcli']."', '".$_GET['codven']."', '".$_GET['condpgto']."','".$_GET['formpgto']."','".$_GET['totped']."','".$_GET['status']."','".$_GET['obs']."')";
      $query = mysql_query($SQL);
      if (mysql_affected_rows($conn) > 0 ) {
         echo "Y";
         } else {
            echo "N";
        }
   
  ?>


