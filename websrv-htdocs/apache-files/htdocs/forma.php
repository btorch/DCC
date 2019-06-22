<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  $pdo = db_connect();

  // Run Prepared Statement
  $stm = $pdo->prepare("SELECT * FROM prazo");
  $stm->execute();
  $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  print(json_encode($rows));
  //echo json_last_error_msg();
  
  // Close PDO
  $pdo = null
?>
