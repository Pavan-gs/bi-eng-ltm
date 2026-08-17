# SmartMart — Programming & Database Fundamentals

## 1. Running Business Case — SmartMart

**SmartMart** is an online shopping company.

Customers can:

- Register
- Browse products
- Place orders
- Make payments
- Cancel orders
- Track deliveries
- Review products

SmartMart employees need to:

- Manage customers
- Manage products
- Track inventory
- Process orders
- Monitor payments
- Analyze sales

### Business Requirement

SmartMart has millions of customers, hundreds of thousands of products, and millions of orders.

The application needs a reliable way to store, manage, retrieve, and analyze this information.

---

# 2. Planning Logic — Before Writing Code

## Business Requirement

Calculate the total price of an order.

A customer purchases:

| Product | Quantity | Price |
|---|---:|---:|
| Laptop | 1 | ₹75,000 |
| Mouse | 2 | ₹1,000 |
| Keyboard | 1 | ₹2,500 |

### Calculation

```text
75000 × 1
+ 1000 × 2
+ 2500 × 1
= ₹79,500
```

For millions of orders, this calculation must be automated.

### Algorithm

```text
1. Read product price
2. Read quantity
3. Multiply price × quantity
4. Add all products
5. Calculate total
6. Display total
```

---

# 3. Pseudocode

```text
START

INPUT price
INPUT quantity

total = price * quantity

DISPLAY total

END
```

Pseudocode describes the solution without depending on a particular programming language.

---

# 4. Flowchart

```text
       ┌─────────────┐
       │    START    │
       └──────┬──────┘
              │
              ▼
      ┌────────────────┐
      │  Input price   │
      └───────┬────────┘
              │
              ▼
      ┌────────────────┐
      │ Input quantity │
      └───────┬────────┘
              │
              ▼
      ┌────────────────────┐
      │ total = price × qty│
      └──────────┬─────────┘
                 │
                 ▼
        ┌────────────────┐
        │ Display total  │
        └───────┬────────┘
                │
                ▼
        ┌──────────────┐
        │     END      │
        └──────────────┘
```

---

# 5. What Is Programming?

Programming is the process of converting a problem-solving procedure into instructions that a computer can execute.

### SmartMart Example

```text
Business Problem
       ↓
Calculate Order Total
       ↓
Algorithm
       ↓
Pseudocode
       ↓
Program
       ↓
Computer Executes It
```

---

# 6. Programming Languages

A programming language provides a formal way to communicate instructions to a computer.

| Language | Common Usage |
|---|---|
| Python | Data, AI, automation, backend |
| Java | Enterprise applications |
| C | Systems programming |
| C++ | Systems, gaming |
| C# | .NET applications |
| JavaScript | Web applications |
| Scala | Big Data / Spark |
| Go | Cloud and backend systems |
| Rust | Systems programming |

### Same Logic, Different Syntax

#### Pseudocode

```text
IF order_total > 50000
    give premium discount
ELSE
    normal discount
```

#### Python

```python
if order_total > 50000:
    discount = 10
else:
    discount = 5
```

#### Java

```java
if (orderTotal > 50000) {
    discount = 10;
} else {
    discount = 5;
}
```

The business logic remains the same. The syntax changes between languages.

---

# 7. Syntax & Structure

## Variables

A variable is a named location used to hold a value.

```python
customer_name = "Rahul"
product_price = 75000
quantity = 2
discount = 10
```

### SmartMart Example

```text
customer_name  → "Rahul"
product_price  → 75000
quantity       → 2
discount       → 10
```

---

# 8. Data Types

| Business Data | Example | Data Type |
|---|---|---|
| Customer name | `"Rahul"` | String |
| Quantity | `3` | Integer |
| Product price | `75000.50` | Decimal / Float |
| Is active? | `True` | Boolean |
| Registration date | `2026-08-16` | Date |

Data types tell the programming language how a value should be interpreted and what operations can be performed on it.

---

# 9. Operators

## Arithmetic Operators

```python
subtotal = price * quantity
discount_amount = subtotal * discount / 100
final_amount = subtotal - discount_amount
```

