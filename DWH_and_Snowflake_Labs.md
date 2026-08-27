# Data Warehousing ---

# 1. The Complete DWH Story

```text
BUSINESS SYSTEMS
      |
      v
SOURCE DATA
      |
      v
INGESTION
      |
      v
LANDING / STAGING
      |
      v
INTEGRATION + TRANSFORMATION
      |
      v
DATA WAREHOUSE
      |
      v
FACT + DIMENSIONS
      |
      v
BI / ANALYTICS
      |
      v
BUSINESS DECISIONS
```

The four-day sequence is essentially:

```text
WHY?
  |
  v
DWH Concepts
  |
  v
HOW IS IT DESIGNED?
  |
  v
Architecture + Modelling
  |
  v
HOW DOES DATA GET THERE?
  |
  v
ETL/ELT + Data Quality
  |
  v
WHERE DOES IT RUN?
  |
  v
Cloud DWH + Snowflake
```

---

# 2. OLTP vs OLAP

## OLTP — Online Transaction Processing

Used to **run the business**.

Examples:

```text
Create order
Update customer
Process payment
Reserve inventory
Update shipment
```

Typical workload:

```text
Many concurrent users
        |
Small transactions
        |
INSERT / UPDATE / DELETE
        |
Current operational state
```

## OLAP — Online Analytical Processing

Used to **analyze the business**.

Examples:

```text
Revenue by month
Revenue by region
Sales by product
Customer lifetime value
Year-over-year growth
Inventory trends
```

Typical workload:

```text
Analysts / BI
      |
Large queries
      |
JOIN + GROUP BY + aggregation
      |
Historical data
      |
Business insight
```

### Core distinction

```text
OLTP = Run the business

OLAP = Analyze the business
```

---

# 3. Why Separate OLTP and OLAP?

An operational database may have millions of transactions while users are still placing orders.

An analytical query may require:

```text
Large scan
   +
Multiple joins
   +
GROUP BY
   +
Aggregations
   +
Historical data
```

Conceptually:

```text
                 OLTP DATABASE
                       |
              +--------+--------+
              |                 |
         Transactions       Analytics
              |                 |
          Small / fast       Large queries
              |                 |
              +--------+--------+
                       |
                Resource pressure
```

A separate analytical environment allows each workload to be optimized for its purpose.

---

# 4. What Is a Data Warehouse?

A practical definition:

> A Data Warehouse is an analytical data environment that integrates data from relevant sources and supports reporting, analytics and historical analysis.

Important ideas:

```text
Integration
Historical data
Analytical workload
Consistent business information
```

A DWH is more than simply a large database.

---

# 5. Benefits and Use Cases

## Historical analysis

```text
2024 ----+
2025 ----+----> Trends
2026 ----+
```

Examples:

- year-over-year revenue
- seasonality
- customer behaviour over time
- product performance

## Integration

```text
ERP --------CRM ---------Website ------> DWH
Payments ----/
Logistics ---/
```

## Consistent reporting

The warehouse can provide standardized analytical definitions and structures.

## Analytical performance

Designed for:

```text
Large datasets
Aggregations
Joins
Historical analysis
Concurrent analytical users
```

## Common use cases

```text
Sales
Customer analytics
Finance
Supply chain
Management reporting
```

---

# 6. DWH Architecture

A simplified architecture:

```text
SOURCE SYSTEMS
      |
      v
INGESTION
      |
      v
STAGING / LANDING
      |
      v
INTEGRATION
      |
      v
DATA WAREHOUSE
      |
      v
DATA MART / ACCESS
      |
      v
BI / ANALYTICS
```

## Source systems

Examples:

```text
MySQL
PostgreSQL
Oracle
SQL Server
ERP
CRM
APIs
CSV / JSON / Parquet
Event streams
Cloud storage
```

## Staging / Landing

Typical purposes:

```text
Receive incoming data
Validate
Preserve source extracts temporarily
Handle malformed records
Prepare transformations
```

## Integration

Typical activities:

```text
Identifier mapping
Data-type standardization
Deduplication
Reference-data mapping
Business rules
Combining sources
```

## Access

```text
DWH
 |
 +-- SQL
 +-- BI
 +-- Analytics
 +-- Data Science
```

---

# 7. EDW vs Data Mart

## Enterprise Data Warehouse

```text
                    EDW
                     |
        +------------+------------+
        |            |            |
      Sales        Finance       HR
```

Broad enterprise scope.

## Data Mart

```text
                    EDW
                     |
       +-------------+-------------+
       |             |             |
   Sales Mart    Finance Mart    HR Mart
```

Focused business/domain scope.

```text
EDW      → enterprise-wide
Data Mart → focused domain
```

---

# 8. DWH Lifecycle

```text
SOURCE
  |
  v
INGEST
  |
  v
LAND / STAGE
  |
  v
TRANSFORM
  |
  v
LOAD / MODEL
  |
  v
VALIDATE
  |
  v
SERVE
  |
  v
ANALYZE
  |
  v
MONITOR
  |
  +----------------------+
                         |
                         v
                    New data
```

