--CTE's and Window Functions

--Common table expressions (ANSII SQL in 1999)
--CTE = temporary table that exists whilst another query is running
--use the temporary table inside another query
--CTE's = 'WITH' queries

--Add a column for each employee showing the ratio of their salary to the average salary of their team.

--team avgs
SELECT
	t.id,
	t.name,
	AVG(e.salary) AS avg_salary
FROM employees as e INNER JOIN teams AS t 
ON e.team_id = t.id 
GROUP BY t.id 

SELECT 
	e.first_name,
	e.last_name,
	team_avgs.name AS team_name,
	e.salary / team_avgs.avg_salary AS salary_over_team_avg
FROM employees as e INNER JOIN (
  SELECT
	t.id,
	t.name,
	AVG(e.salary) AS avg_salary
  FROM employees as e INNER JOIN teams AS t 
  ON e.team_id = t.id 
  GROUP BY t.id 
) AS team_avgs
ON e.team_id = team_avgs.id;
	
	
--Rewrite above, using a common table expression

WITH team_avgs(id, name, avg_salary) AS (
  SELECT
	t.id,
	t.name,
	AVG(e.salary) AS avg_salary
  FROM employees as e INNER JOIN teams AS t 
  ON e.team_id = t.id 
  GROUP BY t.id 
)
SELECT 
	e.first_name,
	e.last_name,
	team_avgs.name AS team_name,
	e.salary,
	e.salary / team_avgs.avg_salary AS salary_over_team_avg
FROM employees AS e INNER JOIN team_avgs
ON e.team_id = team_avgs.id;


--Task: Write a query for the average salary of employees in each country 
--(two columns in this query - country and avg_salary


SELECT 
	country,
	AVG(salary) AS avg_salary
FROM employees
GROUP BY country

--Use that query as a CTE (call it country_avgs).  
--Use the country_avgs CTE to calculate the salary_over_country_avg column in the main query.

WITH country_avgs(country, avg_salary) AS (
	SELECT 
	country,
	AVG(salary) AS avg_salary
	FROM employees
	GROUP BY country
)
SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	e.salary / country_avgs.avg_salary AS salary_over_country_avg
FROM employees AS e INNER JOIN country_avgs
ON e.country = country_avgs.country;

--Can use multiple CTE's eg.

WITH country_avgs(country, avg_salary) AS (
	SELECT
  		country,
  		AVG(salary)
	FROM employees
	GROUP BY country
), 
team_avgs(id, name, avg_salary) AS (
  SELECT
    t.id,
    t.name,
    AVG(e.salary)
  FROM employees AS e INNER JOIN teams AS t
  ON e.team_id = t.id
  GROUP BY t.id
)
SELECT
	e.first_name,
	e.last_name,
	e.salary,
	e.country,
	team_avgs.name AS team_name,
	e.salary / country_avgs.avg_salary AS salary_over_country_avg,
	e.salary / team_avgs.avg_salary AS salary_over_team_avg
FROM employees AS e INNER JOIN country_avgs
ON e.country = country_avgs.country INNER JOIN team_avgs
ON team_avgs.id = e.team_id;

-- Window Functions
-- So far aggregates applied over groups of rows, or occasionally over whole tables
-- called OVER queries

SELECT 
	department,
	AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

SELECT 
	function_name OVER (window definition)


--Window definition?
--Specification of a set of rows relative to current row
-- Default window definition is whole table (all rows)

SELECT 
  first_name,
  last_name,
  salary,
  SUM(salary) OVER () AS sum_salary
 FROM employees;


-- ORDER BY

--Get a table of employees’ names, salary and start date ordered by start date, 
--together with a running total of salaries by start date


SELECT 
	id,
	first_name,
	last_name,
	salary,
	start_date,
	SUM(salary) OVER (ORDER BY start_date ASC NULLS LAST) AS running_tot_salary
FROM employees;



--RANK(), DENSE RANK(), ROW_NUMBER()
--Rank employees in order by their start date with the corporation

SELECT 
  id,
  first_name,
  last_name,
  RANK() OVER (ORDER BY start_date ASC NULLS LAST) AS start_rank,
  DENSE_RANK () OVER (ORDER BY start_date ASC NULLS LAST) AS dnse_rank,
  ROW_NUMBER() OVER (ORDER BY start_date ASC NULLS LAST) AS row_num
FROM employees;


--PARTITION BY
--current row plus any other rows having the same value in the columns specified
--after partition by

--Show for each employee the number of other employees
--who are members of the same department as them

SELECT 
	id,
	first_name,
	last_name,
	department,
	COUNT(*) OVER (PARTITION BY department) - 1 AS num_other_employees_in_dept
FROM employees
ORDER BY id;

--Task
--Get a table of employee id, first and last name, grade and salary, 
--together with two new columns showing the maximum salary for employees of their grade, 
--and the minimum salary for employees of their grade



SELECT 
	id,
	first_name,
	last_name,
	grade,
	salary,
	MAX(salary) OVER (PARTITION BY grade) AS max_salary,
	MIN(salary) OVER (PARTITION BY grade) AS min_salary
FROM employees;


------Instead of complex sub-query from earlier........

--Ratio of each employee to average salary for their team

SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name,
	e.salary,
	e.salary / AVG(e.salary) OVER (PARTITION BY e.team_id) AS salary_over_team_avg
FROM employees AS e INNER JOIN teams AS t 
ON e.team_id = t.id
ORDER BY e.id;


-- ORDER BY and PARTITIO BY together
--Get a table of employees showing the order in which they started work with the corporation split by department


SELECT 
	first_name,
	last_name,
	start_date,
	department,
	RANK() OVER (PARTITION BY department ORDER BY start_date ASC NULLS LAST) AS order_started_in_dept
FROM employees
ORDER BY start_date;














	