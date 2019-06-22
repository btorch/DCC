<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  try {
    $pdo = db_connect();
  catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
  }

  // Get URL string embedded param
  $codven = $_REQUEST['codven'];

  try {
    $stm = $pdo->prepare("SELECT prd.id, prd.data, prd.codcli, prd.codven, prd.cdpro, p.nomepro,
                          prd.qtd, prd.prunit, prd.desconto, prd.total FROM prdped AS prd, produto AS p
                          WHERE p.id = prd.cdpro AND prd.codven = :codven");
    $stm->bindParam(':codven', $codven);
    $stm->execute();
    $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  catch (PDOException $e) {
    echo 'Prepared Statement Failed: ' . $e->getMessage();
  }

  print(json_encode($rows));
  //echo json_last_error_msg();

  // Close PDO
  $pdo = null
?>
