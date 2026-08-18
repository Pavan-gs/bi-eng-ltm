# SQL Complete Learning Syllabus

## Practical-First: Basic → Intermediate → Advanced

> **Learning Philosophy:** Learn SQL by solving real business problems first, then learn the syntax behind the solution.

---

# 1. SQL Learning Strategy

The course follows this progression:

```text
BUSINESS PROBLEM
       ↓
UNDERSTAND THE DATA
       ↓
IDENTIFY REQUIRED TABLES
       ↓
THINK ABOUT THE LOGIC
       ↓
WRITE SQL
       ↓
RUN QUERY
       ↓
ANALYZE RESULT
       ↓
OPTIMIZE QUERY
       ↓
SOLVE SIMILAR PROBLEMS
```

The objective is **not to memorize SQL commands**.

The objective is to develop the ability to think:

> "What business question am I trying to answer, what data do I need, and how can SQL produce that answer?"

---

# 2. Complete SQL Roadmap

```text
                         SQL MASTERY
                              │
              ┌───────────────┼───────────────┐
              │               │               │
            BASIC        INTERMEDIATE      ADVANCED
           0–35%            35–70%          70–100%
              │               │               │
        Retrieve Data     Analyze Data    Engineer Data
              │               │               │
        SELECT            JOINs           CTE
        WHERE             GROUP BY        Recursive CTE
        ORDER BY          HAVING          Window Functions
        DISTINCT          Subqueries      Advanced Analytics
        TOP/LIMIT         Set Operators   Query Optimization
        CASE              CTE             Execution Plans
        NULL              Window Basics   Transactions
        Aggregation       Data Modeling   Procedures
        CRUD              Views           Functions
        DDL               Temp Tables     Triggers
```

---

# 3. LEVEL 1 — SQL BASIC

## Goal

Learn how to:

* Understand databases
* Retrieve data
* Filter data
* Sort data
* Calculate values
* Handle NULLs
* Aggregate data
* Group data
* Apply business logic
* Modify data
* Create database objects

---

# Module 1 — Database Fundamentals

## Topics

* Database
* Database Management System
* Relational Database
* Table
* Row
* Column
* Schema
* Primary Key
* Foreign Key
* Candidate Key
* Composite Key
* Constraints
* Relationships
* Data Types
* NULL

## Practical Questions

* Where is customer data stored?
* How can a customer be uniquely identified?
* How are customers connected to orders?
* What does NULL mean?
* What is the difference between NULL and zero?

---

# Module 2 — SELECT

## Topics

```sql
SELECT
SELECT *
SELECT column1, column2
SELECT DISTINCT
Column aliases
Expressions
```

## Practical Problems

* Display all customers.
* Display customer names.
* Display product name and price.
* Display unique cities.
* Calculate total product value.

## Example

```sql
SELECT
    ProductName,
    Price,
    Quantity,
    Price * Quantity AS TotalValue
FROM Products;
```

---

# Module 3 — Filtering Data

## Topics

```sql
WHERE
=
<>
!=
>
<
>=
<=
AND
OR
NOT
IN
BETWEEN
LIKE
IS NULL
IS NOT NULL
```

## Practical Problems

* Products above ₹10,000
* Customers from Chennai
* Employees hired after 2020
* Products between ₹5,000 and ₹20,000
* Customers whose names start with `A`
* Customers without phone numbers

## Example

```sql
SELECT *
FROM Products
WHERE Price BETWEEN 5000 AND 20000;
```

---

# Module 4 — Sorting Data

## Topics

```sql
ORDER BY
ASC
DESC
```

## Practical Problems

* Cheapest products
* Most expensive products
* Latest customers
* Highest-paid employees

## Example

```sql
SELECT *
FROM Products
ORDER BY Price DESC;
```

---

# Module 5 — Limiting Results

## Topics

Different databases use different syntax:

```sql
TOP
LIMIT
FETCH FIRST
OFFSET
```

## Example — SQL Server

```sql
SELECT TOP 10 *
FROM Products
ORDER BY Price DESC;
```

## Practical Problems

