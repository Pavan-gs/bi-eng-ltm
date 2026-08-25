# Hospital SQL Scenario Playbook
## JOINs + WHERE + GROUP BY + HAVING + Subqueries + Window Functions

This playbook uses the existing `hospital_db` database.

### Scope

Only these SQL concepts are used:

- SELECT
- WHERE
- JOIN / LEFT JOIN
- GROUP BY
- HAVING
- Subqueries
- Window functions

No CTEs, views, procedures, functions, triggers, set operators, or unrelated SQL topics are included.

---

# 1. The Problem-Solving Method

Do not start writing SQL immediately.

For every scenario:

```text
1. Read the question
       ↓
2. What should ONE output row represent?
       ↓
3. Which table contains that information?
       ↓
4. Which other tables are needed?
       ↓
5. Do we need a JOIN?
       ↓
6. Do we need WHERE?
       ↓
7. Do we need GROUP BY?
       ↓
8. Do we need HAVING?
       ↓
9. Do we need a subquery?
       ↓
10. Do we need a window function?
```

## The most important question

> What should ONE output row represent?

Examples:

```text
One row = one appointment
One row = one patient
One row = one doctor
One row = one city
One row = one specialization
```

Once this is clear, the query becomes much easier to design.

---

# 2. Quick Decision Guide

| Requirement | Usually think of |
|---|---|
| Patient name + doctor name | JOIN |
| Completed appointments | JOIN + WHERE |
| Number of appointments per doctor | JOIN + GROUP BY |
| Doctors with more than 2 appointments | GROUP BY + HAVING |
| Patients whose bill is above average | Subquery |
| Doctors whose fee is above average | Subquery |
| Patients who have appointments | EXISTS |
| Patients who never had appointments | NOT EXISTS / LEFT JOIN |
| Rank doctors by fee | Window function |
| Highest-fee doctor in each specialization | Window function |
| Latest appointment for every patient | ROW_NUMBER |
| Top 2 doctors in each specialization | GROUP BY + window function |
| Every appointment + doctor's total appointments | Window function |
| Doctor revenue + revenue rank | GROUP BY + window function |

---

# PART A — JOIN + WHERE

## Question 1 — Patient and Doctor Details

### Scenario

The hospital wants a list of all appointments showing:

- patient name
- doctor name
- specialization
- appointment date
- appointment status

### Target output

```text
patient_name | doctor_name | specialization | appointment_date | status
-------------|-------------|----------------|------------------|----------
Rahul        | Dr. Kumar   | Cardiology     | 2025-05-01       | Completed
Priya        | Dr. Mehta   | Neurology      | 2025-05-03       | Completed
Arun         | Dr. Kumar   | Cardiology     | 2025-05-05       | Pending
...
```

### Step 1 — What is one row?

One row represents:

```text
ONE APPOINTMENT
```

Therefore `appointments` is the main table.

### Step 2 — Where is the information?

```text
Patient name      → patients
Doctor name       → doctors
Specialization    → doctors
Appointment date  → appointments
Status            → appointments
```

### Step 3 — How are the tables connected?

```text
appointments.patient_id = patients.patient_id

appointments.doctor_id = doctors.doctor_id
```

### Step 4 — Solution

```sql
SELECT
    p.patient_name,
    d.doctor_name,
    d.specialization,
    a.appointment_date,
    a.status
FROM appointments a
JOIN patients p
    ON a.patient_id = p.patient_id
JOIN doctors d
    ON a.doctor_id = d.doctor_id;
```

### Why no GROUP BY?

We are not asking for:

```text
COUNT
SUM
AVG
```

We want appointment rows.

### Why no subquery?

No comparison with another result is required.

### Why no window function?

We are not ranking or calculating something across related rows.

---

## Practice Question 2

Show:

```text
patient_name
doctor_name
appointment_date
```

only for `Completed` appointments.

---

## Practice Question 3

Show:

```text
patient_name
city
doctor_name
specialization
```

for patients from `Bangalore`.

---

## Practice Question 4

Show:

```text
patient_name
doctor_name
bill_amount
payment_status
```

for all `Paid` bills.

---

# PART B — JOIN + WHERE + Multiple Conditions

## Question 5 — Completed Cardiology Appointments

### Scenario

Find all completed appointments handled by Cardiology doctors.

### Target output

```text
patient_name | doctor_name | appointment_date | status
-------------|-------------|------------------|----------
Rahul        | Dr. Kumar   | 2025-05-01       | Completed
...
```

### Approach

One row:

```text
ONE APPOINTMENT
```

Tables:

```text
appointments
patients
doctors
```

Conditions:

```text
status = Completed
specialization = Cardiology
```

### Solution

```sql
SELECT
    p.patient_name,
    d.doctor_name,
    a.appointment_date,
    a.status
FROM appointments a
JOIN patients p
    ON a.patient_id = p.patient_id
JOIN doctors d
    ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed'
  AND d.specialization = 'Cardiology';
```

### Important rule

`WHERE` filters individual rows.

---

## Practice Question 6

Find all completed Neurology appointments.

Show:

```text
patient_name
doctor_name
appointment_date
```

---

## Practice Question 7

Find patients who had an appointment with a doctor whose consultation fee is greater than `1000`.

Show:

```text
patient_name
doctor_name
consultation_fee
```

---

## Practice Question 8

Show appointments where:

```text
status = 'Completed'
AND bill_amount > 1000
```

Show:

```text
patient_name
doctor_name
bill_amount
```

---

# PART C — JOIN + GROUP BY

## Question 9 — Number of Appointments per Doctor

### Scenario

Find how many appointments each doctor has handled.

### Target output

```text
doctor_name | appointment_count
-------------|-----------------
Dr. Kumar   | 2
Dr. Mehta   | 1
...
```

### Step 1 — What is one row?

```text
ONE DOCTOR
```

### Step 2 — What tables?

```text
doctors
appointments
```

### Step 3 — What calculation?

```text
COUNT(a.appointment_id)
```

### Step 4 — Why GROUP BY?

We need one result for each doctor.

### Solution

```sql
SELECT
    d.doctor_name,
    COUNT(a.appointment_id) AS appointment_count
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.doctor_name;
```

### Mental model

Before grouping:

```text
Dr. Kumar
Dr. Kumar
Dr. Mehta
Dr. Sharma
...
```

After grouping:

```text
Dr. Kumar   → 2
Dr. Mehta   → 1
Dr. Sharma  → 1
```

---

## Practice Question 10

Find the number of completed appointments for each doctor.

Output:

```text
doctor_name
completed_appointments
```

---

## Practice Question 11

Find total paid billing for each doctor.

Output:

```text
doctor_name
total_paid_billing
```

---

## Practice Question 12

Find total treatment cost handled by each doctor.

Output:

```text
doctor_name
total_treatment_cost
```

---

# PART D — GROUP BY + HAVING

## Question 13 — Doctors With More Than One Appointment

### Scenario

Find doctors who have handled more than one appointment.

### Approach

We already need:

```text
COUNT
+
GROUP BY
```

But now we want:

```text
COUNT > 1
```

This is a condition on the grouped result.

Therefore we use:

```text
HAVING
```

### Solution

```sql
SELECT
    d.doctor_name,
    COUNT(a.appointment_id) AS appointment_count
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.doctor_name
HAVING COUNT(a.appointment_id) > 1;
```

### Important rule

```text
WHERE
→ filters rows before grouping

HAVING
→ filters groups after grouping
```

---

## Practice Question 14

Find doctors with more than `1` completed appointment.

---

## Practice Question 15

Find doctors whose total paid billing is greater than `2000`.

---

## Practice Question 16

Find cities having more than `1` patient.

---

# PART E — MULTI-TABLE JOIN + GROUP BY + HAVING

