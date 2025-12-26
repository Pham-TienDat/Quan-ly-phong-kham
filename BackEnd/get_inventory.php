<?php
// 1. Hiển thị lỗi để dễ kiểm tra
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// 2. CẤU HÌNH CORS (Giải quyết lỗi Access Control Check)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Trả lời yêu cầu kiểm tra của trình duyệt (Preflight)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

// 3. KẾT NỐI DATABASE (Viết trực tiếp để tránh lỗi file config)
$host = "localhost";
$db_name = "clinic_db";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->exec("set names utf8mb4");
} catch(PDOException $e) {
    die(json_encode(["error" => "Kết nối thất bại: " . $e->getMessage()]));
}

$method = $_SERVER['REQUEST_METHOD'];

// 4. XỬ LÝ LẤY DANH SÁCH (GET)
if ($method == 'GET') {
    try {
        $query = "SELECT id, name, code, unit, price, stock_qty FROM medicines ORDER BY name ASC";
        $stmt = $conn->prepare($query);
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($results ? $results : []);
    } catch(PDOException $e) {
        echo json_encode(["error" => $e->getMessage()]);
    }
}

// 5. XỬ LÝ XÓA (DELETE)
if ($method == 'DELETE') {
    $id = $_GET['id'] ?? null;
    if ($id) {
        $stmt = $conn->prepare("DELETE FROM medicines WHERE id = ?");
        $stmt->execute([$id]);
        echo json_encode(["success" => true]);
    }
    exit;
}

// 6. XỬ LÝ THÊM/SỬA (POST)
if ($method == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    if (!$data) exit;

    if (isset($data->id) && !empty($data->id)) {
        // SỬA
        $sql = "UPDATE medicines SET name=?, code=?, unit=?, stock_qty=?, price=? WHERE id=?";
        $params = [$data->name, $data->code, $data->unit, $data->stock_qty, $data->price, $data->id];
    } else {
        // THÊM
        $sql = "INSERT INTO medicines (name, code, unit, stock_qty, price) VALUES (?, ?, ?, ?, ?)";
        $params = [$data->name, $data->code, $data->unit, $data->stock_qty, $data->price];
    }

    $stmt = $conn->prepare($sql);
    $stmt->execute($params);
    echo json_encode(["success" => true]);
    exit;
}
?>