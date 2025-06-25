
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

-- Valid insert
INSERT INTO users (username, email, password_hash) 
VALUES ('alice', 'alice@example.com', 'hash123');

-- Duplicate username (should fail)
INSERT INTO users (username, email, password_hash) 
VALUES ('alice', 'another@example.com', 'hash456');

-- NULL in NOT NULL field (should fail)
INSERT INTO users (username, email) 
VALUES (NULL, NULL);

-- Insert with defaults
INSERT INTO users (username, email, password_hash) 
VALUES ('bob', 'bob@example.com', 'hash789');

-- Check table
SELECT * FROM users;

