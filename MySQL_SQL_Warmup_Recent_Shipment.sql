-- ============================================================
-- SQL WARM-UP DATASET 2
-- Domain: Logistics / Shipment Analytics
-- Database: LogisticsDB
-- MySQL
--
-- Primary focus:
-- Find the most recent shipment for each supplier.
-- ============================================================

DROP DATABASE IF EXISTS LogisticsTrainingDB;
CREATE DATABASE LogisticsTrainingDB;
USE LogisticsTrainingDB;

-- ============================================================
-- 1. TABLE CREATION
-- ============================================================

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL
);

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    supplier_id INT NOT NULL,
    shipment_date DATE NOT NULL,
    shipment_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(30),
    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);

-- ============================================================
-- 2. INSERT SAMPLE DATA
-- ============================================================

INSERT INTO suppliers (supplier_id, supplier_name) VALUES
(1, 'NorthStar Supplies'),
(2, 'BlueWave Traders'),
(3, 'GreenField Components'),
(4, 'MetroCore Industries'),
(5, 'Sunrise Distributors'),
(6, 'Vertex Equipment');

INSERT INTO shipments
(shipment_id, supplier_id, shipment_date, shipment_amount, status)
VALUES
-- NorthStar Supplies
(1001, 1, '2025-01-12', 18500.00, 'Delivered'),
(1002, 1, '2025-03-18', 22400.00, 'Delivered'),
(1003, 1, '2025-06-25', 19800.00, 'Delivered'),

-- BlueWave Traders
(1004, 2, '2025-02-05', 12750.00, 'Delivered'),
(1005, 2, '2025-04-21', 16300.00, 'Delivered'),
(1006, 2, '2025-07-09', 18950.00, 'In Transit'),

-- GreenField Components
(1007, 3, '2025-01-28', 9800.00, 'Delivered'),
(1008, 3, '2025-05-14', 14200.00, 'Delivered'),

-- MetroCore Industries
(1009, 4, '2025-03-03', 31000.00, 'Delivered'),
(1010, 4, '2025-04-17', 28500.00, 'Delivered'),
(1011, 4, '2025-08-02', 35400.00, 'In Transit'),

-- Sunrise Distributors
(1012, 5, '2025-02-11', 7600.00, 'Delivered'),
(1013, 5, '2025-06-08', 11200.00, 'Delivered'),
(1014, 5, '2025-07-28', 13500.00, 'Delivered'),

-- Vertex Equipment
(1015, 6, '2025-01-19', 22000.00, 'Delivered'),
(1016, 6, '2025-05-30', 24800.00, 'Delivered'),
(1017, 6, '2025-08-10', 27100.00, 'In Transit');

-- ============================================================
-- 3. QUICK DATA CHECK
-- ============================================================

SELECT * FROM suppliers;
SELECT * FROM shipments;

-- ============================================================
-- PRIMARY FOCUS
-- MOST RECENT SHIPMENT FOR EACH SUPPLIER
-- ============================================================

-- Q1. Retrieve the most recent shipment for each supplier.
--
-- Requirements:
-- 1. Correctly associate suppliers with their shipments
--    using supplier_id.
-- 2. Identify the latest shipment_date for each supplier.
-- 3. Return:
--       supplier_name,
--       shipment_date,
--       shipment_amount
-- 4. Return only the latest shipment for each supplier.
--
-- Hint:
-- JOIN both tables and use a subquery to obtain the
-- MAX(shipment_date) for the current supplier.
--
-- The expected logical pattern is:
--
-- SELECT supplier_name, shipment_date, shipment_amount
-- FROM suppliers s
-- JOIN shipments sh
--     ON s.supplier_id = sh.supplier_id
-- WHERE shipment_date = (
--     SELECT MAX(...)
--     ...
-- );


-- Q2. Solve Q1 using a correlated subquery.
--
-- Make the correlation explicit:
-- the inner query should find MAX(shipment_date)
-- for the supplier represented by the current outer row.
--
-- Think carefully about which alias belongs to the
-- outer query and which belongs to the inner query.


