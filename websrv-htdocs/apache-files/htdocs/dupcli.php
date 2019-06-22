<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  $pdo = db_connect();

  // Get URL string embedded param
  $codven = $_REQUEST['codven'];

  // Run Prepared Statement
  $stm = $pdo->prepare("SELECT dupcli.codcli,dupcli.codven,dupcli.numdup,dupcli.emissao,dupcli.dtvcto,dupcli.saldev 
                          FROM cliven,dupcli WHERE cliven.codcli = dupcli.codcli and cliven.codven = :codven");
   
  $stm->bindParam(':codven', $codven);
  $stm->execute();
  $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  print(json_encode($rows));
  //echo json_last_error_msg();
  
  // Close PDO
  $pdo = null
?>
