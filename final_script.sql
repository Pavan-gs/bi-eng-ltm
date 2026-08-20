MySQL SQL – HR Schema Script
0. Database and Schema Setup

-- Inspect available tables.
SHOW TABLES;

-- Inspect a table's columns, data types, NULL rules, keys and defaults.
DESCRIBE EMPLOYEES;
DESCRIBE DEPARTMENTS;
DESCRIBE LOCATIONS;
DESCRIBE JOBS;
1. SELECT – Retrieving Data
1.1 Select all columns and rows
-- SELECT * returns every column.
-- Useful for initial exploration; avoid it when only a few columns are required.
SELECT *
FROM EMPLOYEES;
•	A missing FROM clause is valid only when the SELECT expression does not need a table.
1.2 Select specific columns
-- Projection: return only the columns required by the query.
SELECT FIRST_NAME, JOB_ID, SALARY
FROM EMPLOYEES;
1.3 Computed columns
-- A computed column does not have to exist physically in the table.
SELECT
    LAST_NAME,
    JOB_ID,
    SALARY,
    SALARY + 500 AS IncreasedSalary,
    (SALARY + 100) * 12 AS YearlyBonus
FROM EMPLOYEES;

-- Arithmetic operators: +, -, *, /, %
-- Division by zero is an error; do not use a zero denominator.
1.4 SELECT without a table
-- MySQL can evaluate expressions without FROM.
SELECT 100 * 8 AS Result;

SELECT CURRENT_DATE() AS CurrentDate,
       CURRENT_TIME() AS CurrentTime,
       CURRENT_TIMESTAMP() AS CurrentDateTime;
Practice 1: Display FIRST_NAME, LAST_NAME, JOB_ID and SALARY for all employees.
Solution
SELECT FIRST_NAME, LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES;
2. Aliases, Literals and DISTINCT
2.1 Column aliases
-- AS gives a readable name to an output column.
SELECT
    LAST_NAME,
    SALARY,
    (SALARY + 100) * 12 AS BONUS,
    (SALARY + 100) * 12 AS `YEARLY BONUS`
FROM EMPLOYEES;

-- Backticks are used for MySQL identifiers such as aliases containing spaces.
-- Single quotes are for string values, not identifiers.
-- Avoid relying on double quotes for identifiers; SQL mode can change their meaning.
2.2 String literals and concatenation
-- MySQL uses CONCAT() to combine strings.
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS FullName
FROM EMPLOYEES;

SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FullName
FROM EMPLOYEES;

SELECT CONCAT(FIRST_NAME, ' is a ', JOB_ID) AS EmployeeRole
FROM EMPLOYEES;

-- A single quote inside a string is represented by two single quotes.
SELECT CONCAT(
    DEPARTMENT_NAME,
    ' department''s manager id is ',
    CAST(MANAGER_ID AS CHAR)
) AS DEPT_MANAGER
FROM DEPARTMENTS;

-- CONCAT() returns NULL if any argument is NULL.
-- Use COALESCE() when a NULL value should be replaced before concatenation.
2.3 DISTINCT
-- DISTINCT removes duplicate result rows.
SELECT DISTINCT DEPARTMENT_ID
FROM EMPLOYEES;

-- DISTINCT applies to the complete selected combination.
SELECT DISTINCT DEPARTMENT_ID, JOB_ID
FROM EMPLOYEES;
•	SELECT DISTINCT DEPARTMENT_ID, JOB_ID is not the same as DISTINCT DEPARTMENT_ID; uniqueness is evaluated across both columns.
Practice 2: Return the unique JOB_ID values used by employees.
Solution
SELECT DISTINCT JOB_ID
FROM EMPLOYEES;
3. Single-Row Functions – String Functions
Single-row functions return one result for each input row.
3.1 UPPER and LOWER
SELECT
    LAST_NAME,
    UPPER(LAST_NAME) AS UpperLastName,
    LOWER(LAST_NAME) AS LowerLastName
FROM EMPLOYEES;

-- Example of using a function in a filter:
SELECT LAST_NAME
FROM EMPLOYEES
WHERE UPPER(LAST_NAME) = 'KING';

-- Function arguments must have the correct data type.
-- UPPER() and LOWER() expect character expressions.
3.2 Character length
SELECT
    LAST_NAME,
    CHAR_LENGTH(LAST_NAME) AS LengthOfLastName
FROM EMPLOYEES;

-- CHAR_LENGTH() counts characters.
-- LENGTH() counts bytes, which can differ for multibyte character sets.
3.3 LEFT, RIGHT and SUBSTRING
SELECT
    LAST_NAME,
    LEFT(LAST_NAME, 3) AS First3,
    RIGHT(LAST_NAME, 3) AS Last3,
    SUBSTRING(LAST_NAME, 2, 4) AS FourCharsFromPosition2
FROM EMPLOYEES;

-- MySQL string positions are 1-based.
-- SUBSTRING(string, start, length)
-- A start position of 1 means the first character.
-- A start position of 0 produces an empty result.
-- A negative start counts from the end.
3.4 LOCATE and INSTR
SELECT
    LAST_NAME,
    LOCATE('a', LAST_NAME) AS PositionOfA,
    INSTR(LAST_NAME, 'a') AS PositionOfA_UsingINSTR
FROM EMPLOYEES;

-- LOCATE() and INSTR() return 0 when the searched string is not found.
-- They are position functions, not Boolean TRUE/FALSE functions.
3.5 TRIM, LTRIM and RTRIM
SELECT
    TRIM('   MySQL SQL   ') AS Trimmed,
    LTRIM('   MySQL SQL') AS LeftTrimmed,
    RTRIM('MySQL SQL   ') AS RightTrimmed;
3.6 REPLACE
SELECT
    REPLACE('Data Engineering', 'Engineering', 'Science') AS Result;
3.7 Nested string functions
-- Functions can be nested: the result of one function becomes the input to another.
SELECT
    LAST_NAME,
    UPPER(CONCAT(FIRST_NAME, ' ', JOB_ID)) AS EmployeeInfo
FROM EMPLOYEES;
3.8 String condition with SUBSTRING
SELECT EMPLOYEE_ID, JOB_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEES
WHERE SUBSTRING(JOB_ID, 4, 3) = 'REP';

-- If JOB_ID is shorter than the requested range, SUBSTRING() simply returns
-- the characters available; it does not create missing characters.
Practice 3: Display FIRST_NAME, LAST_NAME and a column containing the first 5 characters of LAST_NAME.
Solution
SELECT
    FIRST_NAME,
    LAST_NAME,
    LEFT(LAST_NAME, 5) AS First5Chars
FROM EMPLOYEES;
4. Single-Row Functions – Numeric Functions
4.1 ROUND, CEIL, FLOOR and ABS
SELECT
    ROUND(109999.79698680, 2) AS RoundedNumber,
    FLOOR(109999.79) AS FloorValue,
    ABS(-500) AS AbsoluteValue;

-- ROUND(number, decimals)
-- A negative decimals argument rounds to the left of the decimal point.
-- CEIL() moves upward; FLOOR() moves downward.
-- ABS() returns the absolute value.
4.2 Salary formatting
-- FORMAT(number, decimals) returns a formatted string.
SELECT
    SALARY,
    FORMAT(SALARY, 2) AS SalaryFormatted,
    CONCAT('$', FORMAT(SALARY, 2)) AS SalaryWithDollar
FROM EMPLOYEES;

-- FORMAT() is for presentation; its result is a string, not a numeric value.
-- Do not use FORMAT() when the result must remain numeric for further arithmetic.
Practice 4: Display salary, annual salary, and annual salary rounded to the nearest thousand.
Solution
SELECT
    SALARY,
    SALARY * 12 AS AnnualSalary,
    ROUND(SALARY * 12, -3) AS AnnualSalaryRounded
FROM EMPLOYEES;
5. Date and Time Functions
MySQL DATE stores a date; DATETIME/TIMESTAMP can store date and time. Formatting changes the displayed result, not the stored value.
5.1 Current date and time
SELECT
    CURRENT_DATE() AS CurrentDate,
    CURRENT_TIME() AS CurrentTime,
    CURRENT_TIMESTAMP() AS CurrentDateTime,
    NOW() AS NowValue;

