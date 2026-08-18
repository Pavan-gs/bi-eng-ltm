-- Select the HR database before running the examples.
USE HR;

-- MySQL does not require a GO batch separator.
-- If the database name is not HR in your environment, replace HR with the actual database name.

-- Inspect available tables.
SHOW TABLES;

-- Inspect a table's columns, data types, NULL rules, keys and defaults.
DESCRIBE EMPLOYEES;
DESCRIBE DEPARTMENTS;
DESCRIBE LOCATIONS;
DESCRIBE JOBS;

-- SELECT * returns every column.
-- Useful for initial exploration; avoid it when only a few columns are required.
SELECT *
FROM EMPLOYEES;

-- Projection: return only the columns required by the query.
SELECT FIRST_NAME, JOB_ID, SALARY
FROM EMPLOYEES;

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

-- MySQL can evaluate expressions without FROM.
SELECT 100 * 8 AS Result;

SELECT CURRENT_DATE() AS CurrentDate,
       CURRENT_TIME() AS CurrentTime,
       CURRENT_TIMESTAMP() AS CurrentDateTime;

SELECT FIRST_NAME, LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES;

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

-- DISTINCT removes duplicate result rows.
SELECT DISTINCT DEPARTMENT_ID
FROM EMPLOYEES;

-- DISTINCT applies to the complete selected combination.
SELECT DISTINCT DEPARTMENT_ID, JOB_ID
FROM EMPLOYEES;

SELECT DISTINCT JOB_ID
FROM EMPLOYEES;

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

SELECT
    LAST_NAME,
    CHAR_LENGTH(LAST_NAME) AS LengthOfLastName
FROM EMPLOYEES;

-- CHAR_LENGTH() counts characters.
-- LENGTH() counts bytes, which can differ for multibyte character sets.

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

SELECT
    LAST_NAME,
    LOCATE('a', LAST_NAME) AS PositionOfA,
    INSTR(LAST_NAME, 'a') AS PositionOfA_UsingINSTR
FROM EMPLOYEES;

-- LOCATE() and INSTR() return 0 when the searched string is not found.
-- They are position functions, not Boolean TRUE/FALSE functions.

SELECT
    TRIM('   MySQL SQL   ') AS Trimmed,
    LTRIM('   MySQL SQL') AS LeftTrimmed,
    RTRIM('MySQL SQL   ') AS RightTrimmed;

SELECT
    REPLACE('Data Engineering', 'Engineering', 'Science') AS Result;

-- Functions can be nested: the result of one function becomes the input to another.
SELECT
    LAST_NAME,
    UPPER(CONCAT(FIRST_NAME, ' ', JOB_ID)) AS EmployeeInfo
FROM EMPLOYEES;

SELECT EMPLOYEE_ID, JOB_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEES
WHERE SUBSTRING(JOB_ID, 4, 3) = 'REP';

-- If JOB_ID is shorter than the requested range, SUBSTRING() simply returns
-- the characters available; it does not create missing characters.

SELECT
    FIRST_NAME,
    LAST_NAME,
    LEFT(LAST_NAME, 5) AS First5Chars
FROM EMPLOYEES;

SELECT
    ROUND(109999.79698680, 2) AS RoundedNumber,
    CEIL(109999.21) AS CeilingValue,
    FLOOR(109999.79) AS FloorValue,
    ABS(-500) AS AbsoluteValue;

-- ROUND(number, decimals)
-- A negative decimals argument rounds to the left of the decimal point.
-- CEIL() moves upward; FLOOR() moves downward.
-- ABS() returns the absolute value.

-- FORMAT(number, decimals) returns a formatted string.
SELECT
    SALARY,
    FORMAT(SALARY, 2) AS SalaryFormatted,
    CONCAT('$', FORMAT(SALARY, 2)) AS SalaryWithDollar
FROM EMPLOYEES;

-- FORMAT() is for presentation; its result is a string, not a numeric value.
-- Do not use FORMAT() when the result must remain numeric for further arithmetic.

SELECT
    SALARY,
    SALARY * 12 AS AnnualSalary,
    ROUND(SALARY * 12, -3) AS AnnualSalaryRounded
FROM EMPLOYEES;

SELECT
    CURRENT_DATE() AS CurrentDate,
    CURRENT_TIME() AS CurrentTime,
    CURRENT_TIMESTAMP() AS CurrentDateTime,
    NOW() AS NowValue;

-- CURRENT_DATE() / CURDATE() return the current date.
-- CURRENT_TIME() / CURTIME() return the current time.
-- NOW() / CURRENT_TIMESTAMP() return current date and time.

