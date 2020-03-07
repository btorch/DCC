<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  try {
    $pdo = db_connect("rw");
    //$pdo->exec('SET NAMES utf8');
  } catch (PDOException $e) {
    echo "N";
    echo 'Connection Failed: ' . $e->getMessage();
  }

  // Get Data - assuming from a form method
  $id = $_GET['id'];
  $data = $_GET['data'];
  $codcli = $_GET['codcli'];
  $codven = $_GET['codven'];
  $condpgto = $_GET['condpgto'];
  $formpgto = $_GET['formpgto'];
  $totped  = $_GET['totped'];
  $status = $_GET['status'];
  $obs = $_GET['obs'];

  try {
    $stm = $pdo->prepare("INSERT INTO pedido (id, data, codcli, codven, condpgto, formpgto, totped, status, obs)
                          VALUES (:id, :data, :codcli, :codven, :condpgto, :formpgto, :totped, :status, :obs)");
    $stm->bindParam(':id', $id);
    $stm->bindParam(':data', $data);
    $stm->bindParam(':codcli', $codcli);
    $stm->bindParam(':codven', $codven);
    $stm->bindParam(':condpgto', $condpgto);
    $stm->bindParam(':formpgto', $formpgto);
    $stm->bindParam(':totped', $totped);
    $stm->bindParam(':status', $status);
    $stm->bindParam(':obs', $obs);
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
