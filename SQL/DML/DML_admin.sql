-- ADMIN_001 관리자 로그인

-- 커뮤니티 관리자 추가
INSERT INTO admins (admin_id, admin_email, is_system_admin, is_community_admin, created_at) VALUES
('관리자006', 'kcs111@traders.com', FALSE, TRUE, '2024-01-15 09:00:00');
INSERT INTO admin_credentials (admin_no, password) VALUES
(6, 'passwordd234');

-- 관리자 로그인
SELECT
    a.admin_id AS `관리자 ID`,
    a.admin_email AS `관리자 email`
FROM admins a
JOIN admin_credentials c ON a.admin_no = c.admin_no
WHERE a.admin_id = '관리자001'
AND c.password = 'password000';

-- 관리자 권한 확인
SELECT
    IF(is_system_admin = TRUE, '권한 있음', '권한 없음') AS `시스템 관리 권한`,
    IF(is_community_admin = TRUE, '권한 있음', '권한 없음') AS `커뮤니티 관리 권한`
FROM admins
WHERE admin_id = '관리자001';


-- ADMIN_002 개인정보 관리

-- 김정수(users.user_no = 3) 이메일 주소 변경
INSERT INTO admin_modification_log (admin_no, user_no, modi_type, modi_detail) VALUES
(1, 3, '수정', '사용자(김정수) 이메일 주소 변경: kimjeong@traders.com -> kimjs@traders.com');
UPDATE users 
SET user_email = 'kimjs@traders.com'
WHERE user_no = 3

-- 방지혁(users.user_no = 4) 정보(전화번호) 조회
INSERT INTO admin_modification_log (admin_no, user_no, modi_type, modi_detail) VALUES
(2, 4, '조회', '사용자(방지혁) 전화번호 조회');
SELECT user_mobile
FROM users
WHERE user_no = 4;

-- ADMIN_003 대시보드

-- 대시보드 데이터 입력
INSERT INTO dashboard (total_user_count, register_count, login_count) VALUES
(15420, 87, 3245);

-- 최신 대시보드 확인
SELECT
    total_user_count AS `전체 회원수`,
    register_count AS `일일 가입자 수`,
    login_count AS `당일 접속 회원 수`,
    created_at AS `집계 시각`
FROM dashboard
ORDER BY created_at DESC
LIMIT 1;

-- ADMIN 004 공지사항 및 알림

-- 공지사항 작성
INSERT INTO admin_notification (admin_no, noti_title, noti_text, is_alert) VALUES
(3, '이벤트 종료 안내', '1.18일자로 OO이벤트가 종료됩니다.', FALSE);
