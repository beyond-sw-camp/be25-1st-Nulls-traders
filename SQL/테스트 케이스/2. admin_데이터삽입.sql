-- 1. admins
INSERT INTO admins (admin_id, admin_email, is_system_admin, is_community_admin, created_at, updated_at) VALUES
('admin001', 'admin001@company.com', TRUE, TRUE, '2024-01-15 09:00:00', '2025-01-10 14:30:00'),
('admin002', 'admin002@company.com', TRUE, FALSE, '2024-02-20 10:30:00', NULL),
('admin003', 'admin003@company.com', FALSE, TRUE, '2024-03-10 11:00:00', '2024-12-15 16:20:00'),
('admin004', 'admin004@company.com', FALSE, TRUE, '2024-05-05 13:45:00', NULL),
('admin005', 'admin005@company.com', FALSE, FALSE, '2024-06-18 08:20:00', '2025-01-05 10:00:00');

-- 2. admin_credentials
INSERT INTO admin_credentials (admin_no, password, pw_changed_at) VALUES
(1, 'password1111', '2025-01-10 14:30:00'),
(2, 'password2222', '2024-12-01 09:15:00'),
(3, 'password3333', '2024-12-15 16:20:00'),
(4, 'password4444', '2024-11-20 11:00:00'),
(5, 'password5555', '2025-01-05 10:00:00');

-- 3. admin_notification
INSERT INTO admin_notification (admin_no, noti_title, noti_text, is_alert, created_at) VALUES
(1, '시스템 정기 점검 안내', '시스템 정기 점검이 2025년 1월 25일 02:00~04:00에 진행됩니다.', FALSE, '2025-01-18 15:00:00'),
(1, '[긴급] 보안 취약점 발견으로 인한 긴급 패치 적용 필요', '공지내용~~~', TRUE, '2025-01-19 09:30:00'),
(2, '신규 커뮤니티 가이드라인', '1. 바른말 고운말 2. ~~~', FALSE, '2025-01-17 10:00:00'),
(3, '이벤트 종료 안내', '1.18일자로 OO이벤트가 종료됩니다.', FALSE, '2025-01-16 14:45:00');



-- 4. admin_modification_log
INSERT INTO admin_modification_log (admin_no, user_no, modi_type, modified_at, modi_detail) VALUES
(1, 101, '수정', '2025-01-19 10:15:00', '사용자 이메일 주소 변경: old@example.com -> new@example.com'),
(2, 102, '조회', '2025-01-19 11:30:00', '사용자 상세 정보 조회 (신고 접수 건 확인)'),
(3, 103, '삭제', '2025-01-18 16:45:00', '스팸 계정으로 판단되어 계정 삭제 처리'),
(1, 104, '수정', '2025-01-17 09:20:00', '사용자 권한 변경: 일반 회원 -> VIP 회원'),
(4, 105, '조회', '2025-01-19 13:00:00', '게시물 작성 이력 조회 (부적절한 콘텐츠 신고 건)');

-- 5. dashboard
INSERT INTO dashboard (created_at, total_user_count, register_count, login_count) VALUES
('2025-01-15 23:59:59', 15420, 87, 3245),
('2025-01-16 23:59:59', 15507, 92, 3512),
('2025-01-17 23:59:59', 15599, 105, 3678),
('2025-01-18 23:59:59', 15704, 98, 3821),
('2025-01-19 23:59:59', 15802, 113, 3956);

-- 데이터 확인 쿼리
SELECT * FROM admins;

SELECT * FROM admin_credentials;

SELECT * FROM admin_notification;

SELECT * FROM admin_modification_log;

SELECT * FROM dashboard;