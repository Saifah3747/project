<?php
header('Content-Type: application/json');
require 'db.php';

$stmt = $pdo->prepare("SELECT * FROM transactions ORDER BY timestamp DESC");
$stmt->execute();
$transactions = $stmt->fetchAll();

echo json_encode(['status'=>'success','transactions'=>$transactions]);
?>
