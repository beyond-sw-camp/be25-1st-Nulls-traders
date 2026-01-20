-- 사용자의 질문 입력 (챗봇)
INSERT INTO `Chatbot` (`Message`, `Role`, `user_id`) 
VALUES ('현재 내 삼성전자 주식 비중이 적절한지 분석해줘.', 'User', 'user_01');

-- 챗봇의 답변 입력 (위 질문에 대한 응답, Conversation_id는 자동 생성됨)
INSERT INTO `Chatbot` (`Message`, `Role`, `user_id`) 
VALUES ('네, 포트폴리오를 분석한 결과 리스크 점수는 75점입니다.', 'Bot', 'user_01');

-- 새로운 뉴스 기사 추가 (뉴스)
INSERT INTO `News` (`Title`, `Content`, `Publisher`, `URL`, `Published_at`, `Hash`, `stock_code`)
VALUES (
    '삼성전자, 차세대 반도체 공정 발표', 
    '삼성전자가 오늘 새로운 2나노 공정 로드맵을 발표했습니다...', 
    '경제일보', 
    'https://news.example.com/samsung/123', 
    '2026-01-19', 
    'a1b2c3d4e5f6g7h8i9j0', 
    '005930'
);

-- 특정 뉴스(News_id=1)에 대한 요약 결과 저장 (뉴스 요약)
INSERT INTO `news_summary` (`news_summary_id`, `Converstaion_id`, `News_id`, `summary`, `sentiment`, `news_url`)
VALUES (
    1, 
    1, -- Chatbot 테이블의 Conversation_id 참조
    1, -- News 테이블의 News_id 참조
    '삼성전자가 차세대 반도체 시장 주도권을 위해 2나노 공정 계획을 구체화함.', 
    'POSITIVE', 
    'https://news.example.com/samsung/123'
);

-- 사용자 포트폴리오 분석 결과 저장 (포트폴리오 저장)
INSERT INTO `portfolio_analysis` (`portfolio_id`, `user_id`, `risk_score`, `diversification_score`, `analysis_result`, `Converstaion_id`)
VALUES (
    1, 
    'user_01', 
    75, 
    40, 
    '현재 IT 섹터 비중이 너무 높습니다. 채권이나 배당주로 분산 투자가 필요합니다.', 
    2 -- Chatbot 테이블의 Conversation_id 참조
);

-- 삼성전자(005930)에 대한 종합 요약 정보 저장 (요약)
INSERT INTO `Stock_Summary` (`Summary`, `Converstaion_id`, `stock_code`)
VALUES (
    '최근 반도체 업황 개선 기대감과 외국인 매수세가 유입되며 긍정적인 전망이 우세합니다.', 
    3, 
    '005930'
);

-- FR-STOCK-003 요약 업데이트.
UPDATE Stock_Summary 
SET Summary = '업종 평균 대비 저평가 상태로 전환되었습니다.' 
WHERE stock_code = '005930';
