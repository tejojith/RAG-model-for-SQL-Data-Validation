CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(255) CHECK (REGEXP_LIKE(Username, '^[A-Za-z0-9_\-]+$')),
    Password VARCHAR(255) CHECK (REGEXP_LIKE(Password, '^(?=.*[0-9])(?=.*[!@#$%^&*()+=]).{8,}$')),
    Email VARCHAR(255) NOT NULL,
    -- Add email validation logic here, for example: CHECK (REGEXP_LIKE(Email, '^.+@[a-zA-Z0-9.-]+.[a-zA-Z]+$'))
    IS_EMAIL_VERIFIED BOOLEAN DEFAULT FALSE
);