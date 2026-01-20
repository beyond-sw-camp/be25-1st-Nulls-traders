USE project;
-- ============================================
-- 테이블 삭제
-- ============================================

-- 3단계: 최하위 자식 테이블 삭제
DROP TABLE IF EXISTS Portfolio_analysis;
DROP TABLE IF EXISTS News_summary;
DROP TABLE IF EXISTS Stock_summary;
DROP TABLE IF EXISTS watchlist;
DROP TABLE IF EXISTS portfolios;
DROP TABLE IF EXISTS trades;
DROP TABLE IF EXISTS loan_repayment_history;
DROP TABLE IF EXISTS deposit_withdraw_history;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS user_notification;
DROP TABLE IF EXISTS admin_modification_log;
DROP TABLE IF EXISTS admin_notification;
DROP TABLE IF EXISTS admin_credentials;

-- 2단계: 중간 관계 테이블 삭제
DROP TABLE IF EXISTS loan_repayment_schedule;
DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS stock_price;
DROP TABLE IF EXISTS News;
DROP TABLE IF EXISTS Chatbot;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS login;

-- 1단계: 최상위 부모 테이블 삭제
DROP TABLE IF EXISTS dashboard;
DROP TABLE IF EXISTS loan_policy;
DROP TABLE IF EXISTS stocks;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS users;
-- ============================================
-- 1단계: 최상위 부모 테이블
-- ============================================

-- users 테이블
CREATE TABLE `users` (
	`user_no` 		 INT AUTO_INCREMENT NOT NULL      COMMENT '사용자고유번호',
	`user_name`		 VARCHAR(15) NOT NULL             COMMENT '이름',
	`user_mobile`	 CHAR(11) NOT NULL                COMMENT '휴대전화', 
	`user_email`	 VARCHAR(255) NOT NULL            COMMENT '이메일',
	`user_credit`	 INT NOT NULL                     COMMENT '신용등급',
	`user_status`	 CHAR(2) NOT NULL                 COMMENT '상태',
	`user_created`  DATETIME NOT NULL DEFAULT NOW()   COMMENT '가입일시',

	CONSTRAINT PRIMARY KEY (user_no),
	CONSTRAINT uq_user_mobile UNIQUE (user_mobile),
	CONSTRAINT uq_user_email UNIQUE (user_email),
	CONSTRAINT chk_user_credit CHECK(`user_credit` BETWEEN 0 AND 10),
	CONSTRAINT chk_user_status CHECK(`user_status` IN ('정상', '탈퇴'))
);

-- admins 테이블
CREATE TABLE admins (
    admin_no INT NOT NULL AUTO_INCREMENT,
    admin_id VARCHAR(20) NOT NULL UNIQUE,
    admin_email VARCHAR(100) NOT NULL UNIQUE,
    is_system_admin BOOL NOT NULL DEFAULT FALSE,
    is_community_admin BOOL NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME,

    PRIMARY KEY (admin_no)
);

-- stocks 테이블
CREATE TABLE stocks (
    stock_code VARCHAR(10) PRIMARY KEY COMMENT '종목 코드',
    stock_name VARCHAR(30) NOT NULL COMMENT '종목 이름',
    market_type VARCHAR(10) NOT NULL COMMENT '시장 구분',
    listed_shares BIGINT COMMENT '상장 주식수',
    created_at TIMESTAMP NOT NULL COMMENT '등록일시',
    is_active BOOL NOT NULL DEFAULT TRUE COMMENT '거래 가능 여부'
) COMMENT='주식 종목';

-- loan_policy 테이블
CREATE TABLE loan_policy (
    policy_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    loan_type VARCHAR(20) NOT NULL,
    credit_grade_min INT NOT NULL,
    credit_grade_max INT NOT NULL,
    interest_rate DECIMAL(5,2) NULL,
    max_amount BIGINT NULL,

    CONSTRAINT chk_policy_loan_type CHECK (loan_type IN ('신용')),
    CONSTRAINT chk_policy_credit_min CHECK (credit_grade_min BETWEEN 1 AND 10),
    CONSTRAINT chk_policy_credit_max CHECK (credit_grade_max BETWEEN 1 AND 10),
    CONSTRAINT chk_policy_credit_range CHECK (credit_grade_min <= credit_grade_max),
    CONSTRAINT chk_policy_interest_rate CHECK (interest_rate BETWEEN 0 AND 20.00),
    CONSTRAINT chk_policy_max_amount CHECK (max_amount IS NULL OR max_amount > 0)
);

-- dashboard 테이블
CREATE TABLE dashboard (
    dash_no INT NOT NULL AUTO_INCREMENT,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    total_user_count INT NOT NULL CHECK (total_user_count >= 0),
    register_count INT NOT NULL CHECK (register_count >= 0),
    login_count INT NOT NULL CHECK (login_count >= 0),

    PRIMARY KEY (dash_no)
);

