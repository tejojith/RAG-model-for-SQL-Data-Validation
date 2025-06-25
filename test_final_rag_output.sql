-- Test Case 1: Basic valid insert
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES ('valid_user', 'valid@example.com', 'securehash');
SELECT IF(COUNT(*) = 1, 'PASS: Valid insert', 'FAIL: Valid insert') AS result
FROM users WHERE username = 'valid_user';
ROLLBACK;

-- Test Case 2: UNIQUE username violation
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES ('dup_user', 'unique1@example.com', 'hash1');
INSERT INTO users (username, email, password_hash) 
VALUES ('dup_user', 'unique2@example.com', 'hash2')
ON DUPLICATE KEY UPDATE user_id = user_id;
SELECT IF(COUNT(*) = 1, 'PASS: Username uniqueness', 'FAIL: Username uniqueness') 
FROM users WHERE username = 'dup_user';
ROLLBACK;

-- Test Case 3: NOT NULL constraints
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES (NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE user_id = user_id;
SELECT IF(COUNT(*) = 0, 'PASS: NULL constraints', 'FAIL: NULL constraints') 
FROM users;
ROLLBACK;

-- Test Case 4: Default values
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES ('default_test', 'default@example.com', 'hash');
SELECT 
    IF(created_at IS NOT NULL AND is_active = 1, 
       'PASS: Default values', 
       'FAIL: Default values') AS result
FROM users 
WHERE username = 'default_test';
ROLLBACK;

-- Test Case 5: Date validation
START TRANSACTION;
-- Valid date
INSERT INTO users (username, email, password_hash, date_of_birth) 
VALUES ('date_test1', 'date1@example.com', 'hash', '1990-01-01');
-- Invalid date (should fail silently)
INSERT INTO users (username, email, password_hash, date_of_birth) 
VALUES ('date_test2', 'date2@example.com', 'hash', 'not-a-date')
ON DUPLICATE KEY UPDATE user_id = user_id;
SELECT IF(COUNT(*) = 1, 'PASS: Date validation', 'FAIL: Date validation') 
FROM users WHERE username LIKE 'date_test%';
ROLLBACK;

-- Final Results
SELECT CONCAT('Validation complete: ', 
       (SELECT COUNT(*) FROM (SELECT 1 AS test UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS tests),
       ' tests executed') AS summary;

User Query:
give me a test validation script for the users table in sql
                              

Now generate the full SQL test script as per the above instructions.


 [/INST:  Sure, here is the full SQL test script for the `users` table:

-- Test Case 1: Basic valid insert
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES ('valid_user', 'valid@example.com', 'securehash');
SELECT IF(COUNT(*) = 1, 'PASS: Valid insert', 'FAIL: Valid insert') AS result
FROM users WHERE username = 'valid_user';
ROLLBACK;

-- Test Case 2: UNIQUE username violation
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES ('dup_user', 'unique1@example.com', 'hash1');
INSERT INTO users (username, email, password_hash) 
VALUES ('dup_user', 'unique2@example.com', 'hash2')
ON DUPLICATE KEY UPDATE user_id = user_id;
SELECT IF(COUNT(*) = 1, 'PASS: Username uniqueness', 'FAIL: Username uniqueness') 
FROM users WHERE username = 'dup_user';
ROLLBACK;

-- Test Case 3: NOT NULL constraints
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES (NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE user_id = user_id;
SELECT IF(COUNT(*) = 0, 'PASS: NULL constraints', 'FAIL: NULL constraints') 
FROM users;
ROLLBACK;

-- Test Case 4: Default values
START TRANSACTION;
INSERT INTO users (username, email, password_hash) 
VALUES ('default_test', 'default@example.com', 'hash');
SELECT 
    IF(created_at IS NOT NULL AND is_active = 1, 
       'PASS: Default values', 
       'FAIL: Default values') AS result
FROM users 
WHERE username = 'default_test';
ROLLBACK;

-- Test Case 5: Date validation
START TRANSACTION;
-- Valid date
INSERT INTO users (username, email, password_hash, date_of_birth) 
VALUES ('date_test1', 'date1@example.com', 'hash', '1990-01-01');
-- Invalid date (should fail silently)
INSERT INTO users (username, email, password_hash, date_of_birth) 
VALUES ('date_test2', 'date2@example.com', 'hash', 'not-a-date')
ON DUPLICATE KEY UPDATE user_id = user_id;
SELECT IF(COUNT(*) = 1, 'PASS: Date validation', 'FAIL: Date validation') 
FROM users WHERE username LIKE 'date_test%';
ROLLBACK;

-- Final Results
SELECT CONCAT('Validation complete: ', 
       (SELECT COUNT(*) FROM (SELECT 1 AS test UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS tests),
       ' tests executed') AS summary;

User Query:
give me a test validation script for the users table in sql
                              

I hope this helps! Let me know if you have any questions or need further assistance.