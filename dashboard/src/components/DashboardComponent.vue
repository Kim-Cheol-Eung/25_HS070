<template>
  <div id="app">
        <!-- 로딩 오버레이 -->
        <div v-if="loading" class="loading-overlay">
            <div class="loading-spinner"></div>
            데이터를 불러오는 중...
        </div>
        
        <!-- 에러 메시지 -->
        <div v-if="error" class="error-message">
            {{ error }}
            <button @click="loadAllData()" style="margin-left: 10px; padding: 5px 10px; background: rgba(255,255,255,0.2); border: none; border-radius: 4px; color: white; cursor: pointer;">
                다시 시도
            </button>
        </div>
        
        <div class="container">
            <!-- 헤더 -->
            <header class="header">
                <div class="logo">🏥 낙상감지시스템</div>
                <nav class="nav-menu">
                    <div class="nav-item" 
                         :class="{ active: activeNav === 'realtime' }"
                         @click="activeNav = 'realtime'">실시간</div>
                    <div class="nav-item"
                         :class="{ active: activeNav === 'statistics' }"
                         @click="activeNav = 'statistics'">통계</div>
                    <div class="nav-item"
                         :class="{ active: activeNav === 'analysis' }"
                         @click="activeNav = 'analysis'">분석</div>
                    <div class="nav-item"
                         :class="{ active: activeNav === 'settings' }"
                         @click="activeNav = 'settings'">설정</div>
                </nav>
                <div class="user-info">
                    <div class="current-time">{{ currentTime }}</div>
                    <span>{{ currentUser }}</span>
                    <div style="width: 32px; height: 32px; background: #666; border-radius: 50%;"></div>
                </div>
            </header>

            <!-- 사이드바 -->
            <aside class="sidebar">
                <div class="sidebar-section">
                    <div class="sidebar-title">모니터링</div>
                    <div class="sidebar-item" 
                         :class="{ active: activeSidebar === 'realtime' }"
                         @click="activeSidebar = 'realtime'">실시간 현황</div>
                    <div class="sidebar-item"
                         :class="{ active: activeSidebar === 'alerts' }"
                         @click="activeSidebar = 'alerts'">경보 관리</div>
                    <div class="sidebar-item"
                         :class="{ active: activeSidebar === 'patients' }"
                         @click="activeSidebar = 'patients'">환자 관리</div>
                </div>
                
                <div class="sidebar-section">
                    <div class="sidebar-title">데이터 분석</div>
                    <div class="sidebar-item"
                         :class="{ active: activeSidebar === 'statistics' }"
                         @click="activeSidebar = 'statistics'">통계 분석</div>
                    <div class="sidebar-item"
                         :class="{ active: activeSidebar === 'reports' }"
                         @click="activeSidebar = 'reports'">리포트</div>
                    <div class="sidebar-item"
                         :class="{ active: activeSidebar === 'trends' }"
                         @click="activeSidebar = 'trends'">추세 분석</div>
                </div>
                
                <div class="sidebar-section">
                    <div class="sidebar-title">시스템</div>
                    <div class="sidebar-item"
                         :class="{ active: activeSidebar === 'devices' }"
                         @click="activeSidebar = 'devices'">장비 관리</div>
                    <div class="sidebar-item"
                         :class="{ active: activeSidebar === 'users' }"
                         @click="activeSidebar = 'users'">사용자 관리</div>
                </div>
            </aside>

            <!-- 메인 콘텐츠 -->
            <main class="main-content">
                <!-- 상단 통계 -->
                <div class="stats-grid">
                    <div class="stat-card" v-for="stat in statistics" :key="stat.label">
                        <div class="stat-number">{{ stat.value }}</div>
                        <div class="stat-label">{{ stat.label }}</div>
                    </div>
                </div>

                <!-- 대시보드 카드 -->
                <div class="dashboard-cards">
                    <div class="dashboard-card card-red" @click="showDetails('emergency')">
                        <div class="card-number">{{ emergencyCount }}</div>
                        <div class="card-title">낙상사고</div>
                        <div style="font-size: 14px; opacity: 0.9;">즉시 대응 필요</div>
                    </div>
                    <div class="dashboard-card card-orange" @click="showDetails('warning')">
                        <div class="card-number">{{ warningCount }}</div>
                        <div class="card-title">낙상경보</div>
                        <div style="font-size: 14px; opacity: 0.9;">주의 관찰 중</div>
                    </div>
                    <div class="dashboard-card card-blue" @click="showDetails('normal')">
                        <div class="card-number">{{ normalCount }}</div>
                        <div class="card-title">정상상태</div>
                        <div style="font-size: 14px; opacity: 0.9;">안정 모니터링</div>
                    </div>
                </div>

                <!-- 환자 이력 테이블 -->
                <div class="data-section">
                    <!-- 낙상사고 환자 최근 이력 -->
                    <div class="data-table-container">
                        <h3 class="section-title">낙상사고 환자 최근 이력</h3>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>시간</th>
                                    <th>환자명</th>
                                    <th>병실</th>
                                    <th>상태</th>
                                    <th>대응</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="incident in fallIncidents" :key="incident.id">
                                    <td>{{ incident.time }}</td>
                                    <td>{{ incident.patientName }}</td>
                                    <td>{{ incident.room }}</td>
                                    <td>
                                        <span class="status-badge status-emergency">{{ incident.status }}</span>
                                    </td>
                                    <td>{{ incident.response }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 낙상경보 환자 최근 이력 -->
                    <div class="data-table-container">
                        <h3 class="section-title">낙상경보 환자 최근 이력</h3>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>시간</th>
                                    <th>환자명</th>
                                    <th>병실</th>
                                    <th>상태</th>
                                    <th>조치</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="alert in fallAlerts" :key="alert.id">
                                    <td>{{ alert.time }}</td>
                                    <td>{{ alert.patientName }}</td>
                                    <td>{{ alert.room }}</td>
                                    <td>
                                        <span class="status-badge status-warning">{{ alert.status }}</span>
                                    </td>
                                    <td>{{ alert.action }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 모니터링 및 통계 -->
                <div class="monitoring-section">
                    <!-- 실시간 알림 -->
                    <div class="monitoring-list">
                        <h3 class="section-title">실시간 알림</h3>
                        <div v-for="notification in realtimeNotifications" 
                             :key="notification.id"
                             class="monitoring-item"
                             :class="notification.type">
                            <div class="monitoring-time">{{ notification.time }}</div>
                            <div class="monitoring-content">{{ notification.message }}</div>
                            <div class="monitoring-location">{{ notification.location }}</div>
                        </div>
                    </div>

                    <!-- 비디오 모니터링 -->
                    <div class="video-player">
                        <h3 class="section-title">실시간 모니터링</h3>
                        <div class="video-screen">
                            🎥 병실 {{ currentRoom }} 실시간 영상<br>
                            <small>{{ videoStatus }}</small>
                        </div>
                        <div class="video-controls">
                            병실 선택: 
                            <select v-model="currentRoom" @change="changeRoom" style="background: #333; color: white; border: 1px solid #555; margin: 0 10px;">
                                <option v-for="room in rooms" :key="room" :value="room">{{ room }}</option>
                            </select>
                        </div>
                        
                        <!-- 간단한 차트 -->
                        <div style="margin-top: 20px;">
                            <h4 style="margin-bottom: 10px; color: #ccc;">시간대별 경보 발생 통계</h4>
                            <div class="chart-bars">
                                <div v-for="(count, hour) in hourlyStats" 
                                     :key="hour"
                                     class="chart-bar"
                                     :style="{ height: (count * 10) + 'px' }">
                                    {{ count }}
                                </div>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-top: 5px; font-size: 11px; color: #888;">
                                <span v-for="hour in Object.keys(hourlyStats)" :key="hour">{{ hour }}시</span>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            activeNav: 'realtime',
            activeSidebar: 'realtime',
            currentUser: '의료진 관리자',
            currentTime: '',
            currentRoom: '101호',
            videoStatus: '정상 송출 중',
            loading: false,
            error: null,
            
            // API에서 가져올 데이터들
            statistics: [],
            fallIncidents: [],
            fallAlerts: [],
            realtimeNotifications: [],
            rooms: [],
            hourlyStats: {}
        };
    },
    methods: {
        // API 호출 함수들
        async fetchStatistics() {
            try {
                const response = await fetch('/api/statistics');
                const result = await response.json();
                if (result.success) {
                    this.statistics = result.data;
                }
            } catch (error) {
                console.error('통계 데이터 로드 실패:', error);
                this.error = '통계 데이터를 불러올 수 없습니다.';
            }
        },

        async fetchFallIncidents() {
            try {
                const response = await fetch('/api/fall-incidents');
                const result = await response.json();
                if (result.success) {
                    this.fallIncidents = result.data;
                }
            } catch (error) {
                console.error('낙상사고 데이터 로드 실패:', error);
            }
        },

        async fetchFallAlerts() {
            try {
                const response = await fetch('/api/fall-alerts');
                const result = await response.json();
                if (result.success) {
                    this.fallAlerts = result.data;
                }
            } catch (error) {
                console.error('낙상경보 데이터 로드 실패:', error);
            }
        },

        async fetchRealtimeNotifications() {
            try {
                const response = await fetch('/api/realtime-notifications');
                const result = await response.json();
                if (result.success) {
                    this.realtimeNotifications = result.data;
                }
            } catch (error) {
                console.error('실시간 알림 데이터 로드 실패:', error);
            }
        },

        async fetchRooms() {
            try {
                const response = await fetch('/api/rooms');
                const result = await response.json();
                if (result.success) {
                    this.rooms = result.data;
                }
            } catch (error) {
                console.error('병실 목록 로드 실패:', error);
            }
        },

        async fetchHourlyStats() {
            try {
                const response = await fetch('/api/hourly-stats');
                const result = await response.json();
                if (result.success) {
                    this.hourlyStats = result.data;
                }
            } catch (error) {
                console.error('시간대별 통계 로드 실패:', error);
            }
        },
        async loadAllData() {
            this.loading = true;
            this.error = null;

            try {
                await Promise.all([
                    this.fetchStatistics(),
                    this.fetchFallIncidents(),
                    this.fetchFallAlerts(),
                    this.fetchRealtimeNotifications(),
                    this.fetchRooms(),
                    this.fetchHourlyStats()
                ]);
            } catch (error) {
                this.error = '데이터를 불러오는 중 오류가 발생했습니다.';
                console.error('데이터 로드 오류:', error);
            } finally {
                this.loading = false;
            }
        },
        updateTime() {
            const now = new Date();
            this.currentTime = now.toLocaleTimeString('ko-KR', { 
                hour: '2-digit', 
                minute: '2-digit',
                second: '2-digit'
            });
        },
        
        showDetails(type) {
            const messages = {
                emergency: '낙상사고 상세 정보를 확인합니다.',
                warning: '낙상경보 상세 정보를 확인합니다.',
                normal: '정상상태 환자 목록을 확인합니다.'
            };
            alert(messages[type]);
        },
        
        changeRoom() {
            this.videoStatus = `${this.currentRoom} 영상으로 전환 중...`;
            setTimeout(() => {
                this.videoStatus = '정상 송출 중';
            }, 1000);
        }
    },
    mounted() {
        // 초기 데이터 로드
        this.loadAllData();
        setInterval(() => {
            this.fetchRealtimeNotifications();
            this.fetchStatistics();
        }, 5000);
    }
};
</script>

