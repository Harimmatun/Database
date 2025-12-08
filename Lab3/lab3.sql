-- ==========================================
-- SELECT
-- ==========================================

SELECT * FROM products;

SELECT product_id, name, price 
FROM products 
WHERE price > 1000;

SELECT * FROM products 
WHERE brand_id = 1;

SELECT first_name, last_name, email 
FROM customers;

SELECT * FROM orders 
WHERE status != 'Completed' AND total_amount > 500;


-- ==========================================
-- INSERT
-- ==========================================

INSERT INTO customers (first_name, last_name, email, password_hash, phone) 
VALUES ('Oleh', 'Petrenko', 'oleh.new@email.com', 'secure_pass_99', '+380991112233');

INSERT INTO addresses (customer_id, street, city, postal_code, country)
VALUES (5, 'Kharkivska St, 10', 'Kyiv', '02000', 'Ukraine');

INSERT INTO orders (customer_id, shipping_address_id, status, total_amount)
VALUES (5, 6, 'Pending', 2400.00);

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase)
VALUES (5, 1, 2, 1200.00);


-- ==========================================
-- UPDATE
-- ==========================================

UPDATE products
SET price = 1150.00
WHERE product_id = 3;

UPDATE orders
SET status = 'Shipped'
WHERE order_id = 5;

UPDATE products
SET stock_quantity = stock_quantity - 2
WHERE product_id = 1;


-- ==========================================
-- DELETE
-- ==========================================

INSERT INTO reviews (customer_id, product_id, rating, comment) 
VALUES (1, 3, 1, 'Terrible!');

DELETE FROM reviews
WHERE rating = 1;

DELETE FROM addresses
WHERE street = 'Kharkivska St, 10';