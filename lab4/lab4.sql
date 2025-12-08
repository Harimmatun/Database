-- ЧАСТИНА 1: АГРЕГАЦІЯ ТА ГРУПУВАННЯ

SELECT 
    COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM products;

SELECT 
    c.name AS category_name,
    COUNT(p.product_id) AS product_count
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.name;


SELECT 
    b.name AS brand_name,
    SUM(p.price * p.stock_quantity) AS total_stock_value
FROM brands b
JOIN products p ON b.brand_id = p.brand_id
GROUP BY b.name
ORDER BY total_stock_value DESC;


SELECT 
    customer_id,
    COUNT(order_id) AS orders_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;


-- ЧАСТИНА 2: ОБ'ЄДНАННЯ ТАБЛИЦЬ (JOINs) (3+ типи)

SELECT 
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;


SELECT 
    c.first_name,
    c.last_name,
    o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id;


SELECT 
    c.last_name AS customer,
    cat.name AS category_promo
FROM customers c
CROSS JOIN categories cat;

-- ЧАСТИНА 3: ПІДЗАПИТИ (SUBQUERIES) (3+ запити)

SELECT product_id, name, price
FROM products
WHERE price > (
    SELECT AVG(total_amount) FROM orders
);


SELECT 
    name AS brand_name,
    (SELECT COUNT(*) FROM products p WHERE p.brand_id = b.brand_id) AS products_count
FROM brands b;

SELECT first_name, last_name, email
FROM customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN brands b ON p.brand_id = b.brand_id
    WHERE b.name = 'Apple'
);


-- ЧАСТИНА 4: КОМПЛЕКСНА АНАЛІТИКА (MULTI-TABLE AGGREGATION)


SELECT 
    p.name AS product_name,
    SUM(oi.quantity) AS total_sold_quantity,
    SUM(oi.quantity * oi.price_at_purchase) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY total_revenue DESC;

SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;