---

# 9. Dimensional Modelling

A warehouse model should be designed around analytical questions.

Example:

```text
Revenue
by
Year
Region
Product
Customer Segment
```

This naturally leads to:

```text
FACTS
+
DIMENSIONS
```

---

# 10. Grain

**Grain = what one row represents.**

Examples:

```text
One row = one order
```

or:

```text
One row = one order line
```

or:

```text
One row = one customer-product-day
```

These are different grains.

### Rule

> Define the grain before designing the fact table.

If an order contains three products:

```text
Order grain
    -> 1 row

Order-line grain
    -> 3 rows
```

The measures and joins must be consistent with the chosen grain.

---

# 11. Fact Tables

A fact table represents measurable business events.

Examples:

```text
FACT_SALES
FACT_ORDERS
FACT_PAYMENTS
FACT_SHIPMENTS
FACT_INVENTORY
```

Typical structure:

```text
FACT_SALES

date_key
customer_key
product_key
region_key
quantity
sales_amount
discount_amount
```

A fact table commonly contains:

```text
Foreign keys to dimensions
+
Measures
```

---

# 12. Dimension Tables

Dimensions provide descriptive context.

Examples:

```text
DIM_CUSTOMER
DIM_PRODUCT
DIM_DATE
DIM_REGION
```

Customer:

```text
customer_key
customer_id
customer_name
city
state
segment
```

Product:

```text
product_key
product_id
product_name
category
subcategory
brand
```

Mental model:

```text
FACT
What happened?
How much?
How many?

DIMENSION
Who?
What?
Where?
When?
Which category?
Which segment?
```

---

# 13. Star Schema

```text
                 DIM_DATE
                    |
                    |
DIM_CUSTOMER --- FACT_SALES --- DIM_PRODUCT
                    |
                    |
               DIM_REGION
```

The fact table is central.

Dimensions provide descriptive context.

Typical advantages:

```text
Simple
Easy to understand
BI-friendly
Straightforward analytical joins
```

---

# 14. Snowflake Schema

Star:

```text
DIM_PRODUCT
 |
 +-- category
 +-- subcategory
 +-- brand
```

More normalized Snowflake dimension:

```text
FACT_SALES
    |
    v
DIM_PRODUCT
    |
    +--> DIM_SUBCATEGORY
              |
              +--> DIM_CATEGORY
```

Comparison:

```text
STAR
→ simpler, more denormalized dimensions

SNOWFLAKE
→ more normalized dimensions, potentially more joins
```

---

# 15. Surrogate Keys

A surrogate key is generated by the warehouse.

```text
DIM_CUSTOMER

customer_key | customer_id | customer_name
-------------|-------------|--------------
1            | C101        | Ravi
2            | C102        | Priya
```

Here:

```text
customer_key → surrogate key
customer_id  → business/source key
```

Surrogate keys are particularly useful for:

```text
Historical tracking
Multiple source systems
Stable warehouse relationships
SCD Type 2
```

---

# 16. Slowly Changing Dimensions

SCD handles changes to dimension attributes over time.

Example:

```text
Customer C101
Mumbai
   |
   v
Pune
```

Question:

> Should historical reports continue to show Mumbai for old transactions?

That depends on the SCD strategy.

---

# 17. SCD Type 1

Overwrite the old value.

```sql
UPDATE DWH_TRAINING.DWH.DIM_CUSTOMER_T1
SET CITY = 'Pune'
WHERE CUSTOMER_ID = 'C101';
```

Before:

```text
C101 | Mumbai
```

After:

```text
C101 | Pune
```

History is not retained.

Good for:

```text
Corrections
Typographical fixes
Changes where historical value is not required
```

---

# 18. SCD Type 2

Preserve history using multiple dimension rows.

```text
customer_key | customer_id | city   | from       | to         | current
-------------|-------------|--------|------------|------------|--------
1011         | C101        | Mumbai | 2026-01-01 | 2026-05-31 | N
2057         | C101        | Pune   | 2026-06-01 | NULL       | Y
```

The logical process is:

```text
1. Close old row
2. Insert new row
```

Example:

```sql
UPDATE DWH_TRAINING.DWH.DIM_CUSTOMER_T2
SET
    EFFECTIVE_TO = '2026-05-31',
    IS_CURRENT = FALSE
WHERE CUSTOMER_ID = 'C101'
  AND IS_CURRENT = TRUE;
```

```sql
INSERT INTO DWH_TRAINING.DWH.DIM_CUSTOMER_T2
VALUES
(2, 'C101', 'Ravi', 'Pune',
 '2026-06-01', NULL, TRUE);
```

---

# 19. SCD Type 3

Keep limited history in columns.

```text
customer_id | current_city | previous_city
------------|--------------|--------------
C101        | Pune         | Mumbai
```

Example:

```sql
UPDATE DWH_TRAINING.DWH.DIM_CUSTOMER_T3
SET
    PREVIOUS_CITY = CURRENT_CITY,
    CURRENT_CITY = 'Pune'
WHERE CUSTOMER_ID = 'C101';
```

Comparison:

```text
Type 1 → overwrite
Type 2 → multiple rows
Type 3 → additional historical columns
```

---

# 20. Normalization vs Denormalization

## Normalization

```text
CUSTOMER
   |
   +-- CITY_ID

CITY
   |
   +-- CITY_NAME
```

Reduces redundancy and is common in transactional systems.

## Denormalization

Related descriptive information is intentionally kept closer together.

Dimensional models often favor simpler analytical access patterns.

```text
FACT
 |
 +-- DIM_CUSTOMER
 +-- DIM_PRODUCT
 +-- DIM_DATE
```

---

# PART III — SNOWFLAKE

# 21. Snowflake Architecture

Snowflake has three major architectural layers:

```text
                 SNOWFLAKE
                     |
       +-------------+-------------+
       |             |             |
    STORAGE       COMPUTE      CLOUD SERVICES
       |             |             |
 Persistent       Virtual       metadata,
 data            warehouses    security,
                                optimization
```

Snowflake describes these layers as database storage, compute and cloud services. Snowflake tables are automatically organized into micro-partitions, while virtual warehouses provide independent compute clusters. citeturn0search4

---

# 22. Storage vs Compute

```text
                    SNOWFLAKE
                        |
             +----------+----------+
             |                     |
          STORAGE                COMPUTE
             |                     |
       Persistent data       Virtual Warehouse
```

The key idea:

> Storage and compute are separate resources.

---

# 23. Virtual Warehouse

A Virtual Warehouse is a cluster of compute resources.

It executes:

```text
SELECT
INSERT
UPDATE
DELETE
COPY
MERGE
```

```text
VIRTUAL WAREHOUSE
       |
       +-- Compute
       +-- CPU
       +-- Memory
```

---

# 24. Snowflake Object Hierarchy

```text
ACCOUNT
  |
  +-- DATABASE
        |
        +-- SCHEMA
              |
              +-- TABLE
              +-- VIEW
              +-- STAGE
```

Separately:

```text
ACCOUNT
  |
  +-- VIRTUAL WAREHOUSE
```

---

# 25. Snowflake Setup

```sql
CREATE OR REPLACE DATABASE DWH_TRAINING;

CREATE OR REPLACE SCHEMA DWH_TRAINING.RAW;
CREATE OR REPLACE SCHEMA DWH_TRAINING.STAGING;
CREATE OR REPLACE SCHEMA DWH_TRAINING.DWH;
CREATE OR REPLACE SCHEMA DWH_TRAINING.MART;
```

```sql
CREATE OR REPLACE WAREHOUSE DWH_TRAINING_WH
WITH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

USE WAREHOUSE DWH_TRAINING_WH;
```

Context:

```sql
SELECT
    CURRENT_DATABASE(),
    CURRENT_SCHEMA(),
    CURRENT_WAREHOUSE();
```

---

# 26. Snowflake Dimensional Model Lab

## Customer dimension

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.DWH.DIM_CUSTOMER (
    CUSTOMER_KEY NUMBER,
    CUSTOMER_ID VARCHAR,
    CUSTOMER_NAME VARCHAR,
    CITY VARCHAR,
    STATE VARCHAR,
    SEGMENT VARCHAR,
    EFFECTIVE_FROM DATE,
    EFFECTIVE_TO DATE,
    IS_CURRENT BOOLEAN
);
```

## Product dimension

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.DWH.DIM_PRODUCT (
    PRODUCT_KEY NUMBER,
    PRODUCT_ID VARCHAR,
    PRODUCT_NAME VARCHAR,
    CATEGORY VARCHAR,
    SUBCATEGORY VARCHAR,
    BRAND VARCHAR
);
```

## Date dimension

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.DWH.DIM_DATE (
    DATE_KEY NUMBER,
    FULL_DATE DATE,
    YEAR NUMBER,
    QUARTER NUMBER,
    MONTH NUMBER,
    MONTH_NAME VARCHAR,
    DAY NUMBER
);
```

## Region dimension

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.DWH.DIM_REGION (
    REGION_KEY NUMBER,
    REGION_CODE VARCHAR,
    REGION_NAME VARCHAR
);
```

## Sales fact

Declare the grain first:

> One row = one sales transaction/order line.

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.DWH.FACT_SALES (
    SALES_KEY NUMBER,
    DATE_KEY NUMBER,
    CUSTOMER_KEY NUMBER,
    PRODUCT_KEY NUMBER,
    REGION_KEY NUMBER,
    ORDER_ID VARCHAR,
    QUANTITY NUMBER,
    SALES_AMOUNT NUMBER(12,2),
    DISCOUNT_AMOUNT NUMBER(12,2)
);
```

---

# 27. Sample Dimension Data

```sql
INSERT INTO DWH_TRAINING.DWH.DIM_CUSTOMER
VALUES
(1, 'C101', 'Ravi',  'Mumbai', 'MH', 'Retail',
 '2026-01-01', NULL, TRUE),
(2, 'C102', 'Priya', 'Pune',   'MH', 'Premium',
 '2026-01-01', NULL, TRUE),
