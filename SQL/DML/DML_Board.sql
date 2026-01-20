INSERT INTO posts (user_no, title, content, is_admin_post, post_like, post_dislike) 
VALUES 
(1, '시스템 점검  안내', '1시 ~ 3시 점검 시간입니다..', 'admin', 3, 0),
(2, '삼성전자 전망', '향후 주가 어떻게 보시나요?', 'user', 4, 0);


INSERT INTO comments (post_id, user_no, content, comment_like, comment_dislike) 
VALUES 
(1, 3, '장기적으로는 긍정적으로 봅니다.', 2, 0), 
(2, 4, '저는 아직 관망 중이에요.', 1, 0);


-- notification
INSERT INTO notification (notification_type, message)
VALUES
('POST', '새 게시글이 등록되었습니다.'),
('COMMENT', '게시글에 새 댓글이 달렸습니다.');

-- user_notification 
INSERT INTO user_notification (notification_id, user_no, is_read, read_at) 
VALUES 
(1, 1, FALSE, NULL),
(2, 2, TRUE, NOW());


-- 게시글 수정 (제목 + 내용) 
UPDATE posts 
SET title = '삼성전자 전망 (업데이트)', 
	 content = '주가 동향 알고 싶습니다.', 
	 updated_at = CURRENT_TIMESTAMP 
WHERE post_id = 2;

SELECT title,
		 content,
		 updated_at
FROM posts
WHERE post_id = 2;

SELECT *
FROM posts;

-- 게시글 좋아요 증가 및 게시글 삭제 확인 조회
UPDATE posts
SET
  post_like = CASE
    WHEN post_id = 1 THEN post_like + 1
    ELSE post_like
  END,
  post_del = CASE
    WHEN post_id = 2 THEN 1
    ELSE post_del
  END
WHERE post_id IN (1, 2);

SELECT p.title,
		 p.post_like,
		 p.post_del
FROM posts p;


-- 댓글 내용 수정 
UPDATE comments 
SET content = '답변 감사합니다.', 
updated_at = CURRENT_TIMESTAMP 
WHERE comment_id = 2;

SELECT u.user_name,
		 c.content,
		 c.updated_at
FROM comments c
INNER JOIN users u ON u.user_no = c.user_no
WHERE comment_id = 2;


-- 댓글 좋아요 증가 및 댓글 삭제
UPDATE comments
SET
  comment_like = CASE
    WHEN comment_id = 1 THEN comment_like + 1
    ELSE comment_like
  END,
  comment_del = CASE
    WHEN comment_id = 2 THEN 1
    ELSE comment_del
  END
WHERE comment_id IN (1, 2);

SELECT u.user_name,
		 comment_id,
  		 comment_like,
  		 comment_del
FROM comments c
INNER JOIN users u ON u.user_no = c.user_no;



-- 특정 알림 읽음 처리 
UPDATE user_notification 
SET is_read = TRUE, 
	 read_at = NOW() 
WHERE user_no = 1 AND notification_id = 1;

-- 조회
SELECT u.user_name,
		 un.is_read,
		 un.read_at
FROM user_notification un
INNER JOIN users u ON u.user_no = un.user_no
WHERE un.user_no = 1 AND un.notification_id = 1;











