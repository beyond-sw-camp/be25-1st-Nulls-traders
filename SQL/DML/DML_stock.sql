-- ============================================
-- 1. STOCK_001 (종목 검색)
-- 사용자가 종목명 또는 종목코드로 부분 일치 검색
-- ============================================
SET @target_stock01 = '05'; -- 삼성전자, 현대차
SELECT s.stock_code,
    s.stock_name,
    s.market_type,
    sp.current_price,
    sp.prev_close,
    sp.change_amount,
    sp.change_rate
FROM stocks s
INNER JOIN stock_price sp ON s.stock_code = sp.stock_code
WHERE s.stock_name LIKE CONCAT('%', @target_stock01, '%')  -- 파라미터: 검색어
    OR s.stock_code LIKE CONCAT('%', @target_stock01, '%')
ORDER BY s.stock_name
LIMIT 20;

-- ============================================
-- 2. STOCK_002 (관심종목 등록)
-- ============================================
-- 테스트 시나리오: 1번 유저가 'RTX' 종목을 등록하려고 함
SET @u_no01 = 1;
SET @s_code01 = 'RTX';

INSERT INTO watchlist (user_no, stock_code)
SELECT @u_no01, @s_code01
WHERE (SELECT COUNT(*) FROM watchlist WHERE user_no = @u_no01) < 50 
    AND EXISTS (SELECT 1 FROM stocks WHERE stock_code = @s_code01)
    AND NOT EXISTS (SELECT 1 FROM watchlist WHERE user_no = @u_no01 AND stock_code = @s_code01);

SELECT *
FROM watchlist
WHERE user_no = @u_no01;

-- ============================================
-- 3. STOCK_003 (관심종목 삭제)
-- ============================================
-- 테스트 시나리오: 1번 유저가 'RTX' 종목을 삭제하려고 함
SET @u_no02 = 1;
SET @s_code02 = 'RTX';
DELETE FROM watchlist
WHERE user_no = @u_no02  -- 파라미터: 사용자번호
    AND stock_code = @s_code02;  -- 파라미터: 종목코드

SELECT *
FROM watchlist
WHERE user_no = @u_no02;

-- ============================================
-- 4. STOCK_004 (관심종목 조회)
-- 사용자의 관심종목 목록 조회
-- ============================================
SET @u_no03 = 4; -- 국장을 좋아하는 애국인
SELECT w.watchlist_id,
    w.stock_code,
    s.stock_name,
    sp.current_price,
    sp.change_rate,
    w.added_at
FROM watchlist w
INNER JOIN stocks s ON w.stock_code = s.stock_code
INNER JOIN stock_price sp ON s.stock_code = sp.stock_code
WHERE w.user_no = @u_no03  -- 파라미터: 사용자번호
ORDER BY w.added_at DESC;


-- ============================================
-- 5. STOCK_005 (매수 주문)
-- ============================================
DELIMITER $$

