<?php
  require_once('./includes/dbconnect_pdo.php');

  // Connection to DB
  $pdo = db_connect();

  // Run Prepared Statement
  $stm = $pdo->prepare("SELECT prdnf.codfor AS forn,grupo.descricao,sum(prdnf.total) AS geral FROM grupo,prdnf
                        WHERE EXTRACT(month FROM prdnf.data) = '01' AND prdnf.codfor <> '' AND prdnf.codfor = grupo.id
                        GROUP BY prdnf.codfor");
  $stm->execute();
  $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
  print(json_encode($rows));
  //echo json_last_error_msg();

  // Close PDO
  $pdo = null 
?>
