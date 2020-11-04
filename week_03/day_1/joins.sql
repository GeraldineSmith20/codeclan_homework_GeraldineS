
--Get a list of all the animals that have diet plans together with the diet plans that they are on:

SELECT 
	a.name,
	a.species,
	d.diet_type
FROM animals AS a INNER JOIN diets AS d
ON a.diet_id = d.id


-- Find any known dietary requirements for animals over four years old.

SELECT 
	a.name,
	a.species,
	a.age,
	d.diet_type
FROM animals AS a INNER JOIN diets AS d
ON a.diet_id = d.id 
WHERE a.age > 4;



-- Breakdown the number of animals in the zoo by their diet types.

SELECT 
	d.diet_type,
	COUNT(a.id)
FROM animals AS a INNER JOIN diets AS d 
ON a.diet_id = d.id 
GROUP BY d.diet_type;




-- Task Get the details of all herbivores in the zoo

SELECT 
	d.diet_type,
	a.*
FROM animals AS a INNER JOIN diets AS d 
ON a.diet_id = d.id 
WHERE diet_type ILIKE 'herbivore';

-- Left Join - all animals and their diets uf they have a stored diet

SELECT 
	a.name,
	a.species,
	d.diet_type
FROM animals AS a LEFT JOIN diets AS d
ON a.diet_id = d.id;


-- Get all diets plus details of any animals that follow them


SELECT 
	a.name,
	a.species,
	d.diet_type
FROM animals AS a RIGHT JOIN diets AS d
ON a.diet_id = d.id;


-- Return how many animals followeach diet type, including any diets which no animals follow

SELECT 
	d.diet_type,
	COUNT(a.id)
FROM diets AS d LEFT JOIN animals AS a 
ON d.id = a.diet_id
GROUP BY d.diet_type
ORDER BY d.diet_type ASC;
	
--Full join

SELECT 
	a.*,
	d.*
FROM animals AS a FULL OUTER JOIN diets AS d 
ON a.diet_id = d.id;


--Joins in many-to-many relationships
--Each animal is cared for by many keepers, and each keeper cares for many animals

--Get a rota for the keepers and the animals they look after, ordered first by animal name, and then by day.

SELECT 
	a.name AS animal_name,
	a.species,
	cs.day,
	k.name AS keeper_name
FROM 
	(animals AS a INNER JOIN care_schedule AS cs 
	ON a.id = cs.animal_id) INNER JOIN keepers AS k 
	ON cs.keeper_id = k.id
ORDER BY a.name, cs.day;
	
-- Schedule for Ernest the Snake only
SELECT 
	a.name AS animal_name,
	a.species,
	cs.day,
	k.name AS keeper_name
FROM 
	(animals AS a INNER JOIN care_schedule AS cs 
	ON a.id = cs.animal_id) INNER JOIN keepers AS k 
	ON cs.keeper_id = k.id
WHERE a.name = 'Ernest'


--Self Join

SELECT *
FROM keepers;


--Get a table showing the name of each keeper, 
--together with their manager’s name (if they have a manager)

SELECT
	k.name AS employee_name,
	m.name AS manager_name
FROM keepers AS k LEFT JOIN keepers AS m
ON k.manager_id = m.id;





