CREATE OR REPLACE PROCEDURE sp_buy_stock(
    IN p_user_no INT,       -- 사용자 번호
    IN p_account_id BIGINT, -- 계좌 ID
    IN p_stock_code VARCHAR(10), -- 종목 코드
    IN p_quantity INT       -- 매수 수량
)
BEGIN
    -- 내부 변수 선언
    DECLARE v_current_price DECIMAL(15,2);
    DECLARE v_deposit BIGINT;
    DECLARE v_total_amount DECIMAL(20,2);

    -- 1. 현재가 조회
    SELECT current_price INTO v_current_price
    FROM stock_price
    WHERE stock_code = p_stock_code;

    -- 2. 예수금 확인
    SELECT deposit INTO v_deposit
    FROM accounts
    WHERE account_id = p_account_id;

    -- 3. 체결금액 계산
    SET v_total_amount = v_current_price * p_quantity;

    -- 4. 트랜잭션 및 유효성 검사 시작
    IF v_deposit >= v_total_amount THEN
        START TRANSACTION;
        
        -- 5. 체결 내역 저장
        INSERT INTO trades (user_no, stock_code, account_id, trade_type, quantity, price, total_amount)
        VALUES (p_user_no, p_stock_code, p_account_id, 'BUY', p_quantity, v_current_price, v_total_amount);
        
        -- 6. 예수금 차감
        UPDATE accounts
        SET deposit = deposit - v_total_amount
        WHERE account_id = p_account_id;
        
        -- 7. 포트폴리오 업데이트 (이미 있으면 수량/평단가 갱신, 없으면 추가)
        INSERT INTO portfolios (user_no, stock_code, account_id, quantity, avg_price)
        VALUES (p_user_no, p_stock_code, p_account_id, p_quantity, v_current_price)
        ON DUPLICATE KEY UPDATE
            avg_price = ((avg_price * quantity) + (v_current_price * p_quantity)) / (quantity + p_quantity),
            quantity = quantity + p_quantity,
            updated_at = CURRENT_TIMESTAMP;
        
        COMMIT;
        SELECT '매수 체결 완료' AS result_msg;
    ELSE
        -- 예수금 부족 시 에러 발생 및 롤백
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = '예수금이 부족합니다. (잔액 부족)';
    END IF;
END $$
DELIMITER ;

-- 민정기(user_no: 1, account_id: 1)가 삼성전자(005930) 20주 매수
-- CALL sp_buy_stock(1, 1, '005930', 20);
-- 20개 142000원, 20개 149300원 => 14만 5650원
-- 결과 확인 (잔액이 약 701만 원, 주식은 40개)
-- SELECT deposit FROM accounts WHERE account_id = 1;
-- SELECT * FROM trades ORDER BY trade_id DESC LIMIT 1;
-- SELECT * FROM portfolios WHERE account_id = 1;

-- 방지혁(user_no: 4, account_id: 4)이 현대차(005380) 10주 매수 시도
-- CALL sp_buy_stock(4, 4, '005380', 10); 
-- 결과: "예수금이 부족합니다" 에러 팝업/로그 발생 정상

-- ============================================
-- 6. STOCK_006 (매도 주문)
-- ============================================
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp_sell_stock(
    IN p_user_no INT,           -- 사용자 번호
    IN p_account_id BIGINT,     -- 계좌 ID
    IN p_stock_code VARCHAR(10),-- 종목 코드
    IN p_quantity INT           -- 매도 수량
)
BEGIN
    -- 내부 변수 선언
    DECLARE v_current_price DECIMAL(15,2);
    DECLARE v_owned_quantity INT DEFAULT 0;
    DECLARE v_total_amount DECIMAL(20,2);

    -- 1. 현재가 조회
    SELECT current_price INTO v_current_price
    FROM stock_price
    WHERE stock_code = p_stock_code;

    -- 2. 현재 보유 수량 조회 (해당 계좌의 해당 종목)
    SELECT quantity INTO v_owned_quantity
    FROM portfolios
    WHERE account_id = p_account_id AND stock_code = p_stock_code;

    -- 3. 체결금액 계산
    SET v_total_amount = v_current_price * p_quantity;

    -- 4. 유효성 검사 및 트랜잭션 시작
    IF v_owned_quantity IS NOT NULL AND v_owned_quantity >= p_quantity THEN
        START TRANSACTION;
        
        -- 5. 체결 내역 저장 (SELL 타입)
        INSERT INTO trades (user_no, stock_code, account_id, trade_type, quantity, price, total_amount)
        VALUES (p_user_no, p_stock_code, p_account_id, 'SELL', p_quantity, v_current_price, v_total_amount);
        
        -- 6. 예수금 증가 (매도 대금 입금)
        UPDATE accounts
        SET deposit = deposit + v_total_amount
        WHERE account_id = p_account_id;
        
        -- 7. 포트폴리오 차감
        UPDATE portfolios
        SET quantity = quantity - p_quantity,
            updated_at = CURRENT_TIMESTAMP
        WHERE account_id = p_account_id AND stock_code = p_stock_code;
        
        -- 8. 수량이 0이 되면 포트폴리오에서 삭제
        DELETE FROM portfolios
        WHERE account_id = p_account_id 
          AND stock_code = p_stock_code 
          AND quantity <= 0;
        
        COMMIT;
        SELECT '매도 체결 완료' AS result_msg;
    ELSE
        -- 보유 수량이 부족하거나 종목이 없는 경우
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '보유 수량이 부족하거나 미보유하여 매도할 수 없습니다.';
    END IF;
