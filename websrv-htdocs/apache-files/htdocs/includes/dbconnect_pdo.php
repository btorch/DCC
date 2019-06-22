<?php
function db_connect() {
  // Load configuration as an array. 
  $config = parse_ini_file('../htdocs-priv/dbconfig.ini');
  $dsn = "mysql:host=".$config['servername'].";port=3306;dbname=".$config['dbname'];
  // options = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');
  $options = array(PDO::ATTR_PERSISTENT => true);

  try {
    $dbh = new PDO($dsn,$config['username'],$config['password'],$options);
  } catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
    exit;
  }
  return $dbh;
}
?> 
