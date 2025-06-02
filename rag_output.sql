CREATE TABLE IF NOT EXISTS `users` (
      `user_id` INT PRIMARY KEY AUTO_INCREMENT,
      `username` VARCHAR(50) UNIQUE NOT NULL,
      `email` VARCHAR(100) UNIQUE NOT NULL,
      `password_hash` VARCHAR(255) NOT NULL,
      `first_name` VARCHAR(50),
      `last_name` VARCHAR(50),
      `date_of_birth` DATE,
      `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      `last_login` TIMESTAMP NULL DEFAULT NULL,
      `is_active` BOOLEAN DEFAULT TRUE,
      CONSTRAINT `chk_username_format` CHECK (`username` REGEXP '^[a-zA-Z0-9_-]{3,50}$'),
      CONSTRAINT `chk_email_format` CHECK (`email` REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'),
      CONSTRAINT `chk_password_complexity` CHECK (`password_hash` REGEXP '[A-Z]' AND `password_hash` REGEXP '[a-z]' AND `password_hash` REGEXP '[0-9]' AND `password_hash` REGEXP '[^a-zA-Z0-9]' AND LENGTH(`password_hash`) >= 8),
      CONSTRAINT `chk_dob_reasonable` CHECK (`date_of_birth` IS NULL OR (`date_of_birth` <= CURDATE() AND `date_of_birth` >= DATE_SUB(CURDATE(), INTERVAL 120 YEAR)))
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;