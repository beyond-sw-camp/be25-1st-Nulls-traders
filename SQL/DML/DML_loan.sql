
-- ==========================================
-- 8. 신용대출 한도 조회 (LOAN_006)
-- ==========================================

SET @test_user_no = 6;

SELECT 
    u.user_name AS '사용자명',
    u.user_credit AS '신용등급',
    COALESCE(lp.max_amount, 0) AS '등급별최대한도',
    COALESCE(lp.interest_rate, 0) AS '적용이자율',
    CASE 
        WHEN COALESCE(lp.max_amount, 0) = 0 THEN 0
        WHEN EXISTS (
            SELECT 1 FROM loan 
            WHERE user_no = @test_user_no  -- user_no 기준으로 변경!
              AND loan_type = '신용'
              AND status IN ('승인', '실행중')
        ) THEN 0
        ELSE lp.max_amount
    END AS '대출가능한도',
    CASE 
        WHEN COALESCE(lp.max_amount, 0) = 0 THEN '대출 불가 (신용등급 미달)'
        WHEN EXISTS (
            SELECT 1 FROM loan 
            WHERE user_no = @test_user_no  -- user_no 기준으로 변경!
              AND loan_type = '신용'
              AND status IN ('승인', '실행중')
        ) THEN '대출 불가 (기존 대출 존재)'
        ELSE '대출 가능'
    END AS '가능 여부'
FROM users u
LEFT JOIN loan_policy lp 
    ON lp.loan_type = '신용'
    AND u.user_credit BETWEEN lp.credit_grade_min AND lp.credit_grade_max
WHERE u.user_no = @test_user_no;


-- ==========================================
-- 9. 신용대출 신청 (LOAN_007)
-- ==========================================

SET @test_account_id = 6;
SET @test_amount = 3000000;
SET @test_period = 12;
SET @test_type = '원리금균등분할';

INSERT INTO loan (
    user_no,
    account_id,
    loan_type,
    principal,
    balance,
    interest_rate,
    loan_period_months,
    repayment_type,
    monthly_repayment,
    status
)
SELECT 
    a.user_no,
    a.account_id,
    '신용',
    @test_amount,
    @test_amount,
    lp.interest_rate,
    @test_period,
    @test_type,
    NULL,
    '승인'
FROM accounts a
INNER JOIN users u ON a.user_no = u.user_no
INNER JOIN loan_policy lp ON lp.loan_type = '신용'
    AND u.user_credit BETWEEN lp.credit_grade_min AND lp.credit_grade_max
WHERE a.account_id = @test_account_id
  AND a.status = '정상'
  AND @test_amount >= 1000000
  AND @test_period IN (6, 12, 24)
  AND u.user_credit <= 9
  AND NOT EXISTS (
      SELECT 1 FROM loan 
      WHERE user_no = a.user_no  -- user_no 기준으로 변경!
        AND loan_type = '신용'
        AND status IN ('승인', '실행중')
  )
  AND @test_amount <= lp.max_amount;

-- ==========================================
-- 10. 신용대출 실행 (LOAN_008)
-- ==========================================
-- ==========================================
-- 프로시저: 원리금균등분할 상환 스케줄 생성
-- ==========================================
DELIMITER $$

