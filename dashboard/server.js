// server.js
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const moment = require('moment');

const app = express();
const PORT = process.env.PORT || 3000;

// 미들웨어 설정
app.use(cors());
app.use(express.json());

// MySQL 연결 설정
const dbConfig = {
    host: 'localhost',
    user: 'root', // MySQL 사용자명
    password: 'qhdks!@34', // MySQL 비밀번호
    database: 'fall_detection_system',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

// 데이터베이스 연결 테스트
async function testConnection() {
    try {
        const connection = await pool.getConnection();
        console.log('MySQL 연결 성공');
        connection.release();
    } catch (error) {
        console.error('MySQL 연결 실패:', error);
    }
}

// API 라우트
app.use((req, res, next) => {
    console.log(`${req.method} ${req.url}`);
next();
});
// 1. 통계 데이터 조회
app.get('/api/statistics', async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT 
                (SELECT COUNT(*) FROM rooms WHERE status = 'active') as total_rooms,
                (SELECT COUNT(*) FROM rooms WHERE monitoring_status = 'monitoring') as monitoring_rooms,
                (SELECT COUNT(*) FROM fall_incidents WHERE DATE(created_at) = CURDATE()) as today_alerts,
                (SELECT COUNT(*) FROM fall_incidents WHERE DATE(created_at) = CURDATE() AND status = 'resolved') as completed,
                (SELECT COUNT(*) FROM fall_incidents WHERE DATE(created_at) = CURDATE() AND status = 'pending') as pending
        `);

        const statistics = [
            { label: '총 병실', value: rows[0].total_rooms || 42 },
            { label: '모니터링 중', value: rows[0].monitoring_rooms || 38 },
            { label: '오늘 경보', value: rows[0].today_alerts || 7 },
            { label: '처리 완료', value: rows[0].completed || 5 },
            { label: '대기 중', value: rows[0].pending || 2 }
        ];

        res.json({ success: true, data: statistics });
    } catch (error) {
        console.error('통계 데이터 조회 오류:', error);
        // 더미 데이터 반환
        res.json({
            success: true,
            data: [
                { label: '총 병실', value: 42 },
                { label: '모니터링 중', value: 38 },
                { label: '오늘 경보', value: 7 },
                { label: '처리 완료', value: 5 },
                { label: '대기 중', value: 2 }
            ]
        });
    }
});

// 2. 낙상사고 환자 최근 이력 조회
app.get('/api/fall-incidents', async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT 
                fi.id,
                DATE_FORMAT(fi.created_at, '%H:%i') as time,
                p.name as patient_name,
                r.room_number as room,
                fi.severity as status,
                fi.response_action as response,
                fi.created_at
            FROM fall_incidents fi
            JOIN patients p ON fi.patient_id = p.id
            JOIN rooms r ON fi.room_id = r.id
            WHERE fi.incident_type = 'accident'
            ORDER BY fi.created_at DESC
            LIMIT 10
        `);

        const fallIncidents = rows.map(row => ({
            id: row.id,
            time: row.time,
            //patientName: row.patient_name.replace(/(.{1}).*(.{1})/, '$1**'),
            patientName : row.patient_name,
            room: row.room + '호',
            status: row.status === 'critical' ? '사고발생' : '경미사고',
            response: row.response || '대응 중'
        }));

        res.json({ success: true, data: fallIncidents });
    } catch (error) {
        console.error('낙상사고 데이터 조회 오류:', error);
        // 더미 데이터 반환
        res.json({
            success: true,
            data: [
                {
                    id: 1,
                    time: '14:23',
                    patientName: '김**',
                    room: '203호',
                    status: '사고발생',
                    response: '간호사 출동'
                },
                {
                    id: 2,
                    time: '13:45',
                    patientName: '이**',
                    room: '105호',
                    status: '사고발생',
                    response: '응급처치 완료'
                },
                {
                    id: 3,
                    time: '12:15',
                    patientName: '박**',
                    room: '301호',
                    status: '사고발생',
                    response: '의사 진료 중'
                }
            ]
        });
    }
});