(3, 'C103', 'Arun',  'Delhi',  'DL', 'Retail',
 '2026-01-01', NULL, TRUE);
```

```sql
INSERT INTO DWH_TRAINING.DWH.DIM_PRODUCT
VALUES
(101, 'P501', 'Laptop', 'Electronics', 'Computers', 'BrandA'),
(102, 'P502', 'Phone',  'Electronics', 'Mobiles',   'BrandB'),
(103, 'P503', 'Chair',  'Furniture',   'Office',    'BrandC');
```

```sql
INSERT INTO DWH_TRAINING.DWH.DIM_REGION
VALUES
(1, 'W', 'West'),
(2, 'N', 'North'),
(3, 'S', 'South');
```

---

# 28. Sample Fact Data

```sql
INSERT INTO DWH_TRAINING.DWH.FACT_SALES
VALUES
(1, 20260105, 1, 101, 1, 'O1001', 2, 2000, 100),
(2, 20260107, 2, 102, 1, 'O1002', 1, 1500, 50),
(3, 20260110, 1, 103, 1, 'O1003', 3, 4500, 200),
(4, 20260202, 3, 101, 2, 'O1004', 1, 1000, 0);
```

---

# 29. Star Schema Queries

## Revenue by region

```sql
SELECT
    r.REGION_NAME,
    SUM(f.SALES_AMOUNT) AS REVENUE
FROM DWH_TRAINING.DWH.FACT_SALES f
JOIN DWH_TRAINING.DWH.DIM_REGION r
    ON f.REGION_KEY = r.REGION_KEY
GROUP BY r.REGION_NAME
ORDER BY REVENUE DESC;
```

## Revenue by product category

```sql
SELECT
    p.CATEGORY,
    SUM(f.SALES_AMOUNT) AS REVENUE
FROM DWH_TRAINING.DWH.FACT_SALES f
JOIN DWH_TRAINING.DWH.DIM_PRODUCT p
    ON f.PRODUCT_KEY = p.PRODUCT_KEY
GROUP BY p.CATEGORY
ORDER BY REVENUE DESC;
```

## Revenue by customer segment

```sql
SELECT
    c.SEGMENT,
    SUM(f.SALES_AMOUNT) AS REVENUE
FROM DWH_TRAINING.DWH.FACT_SALES f
JOIN DWH_TRAINING.DWH.DIM_CUSTOMER c
    ON f.CUSTOMER_KEY = c.CUSTOMER_KEY
GROUP BY c.SEGMENT;
```

## Region + category + segment

```sql
SELECT
    r.REGION_NAME,
    p.CATEGORY,
    c.SEGMENT,
    SUM(f.SALES_AMOUNT) AS REVENUE
FROM DWH_TRAINING.DWH.FACT_SALES f
JOIN DWH_TRAINING.DWH.DIM_REGION r
    ON f.REGION_KEY = r.REGION_KEY
JOIN DWH_TRAINING.DWH.DIM_PRODUCT p
    ON f.PRODUCT_KEY = p.PRODUCT_KEY
JOIN DWH_TRAINING.DWH.DIM_CUSTOMER c
    ON f.CUSTOMER_KEY = c.CUSTOMER_KEY
GROUP BY
    r.REGION_NAME,
    p.CATEGORY,
    c.SEGMENT;
```

---

# PART IV — ETL / ELT

# 30. ETL

```text
EXTRACT
   |
   v
TRANSFORM
   |
   v
LOAD
```

Transformation happens before loading into the target.

# 31. ELT

```text
EXTRACT
   |
   v
LOAD
   |
   v
TRANSFORM
```

Transformation happens inside the analytical platform.

### Main distinction

> Where does transformation occur relative to the warehouse load?

---

# 32. Source-Like RAW Table

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.RAW.RAW_ORDERS (
    ORDER_ID VARCHAR,
    ORDER_DATE VARCHAR,
    CUSTOMER_ID VARCHAR,
    REGION VARCHAR,
    AMOUNT VARCHAR
);
```

Load intentionally imperfect data:

```sql
INSERT INTO DWH_TRAINING.RAW.RAW_ORDERS
VALUES
('O1001', '2026-01-05', 'C101', 'West', '2000'),
('O1002', '2026-01-07', 'C102', 'West', '1500'),
('O1003', '2026-01-10', 'C101', 'North', '4500'),
('O1004', 'BAD_DATE', 'C103', 'South', 'ABC');
```

---

# 33. Transform

```sql
SELECT
    ORDER_ID,
    TRY_TO_DATE(ORDER_DATE) AS ORDER_DATE,
    CUSTOMER_ID,
    UPPER(TRIM(REGION)) AS REGION,
    TRY_TO_DECIMAL(AMOUNT, 12, 2) AS AMOUNT
FROM DWH_TRAINING.RAW.RAW_ORDERS;
```

`TRY_` conversion functions are useful when invalid source values need to be identified without aborting the transformation.

---

# 34. Invalid Records

