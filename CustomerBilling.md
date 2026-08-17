# Hands-On Lab — Customer Billing with Discount & Highest-Value Item

## Goal

Compute a customer's final bill for multiple purchased items and identify which single item contributed the highest line total.

Apply a **10% discount if the grand total exceeds 5000**.

---

## Inputs

* `N` — Number of distinct items

For each of the `N` items:

* `itemName` — Item name
* `quantity` — Quantity purchased
* `unitPrice` — Price of one unit

---

## Outputs

Display:

```text
Final Bill Amount = <value>
Highest value item was: <name> worth <lineTotal>
```

If no items are purchased:

```text
No items were purchased.
```

---

## Assumptions

* `N` is an integer.
* Quantity is greater than or equal to `0`.
* Unit price is greater than or equal to `0`.
* If `N = 0`, the total bill is `0`.
* No currency formatting is required.
* The discount is applied **once to the grand total**, not separately to each item.
* The discount rule is strictly `grandTotal > 5000`.
* If the grand total is exactly `5000`, no discount is applied.

---

# Step-by-Step Plan

## Step 1 — Read Number of Items

First, read `N`.

```text
READ N
```

### Why?

`N` determines how many times the program needs to read item details.

For example:

```text
N = 3
```

means the program must process three items.

---

## Step 2 — Initialize Variables

Create variables to maintain the bill and track the highest-value item.

```text
SET grandTotal ← 0

SET maxLineTotal ← 0

SET maxItemName ← ""
```

### Purpose

| Variable       | Purpose                              | Initial Value |
| -------------- | ------------------------------------ | ------------: |
| `grandTotal`   | Stores total value of all items      |           `0` |
| `maxLineTotal` | Stores highest individual line total |           `0` |
| `maxItemName`  | Stores name of highest-value item    |          `""` |

### Why start with 0?

An accumulator such as `grandTotal` must start at zero because nothing has been added yet.

The maximum tracker also starts at zero because prices and quantities are non-negative.

---

# Step 3 — Process Each Item

Use a loop to process all `N` items.

```text
FOR i ← 1 TO N

    READ itemName
    READ quantity
    READ unitPrice

    lineTotal ← quantity × unitPrice

    grandTotal ← grandTotal + lineTotal

    IF lineTotal > maxLineTotal THEN

        maxLineTotal ← lineTotal
        maxItemName ← itemName

    END IF

END FOR
```

---

## Understanding the Line Total

For every item:

```text
lineTotal = quantity × unitPrice
```

Example:

```text
quantity = 5
unitPrice = 120

lineTotal = 5 × 120
          = 600
```

---

## Updating the Grand Total

Every line total is added to the grand total.

```text
grandTotal ← grandTotal + lineTotal
```

For example:

```text
grandTotal = 0

Notebook = 600

grandTotal = 0 + 600
           = 600
```

Then:

```text
Pen = 200

grandTotal = 600 + 200
           = 800
```

And so on.

This is called an **accumulator pattern**.

---

# Step 4 — Find the Highest-Value Item

For every item, compare its line total with the current maximum.

```text
IF lineTotal > maxLineTotal THEN

    maxLineTotal ← lineTotal
    maxItemName ← itemName

END IF
```

Suppose:

```text
maxLineTotal = 600
```

and the next item has:

```text
lineTotal = 3600
```

Then:

```text
3600 > 600
```

Therefore:

```text
maxLineTotal = 3600
maxItemName = "Bag"
```

The program does **not** need to store every item and search again later.

It keeps track of the highest value while processing the items.

This is called the **running maximum pattern**.

---

# Step 5 — Apply Discount

After all items have been processed:

```text
IF grandTotal > 5000 THEN

    discount ← grandTotal × 0.10

    grandTotal ← grandTotal - discount

END IF
```

The important point is that the discount is applied **after calculating the complete bill**.

For example:

```text
grandTotal = 6000

discount = 6000 × 0.10
         = 600

grandTotal = 6000 - 600
           = 5400
```

Therefore:

```text
Final Bill Amount = 5400
```

---

# Step 6 — Display Results

Display the final bill.

```text
PRINT "Final Bill Amount = ", grandTotal
```

If items were purchased:

```text
IF N > 0 THEN

    PRINT "Highest value item was: ",
          maxItemName,
          " worth ",
          maxLineTotal

ELSE

    PRINT "No items were purchased."

END IF
```

---

# Complete Pseudocode

```text
READ N

SET grandTotal ← 0
SET maxLineTotal ← 0
SET maxItemName ← ""

FOR i ← 1 TO N

    READ itemName
    READ quantity
    READ unitPrice

    lineTotal ← quantity × unitPrice

    grandTotal ← grandTotal + lineTotal

    IF lineTotal > maxLineTotal THEN

        maxLineTotal ← lineTotal
        maxItemName ← itemName

    END IF

END FOR

IF grandTotal > 5000 THEN

    discount ← grandTotal × 0.10

    grandTotal ← grandTotal - discount

END IF

PRINT "Final Bill Amount = ", grandTotal

IF N > 0 THEN

    PRINT "Highest value item was: ",
          maxItemName,
          " worth ",
          maxLineTotal

ELSE

    PRINT "No items were purchased."

END IF
```

---

# Worked Example

