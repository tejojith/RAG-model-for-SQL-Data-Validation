-- Drop tables if they exist
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS product_images;

-- Recreate tables exactly as provided
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

CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE product_images (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(100),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert valid row with values for all NOT NULL fields
INSERT INTO products (name, price, stock_quantity, category_id) VALUES ('Product A', 19.99, 5, 1);

-- Attempt to insert a row that violates any UNIQUE constraint (e.g., same username or email)
INSERT INTO products (name, price, stock_quantity, category_id) VALUES ('Product A', 19.99, 5, 1); -- duplicate name

-- Attempt to insert a row that violates any NOT NULL constraint (by omitting a NOT NULL field or inserting NULL)
INSERT INTO products (price, stock_quantity, category_id) VALUES (NULL, NULL, NULL); -- missing name
INSERT INTO reviews (user_id, product_id, rating, comment) VALUES (1, 1, NULL, 'Bad review'); -- missing rating
INSERT INTO product_images (product_id, image_url) VALUES (1, NULL); -- missing alt_text

-- Insert a second valid row with minimal fields (if defaults are present)
INSERT INTO reviews (user_id, product_id, comment) VALUES (2, 1, 'Good review');

-- Verify default values
SELECT * FROM products WHERE name = 'Product A'; -- check created_at and updated_at timestamps
SELECT * FROM reviews WHERE user_id = 2; -- check review_date timestamp

-- SELECT all rows to show the current state of the table
SELECT * FROM products;
SELECT * FROM reviews;
SELECT * FROM product_images;