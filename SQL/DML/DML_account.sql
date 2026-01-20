-- 계좌 관련 DML
-- ========================================== 
-- 1. 증권 계좌 개설 (ACCT-001)
-- ==========================================
-- 민정기(user_no=1) 계좌 개설

INSERT INTO accounts (
    user_no, 
    account_number, 
    account_name, 
    deposit, 
    margin, 
    status
)
VALUES (
    1,
    CONCAT(
        LPAD(YEAR(NOW()) MOD 100, 2, '0'),
        LPAD(1, 8, '0'),
        LPAD(
            (SELECT COALESCE(COUNT(*), 0) + 1 
             FROM accounts 
             WHERE user_no = 1),
            6, '0'
        )
    ),
    '민정기 위탁계좌',
    0,
    0,
    '정상'
);

-- 김예지(user_no=2) 계좌 개설
INSERT INTO accounts (
    user_no, 
    account_number, 
    account_name, 
    deposit, 
    margin, 
    status
)
VALUES (
    2,
    CONCAT(
        LPAD(YEAR(NOW()) MOD 100, 2, '0'),
        LPAD(2, 8, '0'),
        LPAD(
            (SELECT COALESCE(COUNT(*), 0) + 1 
             FROM accounts 
             WHERE user_no = 2),
            6, '0'
        )
    ),
    '김예지 주식계좌',
    0,
    0,
    '정상'
);

-- 김정수(user_no=3) 계좌 개설
INSERT INTO accounts (
    user_no, 
    account_number, 
    account_name, 
    deposit, 
    margin, 
    status
)
VALUES (
    3,
    CONCAT(
        LPAD(YEAR(NOW()) MOD 100, 2, '0'),
        LPAD(3, 8, '0'),
        LPAD(
            (SELECT COALESCE(COUNT(*), 0) + 1 
             FROM accounts 
             WHERE user_no = 3),
            6, '0'
        )
    ),
    '김정수 투자계좌',
    0,
    0,
    '정상'
);

-- 방지혁(user_no=4) 계좌 개설
INSERT INTO accounts (
    user_no, 
    account_number, 
    account_name, 
    deposit, 
    margin, 
    status
)
VALUES (
    4,
    CONCAT(
        LPAD(YEAR(NOW()) MOD 100, 2, '0'),
        LPAD(4, 8, '0'),
        LPAD(
            (SELECT COALESCE(COUNT(*), 0) + 1 
             FROM accounts 
             WHERE user_no = 4),
            6, '0'
        )
    ),
    '방지혁 증권계좌',
    0,
    0,
    '정상'
);

-- 이슬이(user_no=5) 계좌 개설
INSERT INTO accounts (
    user_no, 
    account_number, 
    account_name, 
    deposit, 
    margin, 
    status
)
VALUES (
    5,
    CONCAT(
        LPAD(YEAR(NOW()) MOD 100, 2, '0'),
        LPAD(5, 8, '0'),
        LPAD(
            (SELECT COALESCE(COUNT(*), 0) + 1 
             FROM accounts 
             WHERE user_no = 5),
            6, '0'
        )
    ),
    '이슬이 증권계좌',
    0,
    0,
    '정상'
);

-- 현재진(user_no=6) 계좌 개설
INSERT INTO accounts (
    user_no, 
    account_number, 
    account_name, 
    deposit, 
    margin, 
    status
)
VALUES (
    6,
    CONCAT(
        LPAD(YEAR(NOW()) MOD 100, 2, '0'),
        LPAD(6, 8, '0'),
        LPAD(
            (SELECT COALESCE(COUNT(*), 0) + 1 
             FROM accounts 
             WHERE user_no = 6),
            6, '0'
        )
    ),
    '현재진 증권계좌',
    0,
    0,
    '정상'
);
-- ==========================================
-- 2. 증권 계좌 정보 조회 (ACCT-002)
-- ==========================================

SET @test_account_id= 2;

SELECT a.account_id AS '계좌 ID',
       a.user_no AS '사용자 번호',
       a.account_number AS '계좌번호',
       a.account_name AS '계좌명',
       a.deposit AS '예수금',
       a.margin AS '증거금',
       a.status AS '계좌상태',
       (a.deposit - a.margin) AS '주문가능금액',
       (a.deposit - a.margin) AS '출금가능금액',
       COALESCE(SUM(p.quantity * sp.current_price), 0) AS '보유주식평가액',
       (a.deposit + COALESCE(SUM(p.quantity * sp.current_price), 0)) AS '총평가금액',
       a.last_transaction_at AS '최종거래일시'
