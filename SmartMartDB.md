# SmartMart — Create Tables

```sql
DROP DATABASE IF EXISTS smartdb;

CREATE DATABASE smartdb;

USE smartdb;


-- ============================================================
-- 1. CATEGORIES
-- ============================================================

CREATE TABLE categories
(
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);


-- ============================================================
-- 2. CUSTOMERS
-- ============================================================

CREATE TABLE customers
(
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE DEFAULT (CURRENT_DATE),
    customer_status VARCHAR(20) DEFAULT 'ACTIVE'
);


-- ============================================================
-- 3. PRODUCTS
-- ============================================================

CREATE TABLE products
(
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    product_status VARCHAR(20) DEFAULT 'ACTIVE',

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);


-- ============================================================
-- 4. ADDRESSES
-- ============================================================

CREATE TABLE addresses
(
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_type VARCHAR(20) DEFAULT 'HOME',
    address_line1 VARCHAR(150) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),

    CONSTRAINT fk_addresses_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- ============================================================
-- 5. ORDERS
-- ============================================================

CREATE TABLE orders
(
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(30) DEFAULT 'PLACED',
    total_amount DECIMAL(12,2) DEFAULT 0,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- ============================================================
-- 6. ORDER_ITEMS
-- ============================================================

CREATE TABLE order_items
(
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- ============================================================
-- 7. PAYMENTS
-- ============================================================

CREATE TABLE payments
(
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(30) DEFAULT 'SUCCESS',

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


-- ============================================================
-- 8. INVENTORY
-- ============================================================

CREATE TABLE inventory
(
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 10,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


CUSTOMERS
    │
    ├── ADDRESSES
    │
    └── ORDERS
          │
          ├── ORDER_ITEMS ─── PRODUCTS ─── CATEGORIES
          │
          └── PAYMENTS

PRODUCTS
    │
    └── INVENTORY



---

### 2. `smartmart_insert_data.md`

```md
# SmartMart — Insert Sample Data

USE smartdb;


-- ============================================================
-- 1. CATEGORIES
-- ============================================================

INSERT INTO categories
(category_id, category_name, description)
VALUES
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Computers', 'Laptops, desktops and computer accessories'),
(3, 'Furniture', 'Office and home furniture'),
(4, 'Stationery', 'Books, notebooks and office stationery'),
(5, 'Mobile Accessories', 'Cases, chargers and mobile accessories');


-- ============================================================
-- 2. CUSTOMERS
-- ============================================================

INSERT INTO customers
(
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    state,
    registration_date,
    customer_status
)
VALUES
(201, 'John',   'Doe',      'john.doe@gmail.com',
     '9876543210', 'Chennai', 'Tamil Nadu',
     '2023-01-10', 'ACTIVE'),

(202, 'Jane',   'Smith',    'jane.smith@gmail.com',
     '9876543211', 'Bangalore', 'Karnataka',
     '2023-02-15', 'ACTIVE'),

(203, 'Emily',  'Davis',    'emily.davis@gmail.com',
     '9876543212', 'Mumbai', 'Maharashtra',
     '2023-03-20', 'ACTIVE'),

(204, 'Mark',   'Wilson',   'mark.wilson@gmail.com',
     '9876543213', 'Delhi', 'Delhi',
     '2023-04-25', 'ACTIVE'),

(205, 'Robert', 'Brown',    'robert.brown@gmail.com',
     '9876543214', 'Hyderabad', 'Telangana',
     '2023-05-05', 'ACTIVE'),

(206, 'Sarah',  'Taylor',   'sarah.taylor@gmail.com',
     '9876543215', 'Pune', 'Maharashtra',
     '2023-05-18', 'ACTIVE'),

(207, 'David',  'Miller',   'david.miller@gmail.com',
     '9876543216', 'Coimbatore', 'Tamil Nadu',
     '2023-06-10', 'ACTIVE'),

(208, 'Lisa',   'Anderson', 'lisa.anderson@gmail.com',
     '9876543217', 'Kochi', 'Kerala',
     '2023-07-12', 'INACTIVE');


-- ============================================================
-- 3. PRODUCTS
-- ============================================================

INSERT INTO products
(
    product_id,
    product_name,
    category_id,
    price,
    stock_quantity,
    product_status
)
VALUES
(301, 'Laptop',              2, 75000.00, 25,  'ACTIVE'),
(302, 'Smartphone',          1, 60000.00, 40,  'ACTIVE'),
(303, 'Office Chair',        3,  7500.00, 15,  'ACTIVE'),
(304, 'Notebook Set',        4,   500.00, 100, 'ACTIVE'),
(305, 'Wireless Mouse',      2,  1500.00, 50,  'ACTIVE'),
(306, 'Mechanical Keyboard', 2,  4500.00, 30,  'ACTIVE'),
(307, 'USB-C Charger',       5,  2000.00, 60,  'ACTIVE'),
(308, 'Monitor',             2, 18000.00, 20,  'ACTIVE'),
(309, 'Headphones',          1,  3500.00, 45,  'ACTIVE'),
(310, 'Webcam',              1,  5500.00, 18,  'ACTIVE');


-- ============================================================
-- 4. ADDRESSES
-- ============================================================

