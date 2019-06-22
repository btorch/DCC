<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  $pdo = db_connect();

  // Get URL string embedded param
  $codven = $_REQUEST['codven'];

  // Run Prepared Statement
  $stm = $pdo->prepare("SELECT cliente.id,cliente.nomecli,cliente.fantasia,cliente.endereco,cliente.nro,
                             cliente.compl,cliente.bairro,cliente.cep,cliente.cidade,cliente.estado,cliente.dtcad,cliven.codven,
                             cliente.fone,cliente.cnpj,cliente.insccli,cliente.ultcompra from cliente,cliven
                             WHERE cliente.id = cliven.codcli AND cliven.codven = :codven ");

  $stm->bindParam(':codven', $codven);
  $stm->execute();
  $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  print(json_encode($rows));

  // Close PDO
  $pdo = null
?>
