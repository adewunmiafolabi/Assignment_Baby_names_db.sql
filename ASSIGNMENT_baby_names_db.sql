SELECT * FROM names;

SELECT * FROM regions;

--Which baby names have been used the most in all the years
--Most popular baby names (limit by 10)

SELECT name,
       SUM(births) AS total_births
FROM names
GROUP BY name
ORDER BY total_births DESC
LIMIT 10;


--The most popular names each year 

SELECT year, name, total_births
FROM (
    SELECT year,
           name,
           SUM(births) AS total_births,
           RANK() OVER (PARTITION BY year ORDER BY SUM(births) DESC) AS rank
    FROM names
    GROUP BY year, name
) AS ranked_names
WHERE rank = 1
ORDER BY year;


--Most popular baby names by gender (top male and female names) limit 10
SELECT gender,
       name,
       SUM(births) AS total_births
FROM names
GROUP BY gender, name
ORDER BY gender, total_births DESC
LIMIT 10;

--Top female baby names
SELECT name,
       SUM(births) AS total_births
FROM names
WHERE gender = 'F'
GROUP BY name
ORDER BY total_births DESC
LIMIT 10;

--Top male baby names
SELECT name,
       SUM(births) AS total_births
FROM names
WHERE gender = 'M'
GROUP BY name
ORDER BY total_births DESC
LIMIT 10;

-- Regional trends
-- Which state/regions had the highest number of births


SELECT region, name, total_births
FROM (
    SELECT r.region,
           n.name,
           SUM(n.births) AS total_births,
           RANK() OVER (PARTITION BY r.region ORDER BY SUM(n.births) DESC) AS rnk
    FROM names n
    JOIN regions r ON n.state = r.state
    GROUP BY r.region, n.name
) AS ranked_regions
WHERE rnk = 1
ORDER BY region;


--Trends over time
--How has the popularity of a specific name (e.g., “Michael” or “Jesica”) changed over the years?

SELECT name,year,
       SUM(births) AS total_births
FROM names
WHERE name = 'Micheal'
GROUP BY name,year
ORDER BY name,year;


SELECT name,year,
       SUM(births) AS total_births
FROM names
WHERE name = 'Jessica'
GROUP BY name, year
ORDER BY name, year;

--How many unique names each year

SELECT year,
       COUNT(DISTINCT name) AS unique_names
FROM names
GROUP BY year
ORDER BY year;


--Emerging names (fast-growing names and region)


SELECT region, n.year, n.name, SUM(n.births) AS total_births
FROM names n
JOIN regions r ON n.state = r.state
GROUP BY region, name, n.year, n.name
ORDER BY total_births DESC
LIMIT 10;

--Trends By Gender
--Filter some top specific names of both genders for clearer trends
--( eg. Micheal,Jessica, christopher,Ashley, Mathew, Jenifer) 

SELECT year,
       SUM(CASE WHEN name = 'Micheal' THEN births ELSE 0 END) AS Micheal,
       SUM(CASE WHEN name = 'Jessica' THEN births ELSE 0 END) AS Jessica,
       SUM(CASE WHEN name = 'Christopher' THEN births ELSE 0 END) AS Christopher,
       SUM(CASE WHEN name = 'Ashley' THEN births ELSE 0 END) AS Ashley,
	   SUM(CASE WHEN name = 'Mathew' THEN births ELSE 0 END) AS Mathew,
       SUM(CASE WHEN name = 'Jenifer' THEN births ELSE 0 END) AS Jenifer
FROM names
GROUP BY year
ORDER BY year;
