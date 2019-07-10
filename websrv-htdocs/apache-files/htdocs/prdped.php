<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  try {
    $pdo = db_connect("rw");
  } catch (PDOException $e) {
    echo "N";
    echo 'Connection Failed: ' . $e->getMessage();
  }

  // Get Data - assuming from a form method
  $id = $_GET['id'];
  $data = $_GET['data'];
  $codcli = $_GET['codcli'];
  $codven = $_GET['codven'];
  $cdpro = $_GET['cdpro'];
  $qtd = $_GET['qtd'];
  $prunit  = $_GET['prunit'];
  $desconto = $_GET['desconto'];
  $total = $_GET['total'];

  try {
    $stm = $pdo->prepare("DELETE FROM prdped WHERE id = :id AND codven = :codven AND cdpro = :cdpro");
    $stm->bindParam(':id', $id);
    $stm->bindParam(':codven', $codven);
    $stm->bindParam(':cdpro', $cdpro);
    $stm->execute();
  } catch (PDOException $e) {
    echo 'Prepared Statememnt Failed: ' . $e->getMessage();
  }

  try {
    $stm = $pdo->prepare("INSERT INTO prdped (id, data, codcli, codven, cdpro, qtd, prunit, desconto, total)
                          VALUES (:id, :data, :codcli, :codven, :cdpro, :qtd, :prunit, :desconto, :total)");
    $stm->bindParam(':id', $id);
    $stm->bindParam(':data', $data);
    $stm->bindParam(':codcli', $codcli);
    $stm->bindParam(':codven', $codven);
    $stm->bindParam(':cdpro', $cdpro);
    $stm->bindParam(':qtd', $qtd);
    $stm->bindParam(':prunit', $prunit);
    $stm->bindParam(':desconto', $desconto);
    $stm->bindParam(':total', $total);
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