Common arithmetic operators:

```text
+     Addition
-     Subtraction
*     Multiplication
/     Division
%     Modulus
```

## Comparison Operators

```python
order_total > 50000
order_total == 50000
quantity >= 5
```

Common comparison operators:

```text
>     Greater than
<     Less than
>=    Greater than or equal to
<=    Less than or equal to
==    Equal to
!=    Not equal to
```

## Logical Operators

```python
order_total > 50000 and customer_type == "PREMIUM"
```

Common logical operators:

```text
AND
OR
NOT
```

---

# 10. Control Structures

Control structures determine the flow in which program instructions are executed.

Main types:

```text
Sequential execution
       ↓
Conditional execution
       ↓
Repeated execution
```

---

# 11. IF / ELSE

## Business Requirement

Premium customers receive a 10% discount.

Other customers receive a 5% discount.

```python
if customer_type == "PREMIUM":
    discount = 10
else:
    discount = 5
```

### Business Flow

```text
                 Order
                   │
                   ▼
        ┌────────────────────┐
        │ Premium customer?  │
        └─────────┬──────────┘
              YES │       NO
                  │
          ┌───────▼───────┐
          │ Discount = 10%│
          └───────────────┘
                  │
                  │
                  └───────┐
                          ▼
                 Calculate Total
```

---

# 12. Loops

Loops are used when an operation needs to be performed repeatedly.

## Business Requirement

Calculate the value of every item in an order.

```python
items = [
    ("Laptop", 1, 75000),
    ("Mouse", 2, 1000),
    ("Keyboard", 1, 2500)
]

total = 0

for item in items:
    product_name = item[0]
    quantity = item[1]
    price = item[2]

    total = total + quantity * price

print(total)
```

### Common Loop Types

```text
for loop
while loop
```

---

# 13. Functions & Modular Programming

As SmartMart grows, the application needs separate functionality for:

- Order totals
- Discounts
- Tax
- Shipping
- Loyalty points
- Payments

Instead of putting everything into one large program, functionality can be divided into reusable functions.

## Example

```python
def calculate_subtotal(price, quantity):
    return price * quantity
```

Calling the function:

```python
subtotal = calculate_subtotal(75000, 2)

print(subtotal)
```

Another function:

```python
def calculate_discount(amount, discount_rate):
    return amount * discount_rate / 100
```

Using it:

```python
discount = calculate_discount(150000, 10)
```

### Modular Architecture

```text
                 SmartMart Application
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
     Customer        Order Module    Payment
      Module             │
                          │
                ┌─────────┼─────────┐
                ▼         ▼         ▼
            Subtotal   Discount    Tax
```

### Modular Programming

> Divide a large problem into smaller, reusable, maintainable components.

---

# 14. Why Do We Need a Database?

The SmartMart application may have:

```text
10 million customers
500,000 products
50 million orders
150 million order items
```

Keeping all this information only in program variables is not practical.

The information needs to be stored persistently.

```text
Application
     │
     ▼
Persistent Storage
     │
     ▼
Database
```

---

# 15. What Is a Database?

A database is an organized system for storing, managing, retrieving, and modifying data.

### SmartMart Customer Data

```text
CUSTOMERS

customer_id
name
email
phone
city
registration_date
```

A database allows SmartMart to efficiently work with this information.

---

# 16. File Storage vs Database

A simple file might contain:

```text
101,Rahul,rahul@gmail.com,Chennai
102,Priya,priya@gmail.com,Bangalore
103,Arun,arun@gmail.com,Mumbai
```

As the application grows, problems arise:

- Finding specific records
- Preventing duplicate data
- Maintaining relationships
- Multiple users accessing data
- Security
- Concurrent updates
- Backup and recovery
- Data integrity

A database management system provides mechanisms to solve these problems.

---

# 17. Types of Databases

## Relational Databases

Data is organized into tables.

