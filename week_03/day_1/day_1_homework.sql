-- Find all the employees who work in the ‘Human Resources’ department.
SELECT 
	first_name,
	last_name,
	department
FROM employees 
WHERE department = 'Human Resources';

-- Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.

SELECT 
	first_name,
	last_name,
	country,
	department
FROM employees 
WHERE department = 'Legal';

-- Count the number of employees based in Portugal.

SELECT
	count(id) AS num_employees
FROM employees 
WHERE country = 'Portugal';

-- Count the number of employees based in either Portugal or Spain.

SELECT
	count(id) AS num_employees
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';


-- Count the number of pay_details records lacking a local_account_no.

SELECT 
	count(id) count_lacking_account_no
FROM pay_details 
WHERE local_account_no IS NULL;


-- Get a table with employees first_name and last_name ordered alphabetically by last_name 
--(put any NULLs last).

SELECT 
	first_name,
	last_name
FROM employees
ORDER BY last_name ASC NULLS LAST;


-- How many employees have a first_name beginning with ‘F’?

SELECT 
	COUNT(id) AS num_employees
FROM employees 
WHERE first_name = 'F%';

-- Count the number of pension enrolled employees not based in either France or Germany.

SELECT 
	COUNT(id) AS num_employees
FROM employees 
WHERE country NOT IN ('France', 'Germany');


-- Obtain a count by department of the employees who started work with the corporation in 2003.

SELECT 
	COUNT(id) AS num_employees_2003,
	department
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;


-- Obtain a table showing department, fte_hours and the number of employees in each department 
-- who work each fte_hours pattern. Order the table alphabetically by department, 
-- and then in ascending order of fte_hours.

SELECT
	department,
	fte_hours,
	count(id) as num_employees
FROM employees
GROUP BY department, fte_hours
ORDER BY department ASC,
		 fte_hours ASC; 

		
-- Obtain a table showing any departments in which there are two or more employees lacking 
-- a stored first name. Order the table in descending order of the number of employees 
-- lacking a first name, and then in alphabetical order by department.

SELECT 
	department,
	COUNT(id) AS num_employees_no_first_name
FROM employees
WHERE first_name IS NULL
GROUP BY department
ORDER BY num_employees_no_first_name DESC,
		 department ASC;

-- Find the proportion of employees in each department who are grade 1. -- STUCK!

SELECT 
	department,
	SUM(CAST(grade = 1 AS INTEGER))/COUNT(id) AS grade_1_proportion
FROM employees
GROUP BY department;
	
SELECT 
	department,
	COUNT(id)
FROM employees 
GROUP BY department;
	















