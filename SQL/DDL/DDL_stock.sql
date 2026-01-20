-- USE stock_test;

-- GRANT ALL PRIVILEGES ON stock_test.* TO `beyond`@`%`;
-- SHOW GRANTS FOR `beyond`@`%`;
-- FLUSH PRIVILEGES;

-- 자식 테이블 (FK를 가짐) 먼저 삭제
-- DROP TABLE IF EXISTS watchlist;
-- DROP TABLE IF EXISTS portfolios;
-- DROP TABLE IF EXISTS trades;
-- DROP TABLE IF EXISTS stock_price;

-- 부모 테이블 (참조 대상) 나중에 삭제
-- DROP TABLE IF EXISTS accounts;
-- DROP TABLE IF EXISTS stocks;
-- DROP TABLE IF EXISTS users;

-- 사용자 테이블: PK만 남김
-- CREATE TABLE users (
--     user_no INT PRIMARY KEY AUTO_INCREMENT
-- ) COMMENT='사용자';

-- 계좌 테이블
-- CREATE TABLE accounts (
--     account_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '증권계좌 ID',
--     user_no INT NOT NULL COMMENT '사용자 고유번호',
--     deposit BIGINT NOT NULL DEFAULT 0 COMMENT '예수금',
--     FOREIGN KEY (user_no) REFERENCES users(user_no),
--     CONSTRAINT chk_deposit_positive CHECK (deposit >= 0)
-- ) COMMENT='계좌';

-- ============================================
-- 1. stocks (주식 종목)
-- ============================================
CREATE TABLE stocks (
  stock_code VARCHAR(10) PRIMARY KEY COMMENT '종목 코드',
  stock_name VARCHAR(30) NOT NULL COMMENT '종목 이름',
  market_type VARCHAR(10) NOT NULL COMMENT '시장 구분',
  listed_shares BIGINT COMMENT '상장 주식수',
  created_at TIMESTAMP NOT NULL COMMENT '등록일시',
  is_active BOOL NOT NULL DEFAULT TRUE COMMENT '거래 가능 여부'
) COMMENT='주식 종목';

-- ============================================
-- 2. stock_price (주식 종목 가격)
-- ============================================
CREATE TABLE stock_price (
  price_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '가격 ID',
  stock_code VARCHAR(10) NOT NULL COMMENT '종목 코드',
  current_price DECIMAL(15,2) NOT NULL COMMENT '현재가',
  prev_close DECIMAL(15,2) NOT NULL COMMENT '전일 종가',
  change_amount DECIMAL(15,2) COMMENT '전일대비 금액',
  change_rate DECIMAL(5,2) COMMENT '전일대비 등락률',
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '수정일시',
    
  FOREIGN KEY (stock_code) REFERENCES stocks(stock_code),
  CHECK (current_price > 0),
  CHECK (prev_close > 0)
) COMMENT='주식 종목 가격';

-- ============================================
-- 3. trades (주식 체결 내역)
-- ============================================
CREATE TABLE trades (
    trade_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '체결 번호',
    user_no INT NOT NULL COMMENT '사용자 고유번호',
    stock_code VARCHAR(10) NOT NULL COMMENT '종목 코드',
    account_id BIGINT NOT NULL COMMENT '증권계좌 ID',
    trade_type ENUM('BUY', 'SELL') NOT NULL COMMENT '거래 유형',
    quantity INT NOT NULL COMMENT '수량',
    price DECIMAL(15,2) NOT NULL COMMENT '체결 가격',
    total_amount DECIMAL(20,2) NOT NULL COMMENT '체결 금액',
    trade_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '체결 시간',
    
    FOREIGN KEY (user_no) REFERENCES users(user_no),
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    CHECK (quantity > 0),
    CHECK (price > 0),
    CHECK (total_amount > 0)
) COMMENT='주식 체결 내역';

-- ============================================
-- 4. portfolios (사용자 보유 종목)
-- ============================================
CREATE TABLE portfolios (
    portfolio_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '포트폴리오 ID',
    user_no INT NOT NULL COMMENT '사용자 고유번호',
    stock_code VARCHAR(10) NOT NULL COMMENT '종목 코드',
    account_id BIGINT NOT NULL COMMENT '증권계좌 ID',
    quantity INT NOT NULL COMMENT '보유 수량',
    avg_price DECIMAL(15,2) NOT NULL COMMENT '평균 매입가',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '최초 매수일',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '최종 거래일',
    
    FOREIGN KEY (user_no) REFERENCES users(user_no),
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    UNIQUE KEY uk_account_stock (account_id, stock_code),
    CHECK (quantity > 0),
    CHECK (avg_price > 0)
) COMMENT='사용자 보유 종목';

-- ============================================
-- 5. watchlist (사용자 관심종목)
-- ============================================
CREATE TABLE watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '관심종목 ID',
    user_no INT NOT NULL COMMENT '사용자 고유번호',
    stock_code VARCHAR(10) NOT NULL COMMENT '종목 코드',
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    
    FOREIGN KEY (user_no) REFERENCES users(user_no),
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code),
    UNIQUE KEY uk_user_stock (user_no, stock_code)
) COMMENT='사용자 관심종목';