-- CURRENT_DATE() / CURDATE() return the current date.
-- CURRENT_TIME() / CURTIME() return the current time.
-- NOW() / CURRENT_TIMESTAMP() return current date and time.
5.2 Date filtering
SELECT LAST_NAME, JOB_ID, SALARY, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE < '2008-02-01';

-- ISO date format YYYY-MM-DD is the safest format for DATE literals in MySQL.
-- Avoid comparing a DATE column to an arbitrary display-formatted string.
5.3 DATE_FORMAT – format codes
SELECT
    HIRE_DATE,
    DATE_FORMAT(HIRE_DATE, '%d-%b-%Y') AS `DD-Mon-YYYY`,
    DATE_FORMAT(HIRE_DATE, '%e of %M') AS `Day of Month`,
    DATE_FORMAT(HIRE_DATE, '%Y') AS `Year`,
    DATE_FORMAT(HIRE_DATE, '%M') AS `Month`,
    DATE_FORMAT(HIRE_DATE, '%W') AS `Weekday`
FROM EMPLOYEES;

-- Important MySQL DATE_FORMAT() codes:
-- %Y = 4-digit year, e.g. 2026
-- %y = 2-digit year, e.g. 26
-- %m = month number with leading zero, 01-12
-- %c = month number without leading zero, 1-12
-- %M = full month name, e.g. August
-- %b = abbreviated month name, e.g. Aug
-- %d = day of month with leading zero, 01-31
-- %e = day of month without leading zero, 1-31
-- %D = day of month with English suffix, e.g. 1st, 2nd, 3rd, 4th
-- %W = full weekday name, e.g. Monday
-- %a = abbreviated weekday name, e.g. Mon
-- %H = hour, 00-23
-- %h = hour, 01-12
-- %i = minutes, 00-59
-- %s = seconds, 00-59
--
-- The format string itself is text. Do not write 'YYYY-MM-DD' expecting
-- MySQL to interpret Oracle-style format tokens; use '%Y-%m-%d'.
5.4 Date differences
SELECT
    EMPLOYEE_ID,
    HIRE_DATE,
    ROUND(DATEDIFF(CURRENT_DATE(), HIRE_DATE) / 7, 0) AS WeeksEmployed,
    TIMESTAMPDIFF(MONTH, HIRE_DATE, CURRENT_DATE()) AS MonthsEmployed
FROM EMPLOYEES
ORDER BY WeeksEmployed DESC;

-- DATEDIFF(date1, date2) returns the number of days: date1 - date2.
-- TIMESTAMPDIFF(unit, start, end) returns the difference in the requested unit.
-- TIMESTAMPDIFF(MONTH, ...) counts completed month boundaries according to
-- MySQL's date-difference rules; it is not the same as days/30.
5.5 DATE_ADD and DATE_SUB
SELECT
    HIRE_DATE,
    DATE_ADD(HIRE_DATE, INTERVAL 2 MONTH) AS TwoMonthsLater,
    DATE_SUB(HIRE_DATE, INTERVAL 2 MONTH) AS TwoMonthsEarlier,
    DATE_ADD(HIRE_DATE, INTERVAL 6 MONTH) AS SixMonthReview
FROM EMPLOYEES;

-- INTERVAL requires a value and a unit, such as:
-- INTERVAL 2 MONTH
-- INTERVAL 10 DAY
-- INTERVAL 1 YEAR
-- Invalid/incomplete syntax such as DATE_ADD(HIRE_DATE, 2) is not valid.
5.6 LAST_DAY and next Friday
SELECT
    HIRE_DATE,
    LAST_DAY(HIRE_DATE) AS LastDayOfHireMonth,
    DATE_ADD(
        HIRE_DATE,
        INTERVAL MOD(6 - DAYOFWEEK(HIRE_DATE) + 7, 7) DAY
    ) AS FirstFridayOnOrAfterHireDate
FROM EMPLOYEES;

-- DAYOFWEEK(): Sunday=1, Monday=2, ..., Friday=6, Saturday=7.
-- MOD(...) calculates how many days must be added to reach Friday.
-- LAST_DAY() returns the last calendar day of the month.
5.7 Date formatting examples
SELECT CONCAT(
    DATE_FORMAT(CURRENT_DATE(), '%e of %M'),
    ' is my birthday'
) AS Birthday;

SELECT CONCAT(
    DATE_FORMAT(CURRENT_DATE(), '%D of %M'),
    ' is my birthday'
) AS BirthdayWithSuffix;

SELECT CONCAT(
    DATE_FORMAT(CURRENT_DATE(), '%d %m %Y'),
    ' is my birthday'
) AS NumericDate;

SELECT CONCAT(
    DATE_FORMAT(CURRENT_DATE(), '%Y'),
    ' is my birthday'
) AS CurrentYear;

SELECT CONCAT(
    DATE_FORMAT(CURRENT_DATE(), '%M'),
    ' is my birthday'
) AS CurrentMonth;
Practice 5: Display LAST_NAME and HIRE_DATE in the format "01-Jan-2022".
Solution
SELECT
    LAST_NAME,
    DATE_FORMAT(HIRE_DATE, '%d-%b-%Y') AS FormattedHireDate
FROM EMPLOYEES;
Practice 6: Display LAST_NAME and HIRE_DATE as "1st of Jan 2022" using MySQL date-format codes.
Solution
SELECT
    LAST_NAME,
    DATE_FORMAT(HIRE_DATE, '%D of %b %Y') AS FormattedHireDate
FROM EMPLOYEES;
6. NULL Handling and Conditional Expressions
6.1 NULL in arithmetic
-- Any arithmetic expression containing NULL normally evaluates to NULL.
SELECT
    LAST_NAME,
    SALARY,
    COMMISSION_PCT,
    SALARY + (SALARY * COMMISSION_PCT) AS TotalPay
FROM EMPLOYEES;

-- If COMMISSION_PCT is NULL, TotalPay becomes NULL.
-- Replace NULL explicitly when business logic requires a zero commission.
6.2 IFNULL
SELECT
    LAST_NAME,
    SALARY,
    COMMISSION_PCT,
    IFNULL(COMMISSION_PCT, 0) AS Commission,
    SALARY + (SALARY * IFNULL(COMMISSION_PCT, 0)) AS TotalPay
FROM EMPLOYEES;

-- IFNULL(expression, replacement)
-- If expression is NULL, replacement is returned; otherwise expression is returned.
6.3 COALESCE
SELECT
    LAST_NAME,
    FIRST_NAME,
    SALARY,
    COMMISSION_PCT,
    COALESCE(
        SALARY + (COMMISSION_PCT * SALARY),
        SALARY + 2000,
        SALARY
    ) AS `NEW SALARY`
FROM EMPLOYEES;

-- COALESCE returns the first non-NULL expression from left to right.
-- It can accept more than two arguments.
-- COALESCE(a,b) behaves like a two-choice NULL fallback.
6.4 NULLIF
SELECT
    FIRST_NAME,
    CHAR_LENGTH(FIRST_NAME) AS Expr1,
    LAST_NAME,
    CHAR_LENGTH(LAST_NAME) AS Expr2,
    NULLIF(CHAR_LENGTH(FIRST_NAME), CHAR_LENGTH(LAST_NAME)) AS Result
FROM EMPLOYEES;

-- NULLIF(a,b) returns NULL when a = b; otherwise it returns a.
6.5 CASE expression
SELECT
    LAST_NAME,
    JOB_ID,
    SALARY,
    CASE JOB_ID
        WHEN 'IT_PROG'  THEN (0.10 * SALARY) + SALARY
        WHEN 'SA_REP'   THEN (0.20 * SALARY) + SALARY
        WHEN 'ST_CLERK' THEN (0.05 * SALARY) + SALARY
        ELSE SALARY
    END AS `REVISED SALARY`
FROM EMPLOYEES;

-- Simple CASE compares one expression with several values.
6.6 CASE with conditions
SELECT
    SALARY,
    LAST_NAME,
    CASE
        WHEN SALARY < 10000 THEN 'LOW'
        WHEN SALARY < 20000 THEN 'AVG'
        WHEN SALARY >= 20000 THEN 'HIGH'
        ELSE 'UNKNOWN'
    END AS SALARY_LEVEL
FROM EMPLOYEES;