SELECT LAST_NAME, JOB_ID, SALARY, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE < '2008-02-01';

-- ISO date format YYYY-MM-DD is the safest format for DATE literals in MySQL.
-- Avoid comparing a DATE column to an arbitrary display-formatted string.

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

SELECT
    LAST_NAME,
    DATE_FORMAT(HIRE_DATE, '%d-%b-%Y') AS FormattedHireDate
FROM EMPLOYEES;

SELECT
    LAST_NAME,
    DATE_FORMAT(HIRE_DATE, '%D of %b %Y') AS FormattedHireDate
FROM EMPLOYEES;

-- Any arithmetic expression containing NULL normally evaluates to NULL.
SELECT
    LAST_NAME,
    SALARY,
    COMMISSION_PCT,
    SALARY + (SALARY * COMMISSION_PCT) AS TotalPay
FROM EMPLOYEES;

-- If COMMISSION_PCT is NULL, TotalPay becomes NULL.
-- Replace NULL explicitly when business logic requires a zero commission.

SELECT
    LAST_NAME,
    SALARY,
    COMMISSION_PCT,
    IFNULL(COMMISSION_PCT, 0) AS Commission,
    SALARY + (SALARY * IFNULL(COMMISSION_PCT, 0)) AS TotalPay
FROM EMPLOYEES;

-- IFNULL(expression, replacement)
-- If expression is NULL, replacement is returned; otherwise expression is returned.

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

SELECT
    FIRST_NAME,
    CHAR_LENGTH(FIRST_NAME) AS Expr1,
    LAST_NAME,
    CHAR_LENGTH(LAST_NAME) AS Expr2,
    NULLIF(CHAR_LENGTH(FIRST_NAME), CHAR_LENGTH(LAST_NAME)) AS Result
FROM EMPLOYEES;

-- NULLIF(a,b) returns NULL when a = b; otherwise it returns a.

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

SELECT
    LAST_NAME,
    COMMISSION_PCT,
    CASE
        WHEN COMMISSION_PCT IS NOT NULL THEN 'SAL+COMM'
        ELSE 'SAL'
    END AS IncomeType
FROM EMPLOYEES;

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

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE SALARY > 10000
  AND DEPARTMENT_ID IN (60, 80, 90)
ORDER BY SALARY DESC;

-- IN is equivalent to a series of equality checks combined with OR.
-- Values in an IN list should be compatible with the column data type.

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

SELECT LAST_NAME, DEPARTMENT_ID, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL;

SELECT LAST_NAME, DEPARTMENT_ID, SALARY, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;

-- Do not write: WHERE COMMISSION_PCT = NULL
-- = NULL does not test for NULL. Use IS NULL.

SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE (JOB_ID = 'SA_REP' OR JOB_ID = 'AD_PRES')
  AND SALARY > 10000
ORDER BY HIRE_DATE DESC;

-- Parentheses make the intended logical grouping explicit.
-- AND has higher precedence than OR, so parentheses are strongly recommended
-- when both operators are present.

SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE (JOB_ID = 'SA_REP' OR JOB_ID = 'AD_PRES')
  AND SALARY > 10000
ORDER BY JOB_ID ASC, SALARY DESC;

-- ASC is the default.
-- Multiple ORDER BY expressions are applied left to right as tie-breakers.

SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
ORDER BY 2;

-- 2 refers to the second expression in SELECT: JOB_ID.
-- This is valid but less readable than ORDER BY JOB_ID.

SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE LAST_NAME LIKE 'A%'
  AND SALARY BETWEEN 5000 AND 15000
ORDER BY SALARY DESC;

SELECT
    ROUND(AVG(SALARY), 2) AS AvgSalary,
    MAX(SALARY) AS MaxSalary,
    MIN(SALARY) AS MinSalary
FROM EMPLOYEES
WHERE JOB_ID LIKE '%REP%';

-- AVG(), SUM(), MIN(), MAX() ignore NULL values for the input expression.
-- AVG() returns NULL if there are no non-NULL values.

SELECT
    MIN(HIRE_DATE) AS EarliestHire,
    MAX(HIRE_DATE) AS LatestHire
FROM EMPLOYEES;

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

SELECT COUNT(DISTINCT DEPARTMENT_ID) AS UniqueDepartments
FROM EMPLOYEES;

-- NULL is not counted as a distinct value by COUNT(DISTINCT column).

