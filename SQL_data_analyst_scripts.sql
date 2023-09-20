-- 1. How many rows are in the data_analyst_jobs table? A: 1793
SELECT COUNT(*) AS total_rows
FROM data_analyst_jobs;

-- 2. Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?
--A: XTO Land Data Analyst
SELECT *
FROM data_analyst_jobs
LIMIT 10;

-- 3. How many postings are in Tennessee? How many are there in either Tennessee or Kentucky? A: 21 in TN, 27 in KY and TN
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location IN('KY', 'TN') ;

SELECT COUNT(CASE WHEN location LIKE 'TN' THEN 1 END) AS Tennessee,
	   COUNT(CASE WHEN location LIKE 'KY' THEN 1 END) AS Kentucky
FROM data_analyst_jobs;

-- 4. How many postings in Tennessee have a star rating above 4? A: 3
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE star_rating > 4
AND location ILIKE 'TN';

-- 5. How many postings in the dataset have a review count between 500 and 1000? A: 151
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;

-- 6. Show the average star rating for companies in each state.
--The output should show the state as state and the average rating for the state as avg_rating. Which state shows the highest average rating? A: NE

SELECT location AS state, AVG(star_rating) AS avg_rating
FROM data_analyst_jobs
WHERE location IS NOT NULL
	AND star_rating IS NOT NULL
GROUP BY location
ORDER BY avg_rating DESC;

SELECT location AS state, AVG(star_rating) AS avg_rating
FROM data_analyst_jobs
WHERE location IS NOT NULL
	AND star_rating IS NOT NULL
GROUP BY location
ORDER BY avg_rating DESC;



--Using the CASE statement instead of WHERE we see that the nulls show up. Why? Is this averaging only when the star rating isn't null and the location isn't null but showing those anyhow since we aren't refining what we display AFTER we grab it? Does CASE WHEN in aggregation in this scenario only pull the star rating and location IS NOT NULL before performing the average?

SELECT location AS state, 
	AVG(CASE WHEN star_rating IS NOT NULL AND location IS NOT NULL THEN star_rating END) AS avg_rating
FROM data_analyst_jobs
GROUP BY location
ORDER BY avg_rating DESC;

-- 7. Select unique job titles from the data_analyst_jobs table. How many are there? A: 881

SELECT COUNT(DISTINCT title) AS number_of_unique_titles
FROM data_analyst_jobs;

-- 8. How many unique job titles are there for California companies? A:230
SELECT COUNT(DISTINCT title)
FROM data_analyst_jobs
WHERE location LIKE 'CA';

--same output just using CASE statement
SELECT 
	COUNT(DISTINCT CASE WHEN location LIKE 'CA' THEN title END) AS unique_california_jobs
FROM data_analyst_jobs;


-- 9. Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. 
--How many companies are there with more that 5000 reviews across all locations? A:40?

SELECT DISTINCT company, AVG(star_rating) AS avg_star_rating
FROM data_analyst_jobs
WHERE review_count > 5000
	AND company IS NOT NULL
GROUP BY company;

SELECT COUNT(DISTINCT company)
FROM data_analyst_jobs
WHERE review_count > 5000;
 
 --trying with CASE
SELECT DISTINCT company, 
   AVG(CASE WHEN star_rating IS NOT NULL THEN star_rating END) AS avg_star_rating
FROM data_analyst_jobs
WHERE company IS NOT NULL
	AND star_rating IS NOT NULL
	AND review_count > 5000
GROUP BY company;


-- 10. Add the code to order the query in #9 from highest to lowest average star rating. 
--Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating? A: American Express with a rating of 4.12
SELECT DISTINCT company, AVG(star_rating) AS avg_star_rating
FROM data_analyst_jobs
	WHERE review_count > 5000
	AND company IS NOT NULL
GROUP BY company
ORDER BY avg_star_rating DESC;


-- 11. Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? A: 774 distinct titles containing analyst. 

SELECT COUNT(DISTINCT title)
FROM data_analyst_jobs
WHERE title ILIKE '%analyst%';
	
--same output but with case
SELECT 
	COUNT(DISTINCT CASE WHEN title ILIKE '%analyst%' THEN title END) AS unique_analyst_titles
FROM data_analyst_jobs;


-- 12. How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common? 4. The word they share is 'Tableau'

SELECT DISTINCT title
FROM data_analyst_jobs
WHERE title NOT ILIKE '%Analyst%'
	AND title NOT ILIKE '%Analytics%';
	
--same output but with case
SELECT 
	COUNT(DISTINCT CASE WHEN title NOT ILIKE '%analyst%' AND title NOT ILIKE '%analytics%' THEN title END) AS unique_analyst_and_analytics_titles
FROM data_analyst_jobs;

-- BONUS: You want to understand which jobs requiring SQL are hard to fill. 
--Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.

SELECT domain,
	COUNT(CASE WHEN days_since_posting > 21 AND skill ILIKE '%SQL%'  THEN 1 END) AS sql_jobs_older_than_three_weeks
FROM data_analyst_jobs
GROUP BY domain;

-- Disregard any postings where the domain is NULL.

SELECT domain, 
	COUNT(CASE WHEN days_since_posting > 21 AND skill ILIKE '%SQL%' THEN 1 END) AS sql_jobs_older_than_three_weeks
FROM data_analyst_jobs
WHERE domain IS NOT NULL
GROUP BY domain;

-- Order your results so that the domain with the greatest number of hard to fill jobs is at the top.

SELECT domain, 
	COUNT(CASE WHEN days_since_posting > 21 AND skill ILIKE '%SQL%' THEN 1 END) AS sql_jobs_older_than_three_weeks
FROM data_analyst_jobs
WHERE domain IS NOT NULL
GROUP BY domain
ORDER BY jobs_older_than_three_weeks DESC;

-- Which three industries are in the top 4 on this list? A: Consulting and Business Services, Health Care, Internet and Software, Banks and Financial Services

SELECT domain, 
	COUNT(CASE WHEN days_since_posting > 21 AND skill ILIKE '%SQL%' THEN 1 END) AS sql_jobs_older_than_three_weeks
FROM data_analyst_jobs
WHERE domain IS NOT NULL
GROUP BY domain
ORDER BY sql_jobs_older_than_three_weeks DESC
LIMIT 4;

--How many jobs have been listed for more than 3 weeks for each of the top 4?

--62, 61, 57, 52