-- Conditions are checked from top to bottom.
-- Once a WHEN condition is TRUE, later WHEN clauses are not selected.
-- Avoid overlapping ranges when the intended classification is exclusive.
6.7 CASE based on string length
SELECT
    LAST_NAME,
    FIRST_NAME,
    CASE
        WHEN CHAR_LENGTH(FIRST_NAME) = CHAR_LENGTH(LAST_NAME)
            THEN 'Same Length'
        ELSE 'Different Length'
    END AS NAME_LENGTHS
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 100;
Practice 7: Show LAST_NAME, COMMISSION_PCT and a column called IncomeType containing SAL+COMM when commission exists, otherwise SAL.
Solution
SELECT
    LAST_NAME,
    COMMISSION_PCT,
    CASE
        WHEN COMMISSION_PCT IS NOT NULL THEN 'SAL+COMM'
        ELSE 'SAL'
    END AS IncomeType
FROM EMPLOYEES;
7. WHERE – Restricting Rows
7.1 Equality and comparison
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 90;

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE SALARY > 10000
ORDER BY SALARY DESC;

-- Comparison operators:
-- =  <>  !=  >  >=  <  <=
-- A comparison involving NULL does not become TRUE; use IS NULL / IS NOT NULL.
7.2 AND, BETWEEN and NOT BETWEEN
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE SALARY >= 10000
  AND SALARY <= 15000
ORDER BY SALARY DESC;

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE SALARY BETWEEN 10000 AND 15000
ORDER BY SALARY DESC;

-- BETWEEN is inclusive of both endpoints.

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE SALARY NOT BETWEEN 10000 AND 15000
ORDER BY SALARY DESC;
7.3 IN and NOT IN
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE SALARY > 10000
  AND DEPARTMENT_ID IN (60, 80, 90)
ORDER BY SALARY DESC;

-- IN is equivalent to a series of equality checks combined with OR.
-- Values in an IN list should be compatible with the column data type.
7.4 LIKE
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE LAST_NAME LIKE 'A%';

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE LAST_NAME LIKE '_a%';

-- % = zero or more characters.
-- _ = exactly one character.
-- 'A%' starts with A.
-- '_a%' has 'a' as the second character.
-- '%ing' ends with ing.
-- 'A__%' starts with A and has at least three characters.
7.5 NULL predicates
SELECT LAST_NAME, DEPARTMENT_ID, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL;

SELECT LAST_NAME, DEPARTMENT_ID, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;

-- Do not write: WHERE COMMISSION_PCT = NULL
-- = NULL does not test for NULL. Use IS NULL.
7.6 Combining AND and OR
SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE (JOB_ID = 'SA_REP' OR JOB_ID = 'AD_PRES')
  AND SALARY > 10000
ORDER BY HIRE_DATE DESC;

-- Parentheses make the intended logical grouping explicit.
-- AND has higher precedence than OR, so parentheses are strongly recommended
-- when both operators are present.
7.7 ORDER BY and multiple sort keys
SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE (JOB_ID = 'SA_REP' OR JOB_ID = 'AD_PRES')
  AND SALARY > 10000
ORDER BY JOB_ID ASC, SALARY DESC;

-- ASC is the default.
-- Multiple ORDER BY expressions are applied left to right as tie-breakers.
7.8 ORDER BY column position
SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
ORDER BY 2;

-- 2 refers to the second expression in SELECT: JOB_ID.
-- This is valid but less readable than ORDER BY JOB_ID.
Practice 8: Find employees whose LAST_NAME starts with "A", whose salary is between 5000 and 15000, sorted by salary descending.
Solution
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE LAST_NAME LIKE 'A%'
  AND SALARY BETWEEN 5000 AND 15000
ORDER BY SALARY DESC;
8. Multi-Row / Aggregate Functions
Aggregate functions combine multiple input rows into one result per query or per group.
8.1 AVG, MAX and MIN
SELECT
    ROUND(AVG(SALARY), 2) AS AvgSalary,
    MAX(SALARY) AS MaxSalary,
    MIN(SALARY) AS MinSalary
FROM EMPLOYEES
WHERE JOB_ID LIKE '%REP%';

-- AVG(), SUM(), MIN(), MAX() ignore NULL values for the input expression.
-- AVG() returns NULL if there are no non-NULL values.
8.2 MIN and MAX on dates
SELECT
    MIN(HIRE_DATE) AS EarliestHire,
    MAX(HIRE_DATE) AS LatestHire
FROM EMPLOYEES;
8.3 COUNT(*) vs COUNT(column)
SELECT COUNT(*) AS EmployeeCount
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 90;

SELECT COUNT(COMMISSION_PCT) AS CommissionCount
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 90;

-- COUNT(*) counts rows.
-- COUNT(column) counts only rows where that column is NOT NULL.

SELECT COMMISSION_PCT
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 90;
8.4 COUNT(DISTINCT ...)
SELECT COUNT(DISTINCT DEPARTMENT_ID) AS UniqueDepartments
FROM EMPLOYEES;

-- NULL is not counted as a distinct value by COUNT(DISTINCT column).
8.5 SUM and AVG with NULL handling
SELECT
    SUM(SALARY) AS TotalSalary,
    AVG(SALARY) AS AvgSalary,
    AVG(IFNULL(COMMISSION_PCT, 0)) AS AvgCommissionTreatingNullAsZero
FROM EMPLOYEES;

-- AVG(COMMISSION_PCT) and AVG(IFNULL(COMMISSION_PCT,0)) can have different
-- business meanings. The second explicitly treats missing commission as zero.
Practice 9: Return the minimum, maximum and average salary for employees whose JOB_ID contains REP.
Solution
SELECT
    MIN(SALARY) AS MinSalary,
    MAX(SALARY) AS MaxSalary,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
WHERE JOB_ID LIKE '%REP%';
9. GROUP BY, HAVING and Logical Query Order
9.1 GROUP BY one column
SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary,
    MIN(SALARY) AS MinSalary,
    MAX(SALARY) AS MaxSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY MaxSalary DESC;

-- GROUP BY creates one result group for each distinct DEPARTMENT_ID.
9.2 GROUP BY with WHERE
SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
WHERE JOB_ID IN ('AD_VP', 'AD_PRES', 'IT_PROG')
GROUP BY DEPARTMENT_ID
ORDER BY AvgSalary DESC;

-- WHERE filters individual rows before the groups are formed.
9.3 GROUP BY multiple columns
SELECT
    DEPARTMENT_ID,
    JOB_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID;
9.4 GROUP BY rule and violation
-- Correct: every selected non-aggregate column is part of GROUP BY.
SELECT DEPARTMENT_ID, AVG(SALARY) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- This is invalid with ONLY_FULL_GROUP_BY enabled because DEPARTMENT_ID
-- is selected but is neither aggregated nor grouped:
-- SELECT DEPARTMENT_ID, AVG(SALARY)
-- FROM EMPLOYEES;
9.5 HAVING
SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 10000;

-- HAVING filters groups after GROUP BY.
-- WHERE is for row-level filtering; HAVING is normally used for group-level
-- or aggregate conditions.
9.6 WHERE + GROUP BY + HAVING
SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (50, 60, 80, 90)
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 5000
ORDER BY AvgSalary DESC;

-- Logical flow:
-- FROM / JOIN
-- WHERE
-- GROUP BY
-- HAVING
-- SELECT
-- ORDER BY
-- LIMIT / OFFSET
9.7 Alias visibility
-- SELECT aliases can be used in ORDER BY.
SELECT DEPARTMENT_ID, AVG(SALARY) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY AvgSalary DESC;

-- MySQL also permits a SELECT alias in HAVING:
SELECT DEPARTMENT_ID, AVG(SALARY) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AvgSalary > 10000;

-- A SELECT alias cannot normally be used in WHERE at the same query level:
-- SELECT SALARY * 12 AS AnnualSalary
-- FROM EMPLOYEES
-- WHERE AnnualSalary > 100000;

-- Use the expression:
SELECT SALARY * 12 AS AnnualSalary
FROM EMPLOYEES
WHERE SALARY * 12 > 100000;

-- Or use a derived table when the expression is complex:
SELECT *
FROM (
    SELECT EMPLOYEE_ID, SALARY * 12 AS AnnualSalary
    FROM EMPLOYEES
) AS E
WHERE AnnualSalary > 100000;
9.8 Group by day name
SELECT
    DAYNAME(HIRE_DATE) AS HireDay,
    COUNT(*) AS HireCount