```text
CUSTOMERS

┌────────────┬───────────┬───────────────────┐
│ customer_id│ name      │ email             │
├────────────┼───────────┼───────────────────┤
│ 1          │ Rahul     │ rahul@gmail.com   │
│ 2          │ Priya     │ priya@gmail.com   │
└────────────┴───────────┴───────────────────┘
```

Relational databases support relationships between tables.

## Non-Relational / NoSQL Databases

NoSQL databases can represent data using different models such as:

- Document
- Key-value
- Wide-column
- Graph

### Example Document

```json
{
    "customer_id": 101,
    "name": "Rahul",
    "city": "Chennai",
    "orders": [
        {
            "order_id": 5001,
            "amount": 75000
        }
    ]
}
```

---

# 18. Relational vs Non-Relational

| Feature | Relational | Non-Relational |
|---|---|---|
| Data model | Tables | Documents, key-value, graph, etc. |
| Schema | Usually structured | Often flexible |
| Relationships | Strong support | Model-dependent |
| Query language | SQL | Database-specific |
| Transactions | Strong support | Depends on database |
| Examples | MySQL, PostgreSQL, Oracle | MongoDB, Cassandra, Redis |

---

# 19. What Is an RDBMS?

**RDBMS = Relational Database Management System**

An RDBMS is software used to create, manage, access, secure, and manipulate relational databases.

An RDBMS provides capabilities such as:

- Database creation
- Table creation
- Data insertion
- Data retrieval
- Data modification
- Data deletion
- Relationship management
- Security
- Transactions
- Concurrency
- Backup and recovery

---

# 20. Popular RDBMS Tools

| RDBMS | Common Usage |
|---|---|
| MySQL | Web and application development |
| PostgreSQL | Enterprise and modern application development |
| Oracle Database | Large enterprise systems |
| SQL Server | Microsoft ecosystem and enterprise applications |
| Teradata | Large-scale analytics and data warehousing |

### Course Database

**MySQL** will be used as the primary database for SmartMart demonstrations.

The same SQL concepts can later be compared across:

- MySQL
- PostgreSQL
- Oracle
- SQL Server
- Teradata

---

# 21. RDBMS Architecture

```text
                    SMARTMART APPLICATION
                            │
                            │ SQL
                            ▼
                  ┌─────────────────────┐
                  │        RDBMS        │
                  │                     │
                  │  Query Processing   │
                  │  Security           │
                  │  Transactions       │
                  │  Concurrency        │
                  │  Storage Management │
                  └──────────┬──────────┘
                             │
                             ▼
                     ┌──────────────┐
                     │   DATABASE   │
                     └──────┬───────┘
                            │
          ┌─────────────────┼─────────────────┐
          ▼                 ▼                 ▼
     CUSTOMERS           PRODUCTS           ORDERS
          │                 │                 │
          └─────────────────┼─────────────────┘
                            │
                            ▼
                      ORDER_ITEMS
```

### Mental Model

```text
Application
     ↓
RDBMS
     ↓
Database
     ↓
Tables
     ↓
Rows and Columns
```

---

# 22. SmartMart Database Design

SmartMart requires the following major entities:

```text
CUSTOMERS
PRODUCTS
CATEGORIES
ORDERS
ORDER_ITEMS
PAYMENTS
ADDRESSES
INVENTORY
```

### Relationships

```text
CUSTOMER
   │
   │ places
   ▼
 ORDER
   │
   │ contains
   ▼
ORDER_ITEM
   │
   │ references
   ▼
PRODUCT
   │
   │ belongs to
   ▼
CATEGORY
```

Payment relationship:

```text
ORDER
  │
  └────── PAYMENT
```

---

# 23. SQL

**SQL = Structured Query Language**

SQL is used to communicate with relational databases.

Examples:

```sql
SELECT *
FROM customers;
```

Read this as:

```text
SELECT
   ↓
What data do I want?

FROM
   ↓
Which table contains it?

customers
   ↓
The source table
```

Another example:

```sql
SELECT first_name, email
FROM customers
WHERE city = 'Chennai';
```

Business interpretation:

> Retrieve the first name and email of customers whose city is Chennai.

---

# 24. SQL Command Categories