CREATE PROCEDURE generate_equal_repayment_schedule(
    IN p_loan_id BIGINT
)
BEGIN
    DECLARE v_principal BIGINT;
    DECLARE v_balance BIGINT;
    DECLARE v_interest_rate DECIMAL(5,2);
    DECLARE v_loan_period INT;
    DECLARE v_monthly_repayment BIGINT;
    DECLARE v_executed_at TIMESTAMP;
    
    DECLARE v_month_num INT DEFAULT 1;
    DECLARE v_monthly_interest BIGINT;
    DECLARE v_monthly_principal BIGINT;
    DECLARE v_repayment_date DATE;
    
    -- 대출 정보 조회
    SELECT principal, balance, interest_rate, loan_period_months, monthly_repayment, executed_at
    INTO v_principal, v_balance, v_interest_rate, v_loan_period, v_monthly_repayment, v_executed_at
    FROM loan
    WHERE loan_id = p_loan_id;
    
    -- 회차별 반복
    WHILE v_month_num <= v_loan_period DO
        -- 이자 계산 (남은 잔액 기준)
        SET v_monthly_interest = CEIL(v_balance * v_interest_rate / 100 / 12);
        
        -- 원금 계산
        IF v_month_num = v_loan_period THEN
            -- 마지막 회차: 남은 잔액 전부
            SET v_monthly_principal = v_balance;
        ELSE
            -- 중간 회차: 월 상환액 - 이자
            SET v_monthly_principal = v_monthly_repayment - v_monthly_interest;
        END IF;
        
        -- 상환일 계산
        SET v_repayment_date = DATE_ADD(v_executed_at, INTERVAL v_month_num MONTH);
        
        -- 스케줄 INSERT
        INSERT INTO loan_repayment_schedule (
            loan_id,
            repayment_number,
            repayment_date,
            principal_amount,
            interest_amount,
            total_amount,
            status
        ) VALUES (
            p_loan_id,
            v_month_num,
            v_repayment_date,
            v_monthly_principal,
            v_monthly_interest,
            v_monthly_principal + v_monthly_interest,
            '예정'
        );
        
        -- 잔액 갱신
        SET v_balance = v_balance - v_monthly_principal;
        SET v_month_num = v_month_num + 1;
    END WHILE;
    
END$$

DELIMITER ;


-- ==========================================
-- 10. 신용대출 실행
-- ==========================================

-- 10-1. 원리금균등분할상환 방식

SET @test_loan_id= 10;

START TRANSACTION;

UPDATE loan l
SET status = '실행중',
    executed_at = CURRENT_TIMESTAMP,
    maturity_date = DATE_ADD(CURRENT_DATE, INTERVAL loan_period_months MONTH),
    monthly_repayment = CEIL(
        (principal * (interest_rate / 100 / 12) * POW(1 + (interest_rate / 100 / 12), loan_period_months))
        / (POW(1 + (interest_rate / 100 / 12), loan_period_months) - 1)
    )
WHERE loan_id = @test_loan_id
  AND status = '승인'
  AND repayment_type = '원리금균등분할';

UPDATE accounts
SET deposit = deposit + (SELECT principal FROM loan WHERE loan_id = @test_loan_id),
    last_transaction_at = CURRENT_TIMESTAMP
WHERE account_id = (SELECT account_id FROM loan WHERE loan_id = @test_loan_id);

INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
SELECT account_id,
    	 '입금',
       (SELECT principal FROM loan WHERE loan_id = @test_loan_id),
       deposit
FROM accounts
WHERE account_id = (SELECT account_id FROM loan WHERE loan_id = @test_loan_id);

-- 프로시저 호출로 상환 스케줄 생성
CALL generate_equal_repayment_schedule(@test_loan_id);

COMMIT;



-- 10-2. 만기일시상환 방식
SET @test_loan_id= 9;

START TRANSACTION;

UPDATE loan l
SET status = '실행중',
    executed_at = CURRENT_TIMESTAMP,
    maturity_date = DATE_ADD(CURRENT_DATE, INTERVAL loan_period_months MONTH),
    monthly_repayment = CEIL(principal * interest_rate / 100 / 12)  -- 매월 납부할 이자
WHERE loan_id = @test_loan_id
  AND status = '승인'
  AND repayment_type = '만기일시상환';

UPDATE accounts
SET deposit = deposit + (SELECT principal FROM loan WHERE loan_id = @test_loan_id),
    last_transaction_at = CURRENT_TIMESTAMP
WHERE account_id = (SELECT account_id FROM loan WHERE loan_id = @test_loan_id);

INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
SELECT account_id,
    	 '입금',
       (SELECT principal FROM loan WHERE loan_id = @test_loan_id),
       deposit
FROM accounts
WHERE account_id = (SELECT account_id FROM loan WHERE loan_id = @test_loan_id);