## Question 17 — Doctors With High Revenue

### Scenario

Find doctors whose paid billing revenue is greater than `2000`.

### Approach

One row:

```text
ONE DOCTOR
```

Tables:

```text
doctors
appointments
billing
```

Relationship:

```text
doctors
   |
appointments
   |
billing
```

Calculation:

```text
SUM(b.bill_amount)
```

Row filter:

```text
payment_status = Paid
```

Group filter:

```text
SUM(...) > 2000
```

Therefore:

```text
JOIN
+
WHERE
+
GROUP BY
+
HAVING
```

### Solution

```sql
SELECT
    d.doctor_name,
    SUM(b.bill_amount) AS total_revenue
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
JOIN billing b
    ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Paid'
GROUP BY
    d.doctor_id,
    d.doctor_name
HAVING SUM(b.bill_amount) > 2000;
```

### Important

```text
WHERE payment_status = 'Paid'
```

filters individual billing rows.

```text
HAVING SUM(...) > 2000
```

filters the final doctor groups.

---

## Practice Question 18

Find doctors whose total treatment cost is greater than `1000`.

---

## Practice Question 19

Find patients whose total paid billing is greater than `1500`.

---

## Practice Question 20

Find specializations whose total paid revenue is greater than `2500`.

---

# PART F — SCALAR SUBQUERIES

## Question 21 — Doctors Above Average Fee

### Scenario

Find doctors whose consultation fee is greater than the average consultation fee of all doctors.

### Step 1 — Find the average

```sql
SELECT AVG(consultation_fee)
FROM doctors;
```

This returns one value.

### Step 2 — Compare every doctor with that value

```sql
SELECT
    doctor_name,
    consultation_fee
FROM doctors
WHERE consultation_fee >
(
    SELECT AVG(consultation_fee)
    FROM doctors
);
```

### Mental model

```text
             SUBQUERY
                |
                v
        Average doctor fee
                |
                v
       Compare every doctor
                |
                v
       Keep higher-fee doctors
```

This is a scalar subquery because the inner query returns one value.

---

## Practice Question 22

Find patients whose age is greater than the average patient age.

Show:

```text
patient_name
age
```

---

## Practice Question 23

Find doctors whose consultation fee is below the average consultation fee.

---

## Practice Question 24

Find bills whose amount is greater than the average bill amount.

Show:

```text
bill_id
appointment_id
bill_amount
```

---

# PART G — SUBQUERY WITH IN

## Question 25 — Patients Who Saw Cardiology Doctors

### Scenario

Find patients who had an appointment with a Cardiology doctor.

### First find Cardiology doctor IDs

```sql
SELECT doctor_id
FROM doctors
WHERE specialization = 'Cardiology';
```

This returns a list.

### Then use the list

```sql
SELECT
    p.patient_name
FROM patients p
WHERE p.patient_id IN
(
    SELECT a.patient_id
    FROM appointments a
    WHERE a.doctor_id IN
    (
        SELECT d.doctor_id
        FROM doctors d
        WHERE d.specialization = 'Cardiology'
    )
);
```

### Important idea

```text
IN
→ compare with a list of values
```

---

## Practice Question 26

Find patients who had an appointment with a Neurology doctor.

---

## Practice Question 27

Find patients who had an appointment with a doctor whose consultation fee is greater than `1500`.

---

## Practice Question 28

Find doctors who have at least one appointment for a patient from Chennai.

---

# PART H — EXISTS

## Question 29 — Patients Who Have an Appointment

### Scenario

Find patients who have at least one appointment.

The question is asking:

> Does at least one matching appointment exist?

That is what `EXISTS` is designed for.

### Solution

```sql
SELECT
    p.patient_id,
    p.patient_name
FROM patients p
WHERE EXISTS
(
    SELECT 1
    FROM appointments a
    WHERE a.patient_id = p.patient_id
);
```

### How it works

Take one patient from the outer query.

For Rahul:

```text
patient_id = 1
```

The inner query checks:

```text
Does an appointment exist for patient 1?
```

If yes:

```text
EXISTS = TRUE
```

Then the next patient is checked.

### Why is this correlated?

The inner query uses:

```text
p.patient_id
```

from the outer query.

---

## Practice Question 30

Find patients who have at least one completed appointment.

---

## Practice Question 31

Find doctors who have at least one appointment.

---

## Practice Question 32

Find patients who have at least one treatment.

---

# PART I — NOT EXISTS

## Question 33 — Patients With No Appointments

### Scenario

Find patients who have never had an appointment.

### Solution

```sql
SELECT
    p.patient_id,
    p.patient_name
FROM patients p
WHERE NOT EXISTS
(
    SELECT 1
    FROM appointments a
    WHERE a.patient_id = p.patient_id
);
```

### Mental model

```text
For each patient:

Does appointment exist?
       |
       +-- YES → reject
       |
       +-- NO  → keep
```

---

## Practice Question 34

Find patients who have never received a treatment.

---

## Practice Question 35

Find doctors who have never had an appointment.

---

## Practice Question 36

Find patients who have never received a prescription.

---

# PART J — CORRELATED SUBQUERY

## Question 37 — Patients Above Their City Average Age

### Scenario

Find patients whose age is greater than the average age of patients from their own city.

### Important observation

There is not one average for everyone.

For each patient:

```text
Patient
   ↓
Their city
   ↓
Average age in that city
   ↓
Compare patient age
```

### Solution

```sql
SELECT
    p.patient_name,
    p.city,
    p.age
FROM patients p
WHERE p.age >
(
    SELECT AVG(p2.age)
    FROM patients p2
    WHERE p2.city = p.city
);
```

### Why correlated?

The inner query refers to:

```text
p.city
```

from the outer query.

---

## Practice Question 38

Find doctors whose consultation fee is greater than the average fee within their own specialization.

---

## Practice Question 39

Find patients whose age is greater than the average age of patients of the same gender.

---

## Practice Question 40

Find doctors whose consultation fee is less than the average fee within their specialization.

---

# PART K — BASIC WINDOW FUNCTIONS

## Question 41 — Rank Doctors by Fee

### Scenario

Rank doctors from highest consultation fee to lowest.

### Target output

```text
doctor_name       | consultation_fee | fee_rank
------------------|------------------|---------
Dr. Harish Rao    | 1800             | 1
Dr. Mehta         | 1500             | 2
Dr. Kavitha Devi  | 1400             | 3
...
```

### Solution

```sql
SELECT
    doctor_name,
    consultation_fee,
    RANK() OVER
    (
        ORDER BY consultation_fee DESC
    ) AS fee_rank
FROM doctors;
```

### Key idea

`RANK()` adds information to each row.

It does not collapse the rows.

---

## Practice Question 42

Rank patients from oldest to youngest.

Output:

```text
patient_name
age
age_rank
```

---

## Practice Question 43

Rank doctors from lowest fee to highest.

---

## Practice Question 44

Use `DENSE_RANK()` to rank doctors by consultation fee.

---

# PART L — PARTITION BY

## Question 45 — Rank Doctors Within Specialization

### Scenario

Rank doctors by consultation fee, but restart the ranking for every specialization.

### Target output

```text
specialization | doctor_name | fee | rank
---------------|-------------|-----|-----
Cardiology     | ...         | ... | 1
Cardiology     | ...         | ... | 2
Neurology      | ...         | ... | 1
Neurology      | ...         | ... | 2
```

### Solution

```sql
SELECT
    specialization,
    doctor_name,
    consultation_fee,
    RANK() OVER
    (
        PARTITION BY specialization
        ORDER BY consultation_fee DESC
    ) AS fee_rank
FROM doctors;
```

### Meaning of PARTITION BY

Think:

```text
All doctors
     |
     +---- Cardiology
     |
     +---- Neurology
     |
     +---- Orthopedics
     |
     +---- ...
```

The ranking starts again inside each group.

---

## Practice Question 46

Rank patients by age within each city.

---

## Practice Question 47

Rank doctors by fee within specialization using `DENSE_RANK()`.

---

## Practice Question 48

Rank appointments for each patient by appointment date, newest first.

---

# PART M — ROW_NUMBER()

## Question 49 — Latest Appointment for Each Patient

### Scenario

Find only the latest appointment of every patient.

### Step 1 — Number the appointments

```sql
SELECT
    patient_id,
    appointment_id,
    appointment_date,
    ROW_NUMBER() OVER
    (
        PARTITION BY patient_id
        ORDER BY appointment_date DESC
    ) AS rn
FROM appointments;
```

Conceptually:

```text
patient_id | appointment_id | date       | rn
-----------|----------------|------------|---
1          | 1021           | 2025-05-19 | 1
1          | 1001           | 2025-05-01 | 2
```

### Step 2 — Keep row number 1

```sql
SELECT
    patient_id,
    appointment_id,
    appointment_date
FROM
(
    SELECT
        patient_id,
        appointment_id,
        appointment_date,
        ROW_NUMBER() OVER
        (
            PARTITION BY patient_id
            ORDER BY appointment_date DESC
        ) AS rn
    FROM appointments
) x
WHERE rn = 1;
```

### Mental model

```text
All appointments
       ↓
Group by patient for the window
       ↓
Sort newest first
       ↓
Number rows
       ↓
Keep rn = 1
```

---

## Practice Question 50

Find the earliest appointment for every patient.

---

## Practice Question 51

Find the latest completed appointment for every patient.

---

## Practice Question 52

Find the latest appointment for every doctor.

---

# PART N — GROUP BY + WINDOW FUNCTION

## Question 53 — Rank Doctors by Appointment Count

### Scenario

Rank doctors by the number of appointments they have handled.

### Important

There are two separate jobs:

```text
Job 1:
Count appointments per doctor

Job 2:
Rank those doctors
```

### Step 1 — GROUP BY

```sql
SELECT
    d.doctor_id,
    d.doctor_name,
    COUNT(a.appointment_id) AS appointment_count
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.doctor_name;
```

### Step 2 — Rank the grouped result

```sql
SELECT
    doctor_id,
    doctor_name,
    appointment_count,
    RANK() OVER
    (
        ORDER BY appointment_count DESC
    ) AS appointment_rank
FROM
(
    SELECT
        d.doctor_id,
        d.doctor_name,
        COUNT(a.appointment_id) AS appointment_count
    FROM doctors d
    JOIN appointments a
        ON d.doctor_id = a.doctor_id
    GROUP BY
        d.doctor_id,
        d.doctor_name
) x;
```

### Mental model

```text
appointments
     ↓
GROUP BY doctor
     ↓
appointment count
     ↓
RANK()
     ↓
doctor ranking
```

---

## Practice Question 54

Rank doctors by total paid billing revenue.

Output:

```text
doctor_name
total_revenue
revenue_rank
```

---

## Practice Question 55

Rank doctors by total treatment cost.

---

## Practice Question 56

Rank cities by number of patients.

---

# PART O — GROUP BY + WINDOW + PARTITION BY

## Question 57 — Rank Doctors Within Specialization by Revenue

### Scenario

Find the highest-revenue doctor within each specialization.

### Step 1

Calculate paid revenue for each doctor.

### Step 2

Rank doctors inside each specialization.

### Solution

```sql
SELECT
    specialization,
    doctor_name,
    total_revenue,
    RANK() OVER
    (
        PARTITION BY specialization
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM
(
    SELECT
        d.doctor_id,
        d.doctor_name,
        d.specialization,
        SUM(b.bill_amount) AS total_revenue
    FROM doctors d
    JOIN appointments a
        ON d.doctor_id = a.doctor_id
    JOIN billing b
        ON a.appointment_id = b.appointment_id
    WHERE b.payment_status = 'Paid'
    GROUP BY
        d.doctor_id,
        d.doctor_name,
        d.specialization
) x;
```