```text
SQL
 │
 ├── DDL
 │    ├── CREATE
 │    ├── ALTER
 │    ├── DROP
 │    └── TRUNCATE
 │
 ├── DML
 │    ├── INSERT
 │    ├── UPDATE
 │    └── DELETE
 │
 ├── DQL
 │    └── SELECT
 │
 ├── DCL
 │    ├── GRANT
 │    └── REVOKE
 │
 └── TCL
      ├── COMMIT
      ├── ROLLBACK
      └── SAVEPOINT
```

---

# 25. DDL — Data Definition Language

DDL is used to define and modify database structures.

The primary DDL commands covered here are:

```text
CREATE
ALTER
DROP
TRUNCATE
```

### Business Analogy

Imagine SmartMart is building and managing a warehouse:

```text
CREATE     → Build
ALTER      → Modify
TRUNCATE   → Empty
DROP       → Remove
```

---

# 26. CREATE TABLE

## Business Requirement

SmartMart needs to store customer information.

```sql
CREATE TABLE customers
(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE,
    customer_status VARCHAR(20)
);
```

### Resulting Structure

```text
CUSTOMERS

┌──────────────────────┐
│ customer_id          │
│ first_name           │
│ last_name            │
│ email                │
│ phone                │
│ city                 │
│ state                │
│ registration_date    │
│ customer_status      │
└──────────────────────┘
```

---

# 27. Understanding CREATE TABLE

```sql
CREATE TABLE customers
```

Creates a table named `customers`.

```sql
customer_id INT PRIMARY KEY
```

- `customer_id` → column name
- `INT` → integer data type
- `PRIMARY KEY` → uniquely identifies a customer

```sql
first_name VARCHAR(50) NOT NULL
```

- `VARCHAR(50)` → variable-length text up to 50 characters
- `NOT NULL` → value is required

```sql
email VARCHAR(100) UNIQUE NOT NULL
```

- Email cannot be missing.
- Duplicate email values are not allowed.

---

# 28. CREATE Products Table

```sql
CREATE TABLE products
(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2),
    stock_quantity INT,
    product_status VARCHAR(20)
);
```

---

# 29. CREATE Orders Table

```sql
CREATE TABLE orders
(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(20),
    total_amount DECIMAL(12,2)
);
```

---

# 30. CREATE Order Items Table

```sql
CREATE TABLE order_items
(
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(10,2)
);
```

---

# 31. ALTER TABLE

## Business Requirement

SmartMart now wants to store the customer's date of birth.

The `customers` table already exists.

```sql
ALTER TABLE customers
ADD date_of_birth DATE;
```

### Before

```text
CUSTOMERS

customer_id
first_name
last_name
email
phone
city
state
registration_date
customer_status
```

### After

```text
CUSTOMERS

customer_id
first_name
last_name
email
phone
city
state
registration_date
customer_status
date_of_birth     ← NEW
```

---

# 32. ALTER — Rename a Column

Suppose SmartMart wants to rename `phone` to `mobile_number`.

```sql
ALTER TABLE customers
RENAME COLUMN phone TO mobile_number;
```

---

# 33. ALTER — Modify a Column

Increase the size of the mobile number column.

```sql
ALTER TABLE customers
MODIFY mobile_number VARCHAR(25);
```

The exact syntax for modifying columns can vary between database systems.

---

# 34. DROP TABLE

## Business Requirement

SmartMart has an obsolete temporary table that is no longer required.

```sql
DROP TABLE old_customers;
```

Conceptually:

```text
DROP
  ↓
Remove the table
  ↓
Structure removed
  ↓
Data removed
```

`DROP` should be used carefully because it removes the table itself.

---

# 35. TRUNCATE TABLE

## Business Requirement

SmartMart has a testing table containing 10,000 temporary orders.

The table structure is still required, but all test rows need to be removed.

```sql
TRUNCATE TABLE test_orders;
```

Before:

```text
TEST_ORDERS

10,000 rows
```

After:

```text
TEST_ORDERS

Table exists
       │
       ▼
   0 rows
```

---

