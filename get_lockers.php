<?php
header('Content-Type: application/json');
require 'db.php';

$stmt = $pdo->prepare("SELECT * FROM lockers");
$stmt->execute();
$lockers = $stmt->fetchAll();

echo json_encode(['status'=>'success','lockers'=>$lockers]);
?>
