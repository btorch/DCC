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
    $stm = $pdo->prepare("SELECT cliente.id,cliente.tipo,cliente.nomecli,cliente.fantasia,cliente.endereco,cliente.nro,
                                 cliente.compl,cliente.bairro,cliente.cep,cliente.cidade,cliente.estado,cliente.dtcad,cliven.codven,cliven.rota,
                                 cliente.fone,cliente.cnpj,cliente.insccli,cliente.ultcompra FROM cliente,cliven
                                 WHERE cliente.id = cliven.codcli AND cliven.codven = :codven ");
    $stm->bindParam(':codven', $codven);
    $stm->execute();
    $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  } catch (PDOException $e) {
    echo 'Prepared Statememnt Failed: ' . $e->getMessage();
  }

  if ( count($rows) > 0 ){
    // Return JSON Object
    print(json_encode($rows));
    //print(json_encode($rows, JSON_UNESCAPED_UNICODE));
    //echo json_last_error_msg();
  } else {
    echo "N";
  }


  // Close PDO
  $pdo = null
?>