```sql
SELECT *
FROM DWH_TRAINING.RAW.RAW_ORDERS
WHERE TRY_TO_DATE(ORDER_DATE) IS NULL
   OR TRY_TO_DECIMAL(AMOUNT, 12, 2) IS NULL;
```

---

# 35. Clean Table

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.STAGING.CLEAN_ORDERS AS
SELECT
    ORDER_ID,
    TRY_TO_DATE(ORDER_DATE) AS ORDER_DATE,
    CUSTOMER_ID,
    UPPER(TRIM(REGION)) AS REGION,
    TRY_TO_DECIMAL(AMOUNT, 12, 2) AS AMOUNT
FROM DWH_TRAINING.RAW.RAW_ORDERS
WHERE TRY_TO_DATE(ORDER_DATE) IS NOT NULL
  AND TRY_TO_DECIMAL(AMOUNT, 12, 2) IS NOT NULL;
```

---

# 36. MERGE / UPSERT

Suppose a source contains existing and new customers.

```text
Existing → UPDATE
New      → INSERT
```

Example:

```sql
MERGE INTO DWH_TRAINING.DWH.DIM_CUSTOMER AS TARGET
USING DWH_TRAINING.STAGING.CUSTOMER_STAGE AS SOURCE
ON TARGET.CUSTOMER_ID = SOURCE.CUSTOMER_ID

WHEN MATCHED THEN
    UPDATE SET
        TARGET.CUSTOMER_NAME = SOURCE.CUSTOMER_NAME,
        TARGET.CITY = SOURCE.CITY

WHEN NOT MATCHED THEN
    INSERT
    (
        CUSTOMER_KEY,
        CUSTOMER_ID,
        CUSTOMER_NAME,
        CITY,
        SEGMENT
    )
    VALUES
    (
        SOURCE.CUSTOMER_KEY,
        SOURCE.CUSTOMER_ID,
        SOURCE.CUSTOMER_NAME,
        SOURCE.CITY,
        SOURCE.SEGMENT
    );
```

`MERGE` is useful for incremental ELT pipelines.

---

# PART V — DATA PROFILING AND QUALITY

# 37. Data Profiling

Data profiling means examining:

```text
Structure
Completeness
Uniqueness
Validity
Distribution
Consistency
```

Questions:

```text
How many rows?
How many NULLs?
How many duplicates?
What are the distinct values?
Are dates valid?
Are numbers valid?
```

---

# 38. Row Count

```sql
SELECT COUNT(*) AS ROW_COUNT
FROM DWH_TRAINING.RAW.RAW_ORDERS;
```

# 39. Missing Values

```sql
SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT_IF(CUSTOMER_ID IS NULL) AS NULL_CUSTOMERS,
    COUNT_IF(REGION IS NULL) AS NULL_REGIONS,
    COUNT_IF(ORDER_DATE IS NULL) AS NULL_ORDER_DATES
FROM DWH_TRAINING.RAW.RAW_ORDERS;
```

# 40. Duplicates

```sql
SELECT
    ORDER_ID,
    COUNT(*) AS CNT
FROM DWH_TRAINING.RAW.RAW_ORDERS
GROUP BY ORDER_ID
HAVING COUNT(*) > 1;
```

Remember:

> Duplicate detection depends on the table's expected grain.

# 41. Distinct Values

```sql
SELECT
    REGION,
    COUNT(*) AS CNT
FROM DWH_TRAINING.RAW.RAW_ORDERS
GROUP BY REGION
ORDER BY CNT DESC;
```

# 42. Numeric Profiling

```sql
SELECT
    MIN(TRY_TO_DECIMAL(AMOUNT, 12, 2)) AS MIN_AMOUNT,
    MAX(TRY_TO_DECIMAL(AMOUNT, 12, 2)) AS MAX_AMOUNT,
    AVG(TRY_TO_DECIMAL(AMOUNT, 12, 2)) AS AVG_AMOUNT
FROM DWH_TRAINING.RAW.RAW_ORDERS;
```

---

# 43. Data Quality Dimensions

```text
COMPLETENESS
→ Are required values present?

UNIQUENESS
→ Are unexpected duplicates present?

VALIDITY
→ Are values valid according to type/rules?

CONSISTENCY
→ Do sources agree?

ACCURACY
→ Does the value represent reality?
```

Possible actions for bad data:

```text
Reject
Quarantine
Correct
Default
Impute
Keep NULL
```

The choice depends on business semantics.

---

# PART VI — SNOWFLAKE LOADING

# 44. Internal Stage

Snowflake supports internal and external stages. citeturn0search9

```sql
CREATE OR REPLACE STAGE DWH_TRAINING.RAW.ORDERS_STAGE;
```

```sql
SHOW STAGES IN SCHEMA DWH_TRAINING.RAW;
```

---

# 45. CSV File Format

```sql
CREATE OR REPLACE FILE FORMAT DWH_TRAINING.RAW.CSV_FORMAT
TYPE = CSV
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;
```

---

# 46. COPY INTO

Conceptually:

```text
CSV
 |
 v
STAGE
 |
 v
COPY INTO
 |
 v