SELECT
    SUM(SALARY) AS TotalSalary,
    AVG(SALARY) AS AvgSalary,
    AVG(IFNULL(COMMISSION_PCT, 0)) AS AvgCommissionTreatingNullAsZero
FROM EMPLOYEES;

-- AVG(COMMISSION_PCT) and AVG(IFNULL(COMMISSION_PCT,0)) can have different
-- business meanings. The second explicitly treats missing commission as zero.

SELECT
    MIN(SALARY) AS MinSalary,
    MAX(SALARY) AS MaxSalary,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
WHERE JOB_ID LIKE '%REP%';

SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary,
    MIN(SALARY) AS MinSalary,
    MAX(SALARY) AS MaxSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY MaxSalary DESC;

-- GROUP BY creates one result group for each distinct DEPARTMENT_ID.

SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
WHERE JOB_ID IN ('AD_VP', 'AD_PRES', 'IT_PROG')
GROUP BY DEPARTMENT_ID
ORDER BY AvgSalary DESC;

-- WHERE filters individual rows before the groups are formed.

SELECT
    DEPARTMENT_ID,
    JOB_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID;

-- Correct: every selected non-aggregate column is part of GROUP BY.
SELECT DEPARTMENT_ID, AVG(SALARY) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- This is invalid with ONLY_FULL_GROUP_BY enabled because DEPARTMENT_ID
-- is selected but is neither aggregated nor grouped:
-- SELECT DEPARTMENT_ID, AVG(SALARY)
-- FROM EMPLOYEES;

SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 10000;

-- HAVING filters groups after GROUP BY.
-- WHERE is for row-level filtering; HAVING is normally used for group-level
-- or aggregate conditions.

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

SELECT
    DAYNAME(HIRE_DATE) AS HireDay,
    COUNT(*) AS HireCount
FROM EMPLOYEES
GROUP BY DAYNAME(HIRE_DATE)
HAVING COUNT(*) >= 2
ORDER BY HireCount DESC;

SELECT
    YEAR(END_DATE) AS QuitYear,
    JOB_ID,
    COUNT(*) AS TurnoverCount
FROM EMPLOYEES
WHERE END_DATE IS NOT NULL
GROUP BY YEAR(END_DATE), JOB_ID
ORDER BY TurnoverCount DESC;

SELECT
    DEPARTMENT_ID,
    COUNT(*) AS EmployeeCount
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 5
ORDER BY EmployeeCount DESC;

SELECT
    DEPARTMENT_ID,
    ROUND(AVG(SALARY), 2) AS AvgSalary
FROM EMPLOYEES
WHERE SALARY >= 5000
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 10000
ORDER BY AvgSalary DESC;

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

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID,
    L.CITY
FROM DEPARTMENTS D
INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
WHERE D.DEPARTMENT_ID IN (50, 60, 80);

SELECT
    E.LAST_NAME,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

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

SELECT
    E.LAST_NAME,
    E.SALARY,
    J.JOB_TITLE
FROM EMPLOYEES E
JOIN JOBS J
    ON E.SALARY BETWEEN J.MIN_SALARY AND J.MAX_SALARY;

-- A join condition does not have to use =.
-- BETWEEN, <, >, <= and >= can be used when the business relationship requires it.

SELECT
    E.EMPLOYEE_ID,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
CROSS JOIN DEPARTMENTS D;

-- CROSS JOIN creates every possible employee/department combination.
-- If there are 100 employees and 27 departments, the result can contain
-- 100 * 27 = 2700 combinations.
-- Use it deliberately; it can create a very large result.

SELECT
    E.LAST_NAME,
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- LEFT JOIN keeps every row from the left table.
-- If there is no match, columns from the right table are NULL.

SELECT
    E.LAST_NAME,
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- RIGHT JOIN keeps every row from the right table.
-- LEFT JOIN is often easier to read because the preserved table appears first.

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

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID IS NULL;

-- The LEFT JOIN preserves departments.
-- The WHERE condition keeps only departments for which no employee match exists.

SELECT
    CONCAT(E.FIRST_NAME, ' ', E.LAST_NAME,
           ' is manager of the ', D.DEPARTMENT_NAME) AS Managers
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON D.MANAGER_ID = E.EMPLOYEE_ID;

SELECT
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    L.CITY
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID;

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID IS NULL;

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

SELECT MAX(SALARY) AS SecondHighest
FROM EMPLOYEES
WHERE SALARY < (SELECT MAX(SALARY) FROM EMPLOYEES);

