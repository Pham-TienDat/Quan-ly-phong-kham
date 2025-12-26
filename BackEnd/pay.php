<?php
// File: api/patient_records.php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");
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

// Chỉ cho phép POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'success' => false,
        'error' => 'Method not allowed'
    ]);
    exit;
}

if (!isset($_POST['invoice_id']) || !isset($_POST['method'])) {
    echo json_encode([
        'success' => false,
        'error' => 'Missing invoice_id or method'
    ]);
    exit;
}

$invoiceId = (int)$_POST['invoice_id'];
$method = trim($_POST['method']);

try {
    $db = getDBConnection();
    $db->beginTransaction();

    // Lấy hóa đơn
    $stmt = $db->prepare("
        SELECT total_amount, status 
        FROM invoices 
        WHERE id = ?
        FOR UPDATE
    ");
    $stmt->execute([$invoiceId]);
    $invoice = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$invoice) {
        throw new Exception("Invoice not found");
    }

    if ($invoice['status'] === 'paid') {
        throw new Exception("Invoice already paid");
    }

    $amount = $invoice['total_amount'];

    // Ghi payment
    $stmt = $db->prepare("
        INSERT INTO payments (invoice_id, amount, method)
        VALUES (?, ?, ?)
    ");
    $stmt->execute([$invoiceId, $amount, $method]);

    // Cập nhật invoice
    $stmt = $db->prepare("
        UPDATE invoices
        SET status = 'paid', paid_at = NOW()
        WHERE id = ?
    ");
    $stmt->execute([$invoiceId]);

    $db->commit();

    echo json_encode([
        'success' => true,
        'message' => 'Payment successful',
        'invoice_id' => $invoiceId,
        'amount' => $amount
    ]);

} catch (Exception $e) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