INSERT INTO addresses
(
    address_id,
    customer_id,
    address_type,
    address_line1,
    city,
    state,
    pincode
)
VALUES
(1, 201, 'HOME',
 '12 Anna Nagar', 'Chennai', 'Tamil Nadu', '600040'),

(2, 202, 'HOME',
 '45 MG Road', 'Bangalore', 'Karnataka', '560001'),

(3, 203, 'HOME',
 '78 Andheri West', 'Mumbai', 'Maharashtra', '400058'),

(4, 204, 'HOME',
 '21 Connaught Place', 'Delhi', 'Delhi', '110001'),

(5, 205, 'OFFICE',
 '15 Hitech City', 'Hyderabad', 'Telangana', '500081'),

(6, 206, 'HOME',
 '34 Koregaon Park', 'Pune', 'Maharashtra', '411001'),

(7, 207, 'HOME',
 '10 RS Puram', 'Coimbatore', 'Tamil Nadu', '641002'),

(8, 208, 'HOME',
 '22 MG Road', 'Kochi', 'Kerala', '682016');


-- ============================================================
-- 5. ORDERS
-- ============================================================

INSERT INTO orders
(
    order_id,
    customer_id,
    order_date,
    order_status,
    total_amount
)
VALUES
(401, 201, '2023-08-01', 'DELIVERED', 76500.00),
(402, 202, '2023-08-02', 'DELIVERED', 64500.00),
(403, 203, '2023-08-03', 'DELIVERED',  4000.00),
(404, 204, '2023-08-05', 'SHIPPED',    7500.00),
(405, 201, '2023-08-10', 'DELIVERED', 20000.00),
(406, 205, '2023-08-12', 'PLACED',    78000.00),
(407, 206, '2023-08-15', 'DELIVERED',  9500.00),
(408, 207, '2023-08-18', 'SHIPPED',   18000.00),
(409, 202, '2023-08-20', 'DELIVERED', 75000.00),
(410, 203, '2023-08-22', 'CANCELLED',  3500.00);


-- ============================================================
-- 6. ORDER_ITEMS
-- ============================================================

INSERT INTO order_items
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount
)
VALUES
(1,  401, 301, 1, 75000.00, 0.00),
(2,  401, 304, 3,   500.00, 0.00),

(3,  402, 302, 1, 60000.00, 0.00),
(4,  402, 305, 3,  1500.00, 0.00),

(5,  403, 309, 1,  3500.00, 0.00),
(6,  403, 307, 1,   500.00, 0.00),

(7,  404, 303, 1,  7500.00, 0.00),

(8,  405, 308, 1, 18000.00, 2000.00),

(9,  406, 301, 1, 75000.00, 5000.00),
(10, 406, 307, 1,  2000.00, 0.00),

(11, 407, 303, 1,  7500.00, 0.00),
(12, 407, 305, 1,  1500.00, 0.00),

(13, 408, 308, 1, 18000.00, 0.00),

(14, 409, 301, 1, 75000.00, 0.00),

(15, 410, 309, 1,  3500.00, 0.00);


-- ============================================================
-- 7. PAYMENTS
-- ============================================================

INSERT INTO payments
(
    payment_id,
    order_id,
    payment_date,
    payment_method,
    amount,
    payment_status
)
VALUES
(501, 401, '2023-08-01', 'UPI',
     76500.00, 'SUCCESS'),

(502, 402, '2023-08-02', 'CREDIT_CARD',
     64500.00, 'SUCCESS'),

(503, 403, '2023-08-03', 'UPI',
      4000.00, 'SUCCESS'),

(504, 404, '2023-08-05', 'DEBIT_CARD',
      7500.00, 'SUCCESS'),

(505, 405, '2023-08-10', 'UPI',
     20000.00, 'SUCCESS'),

(506, 406, '2023-08-12', 'CREDIT_CARD',
     78000.00, 'SUCCESS'),

(507, 407, '2023-08-15', 'UPI',
      9500.00, 'SUCCESS'),

(508, 408, '2023-08-18', 'NET_BANKING',
     18000.00, 'SUCCESS'),

(509, 409, '2023-08-20', 'CREDIT_CARD',
     75000.00, 'SUCCESS'),

(510, 410, '2023-08-22', 'UPI',
      3500.00, 'REFUNDED');


-- ============================================================
-- 8. INVENTORY
-- ============================================================

INSERT INTO inventory
(
    inventory_id,
    product_id,
    warehouse_name,
    quantity,
    reorder_level
)
VALUES
(601, 301, 'Chennai Warehouse',   25, 10),
(602, 302, 'Bangalore Warehouse', 40, 10),
(603, 303, 'Chennai Warehouse',   15,  5),
(604, 304, 'Hyderabad Warehouse', 100, 20),
(605, 305, 'Bangalore Warehouse', 50, 10),
(606, 306, 'Chennai Warehouse',   30, 10),
(607, 307, 'Mumbai Warehouse',    60, 15),
(608, 308, 'Chennai Warehouse',   20,  5),
(609, 309, 'Bangalore Warehouse', 45, 10),
(610, 310, 'Mumbai Warehouse',    18,  5);


-- ============================================================
-- VERIFY DATA
-- ============================================================

SELECT * FROM categories;

SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM addresses;

SELECT * FROM orders;

SELECT * FROM order_items;

SELECT * FROM payments;

SELECT * FROM inventory;