RAW TABLE
```

```sql
COPY INTO DWH_TRAINING.RAW.RAW_ORDERS
FROM @DWH_TRAINING.RAW.ORDERS_STAGE
FILE_FORMAT = (
    FORMAT_NAME = DWH_TRAINING.RAW.CSV_FORMAT
);
```

Snowflake uses stages for files involved in bulk loading. citeturn0search2turn0search9

---

# 47. Load Validation

```sql
COPY INTO DWH_TRAINING.RAW.RAW_ORDERS
FROM @DWH_TRAINING.RAW.ORDERS_STAGE
FILE_FORMAT = (
    FORMAT_NAME = DWH_TRAINING.RAW.CSV_FORMAT
)
VALIDATION_MODE = 'RETURN_ERRORS';
```

This is useful for investigating rejected input.

---

# PART VII — ERROR HANDLING AND LOGGING

# 48. Error Table

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.STAGING.LOAD_ERRORS (
    ORDER_ID VARCHAR,
    ERROR_REASON VARCHAR,
    ERROR_TIMESTAMP TIMESTAMP
);
```

```sql
INSERT INTO DWH_TRAINING.STAGING.LOAD_ERRORS
SELECT
    ORDER_ID,
    'Invalid date or amount',
    CURRENT_TIMESTAMP()
FROM DWH_TRAINING.RAW.RAW_ORDERS
WHERE TRY_TO_DATE(ORDER_DATE) IS NULL
   OR TRY_TO_DECIMAL(AMOUNT, 12, 2) IS NULL;
```

---

# 49. ETL Audit Log

```sql
CREATE OR REPLACE TABLE DWH_TRAINING.STAGING.ETL_AUDIT_LOG (
    RUN_ID NUMBER,
    PIPELINE_NAME VARCHAR,
    START_TIME TIMESTAMP,
    END_TIME TIMESTAMP,
    ROWS_READ NUMBER,
    ROWS_LOADED NUMBER,
    ROWS_REJECTED NUMBER,
    STATUS VARCHAR
);
```

A production pipeline/orchestrator can populate this table.

---

# PART VIII — BATCH AND REAL-TIME

# 50. Batch

```text
Source
  |
  | every hour / day
  v
Batch process
  |
  v
DWH
```

Example:

> Load the previous day's sales every night.

A simple SQL batch step:

```sql
INSERT INTO DWH_TRAINING.STAGING.CLEAN_ORDERS
SELECT
    ORDER_ID,
    TRY_TO_DATE(ORDER_DATE),
    CUSTOMER_ID,
    UPPER(TRIM(REGION)),
    TRY_TO_DECIMAL(AMOUNT, 12, 2)
FROM DWH_TRAINING.RAW.RAW_ORDERS
WHERE TRY_TO_DATE(ORDER_DATE) IS NOT NULL
  AND TRY_TO_DECIMAL(AMOUNT, 12, 2) IS NOT NULL;
```

---

# 51. Real-Time / Near-Real-Time

```text
EVENT
  |
  v
STREAMING INGESTION
  |
  v
PROCESSING
  |
  v
ANALYTICAL PLATFORM
```

Examples:

```text
Fraud detection
IoT monitoring
Clickstream
Low-latency operational analytics
```

Snowflake currently provides low-latency ingestion options such as Snowpipe Streaming and transformation mechanisms including streams/tasks and dynamic tables. citeturn0search4turn0search7

---

# PART IX — SNOWFLAKE TABLE TYPES

# 52. Permanent

```sql
CREATE OR REPLACE TABLE PERMANENT_ORDERS (
    ORDER_ID NUMBER,
    AMOUNT NUMBER(12,2)
);
```

# 53. Temporary

```sql
CREATE OR REPLACE TEMPORARY TABLE TEMP_ORDERS AS
SELECT *
FROM DWH_TRAINING.RAW.RAW_ORDERS;
```

Temporary tables are session-specific in Snowflake. citeturn0search2

# 54. Transient

```sql
CREATE OR REPLACE TRANSIENT TABLE TRANSIENT_ORDERS (
    ORDER_ID NUMBER,
    AMOUNT NUMBER(12,2)
);
```

Conceptually:

```text
Permanent
→ durable/default table

Transient
→ persists beyond session, reduced protection

Temporary
→ session-specific
```

Snowflake documents temporary and transient tables as distinct table types with different data-protection/retention characteristics. citeturn0search2

---

# PART X — TIME TRAVEL

# 55. Time Travel

Snowflake Time Travel allows historical data to be queried within the configured retention period and supports recovery and cloning scenarios. citeturn0search8

Example:

```sql
SELECT *
FROM DWH_TRAINING.DWH.FACT_SALES
AT (OFFSET => -60*5);
```

Or:

```sql
SELECT *
FROM DWH_TRAINING.DWH.FACT_SALES
AT (TIMESTAMP => '2026-08-25 10:00:00');
```

`UNDROP` can recover eligible dropped objects:

```sql
UNDROP TABLE DWH_TRAINING.DWH.FACT_SALES;
```

---

# PART XI — MICRO-PARTITIONS AND CLUSTERING

# 56. Micro-Partitions