-- ============================================
-- 2단계: 중간 관계 테이블
-- ============================================

-- login 테이블
CREATE TABLE `login` (
	`user_id`           VARCHAR(10) NOT NULL				   COMMENT 'ID',
	`user_no`           INT NOT NULL							   COMMENT '사용자고유번호',
	`user_pw`           VARCHAR(255) NOT NULL				   COMMENT 'ID비밀번호해시',
	`user_pin`          VARCHAR(255) NULL					   COMMENT '간편비밀번호해시',
	`user_recent`       DATETIME NOT NULL DEFAULT NOW()   COMMENT '최종로그인일시',

	CONSTRAINT PRIMARY KEY (user_id),
	CONSTRAINT fk_login_user_no FOREIGN KEY (user_no) REFERENCES `users`(`user_no`)
);

-- accounts 테이블
CREATE TABLE accounts (
    account_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no INT NOT NULL REFERENCES users(user_no),
    account_number VARCHAR(20) NOT NULL,
    account_name VARCHAR(20) NOT NULL,
    deposit BIGINT NOT NULL DEFAULT 0,
    margin BIGINT NOT NULL DEFAULT 0,
    `status` VARCHAR(10) NOT NULL DEFAULT '정상',
    last_transaction_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_accounts_deposit CHECK (deposit >= 0),
    CONSTRAINT chk_accounts_margin CHECK (margin >= 0),
    CONSTRAINT chk_accounts_status CHECK (status IN ('정상', '정지', '휴면', '해지'))
);

-- posts 테이블
CREATE TABLE posts (
    post_id INT NOT NULL AUTO_INCREMENT,
    user_no INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    is_admin_post VARCHAR(40) NOT NULL CHECK (is_admin_post IN ('admin', 'user')),
    post_like INT NOT NULL DEFAULT 0 CHECK (post_like >= 0),
    post_dislike INT NOT NULL DEFAULT 0 CHECK (post_dislike >= 0),
    post_del BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (post_id),
    CONSTRAINT fk_posts_user
        FOREIGN KEY (user_no) REFERENCES users(user_no)
);

-- notification 테이블
CREATE TABLE notification (
    notification_id INT NOT NULL AUTO_INCREMENT,
    notification_type VARCHAR(30) NOT NULL CHECK (notification_type IN ('POST', 'COMMENT')),
    message TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (notification_id)
);

-- Chatbot 테이블
CREATE TABLE `Chatbot` (
    `conversation_id` INT NOT NULL AUTO_INCREMENT COMMENT '대화 ID',
    `user_id` VARCHAR(10) NOT NULL COMMENT '사용자',
    `message` TEXT NOT NULL COMMENT '메시지',
    `role` ENUM('USER', 'BOT') NOT NULL DEFAULT 'BOT' COMMENT '발화주체',

    CONSTRAINT PRIMARY KEY (`conversation_id`),
    CONSTRAINT `fk_chatbot_user` FOREIGN KEY (`user_id`) REFERENCES `login`(`user_id`) 
) COMMENT='챗봇 대화 테이블';

-- News 테이블
CREATE TABLE `News` (
    `News_id` INT NOT NULL AUTO_INCREMENT COMMENT '뉴스 ID',
    `Title` VARCHAR(100) NOT NULL COMMENT '제목',
    `Content` TEXT NOT NULL COMMENT '내용',
    `Publisher` VARCHAR(20) NOT NULL COMMENT '언론사',
    `URL` VARCHAR(255) NOT NULL COMMENT 'URL',
    `Published_at` DATE NOT NULL DEFAULT (CURRENT_DATE) COMMENT '발행날짜',
    `Hash` VARCHAR(64) NOT NULL COMMENT '해시값 (중복방지)',
    `stock_code` VARCHAR(10) NOT NULL COMMENT '주식코드',

    CONSTRAINT PRIMARY KEY (`News_id`),
    CONSTRAINT `uq_news_url` UNIQUE (`URL`),
    CONSTRAINT `fk_news_stock` FOREIGN KEY (`stock_code`) REFERENCES `stocks`(`stock_code`)
) COMMENT='뉴스';

-- stock_price 테이블
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