* Top 10 products
* Top 5 customers
* Latest 10 orders

---

# Module 6 — SQL Expressions and Aliases

## Topics

```sql
+
-
*
/
%
AS
```

## Example

```sql
SELECT
    ProductName,
    Price,
    Quantity,
    Price * Quantity AS InventoryValue
FROM Products;
```

## Practical Applications

* Revenue calculation
* Inventory value
* Discount calculation
* Tax calculation
* Profit calculation

---

# Module 7 — NULL Handling

## Topics

```sql
IS NULL
IS NOT NULL
COALESCE()
NULLIF()
```

## Important Concepts

```text
NULL ≠ 0
NULL ≠ ''
NULL ≠ FALSE
```

## Example

```sql
SELECT *
FROM Customers
WHERE PhoneNumber IS NULL;
```

## Practical Applications

* Missing phone numbers
* Missing email addresses
* Missing customer information
* Default values
* Data quality checks

---

# Module 8 — Aggregate Functions

## Topics

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

## Practical Problems

* How many customers?
* What is total revenue?
* What is average salary?
* What is the highest product price?
* What is the lowest product price?

## Example

```sql
SELECT
    SUM(SalesAmount) AS TotalSales
FROM Sales;
```

---

# Module 9 — GROUP BY

## Topics

```sql
GROUP BY
```

## Key Concept

```text
Individual Rows
      ↓
GROUP BY
      ↓
Groups
      ↓
Aggregate Functions
```

## Practical Problems

* Revenue by city
* Sales by product
* Employees by department
* Orders by customer
* Sales by month

## Example

```sql
SELECT
    City,
    SUM(SalesAmount) AS Revenue
FROM Sales
GROUP BY City;
```

---

# Module 10 — HAVING

## Key Difference

```text
WHERE
↓
Filters individual rows

HAVING
↓
Filters groups
```

## Example

```sql
SELECT
    City,
    SUM(SalesAmount) AS Revenue
FROM Sales
GROUP BY City
HAVING SUM(SalesAmount) > 1000000;
```

## Practical Problems

* Cities with revenue > ₹10 lakh
* Customers with more than 5 orders
* Products sold more than 1,000 times

---

# Module 11 — CASE

## Topics

```sql
CASE
WHEN
THEN
ELSE
END
```

## Example

```sql
SELECT
    ProductName,
    Price,
    CASE
        WHEN Price >= 50000 THEN 'Premium'
        WHEN Price >= 20000 THEN 'Mid Range'
        ELSE 'Budget'
    END AS ProductCategory
FROM Products;
```

## Practical Applications

* Customer segmentation
* Product classification
* Salary bands
* Risk categories
* Performance categories

---

# Module 12 — String Functions

## Topics

```sql
UPPER()
LOWER()
LEN()
LENGTH()
TRIM()
LTRIM()
RTRIM()
SUBSTRING()
LEFT()
RIGHT()
CONCAT()
REPLACE()
```

## Practical Problems

* Clean customer names
* Extract first name
* Extract last name
* Create full name
* Find email domains
* Remove unwanted spaces
* Replace invalid characters

---

# Module 13 — Date and Time Functions

## Topics

```sql
CURRENT_DATE
CURRENT_TIMESTAMP
YEAR()
MONTH()
DAY()
DATEADD()
DATEDIFF()
EXTRACT()
```

## Practical Problems

* Customers registered this year
* Sales from last month
* Employees with more than 5 years of experience
* Monthly sales
* Yearly sales
* Orders placed today

---

# Module 14 — CRUD Operations

CRUD:

```text
C → CREATE
R → READ
U → UPDATE
D → DELETE
```

## INSERT

```sql
INSERT INTO Customer
(
    CustomerID,
    FirstName,
    LastName
)
VALUES
(
    101,
    'Dani',
    'K'
);
```

## SELECT

```sql
SELECT *
FROM Customer;
```

## UPDATE

```sql
UPDATE Customer
SET City = 'Coimbatore'
WHERE CustomerID = 101;
```

## DELETE

