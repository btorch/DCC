<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  try {
    $pdo = db_connect();
    //$pdo->exec('SET NAMES utf8');
  } catch (PDOException $e) {
    echo 'Connection Failed: ' . $e->getMessage();
  }

  // Get URL string embedded param
  $codven = $_REQUEST['codven'];

  try {
    $stm = $pdo->prepare("SELECT * FROM cliente WHERE codven = :codven");
    $stm->bindParam(':codven', $codven);
    $stm->execute();
    $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  } catch (PDOException $e) {
    echo 'Prepared Statememnt Failed: ' . $e->getMessage();
  }

  if ( count($rows) > 0 ){
    // Return JSON Object
    print(json_encode($rows));
    //echo json_last_error_msg();
  } else {
    echo "N";
  }

  // Close PDO
  $pdo = null
?>
