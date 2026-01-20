
-- users, stocks, stock_price 선행

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