-- 만기일시상환: SQL로 간단하게 처리
INSERT INTO loan_repayment_schedule (
    loan_id,
    repayment_number,
    repayment_date,
    principal_amount,
    interest_amount,
    total_amount,
    status
)
SELECT 
    l.loan_id,
    seq.month_num,
    DATE_ADD(l.executed_at, INTERVAL seq.month_num MONTH),
    CASE 
        WHEN seq.month_num = l.loan_period_months THEN l.principal
        ELSE 0
    END AS principal_amount,
    CEIL(l.principal * l.interest_rate / 100 / 12) AS interest_amount,
    CASE 
        WHEN seq.month_num = l.loan_period_months THEN 
            l.principal + CEIL(l.principal * l.interest_rate / 100 / 12)
        ELSE 
            CEIL(l.principal * l.interest_rate / 100 / 12)
    END AS total_amount,
    '예정'
FROM loan l
CROSS JOIN (
    SELECT 1 AS month_num UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 
    UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12
    UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16
    UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
    UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24
) seq
WHERE l.loan_id = @test_loan_id
  AND seq.month_num <= l.loan_period_months; 

COMMIT;

-- ==========================================
-- 11. 신용대출 상환 (LOAN_009)
-- ==========================================
SET @test_loan_id= 8;

-- 11-1. 정상 자동 상환 
START TRANSACTION;

-- 1. 상환할 스케줄 찾기 (변수에 저장)
SELECT lrs.schedule_id, lrs.repayment_number
INTO @target_schedule_id, @target_repayment_number
FROM accounts a
INNER JOIN loan l ON a.account_id = l.account_id
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
WHERE l.loan_id = @test_loan_id
  AND lrs.repayment_date <= CURRENT_DATE
  AND lrs.status = '예정'
  AND a.deposit >= lrs.total_amount
ORDER BY lrs.repayment_number
LIMIT 1
FOR UPDATE;

-- 2. 상환 내역 기록
INSERT INTO loan_repayment_history (
	loan_id,
   schedule_id,
   repayment_type,
   principal_amount,
   interest_amount,
   overdue_interest_amount,
   total_amount,
   balance_after,
   repayment_method
)
SELECT 
   lrs.loan_id,
   lrs.schedule_id,
   '정상',
   lrs.principal_amount,
   lrs.interest_amount,
   0,
   lrs.total_amount,
   l.balance - lrs.principal_amount,
   '자동'
FROM loan_repayment_schedule lrs
INNER JOIN loan l ON lrs.loan_id = l.loan_id
WHERE lrs.schedule_id = @target_schedule_id;  

-- 3. 스케줄 완료 처리
UPDATE loan_repayment_schedule
SET status = '완료',
    actual_repayment_at = CURRENT_TIMESTAMP
WHERE schedule_id = @target_schedule_id; 

-- 4. 대출 잔액 업데이트
UPDATE loan l
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
SET l.balance = l.balance - lrs.principal_amount,
    l.status = CASE 
        WHEN l.balance - lrs.principal_amount = 0 THEN '완료'
        ELSE l.status
    END
WHERE lrs.schedule_id = @target_schedule_id;  

-- 5. 예수금 차감
UPDATE accounts a
INNER JOIN loan l ON a.account_id = l.account_id
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
SET a.deposit = a.deposit - lrs.total_amount,
    a.last_transaction_at = CURRENT_TIMESTAMP
WHERE lrs.schedule_id = @target_schedule_id;  

-- 6. 입출금 내역 기록
INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
SELECT l.account_id,
       '출금',
       lrs.total_amount,
       a.deposit
FROM loan l
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
INNER JOIN accounts a ON l.account_id = a.account_id
WHERE lrs.schedule_id = @target_schedule_id; 

COMMIT;



-- 11-1-2. 수동 상환 (특정 schedule_id로 상환)
SET @test_schedule_id = 293;  -- 백엔드에서 전달받은 값

START TRANSACTION;

SELECT a.deposit
FROM accounts a
INNER JOIN loan l ON a.account_id = l.account_id
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
WHERE lrs.schedule_id = @test_schedule_id
  AND lrs.status = '예정'
  AND a.deposit >= lrs.total_amount
FOR UPDATE;

-- 2. 상환 내역 기록
INSERT INTO loan_repayment_history (
	loan_id,
   schedule_id,
   repayment_type,
   principal_amount,
   interest_amount,
   overdue_interest_amount,
   total_amount,
   balance_after,
   repayment_method
)
SELECT 
   lrs.loan_id,
   lrs.schedule_id,
   '정상',
   lrs.principal_amount,
   lrs.interest_amount,
   0,
   lrs.total_amount,
   l.balance - lrs.principal_amount,
   '자동'