FROM EMPLOYEES
GROUP BY DAYNAME(HIRE_DATE)
HAVING COUNT(*) >= 2
ORDER BY HireCount DESC;
9.9 Group by year and job
SELECT
    YEAR(END_DATE) AS QuitYear,
    JOB_ID,
    COUNT(*) AS TurnoverCount
FROM EMPLOYEES
WHERE END_DATE IS NOT NULL
GROUP BY YEAR(END_DATE), JOB_ID
ORDER BY TurnoverCount DESC;
Practice 10: Find departments with at least 5 employees and show the employee count, sorted from highest to lowest.
Solution
SELECT
    DEPARTMENT_ID,
    COUNT(*) AS EmployeeCount
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 5
ORDER BY EmployeeCount DESC;
Practice 11: Find departments whose average salary is greater than 10000, considering only employees with salary >= 5000.
Solution
SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
WHERE SALARY >= 5000
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 10000
ORDER BY AvgSalary DESC;
10. JOINs
10.1 INNER JOIN using ON
SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID,
    L.CITY
FROM DEPARTMENTS D
INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID;

-- INNER JOIN returns only rows with a matching join condition.
-- ON contains the relationship between the tables.
10.2 INNER JOIN with filtering
SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID,
    L.CITY
FROM DEPARTMENTS D
INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
WHERE D.DEPARTMENT_ID IN (50, 60, 80);
10.3 Employee + department
SELECT
    E.LAST_NAME,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
10.4 JOIN with USING
-- USING can be used when both tables contain a column with exactly the same name.
SELECT
    E.LAST_NAME,
    DEPARTMENT_ID,
    E.MANAGER_ID
FROM EMPLOYEES E
JOIN DEPARTMENTS D
USING (DEPARTMENT_ID)
WHERE DEPARTMENT_ID = 80;

-- The column named in USING is exposed as one common column in the result.
-- Do not qualify that USING column in the query:
-- WHERE D.DEPARTMENT_ID = 80;  -- invalid with this USING form
--
-- If you need table-qualified references, use ON instead.
10.5 Multi-table JOIN
SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    L.LOCATION_ID,
    L.CITY
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID;
10.6 Self JOIN
SELECT
    E.FIRST_NAME,
    E.LAST_NAME,
    MGR.FIRST_NAME AS ManagerFirstName,
    MGR.LAST_NAME AS ManagerLastName
FROM EMPLOYEES E
JOIN EMPLOYEES MGR
    ON E.MANAGER_ID = MGR.EMPLOYEE_ID;

-- The same table is used twice with different aliases.
-- E represents the employee; MGR represents that employee's manager.
10.7 Non-equi JOIN
SELECT
    E.LAST_NAME,
    E.SALARY,
    J.JOB_TITLE
FROM EMPLOYEES E
JOIN JOBS J
    ON E.SALARY BETWEEN J.MIN_SALARY AND J.MAX_SALARY;

-- A join condition does not have to use =.
-- BETWEEN, <, >, <= and >= can be used when the business relationship requires it.
10.8 CROSS JOIN
SELECT
    E.EMPLOYEE_ID,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
CROSS JOIN DEPARTMENTS D;

-- CROSS JOIN creates every possible employee/department combination.
-- If there are 100 employees and 27 departments, the result can contain
-- 100 * 27 = 2700 combinations.
-- Use it deliberately; it can create a very large result.
10.9 LEFT JOIN
SELECT
    E.LAST_NAME,
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- LEFT JOIN keeps every row from the left table.
-- If there is no match, columns from the right table are NULL.
10.10 RIGHT JOIN
SELECT
    E.LAST_NAME,
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- RIGHT JOIN keeps every row from the right table.
-- LEFT JOIN is often easier to read because the preserved table appears first.
10.11 NATURAL JOIN
-- MySQL supports NATURAL JOIN.
-- It automatically joins columns having the same names in both tables.
-- Use with caution because adding another same-named column later can change
-- the join condition without changing this query.
SELECT
    DEPARTMENT_ID,
    DEPARTMENT_NAME,
    LOCATION_ID,
    CITY
FROM DEPARTMENTS
NATURAL JOIN LOCATIONS;

-- Explicit JOIN ... ON is generally clearer when the relationship matters.
10.12 Departments with no employees
SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID IS NULL;

-- The LEFT JOIN preserves departments.
-- The WHERE condition keeps only departments for which no employee match exists.
10.13 Manager report
SELECT
    CONCAT(E.FIRST_NAME, ' ', E.LAST_NAME,
           ' is manager of the ', D.DEPARTMENT_NAME) AS Managers
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON D.MANAGER_ID = E.EMPLOYEE_ID;
Practice 12: Return employee last name, department name and city for employees who have a matching department and location.
Solution
SELECT
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    L.CITY
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID;
Practice 13: Find departments that currently have no employees.
Solution
SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID IS NULL;




 
11. Subqueries

 
Example 1 — Find the employee with the highest salary
11.1 Scalar / single-row subquery
SELECT MAX(SALARY) AS MaxSalary
FROM EMPLOYEES;

-- A scalar subquery returns one value and can be used where a single value is expected.
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    SALARY
FROM EMPLOYEES
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEES);

-- A scalar subquery returning more than one row causes an error in a scalar context.
11.2 Second-highest distinct salary
SELECT MAX(SALARY) AS SecondHighest
FROM EMPLOYEES
WHERE SALARY < (SELECT MAX(SALARY) FROM EMPLOYEES);

-- The inner query finds the highest salary.
-- The outer query excludes that value and finds the maximum remaining salary.
-- This returns the second-highest DISTINCT salary.
11.3 Third-highest distinct salary
SELECT MAX(SALARY) AS ThirdHighest
FROM EMPLOYEES
WHERE SALARY < (
    SELECT MAX(SALARY)
    FROM EMPLOYEES
    WHERE SALARY < (
        SELECT MAX(SALARY)
        FROM EMPLOYEES
    )
);
11.4 Top 5 salaries
SELECT *
FROM EMPLOYEES
ORDER BY SALARY DESC
LIMIT 5;

-- LIMIT 5 returns at most five rows after sorting.
-- Without ORDER BY, the concept of "top 5" is not deterministic.
Example 2 — Employees earning more than the average salary
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    SALARY
FROM EMPLOYEES
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM EMPLOYEES
);

-- The inner query calculates one value:
-- The overall average salary.
-- The outer query compares every employee's salary
-- Against that single value.
Rule
Scalar subquery
→ returns one value
→ can be used with:
   =, <>, >, <, >=, <=

What can go wrong?
SELECT *
FROM EMPLOYEES
WHERE SALARY = (
    SELECT SALARY
    FROM EMPLOYEES
); 
If the inner query returns multiple employees, MySQL cannot use all those rows as one value.
You would need something such as:
WHERE SALARY IN (...)
	Multi-Row Subquery — IN
	Use IN when the subquery can return multiple values.
	Example 1
	Find employees working in departments located at location 1700:
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID
    FROM DEPARTMENTS
    WHERE LOCATION_ID = 1700
);

-- The inner query may return:
-- 10
-- 20
-- 30
--
-- The outer query asks:
-- Is this employee's DEPARTMENT_ID
-- one of those values?

Example 2
Find employees whose job is one of the jobs used by employees earning more than 10000:
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    JOB_ID,
    SALARY
FROM EMPLOYEES
WHERE JOB_ID IN (
    SELECT JOB_ID
    FROM EMPLOYEES
    WHERE SALARY > 10000
);

-- Inner query produces multiple JOB_ID values.
--
-- IN checks whether the outer employee's JOB_ID
-- occurs in that returned set.
Rule
Use IN when the inner query produces a set of possible values and the outer value only needs to match one of them.

ANY / SOME
ANY means:
The comparison must be true for at least one value returned by the subquery.
SOME is a synonym for ANY.
SELECT
    LAST_NAME,
    JOB_ID,
    SALARY
FROM EMPLOYEES
WHERE SALARY > ANY (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE JOB_ID = 'IT_PROG'
);

-- Suppose IT_PROG salaries are:
-- 4200, 6000, 9000
--
-- SALARY > ANY means:
-- salary must be greater than AT LEAST ONE
-- of these values.
--
-- Therefore a salary of 5000 qualifies because:
-- 5000 > 4200
Example 2
SELECT
    LAST_NAME,
    JOB_ID,
    SALARY
FROM EMPLOYEES
WHERE SALARY < ANY (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE JOB_ID = 'IT_PROG'
);