### Think in two stages

```text
STAGE 1
Doctor
Specialization
Total Revenue

        ↓

STAGE 2
Rank within specialization
```

---

## Practice Question 58

Rank doctors by appointment count within each specialization.

---

## Practice Question 59

Rank doctors by total treatment cost within each specialization.

---

## Practice Question 60

Find the top doctor by paid revenue in each specialization.

Hint:

```text
GROUP BY
+
RANK()
+
keep rank = 1
```

---

# PART P — WINDOW AGGREGATES

## Question 61 — Doctor Total on Every Appointment

### Scenario

For every appointment show:

```text
appointment_id
patient_name
doctor_name
appointment_date
doctor_total_appointments
```

The important requirement is:

> Keep every appointment row, but also show how many appointments that doctor has.

### Solution

```sql
SELECT
    a.appointment_id,
    p.patient_name,
    d.doctor_name,
    a.appointment_date,
    COUNT(*) OVER
    (
        PARTITION BY a.doctor_id
    ) AS doctor_total_appointments
FROM appointments a
JOIN patients p
    ON a.patient_id = p.patient_id
JOIN doctors d
    ON a.doctor_id = d.doctor_id;
```

### Why not GROUP BY?

`GROUP BY` would turn:

```text
Appointment 1001 | Dr. Kumar
Appointment 1003 | Dr. Kumar
```

into:

```text
Dr. Kumar | 2
```

But the requirement wants both appointment rows.

The window function gives:

```text
Appointment 1001 | Dr. Kumar | 2
Appointment 1003 | Dr. Kumar | 2
```

---

## Practice Question 62

For every appointment, show:

```text
patient_name
appointment_date
patient_total_appointments
```

---

## Practice Question 63

For every appointment, show:

```text
doctor_name
appointment_date
doctor_total_appointments
```

---

## Practice Question 64

For every appointment, show the total number of appointments handled by that doctor's specialization.

Hint:

```sql
COUNT(*) OVER
(
    PARTITION BY specialization
)
```

---

# PART Q — WINDOW + ORDER BY

## Question 65 — Running Appointment Count

### Scenario

Show appointments in date order and a running count of appointments.

### Solution

```sql
SELECT
    appointment_id,
    appointment_date,
    COUNT(*) OVER
    (
        ORDER BY appointment_date
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_appointments
FROM appointments
ORDER BY appointment_date;
```

### Mental model

```text
First appointment  → 1
Second appointment → 2
Third appointment  → 3
Fourth appointment → 4
...
```

---

## Practice Question 66

Create a running total of billing amounts ordered by bill ID.

---

## Practice Question 67

Create a running total of treatment costs ordered by treatment ID.

---

## Practice Question 68

For each doctor's appointments, number their appointments in chronological order.

Hint:

```text
ROW_NUMBER()
PARTITION BY doctor_id
ORDER BY appointment_date
```

---

# PART R — SUBQUERY + GROUP BY

## Question 69 — Doctors Above Average Appointment Count

### Scenario

Find doctors whose appointment count is greater than the average appointment count per doctor.

### Thinking

First:

```text
appointment count per doctor
```

Then:

```text
average of those counts
```

Then:

```text
keep doctors whose count is above that average
```

### Solution

```sql
SELECT
    d.doctor_id,
    d.doctor_name,
    COUNT(a.appointment_id) AS appointment_count
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id,
    d.doctor_name
HAVING COUNT(a.appointment_id) >
(
    SELECT AVG(appointment_count)
    FROM
    (
        SELECT
            doctor_id,
            COUNT(*) AS appointment_count
        FROM appointments
        GROUP BY doctor_id
    ) x
);
```

### Mental model