END $$
DELIMITER ;

-- 시나리오 1: 수익 실현을 위한 '일부 매도' (민정기)
-- CALL sp_sell_stock(1, 1, '005930', 10);
-- 결과 확인
-- SELECT deposit AS '매도 후 잔액' FROM accounts WHERE account_id = 1; -- 149만 3000원 늘어나야함 
-- SELECT quantity AS '남은 수량' FROM portfolios WHERE account_id = 1 AND stock_code = '005930'; -- 30개

-- 시나리오2: MSFT를 2주 가진 사용자가 욕심을 내어 5주를 팔려고 시도 (김예지) 
-- CALL sp_sell_stock(2, 2, 'MSFT', 5); -- 보유 수량이 부족하여 매도할 수 없습니다.

-- 시나리오 3: 현재진(user_no: 6, account_id: 6)이 미보유 종목 테슬라(TSLA) 매도 시도
CALL sp_sell_stock(6, 6, 'TSLA', 1);

-- ============================================
-- 7. STOCK_007 (주문 가능 수량 조회)
-- 현재 예수금으로 매수 가능한 최대 수량 조회
-- ============================================
SELECT account_id, user_no
FROM `accounts`;

-- SET @acc_id = 1;         -- 민정기 계좌 (850만7천원)
-- SET @s_code = '005930';  -- 삼성전자 149300원: 56개까지 추가구매 가능

SET @acc_id = 4;            -- 방지혁 계좌(300만원) 
SET @s_code = '000660';     -- SK하이닉스 764,000원: 3개까지 추가구매 가능

SELECT 
    a.deposit,
    sp.current_price,
    FLOOR(a.deposit / sp.current_price) AS max_quantity
FROM accounts a
CROSS JOIN stock_price sp
-- 종목 가격과 계좌 잔액은 직접적인 연결 고리가 없어서 CROSS JOIN
WHERE a.account_id = @acc_id  -- 파라미터: 계좌ID
  AND sp.stock_code = @s_code;  -- 파라미터: 종목코드

-- ============================================
-- 8. STOCK_008 (거래 통계조회)
-- 사용자의 이번달 총 거래횟수 및 금액 조회
-- ============================================
SET @u_no06 = 1;
-- 1485000 + 1350000 + 2986000 + 1493000 = 7,314,000
SELECT COUNT(*) AS trade_count,
    SUM(total_amount) AS total_amount
FROM trades
WHERE user_no = @u_no06
    AND YEAR(trade_time) = YEAR(CURDATE())
    AND MONTH(trade_time) = MONTH(CURDATE());

-- ============================================
-- 9. STOCK_009 (평균 매수 및 매도가 조회)
-- 사용자의 종목별 평균 매수가격, 평균 매도가격
-- ============================================
SET @target_user = 1;
SELECT 
    s.stock_code,
    s.stock_name,
    AVG(CASE WHEN t.trade_type = 'BUY' THEN t.price ELSE NULL END) AS avg_buy_price,
    AVG(CASE WHEN t.trade_type = 'SELL' THEN t.price ELSE NULL END) AS avg_sell_price,
    SUM(CASE WHEN t.trade_type = 'BUY' THEN t.quantity ELSE 0 END) AS total_bought,
    SUM(CASE WHEN t.trade_type = 'SELL' THEN t.quantity ELSE 0 END) AS total_sold
