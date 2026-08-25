/*
===============================================================================
SQL ADVANCED / PERFORMANCE NOTEBOOK
Topics covered before moving into Data Warehousing

Order:
1. Quick recap: SQL object types and persistence
2. Views
3. Temporary Tables
4. CTE vs Temporary Table vs View - comparison demo
5. DCL - GRANT / REVOKE (conceptual + demo)
6. Indexing fundamentals
7. EXPLAIN / Execution Plans
8. Query Optimization Techniques
9. Performance Benchmarking
10. Final checklist before DWH

Assumptions:
- MySQL 8.x
- HR-style database is available
- Tables used:
      employees
      departments
- Typical columns:
      employees(employee_id, first_name, last_name, department_id, salary)
      departments(department_id, department_name)

IMPORTANT:
- The examples are intentionally simple so they can be demonstrated directly.
- Run the statements in the same order where a dependency exists.
- Some statements such as CREATE INDEX may fail if the index already exists.
  In that case, inspect existing indexes with SHOW INDEXES and use another name.
===============================================================================
*/


/*
===============================================================================
1. QUICK RECAP: THREE WAYS TO CREATE REUSABLE / INTERMEDIATE RESULTS
===============================================================================

A VIEW:
- A permanent database object.
- Stores the SQL definition, not normally a separate copy of the result.
- Can be queried repeatedly after it is created.
- Useful for reusable business logic and simplified reporting queries.

A TEMPORARY TABLE:
- A temporary physical table created for the current database session.
- Can be referenced by multiple SQL statements during that session.
- Automatically disappears when the session ends.
- Useful when intermediate data must be reused across multiple statements.

A CTE:
- A named temporary result set for ONE SQL statement.
- Exists only for the statement in which the WITH clause appears.
- It is NOT a table that remains available for the next SELECT.

Simple mental model:

VIEW
    -> permanent database object
    -> reusable across sessions

TEMPORARY TABLE
    -> temporary table
    -> reusable across statements in the current session

CTE
    -> temporary named result
    -> available only inside one SQL statement

The three are NOT interchangeable in every situation.
*/


/*
===============================================================================
2. VIEWS
===============================================================================

Why create a view?

Suppose analysts frequently need employee information together with
department information.

Instead of repeatedly writing the JOIN, we can create a VIEW once.

The view hides query complexity and gives users a simple logical table.
*/


/*
2.1 Create a simple view
-------------------------------------------------------------------------------
This view combines employees and departments.
*/
DROP VIEW IF EXISTS vw_employee_department;

CREATE VIEW vw_employee_department AS
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id;


/*
2.2 Query the view

Notice that the view behaves like a table from the user's perspective.
*/
SELECT *
FROM vw_employee_department;


/*
2.3 Filter the view

The view itself contains the reusable JOIN logic.
We can now apply normal SQL conditions on top of it.
*/
SELECT
    employee_id,
    first_name,
    last_name,
    department_name,
    salary
FROM vw_employee_department
WHERE salary > 5000;


/*
2.4 Use the view for reporting

A view can also be used as the source of an aggregate query.
*/
SELECT
    department_name,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM vw_employee_department
GROUP BY department_name;


/*
2.5 Inspect the view definition
*/
SHOW CREATE VIEW vw_employee_department;


/*
2.6 Remove the view when it is no longer required
*/
-- DROP VIEW IF EXISTS vw_employee_department;


/*
IMPORTANT VIEW CONCEPT

A normal VIEW is not the same as a table containing a permanent copy
of the query result.

Think:

CREATE VIEW
      |
      +--> saves the query definition
      |
      +--> SELECT from the view later
      |
      +--> database executes the underlying logic as required

Materialized views are a different concept and are not the focus here.
*/


/*
===============================================================================
3. TEMPORARY TABLES
===============================================================================

Why use a temporary table?

Suppose we want to identify employees earning above a certain salary and
perform several operations on that intermediate dataset.

A temporary table lets us save that intermediate result and reuse it
across multiple statements during the current session.
*/


/*
3.1 Create a temporary table
-------------------------------------------------------------------------------
CREATE TEMPORARY TABLE means this table belongs to the current session.
*/
DROP TEMPORARY TABLE IF EXISTS temp_high_salary_employees;

CREATE TEMPORARY TABLE temp_high_salary_employees AS
SELECT
    employee_id,
    first_name,
    last_name,
    department_id,
    salary
FROM employees
WHERE salary > 5000;


/*
3.2 Query the temporary table
*/
SELECT *
FROM temp_high_salary_employees;


/*
3.3 Reuse the same temporary table in another statement

This is one of the important differences from a CTE.
*/
SELECT
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary
FROM temp_high_salary_employees;


/*
3.4 Join the temporary table to another table
*/
SELECT
    t.employee_id,
    t.first_name,
    t.last_name,
    t.salary,
    d.department_name
