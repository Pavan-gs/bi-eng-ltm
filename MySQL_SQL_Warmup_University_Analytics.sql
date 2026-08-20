-- ============================================================
-- SQL WARM-UP DATASET
-- Domain: University Academic Analytics
-- Database: UniversityTrainingDB
-- MySQL
-- ============================================================

DROP DATABASE IF EXISTS UniversityTrainingDB;
CREATE DATABASE UniversityTrainingDB;
USE UniversityTrainingDB;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    department_id INT,
    admission_year INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department_id INT,
    credits INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE exam_results (
    result_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    exam_date DATE NOT NULL,
    score DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO departments VALUES
(10, 'Computer Science'),
(20, 'Data Analytics'),
(30, 'Business Administration'),
(40, 'Cyber Security');

INSERT INTO students VALUES
(101, 'Ananya', 10, 2024),
(102, 'Bharat', 10, 2024),
(103, 'Charan', 20, 2023),
(104, 'Divya', 20, 2024),
(105, 'Eshan', 30, 2023),
(106, 'Farah', 30, 2024),
(107, 'Girish', 40, 2023),
(108, 'Hema', 40, 2024),
(109, 'Ishan', 10, 2024);

INSERT INTO courses VALUES
(201, 'Database Systems', 10, 4),
(202, 'Programming Fundamentals', 10, 4),
(203, 'Data Visualization', 20, 3),
(204, 'Statistics for Analytics', 20, 4),
(205, 'Financial Management', 30, 3),
(206, 'Cyber Security Fundamentals', 40, 4),
(207, 'Network Security', 40, 4),
(208, 'Business Intelligence', 20, 3);

INSERT INTO exam_results VALUES
(1001, 101, 201, '2025-03-10', 88),
(1002, 101, 202, '2025-03-15', 94),
(1003, 101, 208, '2025-03-20', 82),
(1004, 102, 201, '2025-03-10', 76),
(1005, 102, 202, '2025-03-15', 84),
(1006, 102, 208, '2025-03-20', 84),
(1007, 103, 203, '2025-03-11', 91),
(1008, 103, 204, '2025-03-16', 87),
(1009, 103, 208, '2025-03-21', 95),
(1010, 104, 203, '2025-03-11', 72),
(1011, 104, 204, '2025-03-16', 89),
(1012, 104, 208, '2025-03-21', 78),
(1013, 105, 205, '2025-03-12', 68),
(1014, 105, 205, '2025-06-12', 74),
(1015, 106, 205, '2025-03-12', 88),
(1016, 106, 205, '2025-06-12', 93),
(1017, 107, 206, '2025-03-13', 81),
(1018, 107, 207, '2025-03-18', 90),
(1019, 108, 206, '2025-03-13', 90),
(1020, 108, 207, '2025-03-18', 90),
(1021, 109, 201, '2025-03-10', 95),
(1022, 109, 202, '2025-03-15', 95),
(1023, 109, 208, '2025-03-20', 91);

-- ============================================================
-- PRIMARY FOCUS: 
-- ============================================================

-- Q1. Retrieve the highest and lowest exam scores for every student.
-- Display student_name, highest_score, lowest_score.
-- Sort alphabetically by student_name.
-- Hint: JOIN + MAX() + MIN() + GROUP BY.

-- Q2. Solve Q1 using correlated subqueries instead of GROUP BY.
-- Use one subquery for MAX(score) and one for MIN(score).
-- The inner queries must refer to the current outer student.

-- Q3. Solve Q1 using window functions.
-- Use MAX(score) OVER (PARTITION BY student_id)
-- and MIN(score) OVER (PARTITION BY student_id).

-- Q4. Solve Q1 using a CTE plus window functions.
-- Calculate window values in the CTE, then return one row per student.

-- Q5. Find the student(s) who achieved the highest individual score
-- in the university. Return student_name and score.
-- If tied, return all matching students.

-- Q6. Find the second-highest DISTINCT score in the university.
-- Do not simply take the second sorted row.

-- ============================================================
-- SECONDARY FOCUS: JOINS
-- ============================================================

-- Q7. Display student_name, course_name, score and exam_date
-- using INNER JOIN.

-- Q8. Display every student with their department_name.

-- Q9. Display every student, including students with no exam results,
-- together with their highest score if available.
-- Use LEFT JOIN.

-- Q10. Display student_name, course_name and score for scores > 90.

-- Q11. Find courses belonging to the same department as
-- 'Database Systems'. Use a subquery.

-- Q12. Solve Q11 using a JOIN instead of a subquery.

-- ============================================================
-- SECONDARY FOCUS: SUBQUERIES
-- ============================================================

-- Q13. Find exam results whose score is greater than the
-- overall average score. Use a scalar subquery.

-- Q14. Find students who have scored above 90 at least once.
-- Use EXISTS.

-- Q15. Find students who have never scored above 90.
-- Use NOT EXISTS.

-- Q16. Find students whose department has at least one student
-- who scored 95. Use IN with a subquery.
-- Important: return every student in such a department,
-- not only the students who scored 95.

-- Q17. Find students whose score is greater than ALL scores
-- obtained in 'Financial Management'.

-- Q18. Find students whose score is greater than ANY score
-- obtained in 'Financial Management'.

-- Q19. Find students whose score is above their own department's
-- average score. Use a correlated subquery.

-- Q20. Find students who have taken every course offered by
-- their own department. Challenge question.

-- ============================================================
-- SECONDARY FOCUS: WINDOW FUNCTIONS
-- ============================================================

-- Q21. Display every exam result with the university-wide
-- average score beside each row. Use AVG() OVER ().

-- Q22. Display every exam result with the average score for
-- that student's department. Use PARTITION BY.

-- Q23. Assign a unique row number to all exam results,
-- highest score first. Use ROW_NUMBER().

-- Q24. Rank students based on their highest score.
-- Tied values must receive the same rank. Use RANK().

-- Q25. Repeat Q24 using DENSE_RANK() and compare the result.

-- Q26. Rank students within each department according to
-- their highest score. Use PARTITION BY + ORDER BY.

-- Q27. Find the top 2 students from each department based on
-- highest score. Use ROW_NUMBER() or RANK() with PARTITION BY.
-- Use a CTE or derived table to filter the generated rank.

-- Q28. Find the highest-scoring exam result for every course.
-- Return course_name, student_name and score.
-- Use a window function or suitable subquery.

-- ============================================================
-- SECONDARY FOCUS: CTEs
-- ============================================================

-- Q29. Create a CTE containing student_id, student_name,
-- department_id and highest_score. Then display only
-- students whose highest_score > 90.

-- Q30. Create two CTEs:
-- 1. Calculate each student's highest score.
-- 2. Calculate average highest score by department.
-- Display department_id and average_highest_score.

-- Q31. Create a CTE that ranks students within each department.
-- Display only the top 2 students from every department.

-- ============================================================
-- MIXED TEST-STYLE WARM-UP
-- ============================================================

-- Q32. For every department, find department_name,
-- highest_score and lowest_score.
-- Include only departments having at least one exam result.

-- Q33. Find the student with the largest difference between
-- their highest and lowest scores.
-- Return student_name, highest_score, lowest_score and score_range.

-- Q34. Find the top 3 students based on their average exam score.
-- Return student_name and average_score.

-- Q35. For every course, display course_name, average_score,
-- highest_score and lowest_score.
-- Sort by average_score descending.

-- ============================================================
-- SUGGESTED ORDER
-- ============================================================
-- PRIMARY: Q1 -> Q6
-- JOINS: Q7 -> Q12
-- SUBQUERIES: Q13 -> Q20
-- WINDOWS: Q21 -> Q28
-- CTEs: Q29 -> Q31
-- MIXED: Q32 -> Q35
--
-- The first six questions deliberately mirror the logical skills
-- required for the upcoming test while changing the domain,
-- table names and data.
