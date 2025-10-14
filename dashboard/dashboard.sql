-- 낙상감지시스템 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS fall_detection_system 
DEFAULT CHARACTER SET utf8mb4 
DEFAULT COLLATE utf8mb4_general_ci;

USE fall_detection_system;

-- 1. 병실 테이블
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL,
    floor INT NOT NULL,
    bed_count INT DEFAULT 1,
    status ENUM('active', 'inactive', 'maintenance') DEFAULT 'active',
    monitoring_status ENUM('monitoring', 'paused', 'offline') DEFAULT 'monitoring',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_room (room_number)
) DEFAULT CHARSET=utf8;

-- 2. 환자 테이블
CREATE TABLE patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender ENUM('M', 'F') NOT NULL,
    room_id INT,
    bed_number INT,
    fall_risk_level ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    admission_date DATE,
    discharge_date DATE NULL,
    status ENUM('active', 'discharged', 'transferred') DEFAULT 'active',
    guardian_name VARCHAR(100),
    guardian_phone VARCHAR(20),
    medical_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE SET NULL
) DEFAULT CHARSET=utf8;

-- 3. 낙상사고/경보 테이블
CREATE TABLE fall_incidents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    room_id INT NOT NULL,
    incident_type ENUM('accident', 'alert', 'near_miss') NOT NULL,
    severity ENUM('minor', 'moderate', 'severe', 'critical') DEFAULT 'moderate',
    alert_level ENUM('low', 'medium', 'high') DEFAULT 'medium',
    description TEXT,
    location_detail VARCHAR(200), -- 병실 내 구체적 위치
    response_time INT, -- 대응 시간 (초)
    response_action VARCHAR(500),
    action_taken VARCHAR(500),
    status ENUM('pending', 'in_progress', 'resolved', 'false_alarm') DEFAULT 'pending',
    reported_by VARCHAR(100), -- 신고자
    responded_by VARCHAR(100), -- 대응자
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
    INDEX idx_incident_date (created_at),
    INDEX idx_patient_incident (patient_id, created_at),
    INDEX idx_room_incident (room_id, created_at)
) DEFAULT CHARSET=utf8;

-- 4. 실시간 알림 테이블
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NULL,
    room_id INT NULL,
    incident_id INT NULL,
    type ENUM('emergency', 'warning', 'info', 'normal') NOT NULL,
    title VARCHAR(200),
    message TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    is_read BOOLEAN DEFAULT FALSE,
    read_by VARCHAR(100) NULL,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE SET NULL,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE SET NULL,
    FOREIGN KEY (incident_id) REFERENCES fall_incidents(id) ON DELETE SET NULL,
    INDEX idx_notification_date (created_at),
    INDEX idx_notification_type (type, created_at)
) DEFAULT CHARSET=utf8;

-- 5. 센서 데이터 테이블 (옵션)
CREATE TABLE sensor_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    sensor_type ENUM('camera', 'motion', 'pressure', 'wearable') NOT NULL,
    sensor_id VARCHAR(50),
    data_type ENUM('movement', 'position', 'vital_signs', 'alert') NOT NULL,
    raw_data JSON,
    processed_data JSON,
    confidence_score DECIMAL(3,2), -- 0.00 ~ 1.00
    anomaly_detected BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
    INDEX idx_sensor_room_date (room_id, created_at),
    INDEX idx_sensor_anomaly (anomaly_detected, created_at)
) DEFAULT CHARSET=utf8;

-- 6. 사용자/의료진 테이블
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'doctor', 'nurse', 'security', 'technician') NOT NULL,
    department VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARSET=utf8;