FROM temp_high_salary_employees t
LEFT JOIN departments d
    ON t.department_id = d.department_id;


/*
3.5 Temporary tables disappear automatically when the database session ends.

You can also explicitly remove one:
*/
DROP TEMPORARY TABLE IF EXISTS temp_high_salary_employees;


/*
===============================================================================
4. CTE vs TEMPORARY TABLE vs VIEW
===============================================================================

The CTE section is only a recap because CTEs have already been covered.

A CTE is useful when the intermediate result is needed only inside ONE
complex statement.

Example:
*/

WITH high_salary_employees AS
(
    SELECT
        employee_id,
        first_name,
        last_name,
        salary,
        department_id
    FROM employees
    WHERE salary > 5000
)
SELECT
    h.employee_id,
    h.first_name,
    h.last_name,
    h.salary,
    d.department_name
FROM high_salary_employees h
LEFT JOIN departments d
    ON h.department_id = d.department_id;


/*
IMPORTANT:

The following does NOT work:

WITH high_salary_employees AS (...)
SELECT ...;

SELECT *
FROM high_salary_employees;

Why?

Because the CTE exists only for the single statement immediately following
the WITH clause.

This is different from a temporary table.
*/


/*
COMPARISON TABLE

VIEW
----
Lifetime:
    Permanent until DROP VIEW.

Can be reused in later statements?
    YES.

Can be reused in another session?
    YES.

Main purpose:
    Reusable query logic / reporting abstraction.

TEMPORARY TABLE
---------------
Lifetime:
    Current database session.

Can be reused in later statements?
    YES.

Can be reused after session closes?
    NO.

Main purpose:
    Intermediate data that must be reused across multiple statements.

CTE
---
Lifetime:
    One SQL statement.

Can be reused in later statements?
    NO.

Main purpose:
    Make one complex query easier to read, structure and maintain.

Easy rule:

    One query       -> CTE
    Several queries -> TEMPORARY TABLE
    Reusable logic  -> VIEW
*/


/*
===============================================================================
5. DCL - DATA CONTROL LANGUAGE
===============================================================================

DCL controls access to database objects.

The two core commands in this curriculum are:

GRANT
    -> give privileges

REVOKE
    -> remove privileges

For a BI / analytics audience, focus on understanding the security model
rather than server administration.
*/


/*
5.1 Example: create an analyst user

The exact syntax and permissions depend on the environment.
Run user-management commands only if you have administrative privileges.

Example:
*/

-- CREATE USER 'analyst_demo'@'localhost' IDENTIFIED BY 'StrongPassword123!';


/*
5.2 Grant SELECT permission

This allows the user to read the table.
*/

-- GRANT SELECT ON employees TO 'analyst_demo'@'localhost';


/*
5.3 Revoke SELECT permission
*/

-- REVOKE SELECT ON employees FROM 'analyst_demo'@'localhost';


/*
5.4 View current grants
*/

-- SHOW GRANTS FOR 'analyst_demo'@'localhost';


/*
Security mental model:

USER
  |
  +--> ROLE
          |
          +--> PRIVILEGES
                    |
                    +--> DATABASE
                    +--> SCHEMA
                    +--> TABLE
                    +--> VIEW
                    +--> etc.

For BI developers, understand what access is required and why.
Detailed backup/server administration is outside the core BI focus here.
*/


/*
===============================================================================
6. INDEXING FUNDAMENTALS
===============================================================================

An index is a data structure that can help the database locate rows faster.

Without a useful index:

    Query
      |
      v
    Table scan
      |
      v
    Many rows may be examined

With a useful index:

    Query
      |
      v
    Index lookup
      |
      v
    Candidate rows found more efficiently

Important:
An index is NOT automatically faster for every query.

Indexes also:
- consume storage
- require maintenance when data changes
- can slow INSERT / UPDATE / DELETE operations
- are most useful when designed for actual query patterns
*/


/*
6.1 Inspect existing indexes

Always inspect the table before creating a new index.
*/
SHOW INDEXES FROM employees;


/*
6.2 Create a single-column index

Suppose this query is executed frequently:
*/
SELECT *
FROM employees
WHERE department_id = 60;


/*
Create an index on department_id.
*/
CREATE INDEX idx_emp_department_demo
ON employees(department_id);


/*
6.3 Test the same query again with EXPLAIN

The execution plan can now be inspected.
*/
EXPLAIN
SELECT *
FROM employees
WHERE department_id = 60;


/*
6.4 Composite indexes

Suppose the common query pattern is:

    WHERE department_id = ?
    AND salary > ?

A composite index may be useful.
*/
CREATE INDEX idx_emp_dept_salary_demo
ON employees(department_id, salary);


/*
Test:
*/
EXPLAIN
SELECT *
FROM employees
WHERE department_id = 60
  AND salary > 5000;


