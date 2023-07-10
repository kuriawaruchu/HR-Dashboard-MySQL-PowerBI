USE projects; # to use the database

SELECT * FROM hr;

# data cleaning
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL; # from ï»¿id to emp_id

SELECT * FROM hr;

DESCRIBE hr; # to see data types

SELECT birthdate FROM hr; # select birthdate column

SET sql_safe_updates = 0; # should be changed back to 1  for security purposes

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE "%/%" THEN date_format(str_to_date(birthdate, "%m/%d/%Y"), "%Y-%m-%d") # with slash
    WHEN birthdate LIKE "%-%" THEN date_format(str_to_date(birthdate, "%m-%d-%Y"), "%Y-%m-%d") # with hyphen
    ELSE NULL 
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE "%/%" THEN date_format(str_to_date(hire_date, "%m/%d/%Y"), "%Y-%m-%d") # with slash
    WHEN hire_date LIKE "%-%" THEN date_format(str_to_date(hire_date, "%m-%d-%Y"), "%Y-%m-%d") # with hyphen
    ELSE NULL 
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, "%Y-%m-%d %H:%i:%s UTC"))
WHERE termdate IS NOT NULL AND termdate != '';

UPDATE hr
SET termdate = NULL
WHERE termdate = '';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr
ADD COLUMN age int;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE()); # calculating age

SELECT # oldest and youngest employee's age
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age < 18; # underage and negatives(outliers)

SELECT birthdate, age FROM hr;
DESCRIBE hr; # to see data types