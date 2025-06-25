
-- Drop table if exists
DROP TABLE IF EXISTS users;

-- Recreate table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Valid insert
INSERT INTO users (username, email, password_hash) 
VALUES ('alice', 'alice@example.com', 'hash123');

-- Attempt to insert duplicate username
INSERT INTO users (username, email, password_hash) 
VALUES ('alice', 'bob@example.com', 'hash456');

-- Attempt to insert NULL value for non-nullable field
INSERT INTO users (username, email, password_hash) 
VALUES ('charlie', NULL, 'hash789');

-- Verify inserted data
SELECT * FROM users;

-- Check default values
SELECT created_at, is_active FROM users WHERE user_id = 1;

-- Confirm failed insertions didn't corrupt state
SELECT * FROM users;