-- The employee's salary must be less than
-- at least one IT_PROG salary.
Rule
> ANY
→ greater than at least one

< ANY
→ less than at least one
ALL
ALL means:
The comparison must be true for every value returned by the subquery.
SELECT
    LAST_NAME,
    JOB_ID,
    SALARY
FROM EMPLOYEES
WHERE SALARY > ALL (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE JOB_ID = 'IT_PROG'
);

-- Suppose IT_PROG salaries are:
-- 4200, 6000, 9000
--
-- SALARY > ALL means:
-- salary must be greater than 4200
-- AND greater than 6000
-- AND greater than 9000.
--
-- Therefore the salary must be greater than 9000.
Example 2
SELECT
    LAST_NAME,
    JOB_ID,
    SALARY
FROM EMPLOYEES
WHERE SALARY < ALL (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE JOB_ID = 'IT_PROG'
);

-- The salary must be lower than EVERY
-- salary returned by the subquery.
Remember
ANY → at least one

ALL → every one

EXISTS
EXISTS does not ask for a particular value.
It asks:
Does at least one matching row exist?
Example 1 — Employees who are managers

SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME
FROM EMPLOYEES E
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES E2
    WHERE E2.MANAGER_ID = E.EMPLOYEE_ID
);

-- For each employee in E:
--
-- Look in E2 and ask:
-- "Does at least one employee report to this person?"
--
-- If yes → keep the employee.
-- If no  → discard the employee.
--
-- SELECT 1 is used because EXISTS only cares
-- whether a matching row exists.
Example 2 — Departments having employees
SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM DEPARTMENTS D
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES E
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
);

-- For every department:
-- check whether at least one employee
-- belongs to that department.
Important rule
EXISTS is an existence test, not a value-returning test.
NOT EXISTS
NOT EXISTS asks:
Does no matching row exist?
Example 1

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM DEPARTMENTS D
WHERE NOT EXISTS (
    SELECT 1
    FROM EMPLOYEES E
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
);

-- Keep the department only when
-- no employee belongs to it.
Example 2
Find employees who are not managers:
SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME
FROM EMPLOYEES E
WHERE NOT EXISTS (
    SELECT 1
    FROM EMPLOYEES E2
    WHERE E2.MANAGER_ID = E.EMPLOYEE_ID
);

-- If nobody has this employee's ID
-- as their MANAGER_ID,
-- the employee is not a manager.
NOT IN and NULL
This is an important SQL trap.
SELECT
    E.LAST_NAME
FROM EMPLOYEES E
WHERE E.EMPLOYEE_ID NOT IN (
    SELECT M.MANAGER_ID
    FROM EMPLOYEES M
    WHERE M.MANAGER_ID IS NOT NULL
);
The IS NOT NULL is important.
Why?
SQL uses three-valued logic:
TRUE
FALSE
UNKNOWN
If the NOT IN list contains NULL, comparisons can become UNKNOWN.
Therefore:
Be careful with NOT IN when the subquery can return NULL.
For existence/anti-matching logic, NOT EXISTS is often easier to reason about.
Correlated Subquery
A correlated subquery is different because:
The inner query refers to a column from the outer query.
Example 1 — Above departmental average
SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME,
    E.SALARY,
    E.DEPARTMENT_ID
FROM EMPLOYEES E
WHERE E.SALARY > (
    SELECT AVG(E2.SALARY)
    FROM EMPLOYEES E2
    WHERE E2.DEPARTMENT_ID = E.DEPARTMENT_ID
);

-- E is the outer query.
-- E2 is the inner query.
--
-- Notice:
-- E2.DEPARTMENT_ID = E.DEPARTMENT_ID
--
-- E.DEPARTMENT_ID comes from the OUTER query.
--
-- Therefore the inner query depends on
-- the current employee's department. 



Conceptually:
Employee John
   ↓
Find average salary of John's department
   ↓
Compare John's salary

Employee Mary
   ↓
Find average salary of Mary's department
   ↓
Compare Mary's salary

Rule
Inner query does NOT depend on outer row
→ non-correlated

Inner query DOES reference outer row
→ correlated

Subquery in FROM — Derived Table
This is the distinction we discussed in class.
A subquery inside FROM is called a derived table.
SELECT
    MX,
    MX * 0.20 AS TAX
FROM (
    SELECT MAX(SALARY) AS MX
    FROM EMPLOYEES
) AS E;
The inner query returns:
MX
----
24000
But because the result is being used in FROM, MySQL treats it as a temporary table:
E
┌───────┐
│  MX   │
├───────┤
│ 24000 │
└───────┘
Therefore the derived table needs an alias:
) AS E
Important rule
The fact that the inner query returns one row does NOT remove the alias requirement.
Compare:
-- Subquery used as a VALUE
SELECT
    (SELECT MAX(SALARY) FROM EMPLOYEES) * 0.20 AS TAX;
No derived-table alias.
Versus:
-- Subquery used as a TABLE
SELECT
    MX * 0.20 AS TAX
FROM (
    SELECT MAX(SALARY) AS MX
    FROM EMPLOYEES
) AS E;
Derived-table alias required.
Subquery in SELECT
A subquery can also appear as a SELECT expression, but it must produce a scalar value.
Example 1
SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME,
    E.SALARY,
    (
        SELECT AVG(E2.SALARY)
        FROM EMPLOYEES E2
    ) AS COMPANY_AVG
FROM EMPLOYEES E;
The company average is calculated once conceptually and displayed alongside each employee.
Example 2
SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME,
    E.SALARY,
    E.SALARY - (
        SELECT AVG(E2.SALARY)
        FROM EMPLOYEES E2
    ) AS DIFFERENCE_FROM_AVG
FROM EMPLOYEES E;
Now the outer query calculates each employee's difference from the overall average.
Rule
A subquery used as a SELECT expression must return a single value for each outer row.
________________________________________
11.12 Nested Subqueries
A subquery can contain another subquery.
Example — Third-highest distinct salary
SELECT MAX(SALARY) AS THIRD_HIGHEST
FROM EMPLOYEES
WHERE SALARY < (
    SELECT MAX(SALARY)
    FROM EMPLOYEES
    WHERE SALARY < (
        SELECT MAX(SALARY)
        FROM EMPLOYEES
    )
);
Read it from the inside:
1. Find highest salary
        ↓
2. Find highest salary below that
        ↓
3. Find highest salary below that
This gives the third-highest distinct salary.
________________________________________
11.13 Subquery vs JOIN
The same business requirement can often be written in different ways.
Using JOIN
SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
Using a subquery
SELECT E.EMPLOYEE_ID,
    E.LAST_NAME,
    (
        SELECT D.DEPARTMENT_NAME
        FROM DEPARTMENTS D
        WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
    ) AS DEPARTMENT_NAME
FROM EMPLOYEES E;


Subquery Decision Rules

WHAT DOES THE SUBQUERY RETURN?

ONE VALUE
    ↓
Scalar subquery
    ↓
=  >  <  >=  <=  <>


MANY VALUES
    ↓
IN / ANY / SOME / ALL


ROWS + COLUMNS
    ↓
FROM (subquery) AS alias
    ↓
Derived table


DO I ONLY WANT TO KNOW WHETHER A MATCH EXISTS?
    ↓
EXISTS / NOT EXISTS


DOES THE INNER QUERY REFER TO THE OUTER QUERY?
    ↓
YES → Correlated
NO  → Non-correlated


And the most important distinction:
WHERE (...) 
→ subquery result is used as a value/set

FROM (...)
→ subquery result is used as a table
→ derived-table alias required

WINDOW FUNCTIONS
12.1 What is a Window Function?
A window function performs a calculation across related rows without collapsing the rows into one result row.
This is the key difference:
Aggregate function
→ combines rows
→ reduces number of rows

Window function
→ calculates across rows
→ keeps the original rows
________________________________________
12.2 Aggregate vs Window Function
Aggregate
SELECT AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEES;
Result:
AVG_SALARY
----------
6461.68
One row.
Window function
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    SALARY,
    AVG(SALARY) OVER () AS AVG_SALARY
FROM EMPLOYEES;
Result conceptually:
EMPLOYEE   SALARY   AVG_SALARY
John       5000     6461
Mary       7000     6461
David      6000     6461
Every employee remains in the result.
Rule
GROUP BY / aggregate functions summarize rows. Window functions calculate across rows while preserving the individual rows.
________________________________________
12.3 OVER()
OVER() tells MySQL that the function is being used as a window function.
Example 1
SELECT
    LAST_NAME,
    SALARY,
    AVG(SALARY) OVER () AS COMPANY_AVG