# 36. CREATE vs ALTER vs TRUNCATE vs DROP

| Command | Table Structure | Existing Data |
|---|---|---|
| CREATE | Creates structure | Creates an empty table |
| ALTER | Modifies structure | Existing data generally remains |
| TRUNCATE | Keeps structure | Removes all rows |
| DROP | Removes structure | Removes table and data |

### Visual Memory

```text
CREATE
🏗️ BUILD

ALTER
🔧 MODIFY

TRUNCATE
🧹 EMPTY

DROP
💥 DESTROY
```

---

# 37. SmartMart DDL Journey

```text
BUSINESS REQUIREMENT
        │
        ▼
"SmartMart needs customers"
        │
        ▼
      CREATE
        │
        ▼
CUSTOMERS TABLE
        │
        ▼
"SmartMart needs date of birth"
        │
        ▼
       ALTER
        │
        ▼
CUSTOMERS TABLE UPDATED
        │
        ▼
"Test data is no longer required"
        │
        ▼
     TRUNCATE
        │
        ▼
TABLE EMPTY
        │
        ▼
"Temporary table is no longer needed"
        │
        ▼
       DROP
        │
        ▼
TABLE REMOVED
```

---

# 38. SmartMart — Application Architecture

```text
                    SMARTMART
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
    Web App        Mobile App      Admin App
        │              │              │
        └──────────────┼──────────────┘
                       │
                       ▼
                  API / Backend
                       │
             ┌─────────┴─────────┐
             │                   │
             ▼                   ▼
        Business Logic       Authentication
             │
             ▼
           MySQL
             │
   ┌─────────┼──────────┐
   ▼         ▼          ▼
Customers Products    Orders
                        │
                        ▼
                   Order Items
```

---

# 39. Learning Journey

## Phase 1 — Think Like a Programmer

```text
Business Problem
       ↓
Understand the Problem
       ↓
Break Into Smaller Problems
       ↓
Algorithm
       ↓
Pseudocode
       ↓
Flowchart
```

## Phase 2 — Build the Logic

```text
Variables
   ↓
Data Types
   ↓
Operators
   ↓
Conditions
   ↓
Loops
   ↓
Functions
```

## Phase 3 — Store Business Data

```text
Why Storage?
     ↓
Database
     ↓
Relational vs NoSQL
     ↓
RDBMS
     ↓
Tables
     ↓
Relationships
```

## Phase 4 — Communicate With the Database

```text
SQL
 │
 ├── DDL
 │    ├── CREATE
 │    ├── ALTER
 │    ├── DROP
 │    └── TRUNCATE
 │
 ├── DML
 │    ├── INSERT
 │    ├── UPDATE
 │    └── DELETE
 │
 ├── DQL
 │    └── SELECT
 │
 ├── DCL
 │
 └── TCL
```

---

# 40. SmartMart — Complete Learning Story

The complete progression is:

```text
                     SMARTMART
                         │
                         ▼
                 Business Problem
                         │
                         ▼
                  Problem Solving
                         │
                         ▼
                    Algorithm
                         │
                         ▼
                     Pseudocode
                         │
                         ▼
                     Flowchart
                         │
                         ▼
                   Programming
                         │
             ┌───────────┼───────────┐
             ▼           ▼           ▼
          Variables   Conditions    Loops
             │           │           │
             └───────────┼───────────┘
                         ▼
                     Functions
                         │
                         ▼
                     Application
                         │
                         ▼
                     Database
                         │
                         ▼
                       RDBMS
                         │
                         ▼
                        SQL
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
         DDL            DML            DQL
          │              │              │
     CREATE/ALTER   INSERT/UPDATE     SELECT
      DROP/TRUNCATE    DELETE
```

---

# 41. Core Principles

> **Don't learn programming syntax first. Learn how to solve the problem first, then express the solution in code.**

> **Don't learn SQL as a collection of commands. Learn SQL as a language for answering business questions.**

> **Every SQL command should be connected to a business requirement.**

> **The SmartMart application is the common thread connecting programming, databases, and SQL.**
