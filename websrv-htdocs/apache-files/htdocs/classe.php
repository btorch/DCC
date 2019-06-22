<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  $pdo = db_connect();

  // Run Prepared Statement
  $stm = $pdo->prepare("SELECT * FROM classe");
  $stm->execute()  
  $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  print(json_encode($rows));

  // Close PDO
  $pdo = null;
?>
