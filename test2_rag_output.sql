-- Drop table if exists
DROP TABLE IF EXISTS users;

-- Recreate table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Start transaction
START TRANSACTION;

-- Insert valid data
INSERT INTO users (username, email, password_hash) 
VALUES ('alice', 'alice@example.com', 'hash123');

-- Test UNIQUE constraints
INSERT INTO users (username, email, password_hash) 
VALUES ('bob', 'bob@example.com', 'hash456'); -- should fail

INSERT INTO users (username, email, password_hash) 
VALUES ('charlie', 'charlie@example.com', 'hash789');

-- Test NOT NULL constraints
INSERT INTO users (username, email) 
VALUES (NULL, NULL); -- should fail

INSERT INTO users (username, email, password_hash) 
VALUES ('david', 'david@example.com', 'hash123');

-- Verify default values
INSERT INTO users (username, email, password_hash) 
VALUES ('eve', 'eve@example.com', NULL);

SELECT * FROM users;

-- Rollback transaction
ROLLBACK;