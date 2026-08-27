# Snowflake DWH Lab 3 — Incremental Loading, MERGE, Upsert, Idempotency and CDC

## Purpose

This lab continues from the Snowflake DWH setup already completed.

The flow so far is:

```text
Source File
    ↓
File Stage
    ↓
COPY INTO
    ↓
RAW
    ↓
STAGING
    ↓
DWH
```

This lab answers one practical question:

> What happens when the source sends new or changed data tomorrow?

We will build the concepts in this order:

```text
Initial DWH data
      ↓
Tomorrow's source data
      ↓
MATCHED / NOT MATCHED
      ↓
MERGE
      ↓
Upsert
      ↓
Idempotency
      ↓
Incremental loading
      ↓
CDC
```

---

# 1. Keep These Terms Separate

### MERGE

A SQL operation that applies source changes to a target.

```text
MATCHED      → UPDATE
NOT MATCHED → INSERT
```

### Upsert

A data operation meaning:

```text
UPDATE existing records
+
INSERT new records
```

`MERGE` is one common way to implement an upsert.

### Incremental loading

Processing only new or changed records instead of the entire source every time.

### CDC

Change Data Capture records what changed in the source.

### Idempotency

If the same batch is processed again, the final DWH state remains correct.

---

# 2. Business Scenario

On Day 1, the DWH contains:

```text
C101 | Ravi  | Mumbai
C102 | Priya | Pune
C103 | Arun  | Delhi
C104 | Sneha | Mumbai
```

Tomorrow the source sends:

```text
C101 | Ravi  | Bangalore
C102 | Priya | Pune
C105 | Meena | Chennai
```

Therefore:

```text
C101 → already exists + changed → UPDATE
C102 → already exists + unchanged → no business change
C105 → new → INSERT
```

---

# 3. Create the Target DWH Table

```sql
USE DATABASE DWH_TRAINING;

CREATE OR REPLACE TABLE DWH.DIM_CUSTOMER_INCREMENTAL
(
    CUSTOMER_ID   VARCHAR PRIMARY KEY,
    CUSTOMER_NAME VARCHAR,
    CITY          VARCHAR,
    SEGMENT       VARCHAR
);
```

## Important

`CUSTOMER_ID` is the primary key.

Therefore the target cannot contain two rows with the same `CUSTOMER_ID`.

This lab does **not** assume that a correctly designed DWH target contains duplicate primary-key records.

---

# 4. Load the Initial Data

```sql
INSERT INTO DWH.DIM_CUSTOMER_INCREMENTAL
VALUES
('C101', 'Ravi',  'Mumbai', 'Retail'),
('C102', 'Priya', 'Pune',   'Premium'),
('C103', 'Arun',  'Delhi',  'Retail'),
('C104', 'Sneha', 'Mumbai', 'Premium');
```

Check:

```sql
SELECT *
FROM DWH.DIM_CUSTOMER_INCREMENTAL
ORDER BY CUSTOMER_ID;
```

Expected:

```text
CUSTOMER_ID | CUSTOMER_NAME | CITY   | SEGMENT
------------|---------------|--------|---------
C101        | Ravi          | Mumbai | Retail
C102        | Priya         | Pune   | Premium
C103        | Arun          | Delhi  | Retail
C104        | Sneha         | Mumbai | Premium
```

This is our Day 1 DWH state.

---

# 5. Tomorrow's Data Arrives

Create a staging table representing the incoming batch.

```sql
CREATE OR REPLACE TEMPORARY TABLE STAGING.CUSTOMER_INCREMENTAL_LOAD
(
    CUSTOMER_ID   VARCHAR,
    CUSTOMER_NAME VARCHAR,
    CITY          VARCHAR,
    SEGMENT       VARCHAR
);
```

Load tomorrow's data:

```sql
INSERT INTO STAGING.CUSTOMER_INCREMENTAL_LOAD
VALUES
('C101', 'Ravi',  'Bangalore', 'Retail'),
('C102', 'Priya', 'Pune',      'Premium'),
('C105', 'Meena', 'Chennai',   'Premium');
```