FROM trades t
JOIN stocks s ON t.stock_code = s.stock_code
WHERE t.user_no = @target_user  -- 파라미터: 사용자번호
GROUP BY s.stock_code, s.stock_name
ORDER BY s.stock_name;

-- ============================================
-- 10. STOCK_010 (손익 순위 정렬)
-- 보유종목을 수익률 기준으로 정렬
-- ============================================
SET @target_acc = 2;
SELECT 
    p.portfolio_id,
    s.stock_code,
    s.stock_name,
    p.quantity,
    p.avg_price,
    sp.current_price,
    (sp.current_price * p.quantity) AS eval_amount,
    ((sp.current_price - p.avg_price) * p.quantity) AS profit_loss,
    (((sp.current_price - p.avg_price) / p.avg_price) * 100) AS profit_rate
FROM portfolios p
JOIN stocks s ON p.stock_code = s.stock_code
JOIN stock_price sp ON s.stock_code = sp.stock_code
WHERE p.account_id = @target_acc  -- 파라미터: 계좌ID
ORDER BY profit_rate DESC;  -- 수익률 높은 순
-- ORDER BY profit_rate ASC;  -- 수익률 낮은 순

-- ============================================
-- 11. STOCK_011 (계좌 요약 조회)
-- 계좌 전체 요약 정보
-- ============================================
-- SET @target_acc = 1; -- 부자
SET @target_acc = 5; -- 거지

SELECT 
    a.account_id,
    a.deposit AS deposit,
    COALESCE(SUM(p.avg_price * p.quantity), 0) AS total_buy_amount,
    COALESCE(SUM(sp.current_price * p.quantity), 0) AS total_eval_amount,
    COALESCE(SUM((sp.current_price - p.avg_price) * p.quantity), 0) AS total_profit_loss,
    CASE 
        WHEN SUM(p.avg_price * p.quantity) > 0 
        THEN (SUM((sp.current_price - p.avg_price) * p.quantity) / SUM(p.avg_price * p.quantity) * 100)
        ELSE 0 
    END AS total_profit_rate
FROM accounts a
LEFT JOIN portfolios p ON a.account_id = p.account_id
LEFT JOIN stock_price sp ON p.stock_code = sp. stock_code
WHERE a.account_id = @target_acc  -- 파라미터: 계좌ID
GROUP BY a.account_id, a.deposit;

-- ============================================
-- 12. STOCK_012 (종목별 거래 내역 조회)
-- 특정 종목의 거래 내역만 조회
-- ============================================
SET @target_acc = 1;
SET @target_stock = '005930'; -- 30개
SELECT 
    t.trade_id,
    t.trade_type,
    s.stock_name,
    t.quantity,
    t.price,
    t.total_amount,
    t.trade_time
FROM trades t
JOIN stocks s ON t.stock_code = s.stock_code
WHERE t.account_id = @target_acc  -- 파라미터: 계좌ID
  AND t.stock_code = @target_stock  -- 파라미터: 종목코드
ORDER BY t.trade_time DESC
LIMIT 100;

-- ============================================
-- 13. STOCK_013 (체결내역 조회)
-- 지정 기간 내 체결 내역 조회
-- ============================================
SET @target_acc = 1;
SET @start_time = '2025-12-01 00:00:00'; -- 12월 초부터
SET @end_time   = '2026-01-20 23:59:59'; -- 오늘 밤까지
-- 기간 지정 조회
SELECT t.trade_id,
    s.stock_code,
    s.stock_name,
    t.trade_type,
    t.quantity,
    t.price,
    t.total_amount,
    t.trade_time
FROM trades t
JOIN stocks s ON t.stock_code = s.stock_code
WHERE t.account_id = @target_acc
    AND t.trade_time BETWEEN @start_time AND @end_time  -- 파라미터: 시작일, 종료일
ORDER BY t.trade_time DESC
LIMIT 100;