/*
IMPORTANT COMPOSITE INDEX RULE

Index:
    (department_id, salary)

The leading column matters.

Conceptually:

    department_id
          |
       salary

A query filtering on department_id can potentially use the index effectively.

A query filtering only on salary may not benefit from this composite index
in the same way.

Do not memorize blindly.
The optimizer, data distribution and query shape all matter.
*/


/*
6.5 Unique index

A unique index enforces uniqueness in addition to providing an index.

Example:
*/
-- CREATE UNIQUE INDEX idx_demo_unique_email
-- ON employees(email);


/*
Do not run the above unless an email column exists and the values are unique.
*/


/*
6.6 Drop a demonstration index if required

Run only when you want to remove the demo index.
*/
-- DROP INDEX idx_emp_department_demo ON employees;
-- DROP INDEX idx_emp_dept_salary_demo ON employees;


/*
===============================================================================
7. CLUSTERED INDEX - CONCEPTUAL DEMO
===============================================================================

Clustered indexing is database-engine specific.

The important concept is:

A clustered index determines how table rows are physically/logically organized
around the index structure in systems that implement clustered indexes that way.

Do NOT confuse this with data-warehouse clustering such as Snowflake
micro-partition clustering.

For this course:
- Understand the concept.
- Know clustered vs non-clustered at a high level.
- Focus more on indexing strategy and EXPLAIN than on DBA-level internals.

Primary keys are commonly associated with clustered storage in some database
systems, but the exact implementation differs between RDBMS products.
*/


/*
===============================================================================
8. EXPLAIN AND EXECUTION PLANS
===============================================================================

EXPLAIN is one of the most important tools for understanding query performance.

Instead of asking only:

    "Does my query return the correct answer?"

we also ask:

    "HOW is the database executing my query?"

Use EXPLAIN:
*/
EXPLAIN
SELECT *
FROM employees
WHERE department_id = 60;


/*
For a JOIN:
*/
EXPLAIN
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    d.department_name
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.salary > 5000;


/*
Things worth looking at in an execution plan include:

- table being accessed
- access type
- possible indexes
- chosen index
- number of rows estimated/examined
- filtering
- join order
- extra operations

The exact columns and terminology depend on the MySQL version and
EXPLAIN format.

Key idea:

SQL statement
     |
     v
Query Optimizer
     |
     v
Execution Plan
     |
     v
Actual data access
*/


/*
===============================================================================
9. QUERY OPTIMIZATION
===============================================================================

Optimization is not "write shorter SQL."

Optimization means reducing unnecessary work while preserving correctness.

A practical optimization checklist:

1. Filter early where appropriate.
2. Avoid SELECT * when only a few columns are required.
3. Index columns used frequently for filtering/joining when appropriate.
4. Check join conditions carefully.
5. Avoid accidental many-to-many joins.
6. Use appropriate data types.
7. Avoid functions on indexed columns when they prevent useful index access.
8. Check execution plans.
9. Reduce unnecessary sorting.
10. Reduce unnecessary data movement.
11. Aggregate at an appropriate stage.
12. Measure before and after changes.

*/


/*
9.1 Avoid SELECT * when only a few columns are needed
*/

/* Less precise */
SELECT *
FROM employees;

/* Better when only these columns are required */
SELECT
    employee_id,
    first_name,
    salary
FROM employees;


/*
9.2 Filter rows

This reduces the amount of data that subsequent operations may need to process.
*/
SELECT
    employee_id,
    first_name,
    salary
FROM employees
WHERE salary > 5000;


/*
9.3 Avoid unnecessary functions on searchable columns

Example pattern:

Potentially problematic pattern:
*/
-- SELECT *
-- FROM employees
-- WHERE YEAR(hire_date) = 2025;


/*
A range predicate can often be more index-friendly:

Only use this example if hire_date exists.
*/
-- SELECT *
-- FROM employees
-- WHERE hire_date >= '2025-01-01'
--   AND hire_date <  '2026-01-01';


/*
9.4 Avoid unnecessary ORDER BY

Sorting can be expensive, especially on large datasets.

Only sort when the business requirement actually needs an ordered result.
*/


/*
9.5 Watch for accidental row multiplication

Example:

Employees
    1 row per employee

Orders
    many rows per employee

Joining them changes the grain.

Always ask:

    What is the grain of each table?
    What will be the grain after the JOIN?

This is especially important before moving into dimensional modelling.
*/


/*
===============================================================================
10. PERFORMANCE BENCHMARKING
===============================================================================

Benchmarking means measuring performance rather than guessing.

Basic process:

1. Establish a baseline.
2. Run the query.
3. Inspect EXPLAIN / execution information.
4. Make ONE change.
5. Run again.
6. Compare.
7. Keep the change only if it improves the workload without causing
   unacceptable side effects.

Never conclude:
    "This query is faster because it looks better."

Measure it.
*/


