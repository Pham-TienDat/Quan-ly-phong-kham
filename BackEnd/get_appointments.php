<?php
// Cho phép tất cả các nguồn truy cập (Sửa lỗi CORS)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clinic_db";

// 1. Kết nối database
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Kết nối thất bại"]));
}

// 2. Truy vấn dữ liệu
$sql = "SELECT 
    p.full_name AS ten_benh_nhan, 
    u.full_name AS ten_bac_si,
    a.start_time AS start_time,
    a.status AS status
FROM appointments a
-- Kết nối với bảng patients để lấy tên bệnh nhân
JOIN patients p ON a.patient_id = p.id
-- Kết nối với bảng doctors thông qua doctor_id
JOIN doctors d ON a.doctor_id = d.id
-- Kết nối tiếp với bảng users để lấy tên thật của bác sĩ
JOIN users u ON d.user_id = u.id
WHERE DATE(a.start_time) = CURDATE();
";

$result = $conn->query($sql);

$appointments = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $appointments[] = $row;
    }
}

// 3. Trả về kết quả JSON
echo json_encode($appointments);

$conn->close();
?>