-- loan 테이블
CREATE TABLE loan (
    loan_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no INT NOT NULL REFERENCES users(user_no),
    account_id BIGINT NOT NULL REFERENCES accounts(account_id),
    loan_type VARCHAR(20) NOT NULL,
    principal BIGINT NOT NULL,
    balance BIGINT NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    loan_period_months INT NOT NULL,
    repayment_type VARCHAR(20) NOT NULL,
    monthly_repayment BIGINT NULL,
    `status` VARCHAR(10) NOT NULL DEFAULT '승인',
    executed_at TIMESTAMP NULL DEFAULT NULL,
    maturity_date DATE NULL DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_loan_type CHECK (loan_type IN ('신용')),
    CONSTRAINT chk_loan_principal CHECK (principal > 0),
    CONSTRAINT chk_loan_balance CHECK (balance >= 0 AND balance <= principal),
    CONSTRAINT chk_loan_interest_rate CHECK (interest_rate BETWEEN 0 AND 20.00),
    CONSTRAINT chk_loan_period CHECK (loan_period_months > 0),
    CONSTRAINT chk_loan_repayment_type CHECK (repayment_type IN ('만기일시상환', '원리금균등분할')),
    CONSTRAINT chk_loan_monthly_repayment CHECK (monthly_repayment IS NULL OR monthly_repayment >= 0),
    CONSTRAINT chk_loan_status CHECK (status IN ('승인', '실행중', '완료', '연체'))
);

-- loan_repayment_schedule 테이블
CREATE TABLE loan_repayment_schedule (
    schedule_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    loan_id BIGINT NOT NULL REFERENCES loan(loan_id),
    repayment_number INT NOT NULL,
    repayment_date DATE NOT NULL,
    principal_amount BIGINT NOT NULL,
    interest_amount BIGINT NOT NULL,
    total_amount BIGINT NOT NULL,
    `status` VARCHAR(10) NOT NULL DEFAULT '예정',
    actual_repayment_at TIMESTAMP NULL,
    
    CONSTRAINT chk_schedule_repayment_number CHECK (repayment_number > 0),
    CONSTRAINT chk_schedule_principal CHECK (principal_amount >= 0),
    CONSTRAINT chk_schedule_interest CHECK (interest_amount >= 0),
    CONSTRAINT chk_schedule_total CHECK (total_amount = principal_amount + interest_amount),
    CONSTRAINT chk_schedule_status CHECK (status IN ('예정', '완료'))
);

-- ============================================
-- 3단계: 최하위 자식 테이블
-- ============================================

-- admin_credentials 테이블
CREATE TABLE admin_credentials (
    admin_no INT NOT NULL,
    password VARCHAR(255) NOT NULL,
    pw_changed_at DATETIME NOT NULL DEFAULT NOW(),

    PRIMARY KEY (admin_no),
    FOREIGN KEY (admin_no) REFERENCES admins(admin_no) 
        ON DELETE CASCADE
);

-- admin_notification 테이블
CREATE TABLE admin_notification (
    noti_no INT NOT NULL AUTO_INCREMENT,
    admin_no INT NOT NULL,
    noti_title TEXT NOT NULL,
    noti_text TEXT NOT NULL,
    is_alert BOOL NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT NOW(),

    PRIMARY KEY (noti_no),
    FOREIGN KEY (admin_no) REFERENCES admins(admin_no)
);

-- admin_modification_log 테이블
CREATE TABLE admin_modification_log (
    modi_no INT NOT NULL AUTO_INCREMENT,
    admin_no INT NOT NULL,
    user_no INT NOT NULL,
    modi_type VARCHAR(20) NOT NULL CHECK (modi_type IN ('수정', '조회', '삭제')),
    modified_at DATETIME NOT NULL,
    modi_detail TEXT NOT NULL,

    PRIMARY KEY (modi_no),
    FOREIGN KEY (admin_no) REFERENCES admins(admin_no),
    FOREIGN KEY (user_no) REFERENCES users(user_no) 
);