```text
Appointments
     ↓
Count per doctor
     ↓
Average of doctor counts
     ↓
Compare each doctor count
     ↓
Keep above-average doctors
```

---

## Practice Question 70

Find patients whose number of appointments is greater than the average number of appointments per patient.

---

## Practice Question 71

Find doctors whose total paid revenue is greater than the average total paid revenue of all doctors.

---

## Practice Question 72

Find cities whose patient count is greater than the average patient count per city.

---

# PART S — SUBQUERY VS WINDOW FUNCTION

## Question 73 — Fee Above Specialization Average

### Scenario

Find doctors whose consultation fee is higher than the average fee of their own specialization.

There are two good ways.

### Method 1 — Correlated subquery

```sql
SELECT
    d.doctor_name,
    d.specialization,
    d.consultation_fee
FROM doctors d
WHERE d.consultation_fee >
(
    SELECT AVG(d2.consultation_fee)
    FROM doctors d2
    WHERE d2.specialization = d.specialization
);
```

### Method 2 — Window function

```sql
SELECT
    doctor_name,
    specialization,
    consultation_fee
FROM
(
    SELECT
        doctor_name,
        specialization,
        consultation_fee,
        AVG(consultation_fee) OVER
        (
            PARTITION BY specialization
        ) AS specialization_avg
    FROM doctors
) x
WHERE consultation_fee > specialization_avg;
```

### Important comparison

```text
Correlated subquery
→ compare the current row with a related calculated result

Window function
→ calculate the related result while keeping the rows
```

---

# PART T — MIXED SCENARIOS

These should be solved independently.

## Question 74

Find the doctor with the highest total paid revenue.

Output:

```text
doctor_name
total_revenue
```

Think:

```text
JOIN
→ GROUP BY
→ SUM
→ highest result
```

---

## Question 75

Find the second-highest total paid revenue generated by a doctor.

Think:

```text
GROUP BY
→ total revenue
→ subquery
```

---

## Question 76

Find the top 2 doctors by paid revenue in every specialization.

Think:

```text
JOIN
→ WHERE
→ GROUP BY
→ SUM
→ RANK / ROW_NUMBER
→ PARTITION BY specialization
→ keep top 2
```

---

## Question 77

For every patient, show:

```text
patient_name
age
city
city_average_age
```

Do not remove any patient rows.

Think:

```text
AVG() OVER
PARTITION BY city
```

---

## Question 78

For every doctor, show:

```text
doctor_name
specialization
consultation_fee
specialization_average_fee
```

Do not remove any doctor rows.

Think:

```text
AVG() OVER
PARTITION BY specialization
```

---

## Question 79

Find doctors whose consultation fee is higher than the average fee of their specialization.

Solve it using:

1. Correlated subquery
2. Window function

---

# PART U — FINAL PRACTICE SET

## Level 1 — JOIN + WHERE

### Question 80

Show patient name, doctor name and specialization for all completed appointments.

### Question 81

Show patients from Hyderabad who had an appointment.

### Question 82

Show appointments handled by doctors whose consultation fee is greater than `1200`.

---

## Level 2 — JOIN + GROUP BY

### Question 83

Find the number of appointments for each specialization.

### Question 84

Find the total paid billing for each specialization.

### Question 85

Find the total treatment cost for each doctor.

---

## Level 3 — GROUP BY + HAVING

### Question 86

Find specializations having more than `2` appointments.

### Question 87

Find doctors whose total paid revenue is greater than `2000`.

### Question 88

Find cities having more than `1` patient.

---

## Level 4 — Subqueries

### Question 89

Find patients older than the average patient age.

### Question 90

Find doctors whose consultation fee is above the overall average.

### Question 91

Find bills above the average bill amount.

---

## Level 5 — EXISTS / NOT EXISTS

### Question 92

Find patients who have at least one completed appointment.

### Question 93

Find patients who have never had an appointment.

### Question 94

Find doctors who have never handled an appointment.

---

