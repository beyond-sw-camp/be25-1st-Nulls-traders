INSERT INTO users VALUES
(1, '민정기', '01000001111', 'minjeong@traders.com', 4, '정상', NOW()),
(2, '김예지', '01022223333', 'kimye@traders.com', 2, '정상', NOW()),
(3, '김정수', '01044445555', 'kimjeong@traders.com', 3, '정상', NOW()),
(4, '방지혁', '01066667777', 'bangji@traders.com', 6, '정상', NOW()),
(5, '이슬이', '01088889999', 'leeseul@traders.com', 8, '정상', NOW()),
(6, '현재진', '01010101010', 'hyunjae@traders.com', 5, '정상', NOW());

-- login 테이블 샘플데이터
INSERT INTO login VALUES
('minjeong1', 1, 'hashed_pw_1', 'hashed_pin_1', NOW()),
('kimye2', 2, 'hashed_pw_2', 'hashed_pin_2', NOW()),
('kimjeong3', 3, 'hashed_pw_3', 'hashed_pin_3', NOW()),
('bangji4', 4, 'hashed_pw_4', 'hashed_pin_4', NOW()),
('leeseul5', 5, 'hashed_pw_5', 'hashed_pin_5', NOW()),
('hyunjae6', 6, 'hashed_pw_6', 'hashed_pin_6', NOW());