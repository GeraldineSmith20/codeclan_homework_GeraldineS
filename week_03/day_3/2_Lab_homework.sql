-- Q1: Are there any pay_details records lacking both a local_account_no and iban number?

SELECT
	id,
	local_account_no,
	iban
FROM pay_details
WHERE local_account_no IS NULL AND iban IS NULL;


-- Q2 Get a table of employees first_name, last_name and country,
-- ordered alphabetically first by country and then by last_name (put any NULLs last).

SELECT
	first_name,
	last_name,
	country
FROM employees
ORDER BY country ASC NULLS LAST, last_name ASC NULLS LAST;


-- Q3 Find the details of the top ten highest paid employees in the corporation.

SELECT *
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 10;

-- Q4 Find the first_name, last_name and salary of the lowest paid employee in Hungary.

SELECT
	first_name,
	last_name,
	salary
FROM employees
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST;

-- Q5 Find all the details of any employees with a ‘yahoo’ email address?

SELECT *
FROM employees
WHERE email LIKE '%@yahoo%'

-- Q6 Provide a breakdown of the numbers of employees enrolled,
-- not enrolled, and with unknown enrollment status in the corporation pension scheme.

SELECT
	COUNT(id) AS num_emp,
	pension_enrol
FROM employees
GROUP BY pension_enrol;

-- Q7 What is the maximum salary among those employees in the ‘Engineering’ department
--who work 1.0 full-time equivalent hours (fte_hours)?

SELECT
	MAX(salary)
FROM employees
WHERE department = 'Engineering' AND fte_hours = 1.0;

-- Q8 Get a table of country, number of employees in that country,
--and the average salary of employees in that country for any countries
-- in which more than 30 employees are based. Order the table by average salary descending.

SELECT
	country,
	Count(id) AS number_employees,
	AVG(salary)
	FROM employees
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY AVG(salary)DESC;

-- Q9 Return a table containing each employees first_name, last_name, full-time equivalent hours
-- (fte_hours), salary, and a new column effective_yearly_salary
-- which should contain fte_hours multiplied by salary.

SELECT
	id,
	first_name,
	last_name,
	fte_hours,
	salary,
	(fte_hours * salary) AS effective_salary
FROM employees;


--Q10 Find the first name and last name of all employees who lack a local_tax_code.

SELECT
	e.first_name,
	e.last_name,
	p.local_tax_code
FROM employees AS e LEFT JOIN pay_details AS p
ON e.id = p.id
WHERE p.local_tax_code IS NULL;

-- Q11 The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours,
-- where charge_cost depends upon the team to which the employee belongs.
-- Get a table showing expected_profit for each employee.

SELECT
	e.first_name,
	e.last_name,
	t.name,
	(48 * 35 * CAST(t.charge_cost AS INT) - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
ORDER BY expected_profit DESC NULLS LAST;


-- Q12 Get a list of the id, first_name, last_name, salary and fte_hours of employees in the largest department.
-- Add two extra columns showing the ratio of each employee’s salary to that department’s average salary,
-- and each employee’s fte_hours to that department’s average fte_hours.

--Option 1

SELECT 
	id, 
	first_name, 
	last_name, 
	salary,
	fte_hours,
	department,
	salary/AVG(salary) OVER () AS ratio_avg_salary,
	fte_hours/AVG(fte_hours) OVER () AS ratio_fte_hours
FROM employees
WHERE department = (
	SELECT
	department
FROM employees 
GROUP BY department
ORDER BY COUNT(id) DESC
LIMIT 1);

--Option 2

WITH legal_avgs(department, avg_salary, avg_fte) AS (
SELECT
	department,
	AVG(salary) AS avg_salary,
	AVG(fte_hours) AS avg_fte,
	COUNT(id) AS count_people
FROM employees
GROUP BY department
ORDER BY count_people DESC NULLS LAST
LIMIT 1
)
	SELECT
	e.id,
	e.first_name,
	e.last_name,
	e.salary,
	e.fte_hours,
	e.department,
	salary / legal_avgs.avg_salary AS salary_ratio,
	fte_hours / legal_avgs.avg_fte AS fte_ratio
FROM employees AS e CROSS JOIN legal_avgs
WHERE e.department = legal_avgs.department;

--Option 3

WITH biggest_dept(name, avg_salary, avg_fte_hours) AS (
	SELECT
		department,
		AVG(salary),
		AVG(fte_hours)
	FROM employees 
	GROUP BY department
	ORDER BY COUNT(id) DESC NULLS LAST
	LIMIT 1
)
SELECT 
	*
FROM employees AS e
INNER JOIN biggest_dept AS db
ON e.department = db.name; 



--Extension Q1
--Return a table of those employee first_names shared by more than one employee,
--together with a count of the number of times each first_name occurs.
--Omit employees without a stored first_name from the table.
--Order the table descending by count, and then alphabetically by first_name.

SELECT
	first_name,
	COUNT(id)
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name
HAVING count(id) > 1
ORDER BY COUNT(id) DESC;


--Extension Q2
--Have a look again at your table for core question 6.
--It will likely contain a blank cell for the row relating to employees with ‘unknown’ pension enrollment status.
-- This is ambiguous: it would be better if this cell contained ‘unknown’ or something similar.
--Can you find a way to do this, perhaps using a combination of COALESCE() and CAST(), or a CASE statement?

SELECT
	pension_enrol,
	COUNT(id) AS num_emp,
	COALESCE(CAST(pension_enrol AS VARCHAR), 'Unknown') AS actual_pension_enrol
FROM employees
GROUP BY pension_enrol;


SELECT
	pension_enrol
 CASE
	WHEN pension_enrol IS NULL THEN 'Unknown'
	WHEN pension_enrol IS TRUE THEN 'Pensioned'
	ELSE  'Unpensioned'
 END AS actual_pension_enrol
 COUNT(id) AS num_employees
FROM employees
GROUP BY pension_enrol;


--Q3 Find the first name, last name, email address and start date of all the employees who are
-- members of the ‘Equality and Diversity’ committee.
--Order the member employees by their length of service in the company, longest first.

SELECT
	e.first_name,
	e.last_name,
	e.email,
	e.start_date,
	c.name
FROM (employees AS e LEFT JOIN employees_committees AS ec
      ON e.id = ec.employee_id) LEFT JOIN committees AS c
      ON ec.committee_id = c.id
WHERE c.name = 'Equality and Diversity'
ORDER BY e.start_date ASC NULLS LAST;


-- Q4. [Tough!] Use a CASE() operator to group employees who are members of committees into
-- salary_class of 'low' (salary < 40000) or 'high' (salary >= 40000).
-- A NULL salary should lead to 'none' in salary_class.
-- Count the number of committee members in each salary_class.

--You likely want to count DISTINCT() employees in each salary_class
--You will need to GROUP BY salary_class

WITH salary_classification(id,salary_class) AS
(SELECT
	id,
	CASE
		 WHEN salary < 40000 THEN 'low'
		 WHEN salary >= 40000 THEN 'high'
		 ELSE 'none'
	END AS salary_class
FROM employees)
SELECT
	COUNT(DISTINCT(e.id)) as num_employees,
	s.salary_class
FROM (employees AS e INNER JOIN salary_classification AS s
      ON e.id = s.id) INNER JOIN employees_committees AS ec
      ON e.id = ec.employee_id
GROUP BY s.salary_class
;
