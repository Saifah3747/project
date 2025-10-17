<?php
header('Content-Type: application/json');
require 'db.php';

$data = json_decode(file_get_contents('php://input'), true);
$rfid = $data['rfid'] ?? '';

if (!$rfid) {
    echo json_encode(['status'=>'error','message'=>'RFID missing']);
    exit;
}

// ตรวจ user
$stmt = $pdo->prepare("SELECT * FROM users WHERE rfid_tag=?");
$stmt->execute([$rfid]);
$user = $stmt->fetch();

if (!$user) {
    // บันทึก failed scan
    $stmt = $pdo->prepare("INSERT INTO transactions (locker_id, action, rfid_tag) VALUES (1,'failed_scan',?)");
    $stmt->execute([$rfid]);
    echo json_encode(['status'=>'error','message'=>'RFID not recognized']);
    exit;
}

// ดึง locker
$stmt = $pdo->prepare("SELECT * FROM lockers WHERE locker_id=1");
$stmt->execute();
$locker = $stmt->fetch();

// toggle status
$new_status = ($locker['status'] === 'available') ? 'in_use' : 'available';

// อัปเดต locker
$stmt = $pdo->prepare("UPDATE lockers SET status=?, last_opened_by=?, updated_at=NOW() WHERE locker_id=1");
$stmt->execute([$new_status, $user['user_id']]);

// บันทึก transaction
$action = ($new_status === 'in_use') ? 'open' : 'close';
$stmt = $pdo->prepare("INSERT INTO transactions (locker_id,user_id,action,rfid_tag) VALUES (1,?,?,?)");
$stmt->execute([$user['user_id'], $action, $rfid]);

echo json_encode([
    'status'=>'success',
    'user'=>$user['name'],
    'user_id'=>$user['user_id'],
    'locker_id'=>1,
    'new_status'=>$new_status
]);
?>
