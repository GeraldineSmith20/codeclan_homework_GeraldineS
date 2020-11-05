--Q1 Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.

SELECT 
	e.*,
	p.local_account_no,
	p.local_sort_code
FROM employees AS e LEFT JOIN pay_details AS p
ON e.id = p.id;

--Q2 Amend your query from question 1 above to also return the name of the team that each employee belongs to.

SELECT 
	e.*,
	p.local_account_no,
	p.local_sort_code,
	t.name AS team_name
FROM employees AS e LEFT JOIN pay_details AS p
ON e.id = p.id INNER JOIN teams AS t
ON t.id = e.team_id;


--Q3 Find the first name, last name and team name of employees who are members of teams for which 
--the charge cost is greater than 80. Order the employees alphabetically by last name.

SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name,
	t.charge_cost
FROM employees AS e LEFT JOIN teams AS t
ON t.id = e.team_id
WHERE CAST(charge_cost AS INT) > 80
ORDER BY e.last_name ASC;



--Q4 Breakdown the number of employees in each of the teams, including any teams without members. 
--Order the table by increasing size of team.

SELECT 
	t.name AS team_name,
	COUNT(e.id) AS no_employees_in_team
FROM employees AS e LEFT JOIN teams AS t
ON t.id = e.team_id
GROUP BY team_name
ORDER BY COUNT(e.id) ASC;


--Q5 The effective_salary of an employee is defined as their fte_hours multiplied by their salary. 
--Get a table for each employee showing their id, first_name, last_name, fte_hours, salary and effective_salary, 
--along with a running total of effective_salary with employees placed in ascending order of effective_salary.

SELECT 
	id,
	first_name,
	last_name,
	fte_hours,
	salary,
	(fte_hours * salary) AS effective_salary,
	SUM(fte_hours * salary) OVER (ORDER BY fte_hours * salary ASC NULLS LAST) AS running_tot_salary
FROM employees;


--Q6 The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of employees in the team. 
--Calculate the total_day_charge for each team.

SELECT 
	t.name AS team_name,
	COUNT(e.id) * CAST(charge_cost AS INT) AS day_charge
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id 
GROUP BY t.id;



--Q7 How would you amend your query from question 6 above to show only those teams with a total_day_charge greater than 5000?
SELECT 
	t.name AS team_name,
	COUNT(e.id) * CAST(charge_cost AS INT) AS day_charge
FROM employees AS e LEFT JOIN teams AS t
ON t.id = e.team_id
GROUP BY t.name, t.charge_cost
HAVING COUNT(e.id) * CAST(t.charge_cost AS INT) > 5000;







