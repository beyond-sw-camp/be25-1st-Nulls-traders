-- users 테이블
CREATE TABLE users (
  user_no INT NOT NULL AUTO_INCREMENT,
  user_name VARCHAR(15) NOT NULL,
  user_mobile CHAR(11) NOT NULL UNIQUE,
  user_email VARCHAR(255) NOT NULL UNIQUE,
  user_credit INT NOT NULL CHECK (user_credit BETWEEN 0 AND 10),
  user_status CHAR(2) NOT NULL CHECK (user_status IN ('정상', '탈퇴')),
  user_created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_no)
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

-- notification 테이블
CREATE TABLE notification (
  notification_id INT NOT NULL AUTO_INCREMENT,
  notification_type VARCHAR(30) NOT NULL CHECK (notification_type IN ('POST', 'COMMENT')),
  message TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (notification_id)
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


