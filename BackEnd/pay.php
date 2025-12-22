<?php
header('Content-Type: application/json; charset=utf-8');

function getDB() {
    return new PDO(
        "mysql:host=127.0.0.1;dbname=clinic_db;charset=utf8mb4",
        "root",
        "",
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
    $db = getDB();
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