View it:

```sql
SELECT *
FROM STAGING.CUSTOMER_INCREMENTAL_LOAD
ORDER BY CUSTOMER_ID;
```

---

# 6. Compare Target and Incoming Data

Target:

```text
C101 | Ravi  | Mumbai
C102 | Priya | Pune
C103 | Arun  | Delhi
C104 | Sneha | Mumbai
```

Incoming:

```text
C101 | Ravi  | Bangalore
C102 | Priya | Pune
C105 | Meena | Chennai
```

Classify the incoming records:

```text
C101 → MATCHED
C102 → MATCHED
C105 → NOT MATCHED
```

This is the problem `MERGE` solves.

---

# 7. Basic MERGE Pattern

```sql
MERGE INTO target
USING source
ON matching_condition

WHEN MATCHED THEN
    UPDATE ...

WHEN NOT MATCHED THEN
    INSERT ...;
```

Mental model:

```text
Incoming record
       |
       ↓
Does business key exist?
       /             YES         NO
      |           |
  MATCHED     NOT MATCHED
      |           |
   UPDATE       INSERT
```

---

# 8. Run the MERGE

```sql
MERGE INTO DWH.DIM_CUSTOMER_INCREMENTAL AS target

USING STAGING.CUSTOMER_INCREMENTAL_LOAD AS source

ON target.CUSTOMER_ID = source.CUSTOMER_ID

WHEN MATCHED THEN
    UPDATE SET
        target.CUSTOMER_NAME = source.CUSTOMER_NAME,
        target.CITY          = source.CITY,
        target.SEGMENT       = source.SEGMENT

WHEN NOT MATCHED THEN
    INSERT
    (
        CUSTOMER_ID,
        CUSTOMER_NAME,
        CITY,
        SEGMENT
    )
    VALUES
    (
        source.CUSTOMER_ID,
        source.CUSTOMER_NAME,
        source.CITY,
        source.SEGMENT
    );
```

Check:

```sql
SELECT *
FROM DWH.DIM_CUSTOMER_INCREMENTAL
ORDER BY CUSTOMER_ID;
```

Expected:

```text
C101 | Ravi  | Bangalore | Retail
C102 | Priya | Pune      | Premium
C103 | Arun  | Delhi     | Retail
C104 | Sneha | Mumbai    | Premium
C105 | Meena | Chennai   | Premium
```

---

# 9. Understand Each Record

### C101

```text
Target:
C101 | Ravi | Mumbai

Incoming:
C101 | Ravi | Bangalore

MATCHED
   ↓
UPDATE
```

Result:

```text
C101 | Ravi | Bangalore
```

### C102

```text
Target:
C102 | Priya | Pune

Incoming:
C102 | Priya | Pune

MATCHED
```

The update action is eligible, but the values are already the same, so the final data does not visibly change.

### C105

```text
Target:
No C105

Incoming:
C105 | Meena | Chennai

NOT MATCHED
   ↓
INSERT
```

---

# 10. Why This Is Called Upsert

Upsert means:

```text
UPDATE existing
+
INSERT new
```

Our MERGE implements that behavior.

```text
MERGE
  ↓
Upsert behavior
```

Remember:

> MERGE is the SQL operation. Upsert describes the behavior.

---

# 11. Primary Keys and Duplicate Data

This is important.

Our target has:

```sql
CUSTOMER_ID VARCHAR PRIMARY KEY
```

Therefore the target cannot contain:

```text
C101
C101
```

as two rows.

So where can duplicate data exist?

## Duplicate source records

The incoming batch itself could contain:

```text
C105 | Meena | Chennai
C105 | Meena | Chennai
```

That is duplicate input data.

## RAW data

A RAW landing table may intentionally have no primary key because its purpose is to retain what arrived.

For example:

```text
RAW

C101 | Ravi | Mumbai
C101 | Ravi | Mumbai
C102 | Priya | Pune
```

These are duplicate arrivals, not duplicate primary-key rows in the final DWH.

## Incorrect matching key

Bad:

```sql
ON target.CUSTOMER_NAME = source.CUSTOMER_NAME
```

Better:

```sql
ON target.CUSTOMER_ID = source.CUSTOMER_ID
```

when `CUSTOMER_ID` is the correct business key.

Therefore:

> Do not think that an upsert creates duplicate primary-key rows. A correctly constrained target prevents that. Duplicate input data and duplicate target records are different problems.

---

# 12. Idempotency

We have already processed the incoming batch:

```text
C101
C102
C105
```

Suppose the same batch is accidentally processed again.

Run the same MERGE again.

```sql
MERGE INTO DWH.DIM_CUSTOMER_INCREMENTAL AS target

USING STAGING.CUSTOMER_INCREMENTAL_LOAD AS source

ON target.CUSTOMER_ID = source.CUSTOMER_ID

WHEN MATCHED THEN
    UPDATE SET
        target.CUSTOMER_NAME = source.CUSTOMER_NAME,
        target.CITY          = source.CITY,
        target.SEGMENT       = source.SEGMENT

WHEN NOT MATCHED THEN
    INSERT
    (
        CUSTOMER_ID,
        CUSTOMER_NAME,
        CITY,
        SEGMENT
    )
    VALUES
    (
        source.CUSTOMER_ID,
        source.CUSTOMER_NAME,
        source.CITY,
        source.SEGMENT
    );
```

Check:

```sql
SELECT *
FROM DWH.DIM_CUSTOMER_INCREMENTAL
ORDER BY CUSTOMER_ID;
```

The final business state remains:

```text
C101 | Ravi  | Bangalore
C102 | Priya | Pune
C103 | Arun  | Delhi
C104 | Sneha | Mumbai
C105 | Meena | Chennai
```

There is still one row for each customer.

This illustrates idempotency:

> Processing the same batch again does not produce an incorrect final business state.

---

# 13. Where Idempotency Fits

Idempotency is **not another step** in the pipeline.

It is a property we want the loading process to have.

```text
Incremental batch
       |
       ↓
     MERGE
       |
       ↓
      DWH

Same batch again
       |
       ↓
     MERGE
       |
       ↓
Same correct DWH state
```

So remember:

```text
CDC
→ What changed?

Incremental loading
→ What data should I process?

MERGE
→ How do I apply it?

Upsert
→ UPDATE existing + INSERT new

Idempotency
→ Same batch again = same correct final state
```

---

# 14. Why Incremental Loading?

Imagine the source has:

```text
10,000,000 customers
```

Tomorrow only:

```text
5,000 customers
```

are new or changed.

A full load processes:

```text
10,000,000
```

An incremental process tries to process:

```text
5,000
```

Conceptually:

```text
SOURCE
10 million records
       |
       | identify new/changed
       ↓
5,000 records
       |
       ↓
MERGE
       |
       ↓
DWH
```

This reduces unnecessary processing.

---

# 15. Full Load vs Incremental Load

## Full load

```text
Source
  ↓
Read everything
  ↓
Load everything
```

## Incremental load

```text
Source
  ↓
Identify new/changed data
  ↓
Process only that data
  ↓
MERGE into DWH
```

Important:

> Incremental loading decides which records need to be processed. MERGE decides what to do with those records.

---

# 16. MERGE Does Not Automatically Make Loading Incremental

Suppose the source sends:

```text
10 million records
```

and only:

```text
5,000
```

changed.

If all 10 million are sent into the MERGE, the process is still handling all 10 million.

MERGE does not automatically discover the 5,000 changed records.

The efficient pattern is:

```text
Source
  ↓
Incremental extraction
  ↓
5,000 changed/new records
  ↓
MERGE
  ↓
DWH
```

---

# 17. Conditional MERGE

We can also avoid updating a matched record when its values have not changed.

