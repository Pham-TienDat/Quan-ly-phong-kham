
-- 1) Tạo database và chọn d
CREATE DATABASE clinic_db
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
USE clinic_db;

-- 2) Bảng users
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `full_name` VARCHAR(200),
  `email` VARCHAR(200),
  `role` VARCHAR(50) NOT NULL,
  `password_hash` VARCHAR(255),
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3) Bảng patients
CREATE TABLE IF NOT EXISTS `patients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(200) NOT NULL,
  `dob` DATE,
  `gender` VARCHAR(10),
  `phone` VARCHAR(50),
  `address` TEXT,
  `insurance_no` VARCHAR(100),
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4) Bảng doctors
CREATE TABLE IF NOT EXISTS `doctors` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT,
  `specialty` VARCHAR(200),
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_doctors_user_id` (`user_id`),
  CONSTRAINT `fk_doctors_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5) Bảng appointments
CREATE TABLE IF NOT EXISTS `appointments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT,
  `doctor_id` INT,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME,
  `status` VARCHAR(50) DEFAULT 'scheduled',
  `reason` TEXT,
  `created_by` INT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_app_patient` (`patient_id`),
  KEY `idx_app_doctor` (`doctor_id`),
  CONSTRAINT `fk_app_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_app_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6) Bảng encounters
CREATE TABLE IF NOT EXISTS `encounters` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `appointment_id` INT,
  `patient_id` INT,
  `doctor_id` INT,
  `encounter_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `diagnosis` TEXT,
  `notes` TEXT,
  PRIMARY KEY (`id`),
  KEY `idx_enc_appt` (`appointment_id`),
  KEY `idx_enc_patient` (`patient_id`),
  KEY `idx_enc_doctor` (`doctor_id`),
  CONSTRAINT `fk_enc_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_enc_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_enc_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7) Bảng medicines
CREATE TABLE IF NOT EXISTS `medicines` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `code` VARCHAR(100),
  `unit` VARCHAR(50),
  `price` DECIMAL(12,2),
  `stock_qty` INT DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_medicines_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8) Bảng prescriptions
CREATE TABLE IF NOT EXISTS `prescriptions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `encounter_id` INT,
  `prescribed_by` INT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pres_enc` (`encounter_id`),
  CONSTRAINT `fk_pres_enc` FOREIGN KEY (`encounter_id`) REFERENCES `encounters`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9) Bảng prescription_items
