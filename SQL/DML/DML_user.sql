-- 회원가입 (요구사항 코드 : user_001)
INSERT INTO `users` VALUES
(7, '신규이름', '신규휴대전화', '신규이메일', 1, '정상', NOW());

INSERT INTO `login` VALUES
('신규ID', 7, '신규ID비밀번호해시', '신규간편비밀번호해시', NOW());

-- 로그인 (요구사항 코드 : user_002)
-- 방법1. ID 및 ID비밀번호 사용
SELECT users.user_name AS '이름',
       login.user_id AS 'ID',
       login.user_pw AS 'ID비밀번호해시'
FROM users
     INNER JOIN login ON users.user_no = login.user_no
WHERE users.user_status LIKE '정상'
  AND login.user_id = '신규ID' 
  AND login.user_pw = '신규ID비밀번호해시';

-- 방법2. 간편비밀번호 사용
SELECT users.user_name AS '이름',
       login.user_pin AS '간편비밀번호해시'
FROM users
     INNER JOIN login ON users.user_no = login.user_no
WHERE users.user_status LIKE '정상' 
  AND login.user_pin = '신규간편비밀번호해시';
  
-- ID 찾기 (요구사항 코드 : user_003)
DROP PROCEDURE IF EXISTS find_user_id;
DELIMITER $$
CREATE OR REPLACE PROCEDURE find_user_id(
   IN f_user_name VARCHAR(15),
	IN f_user_mobile CHAR(11),
	IN f_user_email VARCHAR(255)
)
BEGIN
	SELECT login.user_id AS 'ID' 
	FROM login
     	  INNER JOIN users ON login.user_no = users.user_no
   WHERE users.user_name = f_user_name
     AND users.user_mobile = f_user_mobile
     AND users.user_email = f_user_email; 	
END $$
DELIMITER ;

CALL find_user_id('신규이름', '신규휴대전화', '신규이메일');

-- ID비밀번호 재설정 (요구사항 코드 : user_004)
UPDATE login
INNER JOIN users ON login.user_no = users.user_no
SET login.user_pw = '비밀번호재설정'
WHERE users.user_status LIKE '정상' 
  AND login.user_id = '신규ID';

SELECT user_no AS '사용자고유번호',
       user_id AS 'ID',
       user_pw AS 'ID비밀번호해시' 
FROM login;

-- 회원 탈퇴 (요구사항 코드 : user_005)
UPDATE users
INNER JOIN login ON users.user_no = login.user_no
SET users.user_status = '탈퇴'
WHERE login.user_id = '신규ID';

SELECT user_no AS '사용자고유번호',
       user_name AS '이름',
       user_status AS '상태' 
FROM users;
