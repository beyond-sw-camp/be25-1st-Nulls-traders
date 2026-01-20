-- 커뮤니티 관리자 추가
INSERT INTO admins (admin_id, admin_email, is_system_admin, is_community_admin, created_at) VALUES
('관리자001', 'kcs@gmail.com', FALSE, TRUE, '2024-01-15 09:00:00');
INSERT INTO admin_credentials (admin_no, password) VALUES
(3, 'password1234');

-- 관리자 로그인
SELECT
    a.admin_id AS `관리자 ID`,
    a.admin_email AS `관리자 email`
FROM admins a
JOIN admin_credentials c ON a.admin_no = c.admin_no
WHERE a.admin_id = '관리자001'
AND c.password = 'password1234';


-- 관리자 권한 확인
SELECT
    IF(is_system_admin = TRUE, '권한 있음', '권한 없음') AS `시스템 관리 권한`,
    IF(is_community_admin = TRUE, '권한 있음', '권한 없음') AS `커뮤니티 관리 권한`
FROM admins
WHERE admin_id = '관리자001';


-- 관리자가 사용자 테이블 조회/수정/삭제
INSERT INTO admin_modification_log (admin_no, user_no, modi_type, modified_at, modi_detail) VALUES
(1, '김정수', '수정', '2025-01-13 10:00:00', '사용자 이메일 주소 변경: old@example.com -> new@example.com');



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


-- 공지사항 작성
INSERT INTO admin_notification (admin_no, noti_title, noti_text, is_alert) VALUES
(3, '이벤트 종료 안내', '1.18일자로 OO이벤트가 종료됩니다.', FALSE);
