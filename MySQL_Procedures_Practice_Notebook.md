# MySQL Procedures — Practice Notebook

## Problem 1 — Employee Job History

### Scenario

HR wants a reusable procedure to retrieve the job history of a particular employee.

Create a procedure named `GetEmployeeJobHistory`.

The procedure should accept an employee ID as an `IN` parameter and display:

- Employee ID
- Job ID
- Start Date
- End Date

from `JOB_HISTORY`.

Sort the result by `START_DATE` in ascending order.

### Requirements

- Use an `IN` parameter.
- Retrieve data from `JOB_HISTORY`.
- The employee ID must be supplied when calling the procedure.
- Return all job-history records for that employee.

### Test

```sql
CALL GetEmployeeJobHistory(101);
```

### Think about

```text
Input?
    ↓
employee_id

Table?
    ↓
JOB_HISTORY

Could there be multiple rows?
    ↓
YES

Therefore?
    ↓
Procedure returning a result set
```

---

## Problem 2 — Department Salary Analysis

### Scenario

The HR department wants a reusable procedure that accepts a department ID and calculates the salary statistics for that department.

Create a procedure named `GetDepartmentSalaryStats`.

It should accept the department ID as an `IN` parameter and return:

- Department ID
- Number of employees
- Minimum salary
- Maximum salary
- Average salary

### Example

For:

```sql
CALL GetDepartmentSalaryStats(60);
```

the procedure should return a summary similar to:

```text
department_id | employee_count | min_salary | max_salary | avg_salary
--------------|----------------|------------|------------|-----------
60            | 5              | 4200       | 9000       | 6500.00
```

### Requirements

- Use an `IN` parameter.
- Use aggregate functions.
- Return the result as a result set.
- Do not hard-code the department ID.
- The procedure should work for any valid department ID.

### Think about

```text
Input
 ↓
department_id

Filter
 ↓
WHERE department_id = parameter

Calculations
 ↓
COUNT()
MIN()
MAX()
AVG()

Result
 ↓
one summary row
```

---

## Quick Reminder

### Procedure 1

```text
IN parameter
    +
multiple-row result
    +
ORDER BY
```

### Procedure 2

```text
IN parameter
    +
aggregate functions
    +
single summary-row result
```

### Useful HR tables

```text
EMPLOYEES
DEPARTMENTS
JOBS
JOB_HISTORY
```
