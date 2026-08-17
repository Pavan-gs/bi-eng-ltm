# ACID in SQL

ACID describes four properties that make database transactions **reliable, safe, and consistent**.

```text
A → Atomicity
C → Consistency
I → Isolation
D → Durability
```

---

## 1. Atomicity — "All or Nothing"

A transaction must either **completely succeed or completely fail**.

### Example: Bank Transfer

Suppose we transfer ₹10,000 from Account A to Account B.

```sql
START TRANSACTION;

UPDATE accounts
SET balance = balance - 10000
WHERE account_id = 101;

UPDATE accounts
SET balance = balance + 10000
WHERE account_id = 202;

COMMIT;
```

There are two operations:

```text
Account A → Deduct ₹10,000
Account B → Add ₹10,000
```

If the first operation succeeds but the second fails, we don't want:

```text
Account A → ₹40,000
Account B → ₹20,000
```

because ₹10,000 has effectively disappeared.

Instead, the database should roll back the entire transaction:

```sql
ROLLBACK;
```

### Key Idea

> **Either everything happens, or nothing happens.**

---

## 2. Consistency — "Rules Must Always Be Valid"

A transaction must move the database from **one valid state to another valid state**.

Suppose the business rule is:

```text
Account balance cannot be negative.
```

We can enforce this with a constraint:

```sql
CREATE TABLE accounts
(
    account_id INT PRIMARY KEY,
    balance DECIMAL(12,2) CHECK (balance >= 0)
);
```

This should not be allowed:

```sql
UPDATE accounts
SET balance = balance - 60000
WHERE account_id = 101;
```

if the account only contains ₹50,000.

Database constraints help maintain consistency:

```text
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
```

### Key Idea

> **Data must always obey the defined database and business rules.**

---

## 3. Isolation — "Transactions Should Not Interfere"

Multiple users can execute transactions at the same time.

Consider an e-commerce application.

There is only **1 iPhone left in stock**.

```text
Customer A → Checks stock → 1 available
Customer B → Checks stock → 1 available
```

Both customers try to purchase it at almost the same time.

Without proper isolation, both transactions might read the same stock value and both attempt to purchase the product.

Isolation controls how concurrent transactions interact.

### Common Isolation Levels

```text
READ UNCOMMITTED
READ COMMITTED
REPEATABLE READ
SERIALIZABLE
```

Higher isolation generally provides stronger protection from concurrency problems, although it can reduce concurrency and performance.

### Key Idea

> **Concurrent transactions should not interfere with each other in a way that produces incorrect results.**

---

## 4. Durability — "Committed Means Saved"

Suppose the bank transfer completes successfully:

```sql
COMMIT;
```

Immediately afterward, the database server crashes.

When the database comes back, the committed transaction should still exist.

```text
Account A → ₹40,000
Account B → ₹30,000
```

The changes should not disappear simply because the server crashed.

Databases use mechanisms such as:

```text
Transaction Logs
Write-Ahead Logging
Recovery Mechanisms
Disk Persistence
Replication
Backups
```

### Key Idea

> **Once a transaction is committed, its changes survive failures.**

---

# Complete ACID Example

Consider a bank transfer.

```sql
START TRANSACTION;

-- Deduct money from Account A
UPDATE accounts
SET balance = balance - 10000
WHERE account_id = 101;

-- Add money to Account B
UPDATE accounts
SET balance = balance + 10000
WHERE account_id = 202;

COMMIT;
```

If something goes wrong:

```sql
ROLLBACK;
```

The transaction follows ACID principles.

---

# ACID Summary

| Property        | Meaning                                             | Bank Transfer Example                   |
| --------------- | --------------------------------------------------- | --------------------------------------- |
| **Atomicity**   | All or nothing                                      | Debit and credit both happen            |
| **Consistency** | Database rules remain valid                         | Balance cannot violate constraints      |
| **Isolation**   | Concurrent transactions don't interfere incorrectly | Simultaneous transfers are controlled   |
| **Durability**  | Committed changes survive failures                  | Transfer remains after database restart |

---

# Easy Way to Remember ACID

```text
A → All or Nothing
C → Correct Rules
I → Independent Transactions
D → Data Stays
```

---

# ACID in an E-Commerce Application

Imagine an Amazon/Flipkart-style order process:

```text
Customer places order
        ↓
Create Order
        ↓
Reduce Inventory
        ↓
Process Payment
        ↓
Create Order Items
        ↓
Update Order Status
        ↓
COMMIT
```

Suppose:

```text
Order created        ✓
Inventory reduced    ✓
Payment processed    ✓
Order items created  ✗
```

Should the database leave the system in this state?

```text
Order exists
Inventory reduced
Money deducted
Order incomplete
```

**No.**

The database transaction should roll back the database changes where appropriate:

```text
Order created        → ROLLBACK
Inventory reduced    → ROLLBACK
Order items created  → ROLLBACK
```

Payment processing may involve an external payment system, so it typically requires additional application-level handling rather than assuming a database `ROLLBACK` can undo the payment.

This is where ACID becomes important in real-world applications.

---

# ACID vs Transaction

These two concepts are related but different.

### Transaction

A **transaction** is a group of database operations treated as one logical unit.

```sql
START TRANSACTION;

UPDATE ...
INSERT ...
DELETE ...

COMMIT;
```

### ACID

ACID describes the **properties that make transactions reliable**.

```text
Transaction
    │
    ├── Atomicity
    ├── Consistency
    ├── Isolation
    └── Durability
```

---

# Real-World Examples

| Application   | Example Transaction                          |
| ------------- | -------------------------------------------- |
| Banking       | Transfer money between accounts              |
| E-commerce    | Place an order                               |
| Airline       | Book a seat                                  |
| Hospital      | Create patient billing transaction           |
| Warehouse     | Update inventory after shipment              |
| Payroll       | Process employee salary                      |
| Food Delivery | Create order and update restaurant inventory |

---

# One-Line Definition

> **ACID is a set of properties that ensures database transactions are processed reliably, consistently, and safely even when multiple users or system failures are involved.**
