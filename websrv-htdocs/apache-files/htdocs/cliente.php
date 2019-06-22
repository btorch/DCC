<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  $pdo = db_connect();

  // Get URL string embedded param
  $codven = $_REQUEST['codven'];

  $stm = $pdo->query("SELECT cliente.id,cliente.nomecli,cliente.fantasia,cliente.endereco,cliente.nro,
                             cliente.compl,cliente.bairro,cliente.cep,cliente.cidade,cliente.estado,cliente.dtcad,cliven.codven,
                             cliente.fone,cliente.cnpj,cliente.insccli,cliente.ultcompra from cliente,cliven
                             WHERE cliente.id = cliven.codcli AND cliven.codven = '".$_REQUEST['codven']."' ");

  $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  print(json_encode($rows));
  $pdo = null

  // $sql=("select * from cliven where codven = '".$_REQUEST['codven']."' ");
   
?>