```sql
DELETE FROM Customer
WHERE CustomerID = 101;
```

## Important Rule

> Always be extremely careful with `UPDATE` and `DELETE` without a `WHERE` clause.

---

# Module 15 — DDL

## Topics

```sql
CREATE
ALTER
DROP
TRUNCATE
```

## Example

```sql
CREATE TABLE Employee
(
    EmployeeID INT,
    Name VARCHAR(100),
    Salary DECIMAL(12,2)
);
```

---

# Module 16 — Constraints

## Topics

```text
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
DEFAULT
```

## Practical Applications

* Prevent duplicate customers
* Maintain relationships
* Prevent invalid values
* Enforce mandatory fields
* Maintain data integrity

---

# BASIC PROJECT

# Retail Sales Analysis

Build the following database:

```text
Customers
Products
Categories
Orders
OrderDetails
Employees
Stores
Payments
```

## Business Questions

1. Find all customers.
2. Find customers from Chennai.
3. Find the top 10 products.
4. Find the most expensive product.
5. Find total sales.
6. Find average order value.
7. Find sales by city.
8. Find sales by product.
9. Find sales by month.
10. Find the top customers.
11. Find products that were never sold.
12. Find customers who never placed an order.
13. Find the best-performing store.
14. Find the highest-paid employee.
15. Categorize products by price.

---

# 4. LEVEL 2 — INTERMEDIATE SQL

## Goal

Move from:

> "Retrieve data"

to:

> "Combine and analyze data."

---

# Module 17 — JOINs

## Topics

```sql
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN
CROSS JOIN
SELF JOIN
```

## Fundamental Relationship

```text
Customers
    │
    │ CustomerID
    ▼
Orders
    │
    │ OrderID
    ▼
OrderDetails
    │
    │ ProductID
    ▼
Products
```

## Example

```sql
SELECT
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID;
```

---

# Module 18 — Multi-Table JOINs

Learn how to join:

```text
Customer
    ↓
Order
    ↓
OrderDetail
    ↓
Product
    ↓
Category
```

## Practical Problems

* Customer purchase history
* Product sales
* Category revenue
* Customer spending
* Product profitability

---

# Module 19 — SELF JOIN

Used when a table references itself.

## Example

```text
Employee
----------------
EmployeeID
EmployeeName
ManagerID
```

## Business Problem

> Show every employee and their manager.

---

# Module 20 — Subqueries

## Types

```text
Scalar Subquery
Single-row Subquery
Multi-row Subquery
Subquery in WHERE
Subquery in SELECT
Subquery in FROM
Subquery in HAVING
```

## Example

Find products more expensive than average:

```sql
SELECT *
FROM Products
WHERE Price >
(
    SELECT AVG(Price)
    FROM Products
);
```

---

# Module 21 — Correlated Subqueries

## Concept

```text
Normal Subquery
      ↓
Runs independently

Correlated Subquery
      ↓
Depends on outer query
```

## Practical Problem

> Find employees earning more than the average salary of their own department.

---

# Module 22 — EXISTS and NOT EXISTS

## Topics

```sql
EXISTS
NOT EXISTS
```

## Example

Find customers who have placed at least one order:

```sql
SELECT *
FROM Customers c
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);
```

---

# Module 23 — Set Operators

## Topics

```sql
UNION
UNION ALL
INTERSECT
EXCEPT
```

## Concepts

```text
UNION
→ Combines results and removes duplicates

UNION ALL
→ Combines results without removing duplicates

INTERSECT
→ Returns common records

EXCEPT
→ Returns records in first query but not second
```

---

# Module 24 — Common Table Expressions

## Topics

```sql
WITH
CTE
Multiple CTEs
CTE chains
Recursive CTEs
```

## Example

```sql
WITH CustomerSales AS
(
    SELECT
        CustomerID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY CustomerID
)
SELECT *
FROM CustomerSales
WHERE TotalSales > 100000;
```

## Benefits

* Readability
* Maintainability
* Debugging
* Complex transformations
* Recursive processing

---

# Module 25 — Window Functions

## Fundamental Syntax

