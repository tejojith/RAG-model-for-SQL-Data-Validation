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

-- Attempt to insert duplicate email
INSERT INTO users (username, email, password_hash) 
VALUES ('charlie', 'alice@example.com', 'hash789');

-- Attempt to insert missing field
INSERT INTO users (email, password_hash) 
VALUES ('david@example.com', 'hash123');

-- Attempt to insert NULL value for NOT NULL field
INSERT INTO users (username, email, password_hash) 
VALUES (NULL, 'eve@example.com', 'hash456');

-- Test default values
INSERT INTO users (username, email, password_hash) 
VALUES ('frank', 'frank@example.com', NULL);

SELECT * FROM users;