FROM EMPLOYEES;
Because there is no PARTITION BY, the entire result is treated as one window.
Example 2
SELECT
    LAST_NAME,
    SALARY,
    MAX(SALARY) OVER () AS HIGHEST_SALARY
FROM EMPLOYEES;
The maximum salary is calculated across all employees while every employee row is retained.
PARTITION BY
PARTITION BY divides the rows into logical groups for the window calculation.
It does NOT remove rows.
Example 1 — Department average
SELECT
    LAST_NAME,
    DEPARTMENT_ID,
    SALARY,
    AVG(SALARY) OVER (
        PARTITION BY DEPARTMENT_ID
    ) AS DEPT_AVG
FROM EMPLOYEES;
For every employee, MySQL calculates the average salary of that employee's department.
Example 2 — Department maximum
SELECT
    LAST_NAME,
    DEPARTMENT_ID,
    SALARY,
    MAX(SALARY) OVER (
        PARTITION BY DEPARTMENT_ID
    ) AS DEPT_MAX
FROM EMPLOYEES;
Rule
PARTITION BY means "perform this window calculation separately for each group."
It is NOT the same as GROUP BY.
________________________________________
12.5 ORDER BY Inside OVER()
ORDER BY inside OVER() controls the order used by the window calculation.
It is particularly important for ranking functions.
SELECT
    LAST_NAME,
    SALARY,
    ROW_NUMBER() OVER (
        ORDER BY SALARY DESC
ROW_NUMBER()
ROW_NUMBER() assigns a unique sequential number to every row.
Example 1
SELECT
    LAST_NAME,
    SALARY,
    ROW_NUMBER() OVER (
        ORDER BY SALARY DESC
    ) AS ROW_NUM
FROM EMPLOYEES;
Conceptually:
Salary    Row Number
10000     1
9000      2
8000      3
7000      4
Example 2 — Row number within each department
SELECT
    LAST_NAME,
    DEPARTMENT_ID,
    SALARY,
    ROW_NUMBER() OVER (
        PARTITION BY DEPARTMENT_ID
        ORDER BY SALARY DESC
    ) AS DEPT_ROW_NUM
FROM EMPLOYEES;
The numbering restarts for every department.
Rule
ROW_NUMBER gives every row a different number, even when values are tied.
________________________________________
12.7 RANK()
RANK() gives the same rank to tied values and leaves gaps after ties.
SELECT
    LAST_NAME,
    SALARY,
    RANK() OVER (
        ORDER BY SALARY DESC
    ) AS SALARY_RANK
FROM EMPLOYEES;
If salaries are:
10000
8000
8000
6000
the ranks are:
10000 → 1
8000  → 2
8000  → 2
6000  → 4
Rule
RANK allows ties and leaves gaps.
________________________________________
12.8 DENSE_RANK()
DENSE_RANK() also gives equal values the same rank, but does not leave gaps.
SELECT
    LAST_NAME,
    SALARY,
    DENSE_RANK() OVER (
        ORDER BY SALARY DESC
    ) AS SALARY_RANK
FROM EMPLOYEES;
For:
10000
8000
8000
6000
the result is:
10000 → 1
8000  → 2
8000  → 2
6000  → 3
Easy memory rule
ROW_NUMBER
→ unique number for every row

RANK
→ ties share rank + gaps

DENSE_RANK
→ ties share rank + no gaps
________________________________________
12.9 Ranking Within Each Department
This is one of the most useful BI examples.
SELECT
    LAST_NAME,
    DEPARTMENT_ID,
    SALARY,
    RANK() OVER (
        PARTITION BY DEPARTMENT_ID
        ORDER BY SALARY DESC
    ) AS DEPT_RANK
FROM EMPLOYEES;
Conceptually:
Department 10

John      10000    1
Mary       9000    2
David      9000    2


Department 20

Peter     12000    1
Sarah      8000    2
The rank starts again for every department.
________________________________________
12.10 Top 5 Using ROW_NUMBER()
A window function cannot normally be filtered directly in WHERE at the same query level.
This is NOT valid:
-- Not valid:
SELECT
    LAST_NAME,
    SALARY,
    ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS RN
FROM EMPLOYEES
WHERE RN <= 5;
Instead, create the row number first and filter in an outer query:
SELECT *
FROM (
    SELECT
        E.*,
        ROW_NUMBER() OVER (
            ORDER BY SALARY DESC
        ) AS RN
    FROM EMPLOYEES E
) AS RANKED
WHERE RN <= 5
ORDER BY RN;
What is happening?
Inner query
    ↓
calculate ROW_NUMBER
    ↓
produce RN
    ↓
outer query
    ↓
WHERE RN <= 5
This is exactly where the earlier derived-table concept becomes useful.
________________________________________
12.11 Top 3 Employees Per Department
WITH RANKED_EMPLOYEES AS (
    SELECT
        EMPLOYEE_ID,
        LAST_NAME,
        DEPARTMENT_ID,
        SALARY,
        ROW_NUMBER() OVER (
            PARTITION BY DEPARTMENT_ID
            ORDER BY SALARY DESC
        ) AS RN
    FROM EMPLOYEES
)
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    DEPARTMENT_ID,
    SALARY
FROM RANKED_EMPLOYEES
WHERE RN <= 3
ORDER BY DEPARTMENT_ID, SALARY DESC;
    ) AS ROW_NUM
FROM EMPLOYEES;
The highest salary receives row number 1.

Why CTE?
The CTE first creates the ranking.
The outer query then filters it.
EMPLOYEES
    ↓
ROW_NUMBER per department
    ↓
RANKED_EMPLOYEES
    ↓
RN <= 3
    ↓
Top 3 per department
________________________________________
12.12 Window Function Rules
OVER()
→ turns a supported aggregate/ranking function into a window calculation

PARTITION BY
→ divides rows into logical groups

ORDER BY inside OVER()
→ controls window calculation order

ROW_NUMBER()
→ unique sequence number

RANK()
→ ties share rank; gaps occur

DENSE_RANK()
→ ties share rank; no gaps

Window function
→ keeps original rows

GROUP BY
→ collapses rows into groups
Important:
A window function does not replace GROUP BY. They solve different problems.
________________________________________
13. COMMON TABLE EXPRESSIONS — CTEs
13.1 What is a CTE?
CTE stands for Common Table Expression.
A CTE gives a query result a temporary name so that the result can be used by the query that follows it.
Basic structure:
WITH CTE_NAME AS (
    SELECT ...
)
SELECT ...
FROM CTE_NAME;
Think:
WITH
  ↓
Create named result
  ↓
Use that result
  ↓
Final query
________________________________________
13.2 Basic CTE
Example 1
WITH HIGH_SALARY AS (
    SELECT
        EMPLOYEE_ID,
        LAST_NAME,
        SALARY
    FROM EMPLOYEES
    WHERE SALARY > 5000
)
SELECT *
FROM HIGH_SALARY;
The CTE first creates a result containing employees earning more than 5000.
The final query reads that result.
Example 2
WITH EMPLOYEE_DATA AS (
    SELECT
        EMPLOYEE_ID,
        LAST_NAME,
        SALARY,
        SALARY * 12 AS ANNUAL_SALARY
    FROM EMPLOYEES
)
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    SALARY,
    ANNUAL_SALARY,
    ANNUAL_SALARY * 0.20 AS TAX
FROM EMPLOYEE_DATA;
This is particularly useful when the outer query needs to reuse an expression such as ANNUAL_SALARY.
________________________________________
13.3 CTE vs Derived Table
These two can solve similar problems.
Derived table
SELECT
    ANNUAL_SALARY,
    ANNUAL_SALARY * 0.20 AS TAX
FROM (
    SELECT
        SALARY * 12 AS ANNUAL_SALARY
    FROM EMPLOYEES
) AS E;
CTE
WITH EMPLOYEE_DATA AS (
    SELECT
        SALARY * 12 AS ANNUAL_SALARY
    FROM EMPLOYEES
)
SELECT
    ANNUAL_SALARY,
    ANNUAL_SALARY * 0.20 AS TAX