```sql
function()
OVER
(
    PARTITION BY ...
    ORDER BY ...
)
```

## First Functions

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
```

## Example

```sql
SELECT
    ProductName,
    Sales,
    RANK() OVER
    (
        ORDER BY Sales DESC
    ) AS SalesRank
FROM ProductSales;
```

---

# Module 26 — Advanced Window Functions

## Topics

```sql
LAG()
LEAD()
FIRST_VALUE()
LAST_VALUE()
NTILE()
```

## Practical Problems

* Previous month's sales
* Next month's sales
* Month-over-month growth
* Previous customer transaction
* Customer purchase sequence
* Top N products per category

---

# Module 27 — Running Totals

## Example

```sql
SELECT
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER
    (
        ORDER BY SaleDate
    ) AS RunningSales
FROM Sales;
```

## Applications

* Cumulative revenue
* Running inventory
* Running balance
* Portfolio value

---

# Module 28 — Ranking Problems

Master:

```text
Top 1
Top N
Top N per group
Second highest
Nth highest
Highest per department
```

## Practical Problems

* Top 3 employees per department
* Top 5 products per category
* Highest-paid employee per department
* Second-highest salary

---

# Module 29 — Advanced Date Analysis

## Topics

```text
Date difference
Date addition
Date truncation
Calendar tables
Fiscal years
Rolling periods
Monthly aggregation
Year-over-year analysis
Month-over-month analysis
```

## Business Applications

```text
YoY growth
MoM growth
Customer retention
Employee tenure
Sales trends
```

---

# Module 30 — Conditional Aggregation

## Example

```sql
SELECT
    SUM(
        CASE
            WHEN Gender = 'M' THEN 1
            ELSE 0
        END
    ) AS MaleEmployees,

    SUM(
        CASE
            WHEN Gender = 'F' THEN 1
            ELSE 0
        END
    ) AS FemaleEmployees
FROM Employees;
```

## Applications

* KPI reports
* Dashboard queries
* Conditional counts
* Business segmentation
* Pivot-like reporting

---

# Module 31 — Pivot and Unpivot

## Topics

```text
PIVOT
UNPIVOT
Conditional aggregation
```

## Example Output

```text
             2024    2025    2026
Chennai      10K     15K     20K
Bangalore    20K     25K     30K
Coimbatore   15K     18K     25K
```

---

# Module 32 — Views

## Topics

```sql
CREATE VIEW
ALTER VIEW
DROP VIEW
```

## Applications

* Reusable reports
* Security abstraction
* Simplifying complex queries
* BI reporting

---

# Module 33 — Temporary Tables

Understand:

```text
Temporary Tables
Table Variables
CTEs
```

Know when to use each.

---

# Module 34 — Transactions

## Topics

```sql
BEGIN TRANSACTION
COMMIT
ROLLBACK
SAVEPOINT
```

## ACID

```text
A → Atomicity
C → Consistency
I → Isolation
D → Durability
```

---

# INTERMEDIATE PROJECT

# E-Commerce Analytics Platform

## Tables

```text
Customers
Products
Categories
Orders
OrderDetails
Payments
Returns
Reviews
Employees
```

## Business Problems

1. Top customers
2. Customer lifetime value
3. Repeat customers
4. Churned customers
5. Top products
6. Category performance
7. Monthly revenue
8. Year-over-year growth
9. Average order value
10. Customer ranking
11. Top 3 products per category
12. Returned products
13. Revenue lost due to returns
14. Customer purchase frequency
15. Product profitability
16. Customers with no purchases
17. Products with no sales
18. Monthly customer acquisition
19. Customer retention
20. Sales contribution by category

---

# 5. LEVEL 3 — ADVANCED SQL

## Goal

Move from:

> "Writing SQL"

to:

> "Writing production-quality SQL."

---

# Module 35 — Advanced Query Design

Topics:

```text
Complex JOINs
Nested queries
Multiple CTEs
CTE chains
Window + aggregation
Subquery + window functions
Conditional aggregation
Complex filtering
```

---

# Module 36 — Recursive CTE

## Applications

```text
Organization hierarchy
Folder structures
Bill of materials
Parent-child relationships
Graph-like relationships
```

## Example Hierarchy

```text
CEO
 │
 ├── Director
 │     │
 │     ├── Manager
 │     │     └── Team
 │     │
 │     └── Manager
 │
 └── Director
