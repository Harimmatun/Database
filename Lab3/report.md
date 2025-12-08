# Звіт з Лабораторної роботи №3
**Тема:** Маніпулювання даними SQL (OLTP)

---

## 1. Оператори SELECT (Отримання даних)

### 1.1. Базовий вибір усіх даних
**Завдання:** Використання `SELECT *` для перегляду всього каталогу товарів.
```sql
SELECT * FROM products;
```

### 1.2. Фільтрація за умовою (WHERE)
**Завдання:** Використання `WHERE` для пошуку товарів дорожче 1000 грн.
```sql
SELECT product_id, name, price 
FROM products 
WHERE price > 1000;
```

### 1.3. Вибірка конкретних стовпців
**Завдання:** Вибір лише необхідних полів (ім'я, email) з таблиці клієнтів.
```sql
SELECT first_name, last_name, email 
FROM customers;
```

### 1.4. Складна фільтрація (AND)
**Завдання:** Пошук активних замовлень (не завершених) із сумою більше 500 грн.
```sql
SELECT * FROM orders 
WHERE status != 'Completed' AND total_amount > 500;
```

---

## 2. Оператори INSERT (Вставка даних)

### 2.1. Додавання нового клієнта
**Завдання:** Реєстрація нового користувача в системі.
```sql
INSERT INTO customers (first_name, last_name, email, password_hash, phone) 
VALUES ('Oleh', 'Petrenko', 'oleh.new@email.com', 'secure_pass_99', '+380991112233');
```

### 2.2. Додавання адреси
**Завдання:** Прив'язка нової адреси до клієнта.
```sql
INSERT INTO addresses (customer_id, street, city, postal_code, country)
VALUES (5, 'Kharkivska St, 10', 'Kyiv', '02000', 'Ukraine');
```

### 2.3. Створення замовлення
**Завдання:** Створення нового запису в таблиці замовлень.
```sql
INSERT INTO orders (customer_id, shipping_address_id, status, total_amount)
VALUES (5, 6, 'Pending', 2400.00);
```

### 2.4. Додавання товарів у замовлення
**Завдання:** Наповнення замовлення конкретними товарами.
```sql
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase)
VALUES (5, 1, 2, 1200.00);
```

---

## 3. Оператори UPDATE (Оновлення даних)

### 3.1. Зміна ціни
**Завдання:** Оновлення ціни конкретного товару.
```sql
UPDATE products
SET price = 1150.00
WHERE product_id = 3;
```

### 3.2. Зміна статусу замовлення
**Завдання:** Оновлення статусу обробки замовлення на 'Shipped'.
```sql
UPDATE orders
SET status = 'Shipped'
WHERE order_id = 5;
```

### 3.3. Оновлення складу
**Завдання:** Зменшення кількості товару на складі після продажу.
```sql
UPDATE products
SET stock_quantity = stock_quantity - 2
WHERE product_id = 1;
```

---

## 4. Оператори DELETE (Видалення даних)

### 4.1. Видалення запису
**Завдання:** Видалення відгуку з рейтингом 1.
```sql
DELETE FROM reviews
WHERE rating = 1;
```

### 4.2. Каскадне видалення (вручну)
**Завдання:** Видалення адреси, на яку посилаються існуючі замовлення (спочатку видаляємо замовлення, потім адресу).
```sql
-- Крок 1: Видалення залежних замовлень
DELETE FROM orders 
WHERE shipping_address_id = 6;

-- Крок 2: Видалення адреси
DELETE FROM addresses 
WHERE street = 'Kharkivska St, 10';
```