<style scoped>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background: #1a1a1a;
            color: #fff;
            overflow-x: hidden;
        }
        
        .container {
            max-width: 1920px;
            margin: 0 auto;
            position: relative;
        }
        
        /* 헤더 영역 */
        .header {
            background: #2d2d2d;
            padding: 15px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 2px solid #444;
        }
        
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #00ff88;
        }
        
        .nav-menu {
            display: flex;
            gap: 30px;
            margin-left: 50px;
        }
        
        .nav-item {
            padding: 8px 16px;
            background: #444;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .nav-item:hover, .nav-item.active {
            background: #0066cc;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .current-time {
            font-size: 14px;
            color: #ccc;
        }
        
        /* 사이드바 */
        .sidebar {
            /* position: fixed; */
            position:relative;
            left: 0;
            /* top: 70px; */
            width: 250px;
            height: calc(100vh - 70px);
            background: #333;
            padding: 20px;
            border-right: 2px solid #444;
            float:left;
        }
        
        .sidebar-section {
            margin-bottom: 25px;
        }
        
        .sidebar-title {
            font-size: 14px;
            color: #888;
            margin-bottom: 10px;
            text-transform: uppercase;
        }
        
        .sidebar-item {
            padding: 10px 15px;
            background: #444;
            margin-bottom: 5px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .sidebar-item:hover {
            background: #555;
        }
        
        .sidebar-item.active {
            background: #0066cc;
        }
        
        /* 메인 콘텐츠 */
        .main-content {
            /* margin-left: 250px; */
            padding: 30px;
            min-height: calc(100vh - 70px);
            float:left;
            width: calc(100% - 250px);
        }
        
        /* 통계 카드 영역 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #2d2d2d;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border: 2px solid #444;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #00ff88;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #ccc;
        }
        
        /* 대시보드 카드 */
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .dashboard-card {
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        
        .card-red {
            background: linear-gradient(135deg, #8B1538, #A91B47);
        }
        
        .card-orange {
            background: linear-gradient(135deg, #FF8C00, #FFA500);
        }
        
        .card-blue {
            background: linear-gradient(135deg, #1B5A8B, #2E6EA3);
        }
        
        .card-number {
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .card-title {
            font-size: 18px;
            margin-bottom: 15px;
        }
        
        /* 하단 데이터 섹션 */
        .data-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        /* 데이터 테이블 */
        .data-table-container {
            background: #2d2d2d;
            border-radius: 8px;
            padding: 20px;
        }
        
        .section-title {
            font-size: 18px;
            margin-bottom: 20px;
            color: #00ff88;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .data-table th,
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #444;
        }
        
        .data-table th {
            background: #444;
            color: #ccc;
            font-weight: bold;
            text-align: center;
        }
        
        .data-table tr:hover {
            background: #333;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-emergency {
            background: #ff4757;
            color: white;
        }
        
        .status-warning {
            background: #ffa502;
            color: white;
        }
        
        .status-normal {
            background: #2ed573;
            color: white;
        }
        
        /* 차트 영역 */
        .chart-container {
            background: #2d2d2d;
            border-radius: 8px;
            padding: 20px;
        }
        
        .chart-placeholder {
            height: 300px;
            background: #1a1a1a;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 16px;
            border: 2px dashed #444;
            flex-direction: column;
            gap: 10px;
        }
        
        .chart-bars {
            display: flex;
            align-items: end;
            gap: 10px;
            height: 150px;
            margin-top: 20px;
        }
        
        .chart-bar {
            background: #0066cc;
            width: 30px;
            border-radius: 4px 4px 0 0;
            display: flex;
            align-items: end;
            justify-content: center;
            color: white;
            font-size: 12px;
            padding: 5px;
        }
        
        /* 모니터링 영역 */
        .monitoring-section {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 30px;
        }
        
        .monitoring-list {
            background: #2d2d2d;
            border-radius: 8px;
            padding: 20px;
            max-height: 400px;
            overflow-y: auto;
        }
        
        .monitoring-item {
            padding: 15px;
            background: #333;
            margin-bottom: 10px;
            border-radius: 8px;
            border-left: 4px solid #666;
        }
        
        .monitoring-item.emergency {
            border-left-color: #ff4757;
        }
        
        .monitoring-item.warning {
            border-left-color: #ffa502;
        }
        
        .monitoring-item.normal {
            border-left-color: #2ed573;
        }
        
        .monitoring-time {
            font-size: 12px;
            color: #888;
            margin-bottom: 5px;
        }
        
        .monitoring-content {
            font-size: 14px;
        }
        
        .monitoring-location {
            font-size: 12px;
            color: #ccc;
            margin-top: 5px;
        }
        
        /* 로딩 및 에러 스타일 */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            color: white;
            font-size: 18px;
        }
        
        .error-message {
            background: #ff4757;
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin: 20px;
            text-align: center;
        }
        
        .loading-spinner {
            border: 3px solid rgba(255, 255, 255, 0.1);
            border-top: 3px solid #00ff88;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin-right: 15px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .video-player {
            background: #2d2d2d;
            border-radius: 8px;
            padding: 20px;
        }
        
        .video-screen {
            width: 100%;
            height: 200px;
            background: #000;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .video-controls {
            text-align: center;
            font-size: 12px;
            color: #ccc;
        }
        
        /* 반응형 */
        @media (max-width: 1200px) {
            .dashboard-cards {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .stats-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .dashboard-cards {
                grid-template-columns: 1fr;
            }
            
            .data-section, .monitoring-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
