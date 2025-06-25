
-- Test Case 1: Drop Table Safety
START TRANSACTION;
DROP TABLE IF EXISTS products;
ROLLBACK;

-- Test Case 2: Recreate Table
START TRANSACTION;
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);
ROLLBACK;

-- Test Case 3: Insert Valid Data
START TRANSACTION;
INSERT INTO products (name, description, price, stock_quantity) VALUES ('Product 1', 'Description for product 1', 10.99, 5);
SELECT * FROM products WHERE name = 'Product 1';
ROLLBACK;

-- Test Case 4: Test UNIQUE Constraints
START TRANSACTION;
INSERT INTO products (name, description, price, stock_quantity) VALUES ('Product 2', 'Description for product 2', 10.99, 5);
SELECT * FROM products WHERE name = 'Product 2';
ROLLBACK;

-- Test Case 5: Test NOT NULL Constraints
START TRANSACTION;
INSERT INTO products (name, description, price) VALUES ('Product 3', NULL, NULL);
SELECT * FROM products WHERE name = 'Product 3';
ROLLBACK;

-- Test Case 6: Test Default Values
START TRANSACTION;
INSERT INTO products (name, description, price) VALUES ('Product 4', NULL, NULL);
SELECT * FROM products WHERE name = 'Product 4';
ROLLBACK;

-- Test Case 7: Verify Contents
START TRANSACTION;
SELECT * FROM products;
ROLLBACK;

-- Test Case 8: Final Table Check
START TRANSACTION;
SELECT * FROM products;
ROLLBACK;
----------------------------------------