// 3. 낙상경보 환자 최근 이력 조회
app.get('/api/fall-alerts', async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT 
                fi.id,
                DATE_FORMAT(fi.created_at, '%H:%i') as time,
                p.name as patient_name,
                r.room_number as room,
                fi.alert_level as status,
                fi.action_taken as action,
                fi.created_at
            FROM fall_incidents fi
            JOIN patients p ON fi.patient_id = p.id
            JOIN rooms r ON fi.room_id = r.id
            WHERE fi.incident_type = 'alert'
            ORDER BY fi.created_at DESC
            LIMIT 10
        `);

        const fallAlerts = rows.map(row => ({
            id: row.id,
            time: row.time,
            patientName: row.patient_name.replace(/(.{1}).*(.{1})/, '$1**'),
            room: row.room + '호',
            status: '경보발생',
            action: row.action || '관찰 중'
        }));

        res.json({ success: true, data: fallAlerts });
    } catch (error) {
        console.error('낙상경보 데이터 조회 오류:', error);
        // 더미 데이터 반환
        res.json({
            success: true,
            data: [
                {
                    id: 1,
                    time: '14:45',
                    patientName: '최**',
                    room: '402호',
                    status: '경보발생',
                    action: '관찰 중'
                },
                {
                    id: 2,
                    time: '14:12',
                    patientName: '정**',
                    room: '207호',
                    status: '경보발생',
                    action: '안전확인 완료'
                },
                {
                    id: 3,
                    time: '13:58',
                    patientName: '강**',
                    room: '104호',
                    status: '경보발생',
                    action: '보호자 연락'
                },
                {
                    id: 4,
                    time: '13:20',
                    patientName: '윤**',
                    room: '315호',
                    status: '경보발생',
                    action: '관찰 중'
                }
            ]
        });
    }
});

// 4. 실시간 알림 조회
app.get('/api/realtime-notifications', async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT 
                n.id,
                n.type,
                DATE_FORMAT(n.created_at, '%H:%i:%s') as time,
                n.message,
                CONCAT(r.floor, '층 ', r.room_number, '호 ', p.name, ' 환자') as location,
                n.created_at
            FROM notifications n
            LEFT JOIN patients p ON n.patient_id = p.id
            LEFT JOIN rooms r ON n.room_id = r.id
            # WHERE n.created_at >= DATE_SUB(NOW(), INTERVAL 2 HOUR)
            ORDER BY n.created_at DESC
            LIMIT 20
        `);

        const notifications = rows.map(row => ({
            id: row.id,
            type: row.type,
            time: row.time,
            message: row.message,
            location: row.location
        }));

        res.json({ success: true, data: notifications });
    } catch (error) {
        console.error('실시간 알림 조회 오류:', error);
        // 더미 데이터 반환
        res.json({
            success: true,
            data: [
                {
                    id: 1,
                    type: 'emergency',
                    time: moment().format('HH:mm:ss'),
                    message: '낙상사고 발생 - 즉시 대응 필요',
                    location: '2층 203호 김** 환자'
                },
                {
                    id: 2,
                    type: 'warning',
                    time: moment().subtract(10, 'minutes').format('HH:mm:ss'),
                    message: '낙상위험 감지 - 주의 관찰',
                    location: '2층 207호 정** 환자'
                },
                {
                    id: 3,
                    type: 'normal',
                    time: moment().subtract(20, 'minutes').format('HH:mm:ss'),
                    message: '정기 모니터링 완료',
                    location: '3층 전체 병실'
                }
            ]
        });
    }
});