-- Q3. Solve Q1 using GROUP BY and MAX().
--
-- Return:
--       supplier_name,
--       latest_shipment_date
--
-- Important:
-- This question asks only for the latest DATE.
-- It does not yet ask for the shipment_amount.
--
-- Think about why MAX(shipment_date) alone cannot automatically
-- give you the shipment_amount from that same shipment.


-- Q4. Retrieve supplier_name, shipment_date and shipment_amount
-- for the latest shipment of every supplier using a window function.
--
-- Use ROW_NUMBER() OVER (
--     PARTITION BY supplier_id
--     ORDER BY shipment_date DESC
-- )
--
-- Then use an outer query / CTE to keep only row number = 1.


-- Q5. Retrieve the latest shipment for every supplier using
-- a CTE and ROW_NUMBER().
--
-- The CTE should first rank shipments for each supplier.
-- The outer query should return only rank 1.


-- Q6. Find the supplier that placed the most recent shipment
-- in the entire system.
--
-- Return:
--       supplier_name,
--       shipment_date,
--       shipment_amount
--
-- If multiple suppliers have the same latest date,
-- return all matching suppliers.


-- ============================================================
-- PRIMARY PATTERN — IMPORTANT VARIATION
-- ============================================================

-- Q7. Find the latest shipment AMOUNT for each supplier.
--
-- Return:
--       supplier_name,
--       latest_shipment_amount
--
-- Hint:
-- You need to identify the latest shipment first.
-- Do not assume MAX(shipment_amount) means the amount
-- of the latest shipment.
--
-- Example of the distinction:
-- MAX(amount) = largest shipment
-- latest date = most recent shipment
--
-- They are not necessarily the same shipment.


-- Q8. Find the latest shipment for each supplier, but include
-- only shipments whose status is 'Delivered'.
--
-- Think carefully about where the status condition belongs.
--
-- Question:
-- Are you finding the latest shipment overall and then
-- checking its status, or finding the latest DELIVERED shipment?
--
-- The intended requirement is:
-- "latest delivered shipment for each supplier."


-- ============================================================
-- SECONDARY FOCUS — JOINS
-- ============================================================

-- Q9. Display every shipment with:
--       supplier_name,
--       shipment_date,
--       shipment_amount,
--       status
--
-- Use INNER JOIN.


-- Q10. Display every supplier, including suppliers that have
-- no shipments, together with shipment information if available.
--
-- Use LEFT JOIN.
--
-- This demonstrates the difference between:
-- INNER JOIN → only matching suppliers
-- LEFT JOIN  → every supplier from the left table


-- Q11. Find all suppliers that have at least one shipment
-- with an amount greater than 25000.


-- Q12. Display the supplier_name and total shipment amount
-- for each supplier.
--
-- Use JOIN + GROUP BY + SUM().


-- Q13. Display suppliers whose total shipment amount is
-- greater than 50000.
--
-- Use GROUP BY + HAVING.


-- ============================================================
-- SECONDARY FOCUS — SUBQUERIES
-- ============================================================

-- Q14. Find shipments whose amount is greater than the
-- overall average shipment amount.
--
-- Use a scalar subquery.


-- Q15. Find suppliers who have at least one shipment
-- greater than 30000.
--
-- Use EXISTS.


-- Q16. Find suppliers who have never had a shipment
-- greater than 30000.
--
-- Use NOT EXISTS.


-- Q17. Find all shipments made by suppliers whose total
-- shipment amount is greater than 50000.
--
-- Use a subquery to first identify the qualifying suppliers.


-- Q18. Find shipments whose amount is greater than ANY
-- shipment amount made by 'GreenField Components'.


-- Q19. Find shipments whose amount is greater than ALL
-- shipment amounts made by 'GreenField Components'.


-- Q20. Find suppliers whose shipment amount is above their
-- own supplier's average shipment amount.
--
-- Use a correlated subquery.
--
-- For each shipment:
--     compare its amount with the average amount
--     for that same supplier.


-- ============================================================
-- SECONDARY FOCUS — WINDOW FUNCTIONS
-- ============================================================

-- Q21. Display every shipment with the overall average
-- shipment amount beside every row.
--
-- Use:
--     AVG(shipment_amount) OVER ()