-- 7. 시스템 설정 테이블
CREATE TABLE system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    data_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
    description TEXT,
    updated_by VARCHAR(100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARSET=utf8;

-- 샘플 데이터 삽입

-- 병실 데이터
INSERT INTO rooms (room_number, floor, bed_count, status, monitoring_status) VALUES
('101', 1, 2, 'active', 'monitoring'),
('102', 1, 2, 'active', 'monitoring'),
('103', 1, 1, 'active', 'monitoring'),
('104', 1, 2, 'active', 'monitoring'),
('105', 1, 1, 'active', 'monitoring'),
('201', 2, 2, 'active', 'monitoring'),
('202', 2, 2, 'active', 'monitoring'),
('203', 2, 1, 'active', 'monitoring'),
('204', 2, 2, 'active', 'monitoring'),
('205', 2, 1, 'active', 'monitoring'),
('301', 3, 2, 'active', 'monitoring'),
('302', 3, 2, 'active', 'monitoring'),
('315', 3, 1, 'active', 'monitoring'),
('401', 4, 2, 'active', 'monitoring'),
('402', 4, 2, 'active', 'monitoring');

-- 환자 데이터
INSERT INTO patients (patient_code, name, age, gender, room_id, bed_number, fall_risk_level, admission_date, guardian_name, guardian_phone) VALUES
('P001', '김철수', 75, 'M', 1, 1, 'high', '2024-01-15', '김영희', '010-1234-5678'),
('P002', '이영희', 68, 'F', 2, 1, 'medium', '2024-01-20', '이민수', '010-2345-6789'),
('P003', '박민수', 82, 'M', 8, 1, 'critical', '2024-01-18', '박지영', '010-3456-7890'),
('P004', '최지영', 71, 'F', 14, 2, 'high', '2024-01-22', '최승호', '010-4567-8901'),
('P005', '정승호', 79, 'M', 15, 1, 'medium', '2024-01-25', '정미경', '010-5678-9012'),
('P006', '강미경', 65, 'F', 6, 2, 'low', '2024-01-28', '강태우', '010-6789-0123'),
('P007', '윤태우', 88, 'M', 13, 1, 'critical', '2024-01-30', '윤소영', '010-7890-1234');

-- 낙상사고 데이터 (최근 데이터)
INSERT INTO fall_incidents (patient_id, room_id, incident_type, severity, description, response_action, status, created_at) VALUES
(3, 8, 'accident', 'severe', '화장실에서 낙상사고 발생', '간호사 출동, 응급처치 실시', 'in_progress', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(1, 1, 'accident', 'moderate', '침대 옆에서 넘어짐', '응급처치 완료, 의사 진료 완료', 'resolved', DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(4, 14, 'accident', 'minor', '복도에서 균형 잃고 넘어짐', '의사 진료 중', 'in_progress', DATE_SUB(NOW(), INTERVAL 6 HOUR));

-- 낙상경보 데이터
INSERT INTO fall_incidents (patient_id, room_id, incident_type, alert_level, description, action_taken, status, created_at) VALUES
(5, 15, 'alert', 'high', '비정상적인 움직임 감지', '관찰 중', 'pending', DATE_SUB(NOW(), INTERVAL 30 MINUTE)),
(2, 2, 'alert', 'medium', '위험 구역 접근 감지', '안전확인 완료', 'resolved', DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(6, 6, 'alert', 'medium', '야간 활동 증가', '보호자 연락', 'resolved', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(7, 13, 'alert', 'high', '침대 이탈 감지', '관찰 중', 'pending', DATE_SUB(NOW(), INTERVAL 3 HOUR));

-- 실시간 알림 데이터
INSERT INTO notifications (patient_id, room_id, type, title, message, priority, created_at) VALUES
(3, 8, 'emergency', '낙상사고 발생', '203호 박민수 환자 낙상사고 - 즉시 대응 필요', 'critical', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(5, 15, 'warning', '낙상위험 감지', '402호 정승호 환자 낙상위험 - 주의 관찰', 'high', DATE_SUB(NOW(), INTERVAL 30 MINUTE)),
(NULL, NULL, 'normal', '정기 점검 완료', '3층 전체 병실 정기 모니터링 완료', 'low', DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(6, 6, 'warning', '보호자 연락', '207호 강미경 환자 낙상위험 - 보호자 연락함', 'medium', DATE_SUB(NOW(), INTERVAL 2 HOUR));

-- 사용자 데이터 (관리자)
INSERT INTO users (username, password_hash, name, role, department, phone, email) VALUES
('admin', '$2b$10$example_hash', '의료진 관리자', 'admin', '시스템관리팀', '010-0000-0000', 'admin@hospital.com'),
('nurse01', '$2b$10$example_hash', '김간호사', 'nurse', '내과병동', '010-1111-1111', 'nurse01@hospital.com'),
('doctor01', '$2b$10$example_hash', '이의사', 'doctor', '내과', '010-2222-2222', 'doctor01@hospital.com');

-- 시스템 설정
INSERT INTO system_settings (setting_key, setting_value, data_type, description) VALUES
('fall_detection_sensitivity', '0.85', 'number', '낙상 감지 민감도 (0.0 ~ 1.0)'),
('alert_auto_resolve_minutes', '30', 'number', '경보 자동 해제 시간 (분)'),
('emergency_notification_enabled', 'true', 'boolean', '응급상황 알림 활성화'),
('monitoring_hours', '{"start": "06:00", "end": "22:00"}', 'json', '모니터링 시간 설정');

-- 인덱스 생성 (성능 최적화)
CREATE INDEX idx_patients_room ON patients(room_id, status);
CREATE INDEX idx_incidents_today ON fall_incidents(created_at, incident_type);
CREATE INDEX idx_notifications_unread ON notifications(is_read, created_at);

-- 뷰 생성 (자주 사용하는 조회)
CREATE VIEW v_active_patients AS
SELECT 
    p.id, p.patient_code, p.name, p.age, p.gender,
    r.room_number, p.bed_number, p.fall_risk_level,
    p.admission_date, p.guardian_name, p.guardian_phone
FROM patients p
LEFT JOIN rooms r ON p.room_id = r.id
WHERE p.status = 'active';

-- 오늘의 사고 통계 뷰
CREATE VIEW v_today_incidents AS
SELECT 
    COUNT(*) as total_incidents,
    SUM(CASE WHEN incident_type = 'accident' THEN 1 ELSE 0 END) as accidents,
    SUM(CASE WHEN incident_type = 'alert' THEN 1 ELSE 0 END) as alerts,
    SUM(CASE WHEN status = 'resolved' THEN 1 ELSE 0 END) as resolved,
    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending
FROM fall_incidents
WHERE DATE(created_at) = DATE('now', 'localtime');
