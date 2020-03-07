<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  try {
    $pdo = db_connect("rw");
    //$pdo->exec('SET NAMES utf8');
  } catch (PDOException $e) {
    echo 'Connection Failed: ' . $e->getMessage();
  }

  // Get Data - assuming from a form method
  $id = $_GET['id'];
  $codven = $_GET['codven'];
  $data = $_GET['data'];
  $hora = $_GET['hora'];

  try {
    $stm = $pdo->prepare("INSERT INTO login (id, codven, data, hora) VALUES (:id, :codven, :data, :hora)");
    $stm->bindParam(':id', $id);
    $stm->bindParam(':codven', $codven);
    $stm->bindParam(':data', $data);
    $stm->bindParam(':hora', $hora);
    $stm->execute();
  } catch (PDOException $e) {
    echo 'Prepared Statememnt Failed: ' . $e->getMessage();
  }

//  if ( $stm->rowCount() > 0 ) {
    print('Y');
//  } else {
//    echo "N";
//  }

?>