-- Q22. Display every shipment with the average shipment
-- amount for its supplier.
--
-- Use:
--     AVG(shipment_amount) OVER (PARTITION BY supplier_id)


-- Q23. Assign ROW_NUMBER() to all shipments, with the
-- highest shipment amount first.


-- Q24. Rank shipments by shipment_amount from highest to lowest.
--
-- Use RANK().


-- Q25. Repeat Q24 using DENSE_RANK().
--
-- Compare RANK() and DENSE_RANK() when amounts are tied.


-- Q26. Rank shipments within each supplier by amount,
-- highest amount first.
--
-- Use:
--     PARTITION BY supplier_id
--     ORDER BY shipment_amount DESC


-- Q27. Find the top 2 shipments by amount for every supplier.
--
-- Use ROW_NUMBER() or RANK() with PARTITION BY.
--
-- Filter the generated row number/rank in an outer query
-- or CTE.


-- Q28. Find the most recent shipment for every supplier
-- using ROW_NUMBER().
--
-- Return:
--       supplier_name,
--       shipment_date,
--       shipment_amount
--
-- This is the window-function version of Q1.


-- ============================================================
-- SECONDARY FOCUS — CTEs
-- ============================================================

-- Q29. Create a CTE containing the latest shipment date
-- for each supplier.
--
-- Then join that CTE back to suppliers and shipments to
-- retrieve the corresponding shipment_amount.


-- Q30. Create a CTE that calculates total shipment amount
-- for every supplier.
--
-- Then display only suppliers whose total exceeds 50000.


-- Q31. Create a CTE that ranks shipments within each supplier
-- by shipment_date descending.
--
-- Display only row_number = 1.


-- ============================================================
-- MIXED TEST-STYLE PRACTICE
-- ============================================================

-- Q32. For every supplier, display:
--       supplier_name,
--       total_shipments,
--       highest_shipment_amount,
--       lowest_shipment_amount
--
-- Use JOIN + GROUP BY + COUNT() + MAX() + MIN().


-- Q33. Find the supplier with the largest difference between
-- their highest and lowest shipment amounts.
--
-- Return:
--       supplier_name,
--       highest_amount,
--       lowest_amount,
--       amount_range
--
-- Use a CTE or derived table.


-- Q34. Find the top 3 suppliers based on total shipment amount.
--
-- Return:
--       supplier_name,
--       total_shipment_amount
--
-- Use GROUP BY and ORDER BY with LIMIT.


-- Q35. For every supplier, display their latest shipment
-- together with their average shipment amount.
--
-- Use a CTE/window function or a combination of subquery
-- and JOIN.


-- ============================================================
-- SUGGESTED CLASSROOM ORDER
-- ============================================================
--
-- PRIMARY :
-- Q1  → Latest row per group using JOIN + correlated subquery
-- Q2  → Correlated subquery explicitly
-- Q3  → GROUP BY + MAX(date)
-- Q4  → ROW_NUMBER() solution
-- Q5  → CTE + ROW_NUMBER()
-- Q6  → MAX(date) + handling ties
-- Q7  → Latest row vs MAX(amount) distinction
-- Q8  → Latest row after applying a condition
--
-- SECONDARY:
-- Q9-Q13  → JOIN + GROUP BY + HAVING
-- Q14-Q20 → Scalar, EXISTS, NOT EXISTS, IN/ANY/ALL,
--            correlated subqueries
-- Q21-Q28 → Window functions
-- Q29-Q31 → CTEs
-- Q32-Q35 → Mixed practice
--
-- KEY TAKEAWAY FOR THE PRIMARY PROBLEM:
--
-- "MAX(date)" tells us the latest DATE.
-- It does NOT automatically return the other columns
-- belonging to that same row.
--
-- To get the complete latest record, we must connect
-- the maximum date back to the original shipment row.
--
-- Common patterns:
--
-- 1. JOIN + correlated subquery
-- 2. CTE + JOIN
-- 3. ROW_NUMBER() + outer query
--
-- All three can solve the same business requirement.
-- The important part is understanding why the extra step
-- is required to retrieve shipment_amount from the latest row.
-- ============================================================