Snowflake automatically organizes table data into micro-partitions.

```text
TABLE
 |
 +-- Micro-partition
 +-- Micro-partition
 +-- Micro-partition
 +-- Micro-partition
```

Snowflake manages this storage organization automatically. citeturn0search4

# 57. Clustering

For very large tables with recurring selective access patterns, clustering can be considered.

Example:

```sql
CREATE OR REPLACE TABLE LARGE_SALES
CLUSTER BY (ORDER_DATE, REGION)
AS
SELECT *
FROM DWH_TRAINING.DWH.FACT_SALES;
```

Important:

```text
Traditional OLTP index
        !=
Snowflake clustering
```

Snowflake table organization is based on micro-partitions rather than the conventional indexing model used in many OLTP databases.

---

# PART XII — COMPUTE MANAGEMENT

# 58. Warehouse Size

```sql
ALTER WAREHOUSE DWH_TRAINING_WH
SET WAREHOUSE_SIZE = 'SMALL';
```

Resize:

```sql
ALTER WAREHOUSE DWH_TRAINING_WH
SET WAREHOUSE_SIZE = 'MEDIUM';
```

Conceptually:

```text
Larger warehouse
      |
More compute
      |
Potentially faster query
      |
More compute consumption
```

# 59. Auto Suspend / Resume

```sql
ALTER WAREHOUSE DWH_TRAINING_WH
SET
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;
```

# 60. Suspend / Resume

```sql
ALTER WAREHOUSE DWH_TRAINING_WH SUSPEND;
```

```sql
ALTER WAREHOUSE DWH_TRAINING_WH RESUME;
```

Core model:

```text
QUERY
  |
  v
VIRTUAL WAREHOUSE
  |
  +--> Size
  +--> Concurrency
  +--> Auto-suspend
  +--> Auto-resume
  |
  v
Compute consumption
```

---

# PART XIII — QUERY PERFORMANCE

# 61. Performance Mindset

The goal is:

> Reduce unnecessary work while preserving the correct result.

Check:

```text
Rows scanned
Bytes scanned
Join behaviour
Filtering
Aggregation
Execution time
Warehouse utilization
```

A good workflow:

```text
QUERY
  |
  v
MEASURE
  |
  v
PROFILE
  |
  v
CHANGE ONE THING
  |
  v
MEASURE AGAIN
  |
  v
COMPARE
```

---

# 62. Example Analytical Query

```sql
SELECT
    r.REGION_NAME,
    p.CATEGORY,
    SUM(f.SALES_AMOUNT) AS REVENUE
FROM DWH_TRAINING.DWH.FACT_SALES f
JOIN DWH_TRAINING.DWH.DIM_REGION r
    ON f.REGION_KEY = r.REGION_KEY
JOIN DWH_TRAINING.DWH.DIM_PRODUCT p
    ON f.PRODUCT_KEY = p.PRODUCT_KEY
GROUP BY
    r.REGION_NAME,
    p.CATEGORY;
```

Performance questions:

```text
How much data is scanned?
Are filters selective?
Are joins necessary?
Is the warehouse appropriately sized?
Would clustering help at large scale?
```

---

# 63. Query History

A metadata query can be used to inspect recent queries:

```sql
SELECT
    QUERY_ID,
    QUERY_TEXT,
    EXECUTION_TIME,
    BYTES_SCANNED,
    ROWS_PRODUCED
FROM TABLE(
    INFORMATION_SCHEMA.QUERY_HISTORY(
        END_TIME_RANGE_START => DATEADD('HOUR', -1, CURRENT_TIMESTAMP()),
        END_TIME_RANGE_END   => CURRENT_TIMESTAMP()
    )
)
ORDER BY START_TIME DESC;
```

Snowsight Query History and Query Profile are also useful for investigating execution.

---

# PART XIV — CLOUD DATA WAREHOUSING

# 64. Cloud DWH

Traditional:

```text
Buy servers
   |
Install software
   |
Provision storage
   |
Maintain infrastructure
```

Cloud:

```text
Managed cloud platform
       |
Elastic resources
       |
Usage-based model
```

Common benefits:

```text
Elasticity
Managed infrastructure
Independent storage/compute
Cloud integration
Global availability
```

---

# 65. Snowflake

Mental model:

```text
Cloud analytical platform
+
Separated storage and compute
+
SQL
+
Elastic compute
+
Semi-structured data
```

# 66. BigQuery

Mental model:

```text
Serverless analytical warehouse
+
Google Cloud integration
+
Large-scale analytics
```

# 67. Redshift

Mental model:

```text
AWS analytical warehouse
+
AWS ecosystem integration
```

# 68. Databricks

Mental model:

```text
Lakehouse
+
Data engineering
+
Spark
+
SQL analytics
+
ML / AI
```

### Comparison

| Platform | Mental model | Strong fit |
|---|---|---|
| Snowflake | Cloud analytical platform | DWH / BI / cross-cloud analytics |
| BigQuery | Serverless warehouse | Large-scale analytics / GCP |
| Redshift | AWS warehouse | AWS-centric analytics |
| Databricks | Lakehouse | Data engineering + analytics + ML |