## Input

```text
N = 3

Item 1:
itemName = "Notebook"
quantity = 5
unitPrice = 120

Item 2:
itemName = "Pen"
quantity = 10
unitPrice = 20

Item 3:
itemName = "Bag"
quantity = 2
unitPrice = 1800
```

---

# Desk Check / Trace

| Item     | Quantity | Unit Price | Line Total | Grand Total | Max Item | Max Line Total |
| -------- | -------: | ---------: | ---------: | ----------: | -------- | -------------: |
| Notebook |        5 |        120 |        600 |         600 | Notebook |            600 |
| Pen      |       10 |         20 |        200 |         800 | Notebook |            600 |
| Bag      |        2 |       1800 |       3600 |        4400 | Bag      |           3600 |

After processing all items:

```text
Grand Total = 4400
```

Discount condition:

```text
4400 > 5000
```

This is false.

Therefore:

```text
Discount = 0
Final Bill Amount = 4400
```

Highest-value item:

```text
Bag
3600
```

---

# Expected Output

```text
Final Bill Amount = 4400
Highest value item was: Bag worth 3600
```

---

# Test Case 2 — Discount Applied

## Input

```text
N = 3

Laptop
1
75000

Mouse
2
1500

Keyboard
1
4500
```

Line totals:

```text
Laptop   = 1 × 75000 = 75000
Mouse    = 2 × 1500  = 3000
Keyboard = 1 × 4500  = 4500
```

Grand total:

```text
75000 + 3000 + 4500 = 82500
```

Discount:

```text
82500 × 0.10 = 8250
```

Final bill:

```text
82500 - 8250 = 74250
```

Output:

```text
Final Bill Amount = 74250
Highest value item was: Laptop worth 75000
```

---

# Test Case 3 — No Items

## Input

```text
N = 0
```

Output:

```text
Final Bill Amount = 0
No items were purchased.
```

---

# Test Case 4 — Exactly 5000

Suppose:

```text
grandTotal = 5000
```

Condition:

```text
grandTotal > 5000
```

is false.

Therefore:

```text
Final Bill Amount = 5000
```

No discount is applied.

---

# Test Case 5 — Zero Quantity

```text
N = 2

Pen
0
20

Notebook
0
100
```

Line totals:

```text
Pen      = 0 × 20  = 0
Notebook = 0 × 100 = 0
```

Grand total:

```text
0
```

Output:

```text
Final Bill Amount = 0
Highest value item was: Pen worth 0
```

---

# Important Programming Patterns

## 1. Accumulator

Used to calculate a running total.

```text
grandTotal ← grandTotal + lineTotal
```

Common examples:

```text
sum
total sales
total salary
total marks
total quantity
```

---

## 2. Running Maximum

Used to find the largest value while processing data.

```text
IF value > maximum THEN
    maximum ← value
END IF
```

Common examples:

```text
highest salary
highest price
highest marks
largest transaction
highest sales
```

---

## 3. Counter-Controlled Loop

The value of `N` controls how many times the loop executes.

```text
FOR i ← 1 TO N
```

If:

```text
N = 5
```

the loop executes five times.

---

## 4. Conditional Processing

The discount is applied only when a business rule is satisfied.

```text
IF grandTotal > 5000 THEN
    discount ← grandTotal × 0.10
END IF
```

This represents a real business rule:

> Customers spending more than ₹5,000 receive a 10% discount.

---

# Concepts Covered

| Programming Concept   | Used In                               |
| --------------------- | ------------------------------------- |
| Variables             | `grandTotal`, `quantity`, `unitPrice` |
| Input                 | `READ`                                |
| Output                | `PRINT`                               |
| Arithmetic operators  | `×`, `+`, `-`                         |
| Assignment            | `←`                                   |
| Loop                  | `FOR`                                 |
| Conditional statement | `IF`                                  |
| Accumulator           | `grandTotal`                          |
| Running maximum       | `maxLineTotal`                        |
| String variable       | `maxItemName`                         |
| Business rule         | 10% discount                          |
| Edge-case handling    | `N = 0`                               |
| Trace / desk check    | Manual execution                      |

---

# Lab Challenge

Modify the program to support the following additional business rules:

1. Apply **15% discount** when the grand total exceeds `10000`.
2. Apply **10% discount** when the grand total is between `5001` and `10000`.
3. No discount when the grand total is `5000` or below.
4. Display the discount amount separately.
5. Display the number of items purchased.
6. Display the item with the lowest line total.
7. Display the average line total.
8. Display the total quantity purchased.

Example output:

```text
Total Items = 4
Total Quantity = 12
Gross Bill = 12500
Discount = 1875
Final Bill Amount = 10625
Highest value item was: Laptop worth 75000
Lowest value item was: Pen worth 200
Average Line Total = 31250
```

---

# Key Takeaway

The most important pattern in this exercise is:

```text
FOR each item

    calculate value

    add value to total

    compare value with current maximum

    update maximum if necessary

END FOR
```

This same pattern appears in real-world applications such as:

* Finding the highest-selling product
* Finding the largest bank transaction
* Finding the employee with the highest salary
* Finding the most expensive order
* Finding the customer with the highest purchase
* Finding the highest-scoring student

The business problem changes, but the underlying programming pattern remains the same.
