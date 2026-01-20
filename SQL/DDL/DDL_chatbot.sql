CREATE TABLE `Chatbot` (
	`Converstaion_id`	INT	NOT NULL	DEFAULT AUTO_INCREMENT,
	`Message`	TEXT	NOT NULL,
	`Role`	ENUM(User,Bot)	NOT NULL,
	`user_id`	VARCHAR(10)	NOT NULL
);

CREATE TABLE `portfolio_analysis` (
	`portfolio_id`	INT	NOT NULL,
	`user_id`	VARCHAR(10)	NOT NULL,
	`risk_score`	INT	NOT NULL,
	`diversification_score`	INT	NOT NULL,
	`analysis_result`	TEXT	NOT NULL,
	`Converstaion_id`	INT	NOT NULL	DEFAULT AUTO_INCREMENT
);

CREATE TABLE `News` (
	`News_id`	INT	NOT NULL	DEFAULT AUTO_INCREMENT,
	`Title`	VARCHAR(100)	NOT NULL,
	`Content`	TEXT	NOT NULL,
	`Publisher`	VARCHAR(20)	NOT NULL,
	`URL`	TEXT	NOT NULL,
	`Published_at`	DATE	NOT NULL	DEFAULT CURDATE,
	`Hash`	VARCHAR(64)	NOT NULL,
	`stock_code`	VARCHAR(10)	NOT NULL	COMMENT '종목 코드'
);

CREATE TABLE `news_summary` (
	`news_summary_id`	INT	NOT NULL,
	`Converstaion_id`	INT	NOT NULL	DEFAULT AUTO_INCREMENT,
	`News_id`	INT	NOT NULL	DEFAULT AUTO_INCREMENT,
	`summary`	TEXT	NOT NULL,
	`sentiment`	ENUM('POSITIVE', 'NEUTRAL', 'NEGATIVE')	NOT NULL,
	`news_url`	TEXT	NOT NULL
);

CREATE TABLE `Stock_Summary` (
	`Stock_summary_id`	INT	NOT NULL	DEFAULT AUTO_INCREMENT,
	`Summary`	TEXT	NOT NULL,
	`Converstaion_id`	INT	NOT NULL	DEFAULT AUTO_INCREMENT,
	`stock_code`	VARCHAR(10)	NOT NULL	COMMENT '종목 코드'
);

ALTER TABLE `Chatbot` ADD CONSTRAINT `PK_CHATBOT` PRIMARY KEY (
	`Converstaion_id`
);

ALTER TABLE `portfolio_analysis` ADD CONSTRAINT `PK_PORTFOLIO_ANALYSIS` PRIMARY KEY (
	`portfolio_id`
);

ALTER TABLE `News` ADD CONSTRAINT `PK_NEWS` PRIMARY KEY (
	`News_id`
);

ALTER TABLE `news_summary` ADD CONSTRAINT `PK_NEWS_SUMMARY` PRIMARY KEY (
	`news_summary_id`
);

ALTER TABLE `Stock_Summary` ADD CONSTRAINT `PK_STOCK_SUMMARY` PRIMARY KEY (
	`Stock_summary_id`
);