============================================================
-- MySQL Demo: UNION, UNION ALL and FULL OUTER JOIN
-- ============================================================

DROP DATABASE IF EXISTS JoinSetDemo;
CREATE DATABASE JoinSetDemo;
USE JoinSetDemo;


-- ============================================================
-- 1. CREATE TWO SIMPLE TABLES
-- ============================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount DECIMAL(10,2)
);


-- ============================================================
-- 2. INSERT DATA
-- ============================================================
-- Customer 3 has no order.
-- Order 104 belongs to customer 4,
-- but customer 4 does not exist.
--
-- This allows us to demonstrate unmatched rows
-- on BOTH sides of a join.

INSERT INTO customers VALUES
(1, 'Ananya'),
(2, 'Bharat'),
(3, 'Charan');

INSERT INTO orders VALUES
(101, 1, 5000.00),
(102, 2, 7500.00),
(103, 2, 3000.00),
(104, 4, 9000.00);


-- ============================================================
-- 3. CHECK THE DATA
-- ============================================================

SELECT * FROM customers;

SELECT * FROM orders;


-- ============================================================
-- 4. UNION
-- ============================================================
-- UNION combines result sets VERTICALLY
-- and removes duplicate rows.
--
-- Bharat occurs in both SELECT statements,
-- but appears only once in the final result.

SELECT customer_name
FROM customers
WHERE customer_id IN (1, 2)

UNION

SELECT customer_name
FROM customers
WHERE customer_id IN (2, 3);


-- ============================================================
-- 5. UNION ALL
-- ============================================================
-- UNION ALL also combines result sets vertically,
-- but keeps duplicate rows.
--
-- Bharat appears twice.

SELECT customer_name
FROM customers
WHERE customer_id IN (1, 2)

UNION ALL

SELECT customer_name
FROM customers
WHERE customer_id IN (2, 3);


-- ============================================================
-- 6. VERY SIMPLE UNION vs UNION ALL DEMO
-- ============================================================

SELECT 'A' AS value
UNION
SELECT 'A';

-- Result:
-- A
--
-- Duplicate removed.


SELECT 'A' AS value
UNION ALL
SELECT 'A';

-- Result:
-- A
-- A
--
-- Duplicate retained.


-- ============================================================
-- 7. INNER JOIN — BASELINE
-- ============================================================
-- INNER JOIN returns only matching rows
-- from both tables.

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;

-- Customer 3 is missing because there is no order.
-- Order 104 is missing because customer 4 does not exist.


-- ============================================================
-- 8. LEFT OUTER JOIN
-- ============================================================
-- Keep EVERY row from the LEFT table: customers.
--
-- If there is no matching order,
-- columns from orders become NULL.

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;

-- Customer 3 appears with NULL order information.


-- ============================================================
-- 9. RIGHT OUTER JOIN
-- ============================================================
-- Keep EVERY row from the RIGHT table: orders.
--
-- If there is no matching customer,
-- columns from customers become NULL.

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id;

-- Order 104 appears with NULL customer information.


-- ============================================================
-- 10. FULL OUTER JOIN
-- ============================================================
-- IMPORTANT:
-- MySQL does NOT support FULL OUTER JOIN directly.
--
-- We simulate it using:
--
-- LEFT JOIN
-- UNION
-- RIGHT JOIN
--
-- LEFT JOIN:
-- keeps all customers
--
-- RIGHT JOIN:
-- keeps all orders
--
-- UNION:
-- combines both results and removes
-- duplicate matching rows.

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id

UNION

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_amount
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id;


-- ============================================================
-- 11. CONCEPT TO REMEMBER
-- ============================================================
--
-- UNION:
-- Combines result sets VERTICALLY.
--
-- JOIN:
-- Combines related tables HORIZONTALLY.
--
--
-- UNION is NOT a replacement for JOIN.
-- They solve different problems.
--
--
-- INNER JOIN
-- → only matching rows
--
-- LEFT JOIN
-- → everything from LEFT table
--
-- RIGHT JOIN
-- → everything from RIGHT table
--
-- FULL OUTER JOIN
-- → everything from BOTH tables
-- → not directly supported by MySQL
-- → simulate using LEFT JOIN
-- UNION
-- RIGHT JOIN


-- ============================================================
-- 12. PRACTICE
-- ============================================================

-- Q1. Return customer names using UNION
-- and remove duplicates.

-- Q2. Return customer names using UNION ALL
-- and keep duplicates.

-- Q3. Show every customer,
-- including customers without orders.

-- Q4. Show every order,
-- including orders without a matching customer.

-- Q5. Simulate a FULL OUTER JOIN in MySQL.

-- Q6. Explain why UNION is used between
-- the LEFT JOIN and RIGHT JOIN results.