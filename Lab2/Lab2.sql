CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, 
    phone VARCHAR(20)
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    street VARCHAR(150) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL REFERENCES categories(category_id),
    brand_id INTEGER NOT NULL REFERENCES brands(brand_id),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0), 
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0) 
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    shipping_address_id INTEGER NOT NULL REFERENCES addresses(address_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    total_amount NUMERIC(10, 2) NOT NULL DEFAULT 0.00 CHECK (total_amount >= 0)
);

CREATE TABLE order_items (
    order_id INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0), 
    price_at_purchase NUMERIC(10, 2) NOT NULL CHECK (price_at_purchase >= 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5), 
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (first_name, last_name, email, password_hash, phone) VALUES
('Олександр', 'Коваль', 'alex.koval@email.com', 'h@sh1', '+380501234567'),
('Марія', 'Шевченко', 'maria.sheva@email.com', 'h@sh2', '+380671234567'),
('Дмитро', 'Бондаренко', 'dmytro.bond@email.com', 'h@sh3', '+380931234567'),
('Анна', 'Мельник', 'anna.melnyk@email.com', 'h@sh4', NULL);

INSERT INTO addresses (customer_id, street, city, postal_code, country) VALUES
(1, 'вул. Хрещатик, 10', 'Київ', '01001', 'Україна'),
(1, 'вул. Лесі Українки, 5', 'Львів', '79000', 'Україна'), 
(2, 'пр. Свободи, 15', 'Львів', '79007', 'Україна'),
(3, 'вул. Дерибасівська, 1', 'Одеса', '65000', 'Україна'),
(4, 'вул. Сумська, 20', 'Харків', '61000', 'Україна');

INSERT INTO categories (name) VALUES
('Ноутбуки'),
('Смартфони'),
('Аксесуари'),
('Планшети');

INSERT INTO brands (name) VALUES
('Apple'),
('Samsung'),
('Asus'),
('Dell'),
('Logitech');

INSERT INTO products (category_id, brand_id, name, description, price, stock_quantity) VALUES
(1, 1, 'MacBook Air M2', 'Легкий та потужний ноутбук', 1200.00, 15),
(1, 3, 'Asus ROG Zephyrus', 'Ігровий ноутбук', 1800.00, 8),
(2, 1, 'iPhone 15 Pro', 'Смартфон з титановим корпусом', 1100.00, 30),
(2, 2, 'Samsung Galaxy S24', 'Смартфон з AI', 950.00, 25),
(3, 5, 'Logitech MX Master 3S', 'Професійна мишка', 99.99, 100);

INSERT INTO orders (customer_id, shipping_address_id, status, total_amount) VALUES
(1, 1, 'Completed', 1100.00),

(2, 3, 'Shipped', 1299.99),

(3, 4, 'Processing', 950.00),

(1, 2, 'Pending', 99.99);

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 3, 1, 1100.00);

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(2, 1, 1, 1200.00),
(2, 5, 1, 99.99);

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(3, 4, 1, 950.00);

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(4, 5, 1, 99.99);

INSERT INTO reviews (customer_id, product_id, rating, comment) VALUES
(1, 3, 5, 'Найкращий телефон, який у мене був!'),
(2, 1, 4, 'Хороший ноутбук, але гріється при навантаженні.'),
(2, 5, 5, 'Дуже зручна мишка для роботи.'),
(3, 4, 5, 'Samsung як завжди на висоті.');