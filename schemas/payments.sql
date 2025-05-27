CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    transaction_id INT(100),
    status ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);