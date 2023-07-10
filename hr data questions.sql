-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT -- get min and max age
	min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate IS NULL;

SELECT -- create age groups
   CASE
     WHEN age >= 18 AND age <= 24 THEN "18 to 24"
     WHEN age >= 25 AND age <= 34 THEN "25 to 34"
     WHEN age >= 35 AND age <= 44 THEN "35 to 44"
     WHEN age >= 45 AND age <= 54 THEN "45 to 54"
     WHEN age >= 55 AND age <= 64 THEN "55 to 64"
     ELSE "65+"
   END AS age_group, 
   count(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;

SELECT -- create age groups
   CASE
     WHEN age >= 18 AND age <= 24 THEN "18 to 24"
     WHEN age >= 25 AND age <= 34 THEN "25 to 34"
     WHEN age >= 35 AND age <= 44 THEN "35 to 44"
     WHEN age >= 45 AND age <= 54 THEN "45 to 54"
     WHEN age >= 55 AND age <= 64 THEN "55 to 64"
     ELSE "65+"
   END AS age_group, gender,
   count(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT
	round(avg(datediff(termdate, hire_date)) / 365,0) AS emp_length_avg -- days to years
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
-- dept+gender
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY department, gender
ORDER BY department;

-- job title+gender
SELECT jobtitle, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle, gender
ORDER BY jobtitle;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which departmeent has the highest turnover rate?
SELECT department, -- defining the columns in the output table
	total_count, -- in the department
    terminated_count, -- have left
    round((terminated_count / total_count * 100),0) AS termination_rate_pct
FROM ( -- the sub-query
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    -- is terminated and the termdate is either today or before today
    -- then count, otherwise, don't count
    FROM hr
    WHERE age >= 18
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate_pct DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT
  year,
  hires,
  terminations,
  hires - terminations AS net_change,
  round((hires - terminations) / hires * 100, 2) AS net_change_pct
FROM(
	SELECT 
	  YEAR(hire_date) AS year, -- extract the year from the hire date
      count(*) AS hires,
      SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
      FROM hr
      WHERE age >= 18
      GROUP BY YEAR(hire_date)
      ) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure disrbution for each department? (time employees spend in a department)
SELECT department, round(avg(datediff(termdate, hire_date) / 365), 0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18
GROUP BY department;

SELECT termdate FROM hr;