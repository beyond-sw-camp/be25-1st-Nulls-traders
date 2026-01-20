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

