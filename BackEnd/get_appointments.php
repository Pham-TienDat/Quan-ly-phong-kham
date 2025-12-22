<?php
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
$sql = "SELECT patient, start_time, doctor_id, status FROM appointments";
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