CREATE TABLE IF NOT EXISTS `prescription_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `prescription_id` INT,
  `medicine_id` INT,
  `dose` VARCHAR(200),
  `qty` INT,
  `instructions` TEXT,
  PRIMARY KEY (`id`),
  KEY `idx_pi_pres` (`prescription_id`),
  KEY `idx_pi_med` (`medicine_id`),
  CONSTRAINT `fk_pi_pres` FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pi_med` FOREIGN KEY (`medicine_id`) REFERENCES `medicines`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10) Bảng invoices
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `encounter_id` INT,
  `total_amount` DECIMAL(12,2),
  `status` VARCHAR(50) DEFAULT 'unpaid',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `paid_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  KEY `idx_inv_enc` (`encounter_id`),
  CONSTRAINT `fk_inv_enc` FOREIGN KEY (`encounter_id`) REFERENCES `encounters`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11) Bảng payments
CREATE TABLE IF NOT EXISTS `payments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `invoice_id` INT,
  `amount` DECIMAL(12,2),
  `method` VARCHAR(50),
  `paid_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pay_inv` (`invoice_id`),
  CONSTRAINT `fk_pay_inv` FOREIGN KEY (`invoice_id`) REFERENCES `invoices`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12) Bảng audit_logs
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT,
  `action` TEXT,
  `resource_type` VARCHAR(100),
  `resource_id` INT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_user` (`user_id`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================
-- 13) Dữ liệu mẫu (tiếng Việt)
-- Chú ý: dùng INSERT IGNORE với key unique để tránh lỗi nếu chạy nhiều lần
-- ============================

-- 13.1) Người dùng mẫu (username unique)
INSERT IGNORE INTO `users` (username, full_name, email, role, password_hash)
VALUES
  ('admin', 'Quản trị Phòng Khám', 'admin@example.com', 'admin', 'changeme'),
  ('dr_hoang', 'Bs. Hoàng Văn A', 'hoang@example.com', 'doctor', 'changeme'),
  ('dr_linh', 'Bs. Lê Thị Linh', 'linh@example.com', 'doctor', 'changeme'),
  ('reception1', 'Lễ tân 1', 'lt1@example.com', 'reception', 'changeme'),
  ('account1', 'Kế toán 1', 'ketoan@example.com', 'accountant', 'changeme');

-- 13.2) Bác sĩ (tham chiếu users)
INSERT IGNORE INTO `doctors` (user_id, specialty, created_at)
VALUES
  ((SELECT id FROM users WHERE username='dr_hoang'), 'Nội tiêu hóa', NOW()),
  ((SELECT id FROM users WHERE username='dr_linh'), 'Nội tổng quát', NOW());

-- 13.3) Bệnh nhân mẫu (20 bản ghi)
INSERT INTO `patients` (full_name, dob, gender, phone, address, insurance_no, created_at) VALUES
('Nguyễn Văn An', '1982-02-14', 'male', '0901234001', 'Quận 1, TP.HCM', 'BHYT-A001', NOW()),
('Trần Thị Bích', '1990-07-22', 'female', '0901234002', 'Quận 3, TP.HCM', 'BHYT-B002', NOW()),
('Lê Văn Cường', '1975-12-05', 'male', '0901234003', 'Hà Nội', 'BHYT-C003', NOW()),
('Phạm Thị Dung', '1988-04-10', 'female', '0901234004', 'Hải Phòng', 'BHYT-D004', NOW()),
('Hoàng Minh Đức', '1995-09-01', 'male', '0901234005', 'Đà Nẵng', 'BHYT-E005', NOW()),
('Ngô Thị Em', '2000-11-11', 'female', '0901234006', 'Cần Thơ', 'BHYT-F006', NOW()),
('Vũ Văn Phong', '1968-03-03', 'male', '0901234007', 'Bắc Ninh', 'BHYT-G007', NOW()),
('Đặng Thị Hồng', '1984-06-30', 'female', '0901234008', 'Thanh Hóa', 'BHYT-H008', NOW()),
('Trương Văn Khoa', '1979-08-16', 'male', '0901234009', 'Nghệ An', 'BHYT-I009', NOW()),
('Mai Thị Lan', '1992-01-20', 'female', '0901234010', 'Bình Dương', 'BHYT-J010', NOW()),
('Phan Văn Long', '1986-10-02', 'male', '0901234011', 'Đồng Nai', 'BHYT-K011', NOW()),
('Bùi Thị Mai', '1998-05-15', 'female', '0901234012', 'Hải Dương', 'BHYT-L012', NOW()),
('Lộc Văn Nam', '1970-07-07', 'male', '0901234013', 'Quảng Ninh', 'BHYT-M013', NOW()),
('Nguyễn Thị Oanh', '1981-02-19', 'female', '0901234014', 'Thái Bình', 'BHYT-N014', NOW()),
('Trịnh Văn Phát', '1993-12-25', 'male', '0901234015', 'Hòa Bình', 'BHYT-O015', NOW()),
('Đỗ Thị Quỳnh', '1987-09-09', 'female', '0901234016', 'Vĩnh Phúc', 'BHYT-P016', NOW()),
('Phùng Văn Sơn', '1965-04-04', 'male', '0901234017', 'Nam Định', 'BHYT-Q017', NOW()),
('Nguyễn Thị Tâm', '1996-03-03', 'female', '0901234018', 'Thừa Thiên Huế', 'BHYT-R018', NOW()),
('Hoàng Văn Uy', '2002-02-02', 'male', '0901234019', 'Kon Tum', 'BHYT-S019', NOW()),
('Lê Thị Vân', '1991-08-08', 'female', '0901234020', 'Nha Trang', 'BHYT-T020', NOW());

-- 13.4) Thuốc mẫu (15 thuốc)
INSERT IGNORE INTO `medicines` (name, code, unit, price, stock_qty) VALUES
('Paracetamol 500mg', 'MED-0001', 'viên', 1500.00, 200),
('Aspirin 81mg', 'MED-0002', 'viên', 1200.00, 150),
('Amoxicillin 500mg', 'MED-0003', 'viên', 4500.00, 80),
('Omeprazole 20mg', 'MED-0004', 'viên', 8000.00, 60),
('Ibuprofen 400mg', 'MED-0005', 'viên', 3000.00, 100),
('Vitamin C 500mg', 'MED-0006', 'viên', 1000.00, 300),
('Metformin 500mg', 'MED-0007', 'viên', 2500.00, 120),
('Atorvastatin 20mg', 'MED-0008', 'viên', 20000.00, 50),
('Lisinopril 10mg', 'MED-0009', 'viên', 18000.00, 40),
('Cetirizine 10mg', 'MED-0010', 'viên', 2500.00, 90),
('Salbutamol inhaler', 'MED-0011', 'lọ', 70000.00, 30),
('Prednisone 5mg', 'MED-0012', 'viên', 5000.00, 70),
('Furosemide 40mg', 'MED-0013', 'viên', 6000.00, 60),
('Amiodarone 200mg', 'MED-0014', 'viên', 15000.00, 20),
('Ciprofloxacin 500mg', 'MED-0015', 'viên', 10000.00, 40);

-- 13.5) Lịch hẹn mẫu (3 bản ghi)
INSERT INTO `appointments` (patient_id, doctor_id, start_time, end_time, status, reason, created_by, created_at)
VALUES
(
  (SELECT id FROM patients WHERE full_name='Nguyễn Văn An' LIMIT 1),
  (SELECT id FROM doctors ORDER BY id LIMIT 1),
  DATE_ADD(NOW(), INTERVAL 2 HOUR),
  DATE_ADD(DATE_ADD(NOW(), INTERVAL 2 HOUR),INTERVAL 20 MINUTE),
  'scheduled',
  'Khám tổng quát',
  (SELECT id FROM users WHERE username='reception1' LIMIT 1),
  NOW()
),
(
  (SELECT id FROM patients WHERE full_name='Trần Thị Bích' LIMIT 1),
  (SELECT id FROM doctors ORDER BY id LIMIT 1),
  DATE_ADD(NOW(), INTERVAL 1 DAY),
  DATE_ADD(DATE_ADD(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE),
  'scheduled',
  'Đau bụng',
  (SELECT id FROM users WHERE username='reception1' LIMIT 1),
  NOW()
),
(
  (SELECT id FROM patients WHERE full_name='Lê Văn Cường' LIMIT 1),
  (SELECT id FROM doctors ORDER BY id LIMIT 1 OFFSET 1),
  DATE_ADD(NOW(), INTERVAL 3 DAY),
  DATE_ADD(DATE_ADD(NOW(), INTERVAL 3 DAY),INTERVAL 30 MINUTE),
  'scheduled',
  'Tái khám huyết áp',
  (SELECT id FROM users WHERE username='reception1' LIMIT 1),
  NOW()
);

-- 13.6) Encounter, prescription, prescription_items cho 1 appointment
INSERT INTO `encounters` (appointment_id, patient_id, doctor_id, encounter_date, diagnosis, notes)
VALUES
(
  (SELECT id FROM appointments WHERE reason='Khám tổng quát' LIMIT 1),
  (SELECT patient_id FROM appointments WHERE reason='Khám tổng quát' LIMIT 1),
  (SELECT doctor_id FROM appointments WHERE reason='Khám tổng quát' LIMIT 1),
  NOW(),
  'Khám tổng quát, không phát hiện dấu hiệu nặng. Hẹn tái khám 1 tháng.',
  'Khuyến cáo nghỉ ngơi, xét nghiệm máu nếu cần.'
);

INSERT INTO `prescriptions` (encounter_id, prescribed_by, created_at)
VALUES
(
  (SELECT id FROM encounters ORDER BY id DESC LIMIT 1),
  (SELECT id FROM users WHERE username='dr_hoang' LIMIT 1),
  NOW()
);

INSERT INTO `prescription_items` (prescription_id, medicine_id, dose, qty, instructions)
VALUES
(
  (SELECT id FROM prescriptions ORDER BY id DESC LIMIT 1),
  (SELECT id FROM medicines WHERE code='MED-0001' LIMIT 1),
  '1 viên x 3 lần/ngày',
  10,
  'Uống sau ăn'
);

-- 13.7) Hoá đơn & thanh toán mẫu
INSERT INTO `invoices` (encounter_id, total_amount, status, created_at)
VALUES
(
  (SELECT id FROM encounters ORDER BY id DESC LIMIT 1),
  150000.00,
  'unpaid',
  NOW()
);

INSERT INTO `payments` (invoice_id, amount, method, paid_at)
VALUES
(
  (SELECT id FROM invoices ORDER BY id DESC LIMIT 1),
  150000.00,
  'Tiền mặt',
  NOW()
);

-- 13.8) Audit logs mẫu
INSERT INTO `audit_logs` (user_id, action, resource_type, resource_id, created_at)
VALUES
(
  (SELECT id FROM users WHERE username='reception1' LIMIT 1),
  'Tạo lịch hẹn',
  'appointments',
  (SELECT id FROM appointments ORDER BY id DESC LIMIT 1),
  NOW()
);
