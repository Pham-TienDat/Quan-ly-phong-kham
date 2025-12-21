<?php
// 1. Kết nối cơ sở dữ liệu
$conn = mysqli_connect("localhost", "root", "", "clinic_db");
if (!$conn) {
    die("Lỗi kết nối hệ thống.");
}
mysqli_set_charset($conn, "utf8mb4");

// 2. Tiếp nhận dữ liệu từ Form
$phone = mysqli_real_escape_string($conn, $_POST['phone']);
$full_name = mysqli_real_escape_string($conn, $_POST['full_name']);
$reason = mysqli_real_escape_string($conn, $_POST['reason']);
$dob = $_POST['dob'];
$ins = mysqli_real_escape_string($conn, $_POST['insurance_no']);

// Bước 1: Tra cứu hoặc tạo mới hồ sơ bệnh nhân
$check_sql = "SELECT id FROM patients WHERE phone = '$phone' LIMIT 1";
$result = mysqli_query($conn, $check_sql);

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    $patient_id = $row['id'];
} else {
    // Tạo hồ sơ mới nếu là bệnh nhân mới
    $sql_new_patient = "INSERT INTO patients (full_name, dob, phone, insurance_no) 
                        VALUES ('$full_name', '$dob', '$phone', '$ins')";
    mysqli_query($conn, $sql_new_patient);
    $patient_id = mysqli_insert_id($conn);
}

// Bước 2: Tạo lượt khám mới (Appointments)
$sql_app = "INSERT INTO appointments (patient_id, start_time, status, reason) 
            VALUES ('$patient_id', NOW(), 'scheduled', '$reason')";

if (mysqli_query($conn, $sql_app)) {
    $stt = mysqli_insert_id($conn); 
    
    // Bước 3: Ghi nhật ký hệ thống (Audit Logs)
    $action = "Đăng ký khám mới cho BN: " . $full_name;
    $sql_log = "INSERT INTO audit_logs (action, resource_type, resource_id) 
                VALUES ('$action', 'appointments', '$stt')";
    mysqli_query($conn, $sql_log);

    // Trả về kết quả đầu ra
    echo "<div style='text-align: center; padding: 50px; font-family: Arial;'>";
    echo "<h2>ĐĂNG KÝ THÀNH CÔNG</h2>";
    echo "<p>Bệnh nhân: <b>$full_name</b></p>";
    echo "<h1>SỐ THỨ TỰ: $stt</h1>";
    echo "<button onclick='window.print()'>In phiếu khám</button>";
    echo "<p><a href='../FrontEnd/registration.html'>Quay lại</a></p>";
    echo "</div>";
}
?>