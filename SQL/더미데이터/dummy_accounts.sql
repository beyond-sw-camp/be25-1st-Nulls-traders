-- 테스트 DML 쿼리들
-- ==========================================

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

-- 5. 증권 계좌 입금 (TRANS_001)
-- ==========================================
-- 민정기 계좌에 1천만원 입금
START TRANSACTION;

UPDATE accounts
SET deposit = deposit + 10000000,
    last_transaction_at = CURRENT_TIMESTAMP
WHERE account_id = 1;

INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
VALUES (1, '입금', 10000000, (SELECT deposit FROM accounts WHERE account_id = 1));

COMMIT;

-- 김예지 계좌에 500만원 입금
START TRANSACTION;

UPDATE accounts
SET deposit = deposit + 5000000,
    last_transaction_at = CURRENT_TIMESTAMP
WHERE account_id = 2;

INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
VALUES (2, '입금', 5000000, (SELECT deposit FROM accounts WHERE account_id = 2));

COMMIT;

-- 방지혁 계좌에 300만원 입금
START TRANSACTION;

UPDATE accounts
SET deposit = deposit + 3000000,
    last_transaction_at = CURRENT_TIMESTAMP
WHERE account_id = 4;

INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
VALUES (4, '입금', 3000000, (SELECT deposit FROM accounts WHERE account_id = 4));

COMMIT;

-- loan_policy
INSERT INTO loan_policy (loan_type, credit_grade_min, credit_grade_max, interest_rate, max_amount) VALUES
('신용', 1, 3, 7.00, 10000000),
('신용', 4, 6, 9.50, 5000000),
('신용', 7, 9, 12.00, 3000000),
('신용', 10, 10, NULL, NULL);
