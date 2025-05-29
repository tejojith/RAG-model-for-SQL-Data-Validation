{'query': 'give me the validation schema for users table and it should be in sql format', 'result': " ALTER TABLE users\n   ADD CONSTRAINT pk_user PRIMARY KEY (id),\n   ADD CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}$'),\n   ADD CONSTRAINT chk_username_length CHECK (LENGTH(username) BETWEEN 5 AND 50),\n   ADD CONSTRAINT chk_password_length CHECK (LENGTH(password_hash) >= 8),\n   ADD CONSTRAINT chk_dob_reasonable CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR));", 'source_documents': [Document(metadata={'source': 'schemas\\validations.txt'}, page_content="# Database Schema with Validations\n\nRule 1: All tables must define a PRIMARY KEY and it must be mentioned explicitaly.\nRule 2: Columns must have consistent data types.\nRule 3: Use of UNIQUE is not a replacement for PRIMARY KEY.\nRule 4: Foreign keys must reference valid primary keys.\n\n## 1. Users Table\n\nALTER TABLE users\nADD CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}$'),\nADD CONSTRAINT chk_username_length CHECK (LENGTH(username) BETWEEN 5 AND 50),\nADD CONSTRAINT chk_password_length CHECK (LENGTH(password_hash) >= 8),\nADD CONSTRAINT chk_dob_reasonable CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR));\n\n## 2. Addresses Table\n\nALTER TABLE addresses\nADD CONSTRAINT chk_postal_code_format CHECK (\n    (country = 'US' AND postal_code REGEXP '^[0-9]{5}(-[0-9]{4})?$') OR\n    (country = 'CA' AND postal_code REGEXP '^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$') OR\n    (country NOT IN ('US', 'CA'))\n);\n\n## 3. Products Table"), Document(metadata={'source': 'schemas\\validations.txt'}, page_content="# Database Schema with Validations\n\nRule 1: All tables must define a PRIMARY KEY and it must be mentioned explicitaly.\nRule 2: Columns must have consistent data types.\nRule 3: Use of UNIQUE is not a replacement for PRIMARY KEY.\nRule 4: Foreign keys must reference valid primary keys.\n\n## 1. Users Table\n\nALTER TABLE users\nADD CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}$'),\nADD CONSTRAINT chk_username_length CHECK (LENGTH(username) BETWEEN 5 AND 50),\nADD CONSTRAINT chk_password_length CHECK (LENGTH(password_hash) >= 8),\nADD CONSTRAINT chk_dob_reasonable CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR));\n\n## 2. Addresses Table\n\nALTER TABLE addresses\nADD CONSTRAINT chk_postal_code_format CHECK (\n    (country = 'US' AND postal_code REGEXP '^[0-9]{5}(-[0-9]{4})?$') OR\n    (country = 'CA' AND postal_code REGEXP '^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$') OR\n    (country NOT IN ('US', 'CA'))\n);\n\n## 3. Products Table"), Document(metadata={'source': 'schemas\\validations.txt'}, page_content="# Database Schema with Validations\n\nRule 1: All tables must define a PRIMARY KEY and it must be mentioned explicitaly.\nRule 2: Columns must have consistent data types.\nRule 3: Use of UNIQUE is not a replacement for PRIMARY KEY.\nRule 4: Foreign keys must reference valid primary keys.\n\n## 1. Users Table\n\nALTER TABLE users\nADD CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}$'),\nADD CONSTRAINT chk_username_length CHECK (LENGTH(username) BETWEEN 5 AND 50),\nADD CONSTRAINT chk_password_length CHECK (LENGTH(password_hash) >= 8),\nADD CONSTRAINT chk_dob_reasonable CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR));\n\n## 2. Addresses Table\n\nALTER TABLE addresses\nADD CONSTRAINT chk_postal_code_format CHECK (\n    (country = 'US' AND postal_code REGEXP '^[0-9]{5}(-[0-9]{4})?$') OR\n    (country = 'CA' AND postal_code REGEXP '^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$') OR\n    (country NOT IN ('US', 'CA'))\n);\n\n## 3. Products Table"), Document(metadata={'source': 'schemas\\validations.txt'}, page_content="# Database Schema with Validations\n\nRule 1: All tables must define a PRIMARY KEY and it must be mentioned explicitaly.\nRule 2: Columns must have consistent data types.\nRule 3: Use of UNIQUE is not a replacement for PRIMARY KEY.\nRule 4: Foreign keys must reference valid primary keys.\n\n## 1. Users Table\n\nALTER TABLE users\nADD CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,4}$'),\nADD CONSTRAINT chk_username_length CHECK (LENGTH(username) BETWEEN 5 AND 50),\nADD CONSTRAINT chk_password_length CHECK (LENGTH(password_hash) >= 8),\nADD CONSTRAINT chk_dob_reasonable CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR));\n\n## 2. Addresses Table\n\nALTER TABLE addresses\nADD CONSTRAINT chk_postal_code_format CHECK (\n    (country = 'US' AND postal_code REGEXP '^[0-9]{5}(-[0-9]{4})?$') OR\n    (country = 'CA' AND postal_code REGEXP '^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$') OR\n    (country NOT IN ('US', 'CA'))\n);\n\n## 3. Products Table")]}
----------------------------------------
 CREATE TABLE users (
      id INT PRIMARY KEY,
      email VARCHAR(255) CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
      username VARCHAR(50) CHECK (LENGTH(username) BETWEEN 5 AND 50),
      password_hash VARCHAR(255) CHECK (LENGTH(password_hash) >= 8),
      date_of_birth DATE CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR))
   );