/*
10.1 Baseline query
*/
SELECT
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;


/*
10.2 Inspect the plan
*/
EXPLAIN
SELECT
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;


/*
10.3 MySQL timing / execution measurement

For supported MySQL 8.x environments, EXPLAIN ANALYZE can provide
actual execution information in addition to the estimated plan.

Example:
*/
EXPLAIN ANALYZE
SELECT
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;


/*
IMPORTANT:

EXPLAIN:
    primarily helps inspect the optimizer's planned execution.

EXPLAIN ANALYZE:
    executes the query and provides actual execution information
    in MySQL versions that support it.

Use it carefully for expensive queries because it actually executes
the statement.
*/


/*
===============================================================================
11. VIEWS vs TEMP TABLES vs CTE - FINAL DEMO
===============================================================================

This section is intentionally simple enough to demonstrate live.

SCENARIO:
"Find employees earning more than 5000 and show their department."

OPTION 1 - CTE
---------------
Good when the intermediate result is needed only for ONE query.
*/

WITH high_salary AS
(
    SELECT *
    FROM employees
    WHERE salary > 5000
)
SELECT
    h.employee_id,
    h.first_name,
    h.salary,
    d.department_name
FROM high_salary h
LEFT JOIN departments d
    ON h.department_id = d.department_id;


/*
OPTION 2 - TEMPORARY TABLE
--------------------------
Good when the intermediate result will be reused by multiple statements.
*/

DROP TEMPORARY TABLE IF EXISTS temp_high_salary;

CREATE TEMPORARY TABLE temp_high_salary AS
SELECT *
FROM employees
WHERE salary > 5000;

SELECT *
FROM temp_high_salary;

SELECT
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM temp_high_salary;

DROP TEMPORARY TABLE IF EXISTS temp_high_salary;


/*
OPTION 3 - VIEW
---------------
Good when the logic is a reusable business/reporting definition.
*/

DROP VIEW IF EXISTS vw_high_salary_employees;

CREATE VIEW vw_high_salary_employees AS
SELECT
    employee_id,
    first_name,
    last_name,
    department_id,
    salary
FROM employees
WHERE salary > 5000;

SELECT *
FROM vw_high_salary_employees;

SELECT
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM vw_high_salary_employees;


/*
Remove the demo view when required:
*/
-- DROP VIEW IF EXISTS vw_high_salary_employees;


/*
===============================================================================
12. FINAL DECISION GUIDE
===============================================================================

Question:
"Do I need the result only inside this one query?"

    YES
      |
      +--> CTE

Question:
"Do I need the intermediate result across several statements
during this session?"

    YES
      |
      +--> TEMPORARY TABLE

Question:
"Is this business/query logic reusable by many queries/users?"

    YES
      |
      +--> VIEW

Question:
"Is the query slow?"

    |
    +--> EXPLAIN
    |
    +--> identify expensive operations
    |
    +--> check indexes
    |
    +--> optimize query
    |
    +--> measure again


===============================================================================
13. FINAL PRE-DWH CHECKLIST
===============================================================================

SQL / Database concepts that should now be comfortable:

[ ] DDL
[ ] DML
[ ] DQL
[ ] Joins
[ ] Subqueries
[ ] Aggregations
[ ] UNION / UNION ALL
[ ] Window functions
[ ] CTEs
[ ] Transactions
[ ] ACID
[ ] COMMIT / ROLLBACK / SAVEPOINT
[ ] Views
[ ] Stored Procedures
[ ] Functions / UDFs
[ ] Triggers

Remaining advanced concepts to understand before/while entering DWH:

[ ] Query optimization
[ ] EXPLAIN / execution plans
[ ] Indexing
[ ] Composite indexes
[ ] Temporary tables
[ ] Performance benchmarking
[ ] DCL / GRANT / REVOKE
[ ] Clustered indexing - conceptual understanding
[ ] DBA topics - conceptual only for this audience

DWH starts next:

[ ] What is a Data Warehouse?
[ ] OLTP vs OLAP
[ ] DWH architecture
[ ] Staging / integration / access layers
[ ] EDW vs Data Mart
[ ] ETL vs ELT
[ ] Batch vs real-time
[ ] Dimensional modelling
[ ] Star schema
[ ] Snowflake schema
[ ] Fact tables
[ ] Dimension tables
[ ] Grain / granularity
[ ] Surrogate keys
[ ] SCD Type 1 / 2 / 3
[ ] Normalization vs denormalization
[ ] Data profiling / cleansing
[ ] Loading strategies
[ ] Error handling / logging
[ ] Cloud DWH
[ ] Snowflake / Databricks / BigQuery / Redshift


===============================================================================
END OF NOTEBOOK
===============================================================================