```

---

# Module 37 — Advanced Window Functions

## Topics

```text
ROWS
RANGE
GROUPS
Window frames
PARTITION BY
ORDER BY
```

## Practical Problems

* Rolling 7-day average
* Rolling 30-day revenue
* Moving average
* Running balance
* Cumulative percentage
* Previous/next transaction

---

# Module 38 — Advanced Analytics

Learn SQL patterns for:

```text
Cohort Analysis
Customer Retention
Customer Churn
Customer Segmentation
Pareto Analysis
Market Basket Analysis
Funnel Analysis
Sessionization
Time-Series Analysis
```

---

# Module 39 — Data Quality SQL

Use SQL to identify:

```text
Duplicate records
NULL values
Invalid values
Orphan records
Referential integrity problems
Invalid dates
Negative values
Outliers
Missing records
Unexpected values
```

## Example

Find duplicate emails:

```sql
SELECT
    Email,
    COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;
```

---

# Module 40 — SQL Performance

## Topics

```text
Indexes
Clustered Index
Non-Clustered Index
Composite Index
Covering Index
Execution Plans
Statistics
Cardinality
Table Scan
Index Scan
Index Seek
```

---

# Module 41 — Query Optimization

## Optimization Areas

```text
JOINs
WHERE
GROUP BY
ORDER BY
Subqueries
CTEs
Window Functions
Indexes
Data Types
Filtering
Partitioning
```

## Optimization Process

```text
Bad Query
    ↓
Execution Plan
    ↓
Identify Bottleneck
    ↓
Optimize
    ↓
Execute Again
    ↓
Compare Performance
```

---

# Module 42 — Transactions and Concurrency

## Topics

```text
ACID
Locks
Blocking
Deadlocks
Isolation Levels
Dirty Reads
Non-Repeatable Reads
Phantom Reads
```

## Isolation Levels

```text
READ UNCOMMITTED
READ COMMITTED
REPEATABLE READ
SERIALIZABLE
SNAPSHOT
```

---

# Module 43 — Stored Procedures

## Topics

```sql
CREATE PROCEDURE
ALTER PROCEDURE
EXEC
DROP PROCEDURE
```

Also learn:

```text
Parameters
Output Parameters
Error Handling
Transactions
Dynamic SQL
```

---

# Module 44 — User Defined Functions

## Topics

```text
Scalar Functions
Table-Valued Functions
Inline Table-Valued Functions
```

---

# Module 45 — Triggers

## Topics

```text
INSERT Trigger
UPDATE Trigger
DELETE Trigger
```

## Applications

```text
Audit
History
Validation
Change Tracking
```

Also understand:

> When NOT to use triggers.

---

# Module 46 — Dynamic SQL

## Topics

```text
Dynamic SQL
Parameterized SQL
SQL Injection
sp_executesql
```

## Security Focus

Never concatenate untrusted user input directly into SQL.

---

# Module 47 — SQL Security

## Topics

```text
Users
Roles
Permissions
GRANT
REVOKE
DENY
Row-Level Security
SQL Injection
Least Privilege
```

---

# Module 48 — Database Design

## Normalization

```text
1NF
2NF
3NF
BCNF
```

## Denormalization

Understand:

* Why denormalization is required
* When to denormalize
* Performance implications

## Data Warehouse Modeling

```text
Fact Tables
Dimension Tables
Star Schema
Snowflake Schema
Surrogate Keys
Natural Keys
```

---

# Module 49 — SQL for Data Engineering

This module is particularly important for Data Engineers.

## Technologies

```text
SQL Server
PostgreSQL
Oracle
MySQL
BigQuery
Snowflake
Redshift
Databricks SQL
Spark SQL
```

## ETL / ELT

```text
Source
  ↓
Staging
  ↓
