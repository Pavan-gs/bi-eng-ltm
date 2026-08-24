-- ============================================================
-- MySQL Stored Programs: PROCEDURES, FUNCTIONS AND TRIGGERS
-- ============================================================
--
-- PROCEDURE
--   An explicitly invoked stored program used to perform one or
--   more database operations. It can also return result sets or
--   values through OUT / INOUT parameters.
--
-- FUNCTION
--   A stored program that returns ONE value and can be used inside
--   an SQL expression such as SELECT or WHERE.
--
-- TRIGGER
--   A stored program that runs automatically when INSERT, UPDATE
--   or DELETE occurs on a table.
--
-- Key distinction:
--   PROCEDURE -> explicitly CALL it
--   FUNCTION  -> use it as an expression
--   TRIGGER   -> runs automatically
--
-- ============================================================


-- ============================================================
-- DELIMITER
-- ============================================================
--
-- MySQL normally uses ; to end a statement.
-- Stored programs contain multiple statements ending in ;.
--
-- DELIMITER // temporarily makes // the end of the complete
-- CREATE PROCEDURE / FUNCTION / TRIGGER statement.
--
-- DELIMITER ; restores the normal delimiter.
--
-- DELIMITER is a MySQL client command; it is not stored as
-- part of the procedure, function or trigger.
-- ============================================================


-- ============================================================
-- 1. PROCEDURE: SIMPLE RESULT SET
-- ============================================================
--
-- Requirement:
-- Return all employees belonging to a supplied department.
--
-- IN means the caller supplies a value to the procedure.
--
-- p_department_id is the parameter name.
-- INT is its data type.
--
-- CREATE PROCEDURE stores the procedure.
-- It does not execute the procedure.
--
-- Execute later using:
-- CALL GetEmployeesByDepartment(60);
-- ============================================================

DROP PROCEDURE IF EXISTS GetEmployeesByDepartment;

DELIMITER //

CREATE PROCEDURE GetEmployeesByDepartment(
    IN p_department_id INT
)
BEGIN
    SELECT
        employee_id,
        last_name,
        salary
    FROM employees
    WHERE department_id = p_department_id;
END //

DELIMITER ;

CALL GetEmployeesByDepartment(60);


-- ============================================================
-- 2. PROCEDURE: IN + OUT PARAMETER
-- ============================================================
--
-- Requirement:
-- Accept a department ID and return its employee count.
--
-- IN:
--   Caller -> procedure
--
-- OUT:
--   Procedure -> caller
--
-- SELECT ... INTO stores the COUNT result in the OUT parameter.
--
-- @total is a MySQL session variable used to receive the OUT value.
-- ============================================================

DROP PROCEDURE IF EXISTS GetEmployeeCount;

DELIMITER //

CREATE PROCEDURE GetEmployeeCount(
    IN p_department_id INT,
    OUT p_employee_count INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_employee_count
    FROM employees
    WHERE department_id = p_department_id;
END //

DELIMITER ;

CALL GetEmployeeCount(60, @total);

SELECT @total AS employee_count;


-- ============================================================
-- 3. PROCEDURE: BUSINESS OPERATION
-- ============================================================
--
-- Requirement:
-- Increase an employee's salary by a supplied percentage.
--
-- A procedure is especially useful when the requirement is to
-- perform an operation or a sequence of database operations.
-- ============================================================

DROP PROCEDURE IF EXISTS PromoteEmployee;

DELIMITER //

CREATE PROCEDURE PromoteEmployee(
    IN p_employee_id INT,
    IN p_increment DECIMAL(5,2)
)
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_increment / 100)
    WHERE employee_id = p_employee_id;
END //

DELIMITER ;

CALL PromoteEmployee(101, 10);


-- ============================================================
-- 4. PROCEDURE: BUSINESS OPERATION + OUT VALUE
-- ============================================================
--
-- A procedure can perform an operation AND return a value.
--
-- Requirement:
-- Increase an employee's salary and return the new salary.
--
-- This is why:
--   "Procedure = does not return anything"
--
-- is NOT a correct rule.
--
-- A procedure can return result sets and values.
-- ============================================================

DROP PROCEDURE IF EXISTS PromoteEmployeeAndGetSalary;

DELIMITER //

CREATE PROCEDURE PromoteEmployeeAndGetSalary(
    IN p_employee_id INT,
    IN p_increment DECIMAL(5,2),
    OUT p_new_salary DECIMAL(10,2)
)
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_increment / 100)
    WHERE employee_id = p_employee_id;

    SELECT salary
    INTO p_new_salary
    FROM employees
    WHERE employee_id = p_employee_id;