No platform is universally best; selection depends on workload, cloud ecosystem, skills, cost, governance and integration requirements.

---

# PART XV — COMPLETE SNOWFLAKE LAB FLOW

```text
1. Create database
        |
2. Create schemas
        |
3. Create warehouse
        |
4. Create RAW table
        |
5. Load source-like data
        |
6. Profile data
        |
7. Detect bad records
        |
8. Clean / transform
        |
9. Create dimensions
        |
10. Define fact grain
        |
11. Create fact
        |
12. Load dimensions
        |
13. Load fact
        |
14. Query star schema
        |
15. Demonstrate SCD
        |
16. Demonstrate Time Travel
        |
17. Inspect query performance
        |
18. Manage compute
```

---

# PART XVI — INTEGRATED RETAIL SCENARIO

A retail company has:

```text
ORDER MANAGEMENT
CRM
PAYMENT SYSTEM
WEBSITE
LOGISTICS
```

Requirement:

> Build a dashboard showing monthly revenue by region, product category and customer segment for the last three years.

## Source systems

```text
Orders
Customers
Products
Payments
Logistics
```

## Fact

Likely:

```text
FACT_SALES
```

Measures:

```text
quantity
gross_amount
discount
net_amount
```

## Dimensions

```text
DIM_DATE
DIM_CUSTOMER
DIM_PRODUCT
DIM_REGION
```

## Grain

Possible grain:

```text
One row = one order line
```

## Historical customer changes

If historical reporting requires the customer segment valid at the time of sale:

```text
SCD Type 2
```

may be appropriate.

## Analytical queries

```text
Revenue by month
Revenue by region
Revenue by product category
Revenue by customer segment
```

---

# PART XVII — CRITICAL DISTINCTIONS

```text
Database
→ general data management system

Data Warehouse
→ analytical data environment
```

```text
OLTP
→ run the business

OLAP
→ analyze the business
```

```text
ETL
→ transform before load

ELT
→ load before transform
```

```text
Fact
→ measurable business event

Dimension
→ descriptive context
```

```text
Grain
→ meaning of one row

Row count
→ number of rows
```

```text
Business key
→ source/business identifier

Surrogate key
→ warehouse-generated identifier
```

```text
Star
→ simpler, relatively denormalized dimensions

Snowflake
→ more normalized dimensions
```

```text
Temporary
→ session-specific

Transient
→ persists beyond session, reduced protection
```

```text
Storage
→ persistent data

Compute
→ resources executing work
```

```text
Traditional OLTP index
→ index structure for row access

Snowflake clustering
→ micro-partition organization/pruning strategy
```

---

# PART XVIII — FINAL REVISION QUESTIONS

## DWH Concepts

1. What problem does a DWH solve?
2. Why separate OLTP and OLAP?
3. What is historical data?
4. What is an EDW?
5. What is a Data Mart?
6. What is staging?
7. What is integration?
8. What is the DWH lifecycle?

## Data Modelling

9. What is grain?
10. Why define grain first?
11. What is a fact table?
12. What is a dimension?
13. What is a surrogate key?
14. Why use surrogate keys?
15. Star vs Snowflake schema?
16. Normalization vs denormalization?
17. What is SCD?
18. Type 1 vs Type 2 vs Type 3?

## ETL / Quality

19. ETL vs ELT?
20. Batch vs real-time?
21. What is data profiling?
22. How do you detect duplicates?
23. How do you detect missing data?
24. How do you handle invalid records?
25. What is an ETL audit log?
26. What is `MERGE`?
27. What is a Snowflake stage?
28. What does `COPY INTO` do?

## Snowflake

29. What are Snowflake's major architecture layers?
30. What is a Virtual Warehouse?
31. Storage vs compute?
32. What are databases and schemas?
33. What is a micro-partition?
34. What is clustering?
35. Temporary vs transient table?
36. What is Time Travel?
37. What is `UNDROP`?
38. How do you control warehouse compute?
39. How do you inspect query history?
40. How would you investigate a slow query?

---

# PART XIX — THE CORE MENTAL MODEL

```text
                    BUSINESS
                       |
                       v
                BUSINESS QUESTIONS
                       |
                       v
                 DATA SOURCES
                       |
                       v
                  INGESTION
                       |
                       v
                RAW / STAGING
                       |
                       v
              CLEAN + INTEGRATE
                       |
                       v
                DATA WAREHOUSE
                       |
                       v
               DEFINE THE GRAIN
                       |
                       v
                FACT + DIMENSIONS
                       |
                       v
             STAR / SNOWFLAKE
                       |
                       v
              HISTORICAL LOGIC
                     (SCD)
                       |
                       v
                 ANALYTICS SQL
                       |
                       v
                    BI / REPORTS
                       |
                       v
                BUSINESS DECISIONS
```

The two questions that should drive the entire modelling process are:

> **What business question are we trying to answer?**

and:

> **What does one row represent?**

Once those are clear, the fact table, dimensions, keys, transformations and analytical queries become much easier to design.