Validation
  ↓
Transformation
  ↓
Target
```

---

# Module 50 — Incremental Loading

Learn:

```text
Full Load
Incremental Load
Watermark
Last Modified Date
High-Water Mark
```

## Example

```text
First Run
---------
Load everything

Next Run
--------
Load only records where
ModifiedDate > LastSuccessfulRun
```

---

# Module 51 — Change Data Capture

Learn:

```text
CDC
Insert
Update
Delete
Change Tracking
Audit Columns
```

---

# Module 52 — Slowly Changing Dimensions

## Types

```text
SCD Type 0
SCD Type 1
SCD Type 2
SCD Type 3
```

Focus especially on:

```text
SCD Type 1
SCD Type 2
```

---

# Module 53 — MERGE / UPSERT

## Business Requirement

```text
If record exists
    → UPDATE

If record doesn't exist
    → INSERT
```

Typical pattern:

```text
Source
  ↓
Staging
  ↓
Validation
  ↓
Deduplication
  ↓
MERGE / UPSERT
  ↓
Target
```

---

# Module 54 — Advanced SQL Patterns

Master these patterns:

1. Second highest salary
2. Nth highest salary
3. Top N per department
4. Duplicate records
5. Remove duplicates
6. Employees earning above department average
7. Customers who never purchased
8. Products never sold
9. Consecutive dates
10. Gaps and islands
11. Running total
12. Moving average
13. Year-over-year growth
14. Month-over-month growth
15. Latest record per customer
16. First transaction
17. Last transaction
18. Top 3 products per category
19. Customer retention
20. Customer churn
21. Duplicate detection
22. Missing sequence detection
23. Consecutive login days
24. Longest customer activity streak
25. Percentage contribution
26. Pareto analysis
27. Median calculation
28. Rolling averages
29. Ranking within groups
30. Change detection

---

# 6. SQL Interview Preparation

## Basic Interview Questions

* What is SQL?
* What is a database?
* What is a table?
* What is a primary key?
* What is a foreign key?
* What is NULL?
* Difference between DELETE and TRUNCATE?
* Difference between WHERE and HAVING?
* Difference between UNION and UNION ALL?

## Intermediate Questions

* Explain different JOIN types.
* What is a subquery?
* What is a correlated subquery?
* What is a CTE?
* CTE vs temporary table?
* What are window functions?
* RANK vs DENSE_RANK?
* ROW_NUMBER vs RANK?
* EXISTS vs IN?
* WHERE vs HAVING?

## Advanced Questions

* How do you optimize a slow query?
* What is an execution plan?
* What is an index?
* Clustered vs non-clustered index?
* What causes deadlocks?
* Explain transaction isolation levels.
* What is SCD Type 2?
* How do you implement incremental loading?
* How do you remove duplicates?
* How do you find gaps and islands?
* How do you calculate rolling averages?
* How do you implement customer retention?

---

# 7. Recommended Practical Database

## Primary Database

Use:

```text
AdventureWorks
```

because it provides realistic business entities such as:

```text
Customers
Products
Sales
Employees
Departments
Addresses
Vendors
Purchasing
Production
Inventory
```

The same SQL concepts can then be practiced against:

```text
PostgreSQL
SQL Server
MySQL
Oracle
BigQuery
Snowflake
Databricks SQL
```

---

# 8. Practical Learning Method

For every topic, use this structure:

```text
1. BUSINESS PROBLEM
        ↓
2. UNDERSTAND DATA
        ↓
3. IDENTIFY TABLES
        ↓
4. THINK ABOUT LOGIC
        ↓
5. WRITE SQL
        ↓
6. EXECUTE
        ↓
7. ANALYZE RESULT
        ↓
8. EXPLAIN EVERY CLAUSE
        ↓
9. COMMON MISTAKES
        ↓
10. OPTIMIZE
        ↓