FROM EMPLOYEE_DATA;
Rule
A CTE is essentially a named intermediate query result.
The CTE version is often easier to read when the query has multiple logical steps.
________________________________________
13.4 Multiple CTEs
Multiple CTEs are separated by commas.
WITH EMPLOYEE_DATA AS (
    SELECT
        EMPLOYEE_ID,
        DEPARTMENT_ID,
        SALARY
    FROM EMPLOYEES
),
DEPARTMENT_SUMMARY AS (
    SELECT
        DEPARTMENT_ID,
        COUNT(*) AS EMPLOYEE_COUNT,
        AVG(SALARY) AS AVG_SALARY
    FROM EMPLOYEE_DATA
    GROUP BY DEPARTMENT_ID
)
SELECT *
FROM DEPARTMENT_SUMMARY
ORDER BY AVG_SALARY DESC;
The flow is:
EMPLOYEES
    ↓
EMPLOYEE_DATA
    ↓
DEPARTMENT_SUMMARY
    ↓
FINAL SELECT
A later CTE can use an earlier CTE.
________________________________________
13.5 CTE + Window Function
This is an important BI pattern.
WITH RANKED_EMPLOYEES AS (
    SELECT
        EMPLOYEE_ID,
        LAST_NAME,
        DEPARTMENT_ID,
        SALARY,
        RANK() OVER (
            PARTITION BY DEPARTMENT_ID
            ORDER BY SALARY DESC
        ) AS DEPT_RANK
    FROM EMPLOYEES
)
SELECT *
FROM RANKED_EMPLOYEES
WHERE DEPT_RANK <= 3;
What happens?
Step 1
EMPLOYEES
    ↓
Step 2
RANK employees inside each department
    ↓
Step 3
Store the result temporarily as RANKED_EMPLOYEES
    ↓
Step 4
Filter ranks <= 3
This pattern appears constantly in analytics and BI work.
________________________________________
13.6 Recursive CTE
A recursive CTE is used when data has a parent-child hierarchy.
For example:
Steve
 ├── John
 │    └── David
 └── Mary
Suppose:
EMPLOYEE_ID   LAST_NAME   MANAGER_ID
100           Steve       NULL
101           John        100
102           Mary        100
103           David       101
We can traverse this hierarchy:
WITH RECURSIVE EMPLOYEE_HIERARCHY AS (

    -- Anchor member:
    -- Start with employees who have no manager.
    SELECT
        EMPLOYEE_ID,
        LAST_NAME,
        MANAGER_ID,
        1 AS LEVEL
    FROM EMPLOYEES
    WHERE MANAGER_ID IS NULL

    UNION ALL

    -- Recursive member:
    -- Find employees whose manager is one of
    -- the employees already found.
    SELECT
        E.EMPLOYEE_ID,
        E.LAST_NAME,
        E.MANAGER_ID,
        H.LEVEL + 1
    FROM EMPLOYEES E
    JOIN EMPLOYEE_HIERARCHY H
        ON E.MANAGER_ID = H.EMPLOYEE_ID
)
SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    MANAGER_ID,
    LEVEL
FROM EMPLOYEE_HIERARCHY
ORDER BY LEVEL, EMPLOYEE_ID;
Two essential parts
ANCHOR
→ where recursion starts

RECURSIVE MEMBER
→ finds the next level
UNION ALL connects the two.
Rule
Recursive CTE = start somewhere, find children, then use those children to find the next level, continuing until there are no more matching rows.
________________________________________
13.7 CTE Rules
WITH
→ starts the CTE definition

CTE_NAME
→ temporary name for the result

Normal CTE
→ exists for the statement that follows it

Multiple CTEs
→ separate with commas

Later CTE
→ can reference an earlier CTE

WITH RECURSIVE
→ used for recursive CTEs

Recursive CTE
→ requires an anchor member + recursive member
A CTE is not a permanent table and is different from a saved database view.
________________________________________
13.8 Final Decision Map
I need another query inside my query
                ↓
            SUBQUERY
                │
     ┌──────────┼───────────┐
     ↓          ↓           ↓
 ONE VALUE   MANY VALUES  ROWS+COLUMNS
     ↓          ↓           ↓
 Scalar      IN/ANY/ALL   FROM (...)
                            ↓
                       Derived Table


I only need to know:
"Does a matching row exist?"
                ↓
         EXISTS / NOT EXISTS


Does inner query use
current outer row?
                ↓
        Correlated


I need to calculate across rows
but KEEP every row
                ↓
        WINDOW FUNCTION
                │
       ┌────────┼──────────┐
       ↓        ↓          ↓
     AVG      RANK     ROW_NUMBER
       │
 PARTITION BY
       ↓
calculate separately
for each logical group


I need to break a complex
query into named steps
                ↓
              CTE
                │
        ┌───────┴────────┐
        ↓                ↓
      Normal          Recursive
                         ↓
                  Parent-child data

12. DDL and DML – Table Definition and Data Changes
12.1 Create a sample table
CREATE TABLE RETAIL_DB1 (
    CUST_ID INT NOT NULL,
    CUST_NAME VARCHAR(50) NOT NULL,
    CITY VARCHAR(50),
    GENDER VARCHAR(10),
    PROF VARCHAR(20),
    CONSTRAINT RETAILDB_PK PRIMARY KEY (CUST_ID)
);

-- PRIMARY KEY means unique + NOT NULL.
-- AUTO_INCREMENT is optional; it is not required for a primary key.
-- A constraint name is optional, but naming important constraints can make
-- schema maintenance easier.
12.2 Inspect table definition
DESCRIBE RETAIL_DB1;

-- SHOW CREATE TABLE gives the complete CREATE TABLE definition.
SHOW CREATE TABLE RETAIL_DB1;
12.3 Insert rows
INSERT INTO RETAIL_DB1 (CUST_ID, CUST_NAME, CITY, GENDER, PROF)
VALUES (101, 'RAM', 'BLR', 'M', 'Engineer');

INSERT INTO RETAIL_DB1 (CUST_ID, CUST_NAME, CITY, GENDER, PROF)
VALUES
    (102, 'BHEEM', 'MLR', 'M', 'Manager'),
    (103, 'JOHN', 'BLR', 'M', 'Analyst');

-- Always list the target columns explicitly.
-- If a column is omitted, its DEFAULT value is used if one is defined.
-- '' is an empty string; it is not NULL.
-- NULL is a separate value and is allowed only when the column permits NULL.
12.4 UPDATE safely
-- First inspect the exact rows that will be changed.
SELECT *
FROM RETAIL_DB1
WHERE CUST_ID = 102;

UPDATE RETAIL_DB1
SET CITY = 'MUM'
WHERE CUST_ID = 102;

-- Missing WHERE updates every row.
-- Before a production UPDATE, run a SELECT with the same WHERE condition.
12.5 DELETE safely
SELECT *
FROM RETAIL_DB1
WHERE CUST_ID = 103;

DELETE FROM RETAIL_DB1
WHERE CUST_ID = 103;

-- Missing WHERE deletes every row from the table.
-- DELETE FROM RETAIL_DB1 removes rows but keeps the table structure.
12.6 ALTER TABLE
ALTER TABLE RETAIL_DB1
ADD COLUMN EMAIL VARCHAR(100);

ALTER TABLE RETAIL_DB1
MODIFY COLUMN GENDER VARCHAR(20);

ALTER TABLE RETAIL_DB1
MODIFY COLUMN PROF VARCHAR(50);

ALTER TABLE RETAIL_DB1
DROP COLUMN EMAIL;

-- MySQL uses MODIFY COLUMN to change a column definition.
-- Dropping a column removes the column and its data.
12.7 Rename table
RENAME TABLE RETAIL_DB1 TO MYRETAIL_DB1;
12.8 Drop a primary key
-- The primary key can be removed without needing a custom constraint name.
ALTER TABLE MYRETAIL_DB1
DROP PRIMARY KEY;

-- Re-add it if required:
ALTER TABLE MYRETAIL_DB1
ADD PRIMARY KEY (CUST_ID);

-- A primary key is referred to as PRIMARY in MySQL.
12.9 Transactions
START TRANSACTION;

UPDATE MYRETAIL_DB1
SET CITY = 'BLR'
WHERE CUST_ID = 101;

SELECT *
FROM MYRETAIL_DB1
WHERE CUST_ID = 101;

-- Undo all uncommitted changes in this transaction:
ROLLBACK;