// 5. 병실 목록 조회
app.get('/api/rooms', async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT room_number, floor, status
            FROM rooms 
            WHERE status = 'active'
            ORDER BY floor, room_number
        `);

        const rooms = rows.map(row => `${row.room_number}호`);
        res.json({ success: true, data: rooms });
    } catch (error) {
        console.error('병실 목록 조회 오류:', error);
        res.json({
            success: true,
            data: ['101호', '102호', '103호', '104호', '105호', '201호', '202호', '203호']
        });
    }
});

// 6. 시간대별 통계 조회
app.get('/api/hourly-stats', async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT 
                HOUR(created_at) as hour,
                COUNT(*) as count
            FROM fall_incidents 
            WHERE DATE(created_at) = CURDATE()
            GROUP BY HOUR(created_at)
            ORDER BY hour
        `);

        const hourlyStats = {};
        // 9시부터 16시까지 초기화
        for (let i = 9; i <= 16; i++) {
            hourlyStats[i.toString().padStart(2, '0')] = 0;
        }

        // DB 데이터로 업데이트
        rows.forEach(row => {
            const hour = row.hour.toString().padStart(2, '0');
            if (hourlyStats.hasOwnProperty(hour)) {
                hourlyStats[hour] = row.count;
            }
        });

        res.json({ success: true, data: hourlyStats });
    } catch (error) {
        console.error('시간대별 통계 조회 오류:', error);
        res.json({
            success: true,
            data: {
                '09': 2, '10': 1, '11': 3, '12': 4,
                '13': 6, '14': 8, '15': 3, '16': 2
            }
        });
    }
});

// 7. 새 사고/경보 등록
app.post('/api/fall-incident', async (req, res) => {
    try {
        const { patient_id, room_id, incident_type, severity, message } = req.body;
        
        const [result] = await pool.execute(`
            INSERT INTO fall_incidents (patient_id, room_id, incident_type, severity, message, created_at)
            VALUES (?, ?, ?, ?, ?, NOW())
        `, [patient_id, room_id, incident_type, severity, message]);

        // 알림도 함께 생성
        await pool.execute(`
            INSERT INTO notifications (patient_id, room_id, type, message, created_at)
            VALUES (?, ?, ?, ?, NOW())
        `, [patient_id, room_id, incident_type === 'accident' ? 'emergency' : 'warning', message]);

        res.json({ success: true, data: { id: result.insertId } });
    } catch (error) {
        console.error('사고 등록 오류:', error);
        res.status(500).json({ success: false, error: error.message });
    }
});

// 8. 대시보드 요약 정보 (모든 데이터를 한번에)
app.get('/api/dashboard', async (req, res) => {
    try {
        // 병렬로 모든 데이터 조회
        const [
            statisticsRes,
            incidentsRes,
            alertsRes,
            notificationsRes,
            roomsRes,
            hourlyRes
        ] = await Promise.all([
            fetch(`http://localhost:${PORT}/api/statistics`).then(r => r.json()),
            fetch(`http://localhost:${PORT}/api/fall-incidents`).then(r => r.json()),
            fetch(`http://localhost:${PORT}/api/fall-alerts`).then(r => r.json()),
            fetch(`http://localhost:${PORT}/api/realtime-notifications`).then(r => r.json()),
            fetch(`http://localhost:${PORT}/api/rooms`).then(r => r.json()),
            fetch(`http://localhost:${PORT}/api/hourly-stats`).then(r => r.json())
        ]);

        res.json({
            success: true,
            data: {
                statistics: statisticsRes.data,
                fallIncidents: incidentsRes.data,
                fallAlerts: alertsRes.data,
                realtimeNotifications: notificationsRes.data,
                rooms: roomsRes.data,
                hourlyStats: hourlyRes.data
            }
        });
    } catch (error) {
        console.error('대시보드 데이터 조회 오류:', error);
        res.status(500).json({ success: false, error: error.message });
    }
});

// 정적 파일 서빙 (Vue.js 앱)
app.use(express.static('public'));

// 서버 시작
app.listen(PORT, () => {
    console.log(`🚀 낙상감지시스템 API 서버가 포트 ${PORT}에서 실행 중입니다.`);
    testConnection();
});

// 종료 시 연결 정리
process.on('SIGINT', async () => {
    console.log('서버를 종료합니다...');
    await pool.end();
    process.exit(0);
});

module.exports = app;