-- The inner query finds the highest salary.
-- The outer query excludes that value and finds the maximum remaining salary.
-- This returns the second-highest DISTINCT salary.

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

SELECT *
FROM EMPLOYEES
ORDER BY SALARY DESC
LIMIT 5;

-- LIMIT 5 returns at most five rows after sorting.
-- Without ORDER BY, the concept of "top 5" is not deterministic.

SELECT *
FROM (
    SELECT
        E.*,
        ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS row_num
    FROM EMPLOYEES E
) AS ranked
WHERE row_num <= 5
ORDER BY row_num;

-- A window function is calculated in the inner query.
-- The outer query can then filter the generated row_num.
-- Window functions cannot be used directly in WHERE at the same query level.

SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE SALARY < ANY (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE JOB_ID = 'IT_PROG'
)
AND JOB_ID <> 'IT_PROG';

-- < ANY means the comparison is true if it is less than at least one value
-- returned by the subquery.

SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE SALARY < ALL (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE JOB_ID = 'IT_PROG'
)
AND JOB_ID <> 'IT_PROG';

-- < ALL means the value must be less than every value returned by the subquery.
-- If the subquery returns no rows, comparison behavior follows SQL's quantified
-- comparison rules; test such cases explicitly when the data can be empty.

SELECT
    E.EMPLOYEE_ID,
    E.SALARY,
    E.LAST_NAME
FROM EMPLOYEES E
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES E1
    WHERE E1.MANAGER_ID = E.EMPLOYEE_ID
      AND E1.SALARY > 10000
);

-- EXISTS checks whether at least one matching row exists.
-- SELECT 1 is conventional because the actual selected value is irrelevant.

SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM DEPARTMENTS D
WHERE NOT EXISTS (
    SELECT 1
    FROM EMPLOYEES E
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
);

SELECT E.LAST_NAME
FROM EMPLOYEES E
WHERE E.EMPLOYEE_ID NOT IN (
    SELECT MGR.MANAGER_ID
    FROM EMPLOYEES MGR
    WHERE MGR.MANAGER_ID IS NOT NULL
);

-- When NOT IN is used, a NULL in the subquery can make the predicate UNKNOWN
-- and produce unexpected results. Excluding NULLs in the subquery is a safe pattern.
-- NOT EXISTS is often easier to reason about for anti-matching logic.

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

-- The inner query refers to E from the outer query.
-- Therefore the inner query is evaluated in relation to the current outer row.

SELECT
    EMPLOYEE_ID,
    LAST_NAME,
    SALARY
FROM EMPLOYEES
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM EMPLOYEES
);

SELECT
    E.EMPLOYEE_ID,
    E.LAST_NAME
FROM EMPLOYEES E
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES E2
    WHERE E2.MANAGER_ID = E.EMPLOYEE_ID
);

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

DESCRIBE RETAIL_DB1;

-- SHOW CREATE TABLE gives the complete CREATE TABLE definition.
SHOW CREATE TABLE RETAIL_DB1;

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

-- First inspect the exact rows that will be changed.
SELECT *
FROM RETAIL_DB1
WHERE CUST_ID = 102;

UPDATE RETAIL_DB1
SET CITY = 'MUM'
WHERE CUST_ID = 102;

-- Missing WHERE updates every row.
-- Before a production UPDATE, run a SELECT with the same WHERE condition.

SELECT *
FROM RETAIL_DB1
WHERE CUST_ID = 103;

DELETE FROM RETAIL_DB1
WHERE CUST_ID = 103;

-- Missing WHERE deletes every row from the table.
-- DELETE FROM RETAIL_DB1 removes rows but keeps the table structure.

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

RENAME TABLE RETAIL_DB1 TO MYRETAIL_DB1;

-- The primary key can be removed without needing a custom constraint name.
ALTER TABLE MYRETAIL_DB1
DROP PRIMARY KEY;

-- Re-add it if required:
ALTER TABLE MYRETAIL_DB1
ADD PRIMARY KEY (CUST_ID);

-- A primary key is referred to as PRIMARY in MySQL.

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

CREATE TABLE CUSTOMER_STATUS (
    CUSTOMER_ID INT PRIMARY KEY,
    CUSTOMER_NAME VARCHAR(100) NOT NULL,
    STATUS VARCHAR(20) NOT NULL DEFAULT 'active'
);

INSERT INTO CUSTOMER_STATUS (CUSTOMER_ID, CUSTOMER_NAME)
VALUES
    (1, 'Ravi'),
    (2, 'Priya');

SELECT *
FROM CUSTOMER_STATUS;

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
