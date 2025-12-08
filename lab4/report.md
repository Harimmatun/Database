# Звіт з Лабораторної роботи №4
**Тема:** Аналітичні SQL-запити (OLAP)

---

## 1. Агрегація та Групування

### 1.1. Базова статистика
**Завдання:** Отримати загальну кількість товарів, середню, мінімальну та максимальну ціну в магазині.
```sql
SELECT 
    COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM products;
```

### 1.2. Групування (GROUP BY)
**Завдання:** Підрахувати кількість товарів у кожній категорії.
```sql
SELECT 
    c.name AS category_name,
    COUNT(p.product_id) AS product_count
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.name;
```

### 1.3. Агрегація з обчисленням
**Завдання:** Порахувати загальну вартість залишків товарів на складі по кожному бренду.
```sql
SELECT 
    b.name AS brand_name,
    SUM(p.price * p.stock_quantity) AS total_stock_value
FROM brands b
JOIN products p ON b.brand_id = p.brand_id
GROUP BY b.name
ORDER BY total_stock_value DESC;
```

### 1.4. Фільтрація груп (HAVING)
**Завдання:** Знайти ID клієнтів, які зробили більше одного замовлення.
```sql
SELECT 
    customer_id,
    COUNT(order_id) AS orders_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;
```

---

## 2. Об'єднання таблиць (JOINs)

### 2.1. INNER JOIN
**Завдання:** Показати імена клієнтів та деталі їхніх замовлень (тільки для тих, хто робив замовлення).
```sql
SELECT 
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
```

### 2.2. LEFT JOIN
**Завдання:** Показати всіх клієнтів, навіть тих, у кого немає замовлень (у полях замовлення буде NULL).
```sql
SELECT 
    c.first_name,
    c.last_name,
    o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id;
```

### 2.3. CROSS JOIN
**Завдання:** Створити матрицю "Клієнт - Категорія" (усі можливі комбінації для маркетингу).
```sql
SELECT 
    c.last_name AS customer,
    cat.name AS category_promo
FROM customers c
CROSS JOIN categories cat;
```

---

## 3. Підзапити (Subqueries)

### 3.1. Підзапит у WHERE
**Завдання:** Знайти товари, ціна яких вища за середній чек усіх замовлень.
```sql
SELECT product_id, name, price
FROM products
WHERE price > (
    SELECT AVG(total_amount) FROM orders
);
```

### 3.2. Підзапит у SELECT
**Завдання:** Вивести список брендів і кількість товарів у них (використовуючи вкладений запит замість GROUP BY).
```sql
SELECT 
    name AS brand_name,
    (SELECT COUNT(*) FROM products p WHERE p.brand_id = b.brand_id) AS products_count
FROM brands b;
```

### 3.3. Підзапит з IN
**Завдання:** Знайти імена та email клієнтів, які купували товари бренду "Apple".
```sql
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
```

---

## 4. Комплексна аналітика

### 4.1. Топ продажів (Revenue)
**Завдання:** Розрахувати загальну виручку по кожному товару на основі реальних продажів.
```sql
SELECT 
    p.name AS product_name,
    SUM(oi.quantity) AS total_sold_quantity,
    SUM(oi.quantity * oi.price_at_purchase) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY total_revenue DESC;
```

### 4.2. Звіт по витратах клієнтів
**Завдання:** Показати, скільки всього грошей витратив кожен клієнт (включно з тими, хто нічого не витратив).
```sql
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
```