11. SOLVE SIMILAR PROBLEMS
```

---

# 9. Standard Format for Every SQL Topic

Every lesson should contain:

## 1. Concept

What is it?

## 2. Syntax

What is the syntax?

## 3. Simple Example

A beginner-friendly example.

## 4. Real Business Scenario

Why would a company need this?

## 5. AdventureWorks Example

A realistic database example.

## 6. Query Explanation

Explain each clause.

## 7. Expected Result

Show what the query produces.

## 8. Common Mistakes

Show incorrect approaches.

## 9. When to Use

Explain practical applicability.

## 10. When NOT to Use

Explain alternatives.

## 11. Interview Question

Provide common interview questions.

## 12. Practice Exercises

Provide exercises without answers.

## 13. Challenge

Give a real-world scenario requiring independent thinking.

---

# 10. Project Progression

## Project 1 — Retail Sales

### Level

Basic

### Skills

```text
SELECT
WHERE
ORDER BY
GROUP BY
HAVING
CASE
Aggregations
Dates
Strings
```

---

## Project 2 — E-Commerce Analytics

### Level

Intermediate

### Skills

```text
JOINs
Subqueries
CTEs
Window Functions
Aggregations
Ranking
Date Analysis
```

---

## Project 3 — Banking Analytics

### Level

Intermediate → Advanced

### Tables

```text
Customers
Accounts
Transactions
Branches
Loans
Payments
Cards
```

### Problems

```text
Fraud transactions
Customer balances
Monthly transactions
High-value customers
Loan defaults
Customer segmentation
Transaction trends
```

---

## Project 4 — Healthcare Analytics

### Tables

```text
Patients
Doctors
Appointments
Diagnoses
Prescriptions
Billing
Hospitals
```

### Problems

```text
Patient visits
Doctor performance
Hospital utilization
Treatment trends
Billing analysis
Readmission analysis
```

---

## Project 5 — Data Engineering ETL

Build:

```text
Source
  ↓
Landing
  ↓
Staging
  ↓
Validation
  ↓
Transformation
  ↓
Warehouse
  ↓
Reporting
```

Use SQL for:

```text
Deduplication
Data validation
Incremental loading
CDC
SCD Type 2
MERGE
Audit
Reconciliation
```

---

# 11. Final SQL Skill Matrix

| Skill              | Basic | Intermediate | Advanced |
| ------------------ | :---: | :----------: | :------: |
| SELECT             |   ✓   |       ✓      |     ✓    |
| WHERE              |   ✓   |       ✓      |     ✓    |
| ORDER BY           |   ✓   |       ✓      |     ✓    |
| DISTINCT           |   ✓   |       ✓      |     ✓    |
| NULL               |   ✓   |       ✓      |     ✓    |
| CASE               |   ✓   |       ✓      |     ✓    |
| Aggregation        |   ✓   |       ✓      |     ✓    |
| GROUP BY           |   ✓   |       ✓      |     ✓    |
| HAVING             |   ✓   |       ✓      |     ✓    |
| String Functions   |   ✓   |       ✓      |     ✓    |
| Date Functions     |   ✓   |       ✓      |     ✓    |
| CRUD               |   ✓   |       ✓      |     ✓    |
| DDL                |   ✓   |       ✓      |     ✓    |
| Constraints        |   ✓   |       ✓      |     ✓    |
| JOINs              |       |       ✓      |     ✓    |
| Subqueries         |       |       ✓      |     ✓    |
| EXISTS             |       |       ✓      |     ✓    |
| Set Operators      |       |       ✓      |     ✓    |
| CTE                |       |       ✓      |     ✓    |
| Window Functions   |       |       ✓      |     ✓    |
| Ranking            |       |       ✓      |     ✓    |
| Pivot              |       |       ✓      |     ✓    |
| Views              |       |       ✓      |     ✓    |
| Temporary Tables   |       |       ✓      |     ✓    |
| Transactions       |       |       ✓      |     ✓    |
| Recursive CTE      |       |              |     ✓    |
| Advanced Windows   |       |              |     ✓    |
| Analytics          |       |              |     ✓    |
| Data Quality       |       |              |     ✓    |
| Indexes            |       |              |     ✓    |
| Execution Plans    |       |              |     ✓    |
| Query Optimization |       |              |     ✓    |
| Concurrency        |       |              |     ✓    |
| Stored Procedures  |       |              |     ✓    |
| Functions          |       |              |     ✓    |
| Triggers           |       |              |     ✓    |
| Dynamic SQL        |       |              |     ✓    |
| Security           |       |              |     ✓    |
| Data Modeling      |       |              |     ✓    |
| ETL/ELT SQL        |       |              |     ✓    |
| CDC                |       |              |     ✓    |
| SCD                |       |              |     ✓    |
| MERGE/UPSERT       |       |              |     ✓    |

---

# 12. Overall Learning Target

By the end of the course, the learner should be able to go from:

```text
"I know SELECT."
```

to:

```text
"I can take a real business problem,
understand the data,
design the SQL,
write the query,
validate the result,
optimize the query,
and explain why my solution is correct."
```

---

# 13. Final Roadmap

```text
                    SQL MASTERY
                         │
                         ▼
              ┌──────────────────┐
              │ SQL FUNDAMENTALS │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ BASIC SQL        │
              │ SELECT           │
              │ WHERE            │
              │ GROUP BY         │
              │ HAVING           │
              │ CASE             │
              │ FUNCTIONS        │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ INTERMEDIATE     │
              │ JOINs             │
              │ SUBQUERIES       │
              │ CTE              │
              │ WINDOW FUNCTIONS │
              │ ANALYTICS        │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ ADVANCED         │
              │ OPTIMIZATION     │
              │ INDEXES          │
              │ TRANSACTIONS     │
              │ SECURITY         │
              │ PROCEDURES       │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ DATA ENGINEERING │
              │ ETL / ELT        │
              │ CDC              │
              │ SCD              │
              │ MERGE            │
              │ DATA QUALITY     │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ REAL PROJECTS    │
              │ RETAIL           │
              │ E-COMMERCE       │
              │ BANKING          │
              │ HEALTHCARE       │
              │ DATA ENGINEERING │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ SQL INTERVIEWS   │
              │ 100+ PROBLEMS    │
              └──────────────────┘
