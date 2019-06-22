<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  $pdo = db_connect();

  $stm = $pdo->query("SELECT * FROM classe");
  $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  print(json_encode($rows));

  $pdo = null;
?>