-- To make changes permanent instead:
-- COMMIT;
•	Transactions require a transactional storage engine such as InnoDB for normal transactional behavior.
12.10 SAVEPOINT
START TRANSACTION;

UPDATE MYRETAIL_DB1
SET CITY = 'BLR'
WHERE CUST_ID = 101;

SAVEPOINT before_second_change;

UPDATE MYRETAIL_DB1
SET PROF = 'Architect'
WHERE CUST_ID = 101;

ROLLBACK TO SAVEPOINT before_second_change;

COMMIT;

-- The first UPDATE remains; the second UPDATE is undone.
-- ROLLBACK without a savepoint would undo all uncommitted changes.
12.11 LIMIT and OFFSET
-- Return the first 10 rows after applying the chosen ordering.
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID
LIMIT 10;

-- Skip the first 20 rows and return the next 10.
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID
LIMIT 10 OFFSET 20;

-- OFFSET is normally used with LIMIT in MySQL.
-- Without ORDER BY, "first 20 rows" is not a stable business definition.
12.12 Top rows without a practical LIMIT size
-- MySQL does not provide a standalone OFFSET clause meaning
-- "skip N and return every remaining row".
-- For true pagination, specify a page size:
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID
LIMIT 20 OFFSET 20;

-- If an application genuinely needs every row after an offset, it is usually
-- better to redesign the pagination requirement rather than use an artificial
-- maximum LIMIT value.
Practice 16: Create a table with CUSTOMER_ID as primary key, CUSTOMER_NAME as NOT NULL, and STATUS with a default value of 'active'.
Solution
CREATE TABLE CUSTOMER_STATUS (
    CUSTOMER_ID INT PRIMARY KEY,
    CUSTOMER_NAME VARCHAR(100) NOT NULL,
    STATUS VARCHAR(20) NOT NULL DEFAULT 'active'
);
Practice 17: Insert two customers without supplying STATUS and verify that the default value is used.
Solution
INSERT INTO CUSTOMER_STATUS (CUSTOMER_ID, CUSTOMER_NAME)
VALUES
    (1, 'Ravi'),
    (2, 'Priya');

SELECT *
FROM CUSTOMER_STATUS;
13. MySQL SQL Rules and Common Violations
Topic	Rule / Common Violation
SELECT	SELECT * is valid but returns every column. A missing FROM is not an error when the query only evaluates expressions such as SELECT 10 + 20.
Aliases	A SELECT alias is available to ORDER BY and MySQL permits it in HAVING, but it is not normally available to WHERE at the same query level.
NULL	Use IS NULL / IS NOT NULL. Do not use = NULL or <> NULL.
WHERE	Filters rows before grouping. Aggregate conditions such as AVG(SALARY) > 10000 belong in HAVING.
GROUP BY	With ONLY_FULL_GROUP_BY, every selected non-aggregated column must be functionally dependent on or included in GROUP BY.
HAVING	Filters groups. It can contain aggregate expressions such as COUNT(*) or AVG(SALARY).
COUNT	COUNT(*) counts rows; COUNT(column) ignores NULL; COUNT(DISTINCT column) counts distinct non-NULL values.
LIKE	% means zero or more characters; _ means exactly one character.
BETWEEN	BETWEEN is inclusive at both ends.
IN	IN compares against a list of values. NOT IN requires care if the comparison set can contain NULL.
ORDER BY	ASC is the default. Multiple expressions are tie-breakers from left to right.
DATE_FORMAT	Use %Y for four-digit year, %y for two-digit year, %m for two-digit month, %d for two-digit day, %e for day without leading zero, %M for full month name, and %b for abbreviated month.
DATE arithmetic	DATEDIFF returns days. TIMESTAMPDIFF returns differences in a chosen unit. DATE_ADD/DATE_SUB require INTERVAL value unit.
CONCAT	CONCAT returns NULL if any argument is NULL. Use COALESCE/IFNULL when NULL should be replaced.
ROUND	ROUND(number, decimals) returns a numeric value. FORMAT(number, decimals) returns a formatted string.
JOIN	Always make the relationship explicit with ON unless USING/NATURAL JOIN is deliberately appropriate.
USING	USING requires the join-column name to exist in both tables. The USING column is referenced without a table qualifier in the query.
NATURAL JOIN	MySQL supports it, but it automatically uses all same-named columns; a schema change can therefore change the join condition.
LEFT JOIN	Preserves all rows from the left table. Unmatched right-side columns become NULL.
CROSS JOIN	Produces every combination of rows; result size is the product of the input row counts.
Subqueries	A scalar subquery used with =, <, >, etc. must return at most one row. Use IN/ANY/ALL/EXISTS when multiple rows are expected.
Window functions	Calculate values across rows without collapsing them. To filter a window result such as ROW_NUMBER(), calculate it in a derived table/CTE and filter outside.
DML safety	Run SELECT with the intended WHERE clause before UPDATE/DELETE. Missing WHERE can affect every row.
Transactions	START TRANSACTION begins a transaction; COMMIT makes changes permanent; ROLLBACK undoes uncommitted changes; SAVEPOINT creates a rollback point.
DDL	CREATE/ALTER/DROP change schema. Do not assume every DDL statement behaves like ordinary transactional DML.
14. Integrated Queries
14.1 Employee analysis – WHERE + GROUP BY + HAVING + ORDER BY
SELECT
    D.DEPARTMENT_NAME,
    COUNT(*) AS EmployeeCount,
    ROUND(AVG(E.SALARY), 2) AS AvgSalary,
    MAX(E.SALARY) AS MaxSalary
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY >= 5000
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(*) >= 3
ORDER BY AvgSalary DESC;
14.2 Employee and manager details – self JOIN + filter + sort
SELECT
    E.LAST_NAME AS EmployeeLastName,
    E.EMPLOYEE_ID,
    M.LAST_NAME AS ManagerLastName,
    E.DEPARTMENT_ID
FROM EMPLOYEES E
JOIN EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID
WHERE E.DEPARTMENT_ID IN (10, 20, 30)
ORDER BY E.DEPARTMENT_ID, E.LAST_NAME;
14.3 Highest salary per country – JOIN + GROUP BY
SELECT
    L.COUNTRY_ID,
    MAX(E.SALARY) AS MaxSalary
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
GROUP BY L.COUNTRY_ID
ORDER BY MaxSalary DESC;
14.4 Employee tenure and review dates
SELECT
    EMPLOYEE_ID,
    HIRE_DATE,
    TIMESTAMPDIFF(MONTH, HIRE_DATE, CURRENT_DATE()) AS MonthsEmployed,
    DATE_ADD(HIRE_DATE, INTERVAL 6 MONTH) AS SixMonthReview,
    DATE_ADD(
        HIRE_DATE,
        INTERVAL MOD(6 - DAYOFWEEK(HIRE_DATE) + 7, 7) DAY
    ) AS FirstFridayOnOrAfterHireDate,
    LAST_DAY(HIRE_DATE) AS LastDayOfHireMonth
FROM EMPLOYEES
WHERE TIMESTAMPDIFF(MONTH, HIRE_DATE, CURRENT_DATE()) < 150
  AND DEPARTMENT_ID = 50;
14.5 Tax calculation
-- Example parameter values
SET @employee_id = 100;
SET @tax_rate = 0.20;

SELECT
    EMPLOYEE_ID,
    FIRST_NAME,
    SALARY,
    SALARY * 12 AS `Annual Salary`,
    @tax_rate AS TAX_RATE,
    (SALARY * 12) * @tax_rate AS `TAX AMOUNT`
FROM EMPLOYEES
WHERE EMPLOYEE_ID = @employee_id;
15. Recommended Logical Query Order
-- Logical processing order:
-- 1. FROM / JOIN
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT
-- 6. DISTINCT
-- 7. ORDER BY
-- 8. LIMIT / OFFSET

-- Written query order is normally:
-- SELECT
-- FROM / JOIN
-- WHERE
-- GROUP BY
-- HAVING
-- ORDER BY
-- LIMIT / OFFSET

-- Example:
SELECT
    D.DEPARTMENT_NAME,
    COUNT(*) AS EmployeeCount,
    ROUND(AVG(E.SALARY), 2) AS AvgSalary
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY >= 5000
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING COUNT(*) >= 3
ORDER BY AvgSalary DESC
LIMIT 10 OFFSET 0;

End of MySQL HR Schema Class Script.