```

---

# Recommended Next Step

Build the course in this order:

```text
01_SQL_Fundamentals.md
02_SELECT.md
03_WHERE_Filtering.md
04_ORDER_BY_Distinct_Top.md
05_SQL_Expressions.md
06_NULL_Handling.md
07_CASE_Statements.md
08_Aggregate_Functions.md
09_GROUP_BY.md
10_HAVING.md
11_String_Functions.md
12_Date_Functions.md
13_CRUD.md
14_DDL.md
15_Constraints.md
16_Basic_SQL_Project.md

17_JOINs.md
18_Multi_Table_JOINs.md
19_Subqueries.md
20_Correlated_Subqueries.md
21_EXISTS.md
22_Set_Operators.md
23_CTE.md
24_Window_Functions.md
25_Advanced_Window_Functions.md
26_Date_Analytics.md
27_Conditional_Aggregation.md
28_Views_Temporary_Tables.md
29_Transactions.md
30_Intermediate_SQL_Project.md

31_Recursive_CTE.md
32_Advanced_Analytics.md
33_Data_Quality.md
34_SQL_Performance.md
35_Query_Optimization.md
36_Indexes.md
37_Execution_Plans.md
38_Concurrency.md
39_Stored_Procedures.md
40_Functions.md
41_Triggers.md
42_Dynamic_SQL.md
43_SQL_Security.md
44_Data_Modeling.md
45_ETL_ELT_SQL.md
46_CDC.md
47_SCD.md
48_MERGE_UPSERT.md
49_Advanced_SQL_Patterns.md
50_Advanced_SQL_Project.md

51_SQL_Interview_Questions.md
52_SQL_Coding_Problems.md
53_SQL_Cheat_Sheet.md
54_SQL_Real_World_Scenarios.md
55_SQL_Final_Project.md
```

**Target:** Learn SQL by solving **real problems first**, with **AdventureWorks as the primary practice database**, and progressively move toward **Data Engineering, Analytics, Performance Optimization, and SQL interviews**.
