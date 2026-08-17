# Assignment: Two-Number Calculator

## Goal

Write a program that asks the user for two numbers, adds them together, displays the result, and determines whether the result is a large or small number.

---

# Step 1 — Planning Logic

### Focus: Planning Logic & Pseudocode

Write pseudocode for the following steps:

1. Get the first number from the user.
2. Get the second number from the user.
3. Calculate the sum of the two numbers.
4. Check whether the sum is greater than `100`.
5. Display an appropriate message.
6. Display the final calculated sum.

### Pseudocode

```text
START

READ numA

READ numB

sumResult ← numA + numB

IF sumResult > 100 THEN
    PRINT "Result is a large number."
ELSE
    PRINT "Result is a small number."
END IF

PRINT "Final Sum = ", sumResult

END
```

---

# Step 2 — Programming Basics & Syntax

### Focus: Variables, Data Types, Input & Operators

## 2.1 Declare Variables

Create three numeric variables:

```text
numA
numB
sumResult
```

Use an appropriate numeric data type.

---

## 2.2 Read Input

Prompt the user to enter two numbers.

```text
Enter first number:
Enter second number:
```

Store the values in:

```text
numA
numB
```

---

## 2.3 Calculate the Sum

Use the addition operator `+`.

```text
sumResult = numA + numB
```

### Example

If:

```text
numA = 40
numB = 75
```

then:

```text
sumResult = 40 + 75
          = 115
```

---

# Step 3 — Control Structures

### Focus: `if / else`

Use the calculated `sumResult` to make a decision.

### Business Rule

```text
IF sumResult > 100
    Result is a large number.
ELSE
    Result is a small number.
```

### Pseudocode

```text
IF sumResult > 100 THEN

    PRINT "Result is a large number."

ELSE

    PRINT "Result is a small number."

END IF
```

---

# Step 4 — Output

### Focus: Displaying Data

Display the final calculated sum clearly.

```text
PRINT "Final Sum = ", sumResult
```

The program should produce output similar to:

```text
Enter first number: 40
Enter second number: 75

Result is a large number.
Final Sum = 115
```

---

# Complete Pseudocode

```text
START

    READ numA

    READ numB

    sumResult ← numA + numB

    IF sumResult > 100 THEN
        PRINT "Result is a large number."
    ELSE
        PRINT "Result is a small number."
    END IF

    PRINT "Final Sum = ", sumResult

END
```

---

# Test Cases

## Test Case 1

### Input

```text
numA = 40
numB = 75
```

### Calculation

```text
40 + 75 = 115
```

### Expected Output

```text
Result is a large number.
Final Sum = 115
```

---

## Test Case 2

### Input

```text
numA = 20
numB = 30
```

### Calculation

```text
20 + 30 = 50
```

### Expected Output

```text
Result is a small number.
Final Sum = 50
```

---

## Test Case 3

### Input

```text
numA = 100
numB = 0
```

### Calculation

```text
100 + 0 = 100
```

Since the condition is:

```text
sumResult > 100
```

`100` is **not greater than** `100`.

### Expected Output

```text
Result is a small number.
Final Sum = 100
```

---

# Concepts Covered

| Concept               | Example                     |
| --------------------- | --------------------------- |
| Variable              | `numA`, `numB`, `sumResult` |
| Data type             | Numeric                     |
| Input                 | Read two numbers            |
| Assignment            | `sumResult = ...`           |
| Arithmetic operator   | `+`                         |
| Conditional statement | `if / else`                 |
| Comparison operator   | `>`                         |
| Output                | Display calculated result   |

---

# Programming Challenge

Modify the program to display an additional message:

```text
If sumResult > 100
    "Result is a large number."

If sumResult = 100
    "Result is exactly 100."

If sumResult < 100
    "Result is a small number."
```

The challenge introduces the idea of **multiple conditions** and prepares you for `if / else if / else`.