FROM loan_repayment_schedule lrs
INNER JOIN loan l ON lrs.loan_id = l.loan_id
WHERE lrs.schedule_id = @test_schedule_id;  

-- 3. 스케줄 완료 처리
UPDATE loan_repayment_schedule
SET status = '완료',
    actual_repayment_at = CURRENT_TIMESTAMP
WHERE schedule_id = @test_schedule_id; 

-- 4. 대출 잔액 업데이트
UPDATE loan l
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
SET l.balance = l.balance - lrs.principal_amount,
    l.status = CASE 
        WHEN l.balance - lrs.principal_amount = 0 THEN '완료'
        ELSE l.status
    END
WHERE lrs.schedule_id = @test_schedule_id;  

-- 5. 예수금 차감
UPDATE accounts a
INNER JOIN loan l ON a.account_id = l.account_id
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
SET a.deposit = a.deposit - lrs.total_amount,
    a.last_transaction_at = CURRENT_TIMESTAMP
WHERE lrs.schedule_id = @test_schedule_id;  

-- 6. 입출금 내역 기록
INSERT INTO deposit_withdraw_history (account_id, transaction_type, amount, balance_after)
SELECT l.account_id,
       '출금',
       lrs.total_amount,
       a.deposit
FROM loan l
INNER JOIN loan_repayment_schedule lrs ON l.loan_id = lrs.loan_id
INNER JOIN accounts a ON l.account_id = a.account_id
WHERE lrs.schedule_id = @test_schedule_id; 

COMMIT;

-- ==========================================
-- 12. 신용대출 조회 (LOAN_010) ----> 대출 실행해야 상세 조회 가능함
-- ==========================================

SET @test_loan_id= 5;

SELECT l.loan_id AS '대출 ID',
       l.loan_type AS '대출유형',
       l.principal AS '대출원금',
       l.balance AS '대출잔액',
       l.interest_rate AS '이자율',
       l.loan_period_months AS '대출기간',
       l.monthly_repayment AS '월상환액',
       l.status AS '대출상태',
       l.executed_at AS '실행일',
       l.maturity_date AS '만기일',
       (SELECT MIN(repayment_date) 
        FROM loan_repayment_schedule 
        WHERE loan_id = l.loan_id AND status = '예정') AS '다음상환일',
       CASE 
           WHEN EXISTS (
               SELECT 1 FROM loan_repayment_schedule
               WHERE loan_id = l.loan_id 
                 AND status = '예정'
                 AND repayment_date < CURRENT_DATE
           ) THEN '연체'
           ELSE '정상'
       END AS '연체여부',
       COALESCE((
           SELECT SUM(
               total_amount + (total_amount * 0.0005 * DATEDIFF(CURRENT_DATE, repayment_date))
           )
           FROM loan_repayment_schedule
           WHERE loan_id = l.loan_id 
             AND status = '예정'
             AND repayment_date < CURRENT_DATE
       ), 0) AS '연체금액'
FROM loan l
WHERE l.loan_id = @test_loan_id;


-- ==========================================
-- 13. 대출 목록 조회 (LOAN_011)
-- ==========================================

SET @test_user_no = 1;

SELECT l.loan_id AS '대출 ID',
       a.account_number AS '계좌번호',
       a.account_name AS '계좌명',
       l.loan_type AS '대출유형',
       l.principal AS '대출원금',
       l.balance AS '대출잔액',
       l.interest_rate AS '이자율',
       l.monthly_repayment AS '월상환액',
       l.status AS '대출상태',
       l.executed_at AS '실행일',
       l.maturity_date AS '만기일',
       l.created_at AS '신청일',
       CASE 
           WHEN l.status = '연체' OR EXISTS (
               SELECT 1 FROM loan_repayment_schedule
               WHERE loan_id = l.loan_id 
                 AND status = '예정'
                 AND repayment_date < CURRENT_DATE
           ) THEN '연체'
           ELSE '정상'
       END AS '연체여부'
FROM loan l
INNER JOIN accounts a ON l.account_id = a.account_id
WHERE l.user_no = @test_user_no
  AND (NULL IS NULL OR l.loan_type = '신용')
ORDER BY l.created_at DESC;