----------------------------------------
 CREATE TABLE users (
       user_id INT PRIMARY KEY,
       email VARCHAR(255) CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
       username VARCHAR(50) CHECK (LENGTH(username) BETWEEN 5 AND 50),
       password_hash VARCHAR(128) CHECK (LENGTH(password_hash) >= 8),
       date_of_birth DATE CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR))
   );
----------------------------------------
 ALTER TABLE users
   ADD CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
   ADD CONSTRAINT chk_username_length CHECK (LENGTH(username) BETWEEN 5 AND 50),
   ADD CONSTRAINT chk_password_length CHECK (LENGTH(password_hash) >= 8),
   ADD CONSTRAINT chk_dob_reasonable CHECK (date_of_birth < DATE_SUB(CURRENT_DATE, INTERVAL 13 YEAR));
----------------------------------------
 CREATE TABLE `users` (
       `user_id` INT PRIMARY KEY AUTO_INCREMENT,
       `username` VARCHAR(50) UNIQUE NOT NULL REGEX '^[a-zA-Z0-9_\-]+$',
       `email` VARCHAR(100) UNIQUE NOT NULL REGEX '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$',
       `password_hash` VARCHAR(255) NOT NULL,
       `first_name` VARCHAR(50),
       `last_name` VARCHAR(50),
       `date_of_birth` DATE,
       `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       `last_login` TIMESTAMP,
       `is_active` BOOLEAN DEFAULT TRUE,
       CHECK (DATE_FORMAT(`date_of_birth`, '%Y-%m-%d') <= NOW())
   );
----------------------------------------
 ```sql
-- Test Case Validation SQL Schema for Users Table

-- Rule 1: All tables must define a PRIMARY KEY and it must be mentioned explicitly. (Valid)

-- Rule 2: Columns must have consistent data types. (Valid, except date_of_birth and last_login are of different type)

-- Rule 3: Use of UNIQUE is not a replacement for PRIMARY KEY. (Valid, only used on username and email)

-- Rule 4: Foreign keys must reference valid primary keys. (N/A, no foreign keys in this table)

-- Additional Application-Level Validations

-- Username: alphanumeric with optional underscores/hyphens (no spaces). (Valid, except for data constraints)
CREATE TABLE users_test (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    username_check CHECK (REGEXP_LIKE(username, '^[a-zA-Z0-9_\-]+$')), -- Validates alphanumeric with optional underscores/hyphens
    -- Other columns omitted for brevity
);

-- Password: minimum 8 chars, require at least 1 number and 1 special character. (N/A, no password field in this table)

-- Email verification via confirmation email. (N/A, not applicable to schema validation)

ALTER TABLE users ADD CONSTRAINT email_unique UNIQUE (email); -- To enforce unique emails

-- Address Management:
   - Validate address components against known lists. (Not applicable to schema validation)
   - Only one default address per user. (Not applicable to schema validation)

-- Product Management:
   - Product name must be unique (case-insensitive). (Not applicable to this table, no product fields exist)
   - Description minimum 20 characters. (Not applicable to this table, no description field exists)

-- Order Processing:
   - Status transitions must follow business rules. (Not applicable to schema validation)
   - Order date cannot be in the future. (Not applicable to schema validation as no order-related fields exist)
```
----------------------------------------
 ```sql
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(255) CHECK (REGEXP_LIKE(Username, '^[A-Za-z0-9_\-]+$')),
    Password VARCHAR(255) CHECK (REGEXP_LIKE(Password, '^.{8,}.*[0-9].*[!@#$%^&*.]')),
    Email VARCHAR(255) UNIQUE,
    EmailVerified BOOLEAN DEFAULT FALSE
);

ALTER TABLE Users ADD CONSTRAINT FK_Email FOREIGN KEY (Email) REFERENCES EmailConfirmations(Email);
```

The above schema follows the rules defined in the context. The `Users` table has a primary key `UserID`. The `Username`, `Password`, and `Email` columns have their respective data types and application-level validations. For example, the username accepts alphanumeric characters with optional underscores or hyphens (no spaces) while the password requires at least 8 characters, including one number and one special character.

The `Email` column is unique but does not serve as a primary key. Instead, it references the `EmailConfirmations` table using a foreign key constraint. The schema also includes an additional column for email verification.
----------------------------------------
