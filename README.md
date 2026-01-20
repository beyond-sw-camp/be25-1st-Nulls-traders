# 🚫Team Nulls
![프로젝트 사진](img/traders.png)
* * *

## 목차
1. [팀원 소개](#1-팀원-소개)
2. [프로젝트 개요](#2-프로젝트-개요)
    - 2.1. [프로젝트 소개](#21-프로젝트-소개)  
    - 2.2. [프로젝트 필요성](#22-프로젝트-필요성)  
    - 2.3. [프로젝트 예상 사용자](#23-프로젝트-예상-사용자)
    - 2.4. [프로젝트 목표](#24-프로젝트-목표)
    - 2.5. [프로젝트 시나리오](#25-프로젝트-시나리오)
3. [기술 스택](#3-기술스택)
4. [요구사항 명세서](#4-요구사항-명세서)
5. [테이블 명세서](#5-테이블-명세서)
6. [ERD](#6-erd)
7. [SQL](#7-sql)
    - 7.1 [DDL](#71-ddl)
    - 7.2 [DML](#72-dml)
    - 7.3 [Test Case](#73-test-case)
8. [후기](#8-후기)
 

## 1.👥 팀원 소개
| 민정기 (팀장, 챗봇) | 김예지 (대출) | 김정수(유저,관리자) | 방지혁(주식 거래) | 이슬이(유저,관리자) | 현재진(게시물) |
| --- | --- | --- | --- | --- | --- |
|<img src="img/뚱이.jpeg" width="100">|<img src="img/집게사장.jpeg" width="100">|<img src="img/징징이.jpeg" width="100">|<img src="img/플랑크톤.jpg" width="100">|<img src="img/스폰지밥.jpg" width="100">|<img src="img/핑핑이.webp" width="100">|

* * *

## 2. 🛹프로젝트 개요
* * *
### 2.1. 🎈프로젝트 소개
2030 세대를 중심으로 개인 투자자가 빠르게 증가하면서[[1]](https://www.hankyung.com/article/2025111668521), 유튜브·커뮤니티·SNS 기반의 정보 소비가 주식 거래에 직접적인 영향을 미치고 있다.[[2]](https://www.jibs.co.kr/news/articles/articlesDetail/39630?feed=da&kakao_from=mainnews)[[3] ](https://www.kcmi.re.kr/report/report_view?report_no=1235)그러나 이러한 정보는 신뢰도와 맥락 등 확실한 정보라고 파악하기 힘들어서 개인 투자자들은 이러한 정보를 보고 제대로된 판단을 내리기 힘들고 이로 인해 충동적인 매매로 이어질수가 있다.
* * *
### 2.2. ❕프로젝트 필요성
본 서비스는 단순한 주식 거래 기능을 제공하는 것을 넘어, 투자자의 거래 이력과 행동을 기반으로 한 정보 제공, 사용자 간 의견 교환 및 정보 교환이 가능한 커뮤니티, AI 챗봇을 통한 투자 정보 요약 및 의사 결정 보조 그리고 투자 여력을 고려한 대출, 자금 관리 기능을 통합한 개인 투자자 중심의 주식 거래 플랫폼을 목표로 한다. 이를 통해 사용자는 단순한 매매가 아닌 이해 기반의 투자 경험을 할 수 있도록 한다.
* * *
### 2.3 🤲프로젝트 예상 사용자
- 사용자 A, 20대 후반, 직장인: 주변에서 다들 재테크로 인해 주식투자를 하기 시작하면서, 자신도 뒤쳐질 생각이 두려워 주식투자를 하기 시작한다. 주식투자가 이번이 처음이고 어떻게 해야할지 모르는 상황이라 불안하기만 하다. 하지만 이 서비스를 사용하여, 다른사람들의 매수 현황 매도 현황을 보고 의견을 들으며 견해를 늘리며 주식을 매수 또는 매도 할 자신이 생긴다.
- 사용자 B, 30대 중반, 주부: 우연히 유튜브 알고리즘에 주식에 대한 영상이 나타나면서, 주식에 대한 정보를 얻게 된다. 하지만 B씨는 유튜브 영상의 정보가 제대로 된 정보인지 확실치 않았다. 하지만 어플 내의 챗봇을 통하여 정보에 대한 출처를 명확히 알게 되었고 어떠한 정보를 확신해야 하는지를 알게 됨으로써, 주식에 대해 매수 매도에 대한 자신의 행동에 자신감을 가지게 된다.
* * *
### 2.4 🏐프로젝트 목표
본 서비스의 목표는 주식 거래를 하며 주식 거래시 검증되지 않은 뉴스와 정보로 인한 잘못된 의사결정을 방지하는 것입니다.
사용자는 다양한 투자자들과의 의견 교류를 통해 정보의 신뢰성을 검증할 수 있으며, AI 챗봇을 활용해 뉴스 요약, 사실 확인, 종목 관련 정보를 제공받아 보다 합리적인 판단을 기반으로 주식 거래를 수행할 수 있도록 돕습니다.
* * *
### 2.5 🏀프로젝트 시나리오
(PPT로 만들어서 추가)
* * *
## 3. 🚙기술스택
| MariaDB | ERDCloud | Linux |
| --- | --- | --- |
|<img src="img/Mariadb.jpg" width="100">|<img src="img/erdCloud.png" width="100">|<img src="img/Linux.png" width="100">|
* * *
## 4. 🐻요구사항 명세서
(사진 추가)
* * *
## 5. 🐧테이블 명세서
(사진 추가)
* * *
## 6. 🐣ERD
(사진 추가)
* * *

## 7. 🎃SQL
* * *
### 7.1 📍DDL

<details>
<summary>User</summary>
<div markdown="1">

```
CREATE TABLE `users` (
  `user_no` INT AUTO_INCREMENT NOT NULL COMMENT '사용자고유번호',
  `user_name` VARCHAR(15) NOT NULL COMMENT '이름',
  `user_mobile` CHAR(11) NOT NULL COMMENT '휴대전화',
  `user_email` VARCHAR(255) NOT NULL COMMENT '이메일',
  `user_credit` INT NOT NULL COMMENT '신용등급',
  `user_status` CHAR(2) NOT NULL COMMENT '상태',
  `user_created` DATETIME NOT NULL DEFAULT NOW() COMMENT '가입일시',

  CONSTRAINT PRIMARY KEY (user_no),
  CONSTRAINT uq_user_mobile UNIQUE (user_mobile),
  CONSTRAINT uq_user_email UNIQUE (user_email),
  CONSTRAINT chk_user_credit CHECK (`user_credit` BETWEEN 0 AND 10),
  CONSTRAINT chk_user_status CHECK (`user_status` IN ('정상', '탈퇴'))
);
```

</div>
</details>

<details>
<summary>Admin</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Stock</summary>
<div markdown="1">

```
CREATE TABLE stocks (
    stock_code VARCHAR(10) PRIMARY KEY COMMENT '종목 코드',
    stock_name VARCHAR(30) NOT NULL COMMENT '종목 이름',
    market_type VARCHAR(10) NOT NULL COMMENT '시장 구분',
    listed_shares BIGINT COMMENT '상장 주식수',
    created_at TIMESTAMP NOT NULL COMMENT '등록일시',
    is_active BOOL NOT NULL DEFAULT TRUE COMMENT '거래 가능 여부'
) COMMENT='주식 종목';
```

</div>
</details>

<details>
<summary>Account</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Dashboard</summary>
<div markdown="1">

```
CREATE TABLE dashboard (
    dash_no INT NOT NULL AUTO_INCREMENT,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    total_user_count INT NOT NULL CHECK (total_user_count >= 0),
    register_count INT NOT NULL CHECK (register_count >= 0),
    login_count INT NOT NULL CHECK (login_count >= 0),

    PRIMARY KEY (dash_no)
);
```

</div>
</details>

<details>
<summary>Chat Bot</summary>
<div markdown="1">

```
CREATE TABLE `Chatbot` (
    `conversation_id` INT NOT NULL AUTO_INCREMENT COMMENT '대화 ID',
    `user_id` VARCHAR(10) NOT NULL COMMENT '사용자',
    `message` TEXT NOT NULL COMMENT '메시지',
    `role` ENUM('USER', 'BOT') NOT NULL DEFAULT 'BOT' COMMENT '발화주체',

    CONSTRAINT PRIMARY KEY (`conversation_id`),
    CONSTRAINT `fk_chatbot_user` FOREIGN KEY (`user_id`) REFERENCES `login`(`user_id`) 
) COMMENT='챗봇 대화 테이블';
```

</div>
</details>

<details>
<summary>Loan Policy</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Login</summary>
<div markdown="1">

```
CREATE TABLE `login` (
	`user_id`           VARCHAR(10) NOT NULL				   COMMENT 'ID',
	`user_no`           INT NOT NULL							   COMMENT '사용자고유번호',
	`user_pw`           VARCHAR(255) NOT NULL				   COMMENT 'ID비밀번호해시',
	`user_pin`          VARCHAR(255) NULL					   COMMENT '간편비밀번호해시',
	`user_recent`       DATETIME NOT NULL DEFAULT NOW()   COMMENT '최종로그인일시',

	CONSTRAINT PRIMARY KEY (user_id),
	CONSTRAINT fk_login_user_no FOREIGN KEY (user_no) REFERENCES `users`(`user_no`)
);
```

</div>
</details>

<details>
<summary>Accounts</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Accounts</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Posts</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Notification</summary>
<div markdown="1">

```
CREATE TABLE notification (
    notification_id INT NOT NULL AUTO_INCREMENT,
    notification_type VARCHAR(30) NOT NULL CHECK (notification_type IN ('POST', 'COMMENT')),
    message TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (notification_id)
);

```

</div>
</details>

<details>
<summary>News</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Stock Price</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Loan</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Loan Repayment Schedule</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Admin Credentials</summary>
<div markdown="1">

```
CREATE TABLE admin_credentials (
    admin_no INT NOT NULL,
    password VARCHAR(255) NOT NULL,
    pw_changed_at DATETIME NOT NULL DEFAULT NOW(),

    PRIMARY KEY (admin_no),
    FOREIGN KEY (admin_no) REFERENCES admins(admin_no) 
        ON DELETE CASCADE
);
```

</div>
</details>

<details>
<summary>Admin Notification</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Admin Modification Log</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>User Notification</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Comments</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Deposit Withdraw History</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Loan Repayment History</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Trades</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Portfolios</summary>
<div markdown="1">

```
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
```

</div>
</details>

<details>
<summary>Watchlist</summary>
<div markdown="1">

```
CREATE TABLE watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '관심종목 ID',
    user_no INT NOT NULL COMMENT '사용자 고유번호',
    stock_code VARCHAR(10) NOT NULL COMMENT '종목 코드',
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    
    FOREIGN KEY (user_no) REFERENCES users(user_no),
    FOREIGN KEY (stock_code) REFERENCES stocks(stock_code),
    UNIQUE KEY uk_user_stock (user_no, stock_code)
) COMMENT='사용자 관심종목';

```

</div>
</details>

<details>
<summary>Stock Summary</summary>
<div markdown="1">

```
CREATE TABLE `Stock_summary` (
    `stock_summary_id` INT NOT NULL AUTO_INCREMENT COMMENT '요약 ID',
    `conversation_id` INT NOT NULL COMMENT '대화 ID',
    `stock_code` VARCHAR(10) NOT NULL COMMENT '종목 코드',
    `summary` TEXT NOT NULL COMMENT '요약내용',

    CONSTRAINT PRIMARY KEY (`stock_summary_id`),
    CONSTRAINT `fk_stock_sum_conv` FOREIGN KEY (`conversation_id`) REFERENCES `Chatbot`(`conversation_id`),
    CONSTRAINT `fk_stock_sum_stock` FOREIGN KEY (`stock_code`) REFERENCES `stocks`(`stock_code`)
) COMMENT='주식 요약';

```

</div>
</details>

<details>
<summary>News Summary</summary>
<div markdown="1">

```
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

```

</div>
</details>

<details>
<summary>Portfolio Analysis</summary>
<div markdown="1">

```
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

```

</div>
</details>

* * *

### 7.2 🎈DML
<details>
<summary>User</summary>
<div markdown="1">

토글 안에 넣을 이미지나 글

</div>
</details>

<details>
<summary>Stock</summary>
<div markdown="1">

토글 안에 넣을 이미지나 글

</div>
</details>

<details>
<summary>Account</summary>
<div markdown="1">

토글 안에 넣을 이미지나 글

</div>
</details>

<details>
<summary>Board</summary>
<div markdown="1">

토글 안에 넣을 이미지나 글

</div>
</details>

<details>
<summary>Chat Bot</summary>
<div markdown="1">

토글 안에 넣을 이미지나 글

</div>
</details>

* * *

### 7.3 🏐Test Case

<details>
<summary>테스트 케이스</summary>
<div markdown="1">

토글 안에 넣을 이미지나 글

</div>
</details>

* * *

## 8. 🎉후기.

##### 민정기
후기 작성
* * *
##### 김예지
후기 작성
* * *
##### 김정수
후기 작성
* * *
##### 방지혁
후기 작성
* * *
##### 이슬이
후기 작성
* * *
##### 현재진
후기 작성
* * *