END //

DELIMITER ;

CALL PromoteEmployeeAndGetSalary(101, 10, @new_salary);

SELECT @new_salary AS new_salary;


-- ============================================================
-- 5. INOUT PARAMETER
-- ============================================================
--
-- INOUT:
--   Caller -> procedure -> caller
--
-- The caller supplies an initial value.
-- The procedure modifies it.
-- The caller can then read the changed value.
-- ============================================================

DROP PROCEDURE IF EXISTS AddBonusToAmount;

DELIMITER //

CREATE PROCEDURE AddBonusToAmount(
    INOUT p_amount DECIMAL(10,2),
    IN p_bonus DECIMAL(10,2)
)
BEGIN
    SET p_amount = p_amount + p_bonus;
END //

DELIMITER ;

SET @amount = 10000;

CALL AddBonusToAmount(@amount, 1500);

SELECT @amount AS amount_after_bonus;


-- ============================================================
-- 6. FUNCTION: SIMPLE CALCULATION
-- ============================================================
--
-- Requirement:
-- Given monthly salary, return annual salary.
--
-- RETURNS DECIMAL(12,2):
--   Declares the data type of the single value returned.
--
-- RETURN:
--   Supplies the actual value.
--
-- DETERMINISTIC:
--   Declares that the function is expected to return the same
--   result for the same input values.
--
-- Example:
--   AnnualSalary(5000) -> 60000
-- ============================================================

DROP FUNCTION IF EXISTS AnnualSalary;

DELIMITER //

