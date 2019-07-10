<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  try {
    $pdo = db_connect("rw");
  } catch (PDOException $e) {
    echo 'Connection Failed: ' . $e->getMessage();
  }

  // Get Data - assuming from a form method
  $id = $_GET['id'];
  $codven = $_GET['codven'];
  $data = $_GET['data'];
  $hora = $_GET['hora'];
  $codjust = $_GET['codjust'];

  try {
    $stm = $pdo->prepare("INSERT INTO justcli (id, codven, data, hora, codjust) VALUES (:id, :codven, :data, :hora, :codjust)");
    $stm->bindParam(':id', $id);
    $stm->bindParam(':codven', $codven);
    $stm->bindParam(':data', $data);
    $stm->bindParam(':hora', $hora);
    $stm->bindParam(':codjust', $codjust);
    $stm->execute();
  } catch (PDOException $e) {
    echo 'Prepared Statememnt Failed: ' . $e->getMessage();
  }

  if ( $stm->rowCount() > 0 ) {
    echo "Y";
  } else {
    echo "N";
  }
?>