## Level 6 — Window Functions

### Question 95

Rank doctors by consultation fee.

### Question 96

Rank doctors by consultation fee within specialization.

### Question 97

Find the latest appointment for every patient.

### Question 98

Find the earliest appointment for every patient.

---

## Level 7 — GROUP BY + Window

### Question 99

Rank doctors by appointment count.

### Question 100

Rank doctors by total paid revenue.

### Question 101

Rank doctors by total paid revenue within specialization.

### Question 102

Find the top 2 doctors by revenue within each specialization.

### Question 103

Rank cities by number of patients.

---

## Level 8 — Mixed

### Question 104

Find doctors whose appointment count is above the average doctor appointment count.

### Question 105

Find patients whose total paid billing is above the average patient billing.

### Question 106

For every doctor, show total paid revenue and rank among all doctors.

### Question 107

For every doctor, show total paid revenue and rank within specialization.

### Question 108

For every patient, show age and average age of patients from the same city.

### Question 109

For every appointment, show the patient's total number of appointments.

### Question 110

Find the latest completed appointment for every patient.

### Question 111

Find the top 2 patients by total paid billing.

---

# FINAL CHEAT SHEET

Before writing SQL, ask:

```text
Q1. What does ONE output row represent?

    Patient?
    Doctor?
    Appointment?
    City?
    Specialization?


Q2. Where is that information?

    patients?
    doctors?
    appointments?
    billing?
    treatments?


Q3. Do I need information from another table?

    YES → JOIN / subquery


Q4. Am I filtering individual rows?

    YES → WHERE


Q5. Am I calculating COUNT / SUM / AVG per group?

    YES → GROUP BY


Q6. Am I filtering COUNT / SUM / AVG?

    YES → HAVING


Q7. Am I comparing a value with another query result?

    YES → Subquery


Q8. Do I need to keep all original rows while
    calculating rank/count/avg/etc.?

    YES → Window function


Q9. Do I need ranking inside groups?

    YES → PARTITION BY


Q10. Do I need only the first/latest/top row in
    each group?

    Usually → ROW_NUMBER() + PARTITION BY
```

# The Most Important Difference

```text
GROUP BY
-----------
Many rows
    ↓
One row per group
```

versus:

```text
WINDOW FUNCTION
----------------
Many rows
    ↓
Keep all rows
    +
Add calculation
```

Example:

```text
GROUP BY

Dr. Kumar   | 2
Dr. Mehta   | 1
```

versus:

```text
WINDOW FUNCTION

Appointment 1001 | Dr. Kumar | 2
Appointment 1003 | Dr. Kumar | 2
Appointment 1002 | Dr. Mehta | 1
```

That distinction should guide the choice between `GROUP BY` and a window function.

# The Overall Pattern

```text
                 BUSINESS QUESTION
                        |
                        v
                 WHAT IS ONE ROW?
                        |
                        v
                   CHOOSE TABLE
                        |
                        v
                 NEED OTHER DATA?
                    /       \
                  YES        NO
                   |
                  JOIN
                   |
                   v
                WHERE?
                   |
                   v
              GROUP BY?
               /      \
             YES       NO
              |
              v
           HAVING?
              |
              v
       NEED COMPARISON?
          /          \
        YES           NO
         |
      SUBQUERY

OR

Need to KEEP rows while
calculating rank/count/avg?
         |
        YES
         |
      WINDOW
```

## Final Goal

The goal is not to memorize 100 queries.

The goal is to look at a new business question and be able to say:

> "This is one row per doctor, so I need doctors as my starting table. I need appointments for the count. I need GROUP BY because I want one row per doctor. I need HAVING because I am filtering the count."

Or:

> "I need every appointment row, but I also need the doctor's total appointment count. GROUP BY would remove the appointment rows, so I need a window function."

Or:

> "I need to compare each doctor with the average fee. The average is another result, so I can use a subquery."

That is the problem-solving pattern to practice.
