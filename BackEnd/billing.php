<?php
// File: api/patient_records.php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");;
// Khi trình duyệt gửi phương thức OPTIONS, chúng ta trả về status 200 và dừng script ngay lập tức.
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

function getDBConnection() {
    $host = 'localhost';
    $dbname = 'clinic_db';
    $username = 'root';
    $password = '';

    return new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $username,
        $password,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
}

if (!isset($_GET['encounter_id'])) {
    echo json_encode([
        'success' => false,
        'error' => 'Missing encounter_id'
    ]);
    exit;
}
$encounterId = (int)$_GET['encounter_id'];
try {
    $db = getDBConnection();
    // 1. Lấy thuốc
    $stmt = $db->prepare("
        SELECT 
            m.name,
            m.price,
            pi.qty,
            (m.price * pi.qty) AS subtotal
        FROM prescriptions pr
        JOIN prescription_items pi ON pr.id = pi.prescription_id
        JOIN medicines m ON pi.medicine_id = m.id
        WHERE pr.encounter_id = ?
    ");
    $stmt->execute([$encounterId]);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $total = 0;
    foreach ($items as $i) {
        $total += $i['subtotal'];
    }

    // 2. Kiểm tra invoice
    $stmt = $db->prepare("SELECT id FROM invoices WHERE encounter_id = ?");
    $stmt->execute([$encounterId]);
    $invoice = $stmt->fetch();

    if (!$invoice) {
        // tạo mới
        $stmt = $db->prepare("
            INSERT INTO invoices (encounter_id, total_amount, status)
            VALUES (?, ?, 'unpaid')
        ");
        $stmt->execute([$encounterId, $total]);
        $invoiceId = $db->lastInsertId();
    } else {
        // cập nhật tổng tiền
        $invoiceId = $invoice['id'];
        $stmt = $db->prepare("
            UPDATE invoices SET total_amount = ? WHERE id = ?
        ");
        $stmt->execute([$total, $invoiceId]);
    }
    echo json_encode([
        'success' => true,
        'invoice_id' => $invoiceId,
        'items' => $items,
        'total_amount' => $total
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
