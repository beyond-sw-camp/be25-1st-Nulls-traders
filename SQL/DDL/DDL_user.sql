-- users 테이블
CREATE TABLE `users` (
	`user_no` 		 INT AUTO_INCREMENT NOT NULL      COMMENT '사용자고유번호',
	`user_name`		 VARCHAR(15) NOT NULL             COMMENT '이름',
	`user_mobile`	 CHAR(11) NOT NULL                COMMENT '휴대전화', 
	`user_email`	 VARCHAR(255) NOT NULL            COMMENT '이메일',
	`user_credit`	 INT NOT NULL                     COMMENT '신용등급',
	`user_status`	 CHAR(2) NOT NULL                 COMMENT '상태',
	`user_created`  DATETIME NOT NULL DEFAULT NOW()  COMMENT '가입일시',
	-- 제약 조건
	CONSTRAINT PRIMARY KEY (user_no),
	CONSTRAINT uq_user_mobile UNIQUE (user_mobile),
	CONSTRAINT uq_user_email UNIQUE (user_email),
	CONSTRAINT chk_user_credit CHECK(`user_credit` BETWEEN 0 AND 10),
	CONSTRAINT chk_user_status CHECK(`user_status` IN ('정상', '탈퇴'))
);

-- login 테이블
CREATE TABLE `login` (
	`ID`           VARCHAR(10) NOT NULL				   COMMENT 'ID',
	`user_no`      INT NOT NULL							COMMENT '사용자고유번호',
	`user_pw`      VARCHAR(255) NOT NULL				COMMENT 'ID비밀번호해시',
	`user_pin`     VARCHAR(255) NULL					   COMMENT '간편비밀번호해시',
	`user_recent`  DATETIME NOT NULL DEFAULT NOW()  COMMENT '최종로그인일시',
	CONSTRAINT PRIMARY KEY (ID),
	CONSTRAINT fk_login_user_no FOREIGN KEY (user_no) REFERENCES `users`(`user_no`)
);

-- admins
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

-- admin_credentials
CREATE TABLE admin_credentials (
    admin_no INT NOT NULL,
    password VARCHAR(255) NOT NULL,
    pw_changed_at DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (admin_no),
    FOREIGN KEY (admin_no) REFERENCES admins(admin_no) 
        ON DELETE CASCADE
);

-- admin_notification
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

-- admin_modification_log
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

-- dashboard
CREATE TABLE dashboard (
    dash_no INT NOT NULL AUTO_INCREMENT,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    total_user_count INT NOT NULL CHECK (total_user_count >= 0),
    register_count INT NOT NULL CHECK (register_count >= 0),
    login_count INT NOT NULL CHECK (login_count >= 0),
    PRIMARY KEY (dash_no)
);