CREATE FUNCTION AnnualSalary(
    p_salary DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN p_salary * 12;
END //

DELIMITER ;

SELECT AnnualSalary(5000) AS annual_salary;

SELECT
    employee_id,
    salary,
    AnnualSalary(salary) AS annual_salary
FROM employees;


-- ============================================================
-- 7. FUNCTION: CLASSIFICATION
-- ============================================================
--
-- Requirement:
-- Classify salary as High, Medium or Low.
--
-- A stored function must return ONE value.
-- ============================================================

DROP FUNCTION IF EXISTS SalaryCategory;

DELIMITER //

CREATE FUNCTION SalaryCategory(
    p_salary DECIMAL(10,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_salary >= 15000 THEN
        RETURN 'High';
    ELSEIF p_salary >= 10000 THEN
        RETURN 'Medium';
    ELSE
        RETURN 'Low';
    END IF;
END //

DELIMITER ;

SELECT
    employee_id,
    salary,
    SalaryCategory(salary) AS salary_category
FROM employees;


-- ============================================================
-- 8. FUNCTION USED IN WHERE
-- ============================================================
--
-- A function can participate in an SQL expression.
--
-- This is a major difference from a procedure.
-- ============================================================

SELECT
    employee_id,
    last_name,
    salary
FROM employees
WHERE AnnualSalary(salary) > 120000;


-- ============================================================
-- 9. DETERMINISTIC VS NON-DETERMINISTIC
-- ============================================================
--
-- DETERMINISTIC:
--   Same input -> expected same output.
--
-- AnnualSalary(5000) always returns 60000.
--
-- CURRENT_DATE(), CURRENT_TIMESTAMP() and RAND() depend on
-- changing state/time and therefore do not have the same
-- behavior for repeated calls over time.
--
-- DETERMINISTIC is a declaration describing expected behavior.
-- It does not magically make a non-deterministic expression
-- deterministic.
-- ============================================================

DROP FUNCTION IF EXISTS TodayDate;

DELIMITER //

CREATE FUNCTION TodayDate()
RETURNS DATE
NOT DETERMINISTIC
BEGIN
    RETURN CURRENT_DATE();
END //

DELIMITER ;

SELECT TodayDate() AS today;


-- ============================================================
-- 10. PROCEDURE VS FUNCTION
-- ============================================================
--
-- PROCEDURE
--   Explicitly invoked using CALL.
--   Can perform multiple operations.
--   Can return result sets.
--   Can return values through OUT / INOUT.
--
-- FUNCTION
--   Used as part of an SQL expression.
--   Must return ONE value.
--   Suitable for reusable calculations and classifications.
--
-- The employee-count procedure could also be implemented as a
-- function because it produces one scalar value:
--
--   SELECT GetEmployeeCount(60);
--
-- The important distinction is not simply:
--   "Procedure does not return; function returns."
--
-- Better rule:
--   PROCEDURE -> explicitly invoked stored operation
--   FUNCTION  -> stored program that returns one value and can
--                participate in SQL expressions
-- ============================================================


-- ============================================================
-- 11. TRIGGER: AUDIT SALARY CHANGES
-- ============================================================
--
-- A trigger is NOT explicitly called.
-- It runs automatically when its table event occurs.
--
-- Requirement:
-- Whenever an employee's salary changes, record:
--   employee ID
--   old salary
--   new salary
--   change time
--
-- OLD = value before UPDATE
-- NEW = value after UPDATE
--
-- AFTER UPDATE:
--   trigger runs after the UPDATE event.
--
-- FOR EACH ROW:
--   trigger executes once for each affected row.
-- ============================================================

DROP TRIGGER IF EXISTS salary_change_audit;

CREATE TABLE IF NOT EXISTS salary_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_at DATETIME
);

DELIMITER //

CREATE TRIGGER salary_change_audit
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_audit
        (
            employee_id,
            old_salary,
            new_salary,
            changed_at
        )
        VALUES
        (
            NEW.employee_id,
            OLD.salary,
            NEW.salary,
            CURRENT_TIMESTAMP
        );
    END IF;
END //

DELIMITER ;

-- The trigger fires automatically. No CALL is required.

UPDATE employees
SET salary = salary + 1000
WHERE employee_id = 101;

SELECT *
FROM salary_audit;


-- ============================================================
-- 12. TRIGGER: VALIDATE SALARY BEFORE INSERT
-- ============================================================
--
-- Requirement:
-- Do not allow an employee to be inserted with a negative salary.
--
-- BEFORE INSERT:
--   trigger runs before the row is inserted.
--
-- NEW.salary:
--   salary that is about to be inserted.
--
-- SIGNAL:
--   raises an error and prevents the invalid operation.
--
-- SQLSTATE '45000':
--   user-defined exception condition.
-- ============================================================

DROP TRIGGER IF EXISTS validate_employee_salary;

DELIMITER //

CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END //

DELIMITER ;

-- Example that should fail:
--
-- INSERT INTO employees
-- (employee_id, last_name, salary)
-- VALUES
-- (999, 'Test', -5000);


-- ============================================================
-- 13. OLD AND NEW
-- ============================================================
--
-- INSERT:
--   OLD = not available
--   NEW = available
--
-- UPDATE:
--   OLD = available
--   NEW = available
--
-- DELETE:
--   OLD = available
--   NEW = not available
--
--             OLD       NEW
--   INSERT     No        Yes
--   UPDATE     Yes       Yes
--   DELETE     Yes       No
-- ============================================================


-- ============================================================
-- 14. BEFORE VS AFTER
-- ============================================================
--
-- BEFORE:
--   Runs before the DML operation.
--   Common uses:
--     validation
--     modifying incoming values
--
-- AFTER:
--   Runs after the DML operation.
--   Common uses:
--     auditing
--     logging
--     maintaining related information
-- ============================================================


-- ============================================================
-- 15. QUICK REFERENCE
-- ============================================================
--
-- PROCEDURE:
--   CREATE PROCEDURE name(...)
--   BEGIN
--       SQL statements;
--   END
--
--   CALL name(...);
--
-- FUNCTION:
--   CREATE FUNCTION name(...)
--   RETURNS datatype
--   [DETERMINISTIC]
--   BEGIN
--       RETURN value;
--   END
--
--   SELECT name(...);
--
-- TRIGGER:
--   CREATE TRIGGER name
--   BEFORE/AFTER INSERT/UPDATE/DELETE
--   ON table_name
--   FOR EACH ROW
--   BEGIN
--       SQL statements;
--   END
--
--   No CALL statement. It fires automatically.
-- ============================================================


-- ============================================================
-- 16. DECISION GUIDE
-- ============================================================
--
-- "I want to explicitly execute a database operation."
--     -> PROCEDURE
--
-- "I need one reusable value inside an SQL expression."
--     -> FUNCTION
--
-- "I need something to happen automatically when INSERT,
--  UPDATE or DELETE occurs."
--     -> TRIGGER
--
-- "I need several SQL operations as one database-side action."
--     -> PROCEDURE
--
-- "I need to calculate or transform a value."
--     -> FUNCTION
--
-- "I need to audit or validate a table event automatically."
--     -> TRIGGER
-- ============================================================