FROM accounts a
LEFT JOIN portfolios p ON a.account_id = p.account_id
LEFT JOIN stock_price sp ON p.stock_code = sp.stock_code
WHERE a.account_id = @test_account_id
GROUP BY a.account_id;


-- ==========================================
-- 3. 계좌 상태 변경 (ACCT-003)
-- ==========================================

SET @test_account_id= 1;

-- 3-1. 정상 → 정지 (관리자 권한) 
UPDATE accounts
SET status = '정지'
WHERE account_id = @test_account_id
  AND status = '정상';

-- 3-2. 정상 → 휴면 (365일 미사용 시 자동)
-- 테스트용: last_transaction_at을 1년 전으로 먼저 설정
UPDATE accounts
SET last_transaction_at = DATE_SUB(NOW(), INTERVAL 366 DAY)
WHERE account_id = @test_account_id;

UPDATE accounts
SET status = '휴면'
WHERE status = '정상'
  AND DATEDIFF(CURRENT_DATE, last_transaction_at) >= 365;


-- 3-4. 정상 → 해지 
UPDATE accounts
SET status = '해지'
WHERE account_id = @test_account_id
  AND status = '정상'
  AND deposit = 0
  AND margin = 0
  AND NOT EXISTS (
      SELECT 1 FROM portfolios 
      WHERE account_id = @test_account_id
        AND quantity > 0
  );


-- ==========================================
-- 4. 유저 계좌 목록 조회 (ACCT-004)
-- ==========================================

SET @test_user_no = 1;

SELECT a.account_id AS '계좌 ID',
       a.account_number AS '계좌번호',
       a.account_name AS '계좌명',
       a.deposit AS '예수금',
       a.margin AS '증거금',
       ROUND(COALESCE(SUM(p.quantity * sp.current_price), 0), 0) AS '보유주식평가액',
       ROUND(a.deposit + COALESCE(SUM(p.quantity * sp.current_price), 0), 0) AS '총평가금액',  -- ROUND 추가, 0 추가
       TRUNCATE(COALESCE(SUM(p.quantity * p.avg_price), 0), 0) AS '총매입금액',  -- 0 추가
       COALESCE(
		 		CASE 
               WHEN SUM(p.quantity * p.avg_price) > 0 THEN
                    ROUND(((SUM(p.quantity * sp.current_price) - SUM(p.quantity * p.avg_price)) / SUM(p.quantity * p.avg_price) * 100), 2)
               ELSE 0
         	END, 0) AS '손익률(%)',
       ROUND(COALESCE((SUM(p.quantity * sp.current_price) - SUM(p.quantity * p.avg_price)), 0), 0) AS '평가손익',
       a.status AS '계좌상태',
       a.last_transaction_at AS '최종거래일시'
FROM accounts a
LEFT JOIN portfolios p ON a.account_id = p.account_id
LEFT JOIN stock_price sp ON p.stock_code = sp.stock_code
WHERE a.user_no = @test_user_no
GROUP BY a.account_id
ORDER BY a.last_transaction_at DESC;

-- ==========================================
-- 5. 증권 계좌 입금 (TRANS_001)
-- ==========================================

SET @test_account_id= 7;
SET @test_amount = 10000000;

START TRANSACTION;

UPDATE accounts
SET deposit = deposit + @test_amount,
    last_transaction_at = CURRENT_TIMESTAMP
WHERE account_id = @test_account_id;

INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
VALUES (@test_account_id, '입금', @test_amount, (SELECT deposit FROM accounts WHERE account_id = @test_account_id));

COMMIT;


-- ==========================================
-- 6. 증권 계좌 출금 (TRANS_002)
-- ==========================================

SET @test_account_id = 7;
SET @test_amount = 10000000;

START TRANSACTION;

SELECT (deposit - margin) AS available_amount
FROM accounts
WHERE account_id = @test_account_id
  AND (deposit - margin) >= @test_amount
  AND status = '정상'
FOR UPDATE;

UPDATE accounts
SET deposit = deposit - @test_amount,
    last_transaction_at = CURRENT_TIMESTAMP
WHERE account_id = @test_account_id;

INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
VALUES (@test_account_id, '출금', @test_amount, (SELECT deposit FROM accounts WHERE account_id = @test_account_id));

COMMIT;


-- ==========================================
-- 7. 입출금 내역 조회 (TRANS_003)
-- ==========================================

SET @test_account_id = 7;

SELECT transaction_id AS '거래번호',
       transaction_type AS '거래유형',
       amount AS '금액',
       balance_after AS '거래 후 잔액',
       transaction_at AS '거래일시'
FROM deposit_withdraw_history
WHERE account_id = @test_account_id
  AND transaction_at >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
ORDER BY transaction_at DESC;