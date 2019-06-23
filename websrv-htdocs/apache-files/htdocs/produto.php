<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  try {
    $pdo = db_connect();
    //$pdo->exec('SET NAMES utf8');
  } catch (PDOException $e) {
    echo 'Connection Failed: ' . $e->getMessage();
  }
     
  try {
    $stm = $pdo->prepare("SELECT * FROM produto");
    $stm->execute();
    $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
    print(json_encode($rows));
    //echo json_last_error_msg();
  } catch (PDOException $e) {
    echo 'Prepared Statememnt Failed: ' . $e->getMessage();
  }

  // Close PDO
  $pdo = null
?>