```sql
MERGE INTO DWH.DIM_CUSTOMER_INCREMENTAL AS target

USING STAGING.CUSTOMER_INCREMENTAL_LOAD AS source

ON target.CUSTOMER_ID = source.CUSTOMER_ID

WHEN MATCHED
     AND (
          target.CUSTOMER_NAME <> source.CUSTOMER_NAME
          OR target.CITY <> source.CITY
          OR target.SEGMENT <> source.SEGMENT
     )
THEN
    UPDATE SET
        target.CUSTOMER_NAME = source.CUSTOMER_NAME,
        target.CITY          = source.CITY,
        target.SEGMENT       = source.SEGMENT

WHEN NOT MATCHED THEN
    INSERT
    (
        CUSTOMER_ID,
        CUSTOMER_NAME,
        CITY,
        SEGMENT
    )
    VALUES
    (
        source.CUSTOMER_ID,
        source.CUSTOMER_NAME,
        source.CITY,
        source.SEGMENT
    );
```

Conceptually:

```text
Incoming
   |
   ↓
Key exists?
 /       YES       NO
 |         |
Values     INSERT
changed?
 /   YES   NO
 |     |
UPDATE NOTHING
```

This is a second optimization layer.

```text
Incremental loading
→ reduce records entering MERGE

Conditional MERGE
→ avoid unnecessary updates for unchanged records
```

---

# 18. How Do We Know What Changed?

One common approach is a timestamp.

Suppose the source contains:

```text
CUSTOMER_ID
CUSTOMER_NAME
CITY
UPDATED_AT
```

If the previous successful load ended at:

```text
2026-08-25 23:59:59
```

we can request:

```sql
SELECT *
FROM SOURCE_CUSTOMERS
WHERE UPDATED_AT > '2026-08-25 23:59:59';
```

Conceptually:

```text
Source
10 million records
       |
       | UPDATED_AT > last processed time
       ↓
5,000 records
       |
       ↓
MERGE
```

This is a common incremental-loading technique.

---

# 19. CDC — Change Data Capture

CDC answers:

> What changed in the source?

For example:

```text
CUSTOMER_ID | OPERATION
------------|----------
C101        | UPDATE
C105        | INSERT
C108        | DELETE
```

Conceptually:

```text
SOURCE
   |
   | changes happen
   ↓
  CDC
   |
   | records the changes
   ↓
Incremental change data
   |
   ↓
MERGE / transformation
   |
   ↓
DWH
```

CDC and incremental loading are related, but they are not identical.

```text
CDC
→ captures changes

Incremental loading
→ processes only new/changed data
```

CDC can be one way of producing the incremental data.

---

# 20. Final Mental Model

Keep this diagram as the main picture:

```text
                         SOURCE SYSTEM
                              |
                     Data changes happen
                              |
                              ▼
                             CDC
                     "What changed?"
                              |
                              ▼
                       RAW / STAGING
                              |
                   Incremental change data
                              |
                              ▼
                            MERGE
                    "How do I apply it?"
                         /                                  /                               MATCHED        NOT MATCHED
                      |                |
                    UPDATE           INSERT
                        \              /
                         \            /
                          ▼          ▼
                              DWH
                               |
                         FACT / DIM
                               |
                              MART
                               |
                               BI
```

Idempotency sits around the process:

```text
              SAME BATCH PROCESSED AGAIN
                         |
                         ▼
                SAME CORRECT DWH STATE
                         ↑
                    IDEMPOTENCY
```

---

# 21. The Five-Concept Shortcut

```text
CDC
→ WHAT changed?

INCREMENTAL
→ WHAT should I process?

MERGE
→ HOW do I apply it?

UPSERT
→ UPDATE + INSERT

IDEMPOTENCY
→ Can I safely process the same batch again?
```

---

# 22. Next Step — SCD Type 1

Now the same customer scenario becomes:

```text
Before:
C101 | Ravi | Mumbai

Source changes:
C101 | Ravi | Bangalore
```

### SCD Type 1

The old value is overwritten:

```text
C101 | Ravi | Bangalore
```

Then SCD Type 2 will preserve the history:

```text
C101 | Ravi | Mumbai
C101 | Ravi | Bangalore
```

SCD Type 2 will introduce:

```text
Surrogate Key
Effective Start Date
Effective End Date
Current Flag
Historical Version
```

