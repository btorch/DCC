<?php
function db_connect($mode = "ro") {
  // Load configuration as an array.
  switch ($mode) {
    case "ro":
      $config = parse_ini_file('../../htdocs-priv/dbconfig.ini');
      break;
    case "rw":
      $config = parse_ini_file('../../htdocs-priv/dbconfig-rw.ini');
      break;
    default:
      $config = parse_ini_file('../../htdocs-priv/dbconfig.ini');
  }
  $dsn = "mysql:host=".$config['servername'].";port=3306;dbname=".$config['dbname'].";charset=utf8mb4";
  $options = array(PDO::ATTR_PERSISTENT => true);
  try {
    $dbh = new PDO($dsn,$config['username'],$config['password'],$options);
  } catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
    exit;
  }
  return $dbh;
}