-- user_notification 테이블
CREATE TABLE user_notification (
    notification_id INT NOT NULL,
    user_no INT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (notification_id, user_no),
    CONSTRAINT fk_user_notification_notification
        FOREIGN KEY (notification_id) REFERENCES notification(notification_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_user_notification_user
        FOREIGN KEY (user_no) REFERENCES users(user_no)
);

-- comments 테이블
CREATE TABLE comments (
    comment_id INT NOT NULL AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_no INT NOT NULL,
    content TEXT NOT NULL,
    comment_like INT NOT NULL DEFAULT 0 CHECK (comment_like >= 0),
    comment_dislike INT NOT NULL DEFAULT 0 CHECK (comment_dislike >= 0),
    comment_del BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (comment_id),
    CONSTRAINT fk_comments_post
        FOREIGN KEY (post_id) REFERENCES posts(post_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_comments_user
        FOREIGN KEY (user_no) REFERENCES users(user_no)
);

-- deposit_withdraw_history 테이블
CREATE TABLE deposit_withdraw_history (
    transaction_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(account_id),
    transaction_type VARCHAR(10) NOT NULL,
    amount BIGINT NOT NULL,
    balance_after BIGINT NOT NULL,
    transaction_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_deposit_withdraw_type CHECK (transaction_type IN ('입금', '출금')),
    CONSTRAINT chk_deposit_withdraw_amount CHECK (amount > 0),
    CONSTRAINT chk_deposit_withdraw_balance CHECK (balance_after >= 0)
);

-- loan_repayment_history 테이블
CREATE TABLE loan_repayment_history (
    repayment_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    loan_id BIGINT NOT NULL REFERENCES loan(loan_id),
    schedule_id BIGINT NULL REFERENCES loan_repayment_schedule(schedule_id),
    repayment_type VARCHAR(20) NOT NULL,
    principal_amount BIGINT NOT NULL,
    interest_amount BIGINT NOT NULL,
    overdue_interest_amount BIGINT NOT NULL DEFAULT 0,
    total_amount BIGINT NOT NULL,
    balance_after BIGINT NOT NULL,
    repayment_method VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_repayment_type CHECK (repayment_type IN ('정상')),
    CONSTRAINT chk_repayment_principal CHECK (principal_amount >= 0),
    CONSTRAINT chk_repayment_interest CHECK (interest_amount >= 0),
    CONSTRAINT chk_repayment_overdue CHECK (overdue_interest_amount >= 0),
    CONSTRAINT chk_repayment_total CHECK (total_amount = principal_amount + interest_amount + overdue_interest_amount),
    CONSTRAINT chk_repayment_balance CHECK (balance_after >= 0),
    CONSTRAINT chk_repayment_method CHECK (repayment_method IN ('자동', '수동'))
);

-- trades 테이블
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

-- portfolios 테이블
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

-- watchlist 테이블
CREATE TABLE watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '관심종목 ID',
    user_no INT NOT NULL COMMENT '사용자 고유번호',
    stock_code VARCHAR(10) NOT NULL COMMENT '종목 코드',
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    
    FOREIGN KEY (user_no) REFERENCES users(user_no),
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code),
    UNIQUE KEY uk_user_stock (user_no, stock_code)
) COMMENT='사용자 관심종목';

-- Stock_summary 테이블
CREATE TABLE `Stock_summary` (
    `stock_summary_id` INT NOT NULL AUTO_INCREMENT COMMENT '요약 ID',
    `conversation_id` INT NOT NULL COMMENT '대화 ID',
    `stock_code` VARCHAR(10) NOT NULL COMMENT '종목 코드',
    `summary` TEXT NOT NULL COMMENT '요약내용',

    CONSTRAINT PRIMARY KEY (`stock_summary_id`),
    CONSTRAINT `fk_stock_sum_conv` FOREIGN KEY (`conversation_id`) REFERENCES `Chatbot`(`conversation_id`),
    CONSTRAINT `fk_stock_sum_stock` FOREIGN KEY (`stock_code`) REFERENCES `stocks`(`stock_code`)
) COMMENT='주식 요약';

-- News_summary 테이블
CREATE TABLE `News_summary` (
    `news_summary_id` INT NOT NULL AUTO_INCREMENT COMMENT '뉴스 요약 ID',
    `conversation_id` INT NOT NULL COMMENT '대화 ID',
    `News_id` INT NOT NULL COMMENT '뉴스 ID',
    `news_url` VARCHAR(255) NOT NULL COMMENT '뉴스 URL',
    `summary` TEXT NOT NULL COMMENT '요약',
    `sentiment` ENUM('POSITIVE', 'NEUTRAL', 'NEGATIVE') NOT NULL DEFAULT 'NEUTRAL' COMMENT '감성분석',

    CONSTRAINT PRIMARY KEY (`news_summary_id`),
    CONSTRAINT `fk_news_sum_conv` FOREIGN KEY (`conversation_id`) REFERENCES `Chatbot`(`conversation_id`),
    CONSTRAINT `fk_news_sum_news` FOREIGN KEY (`News_id`) REFERENCES `News`(`News_id`),
    CONSTRAINT `fk_news_sum_url` FOREIGN KEY (`news_url`) REFERENCES `News`(`URL`)
) COMMENT='뉴스 요약';

-- Portfolio_analysis 테이블
CREATE TABLE `Portfolio_analysis` (
    `portfolio_id` INT NOT NULL AUTO_INCREMENT COMMENT '포트폴리오 ID',
    `conversation_id` INT NOT NULL COMMENT '대화 ID',
    `user_id` VARCHAR(10) NOT NULL COMMENT '유저 ID',
    `risk_score` INT NOT NULL COMMENT '리스크 점수',
    `diversification_score` INT NOT NULL COMMENT '분산도',
    `analysis_result` TEXT NOT NULL COMMENT '분석요약',
    
    CONSTRAINT PRIMARY KEY (`portfolio_id`),
    CONSTRAINT `fk_port_ana_conv` FOREIGN KEY (`conversation_id`) REFERENCES `Chatbot`(`conversation_id`),
    CONSTRAINT `fk_port_ana_user` FOREIGN KEY (`user_id`) REFERENCES `login`(`user_id`)
) COMMENT='포트폴리오 분석';