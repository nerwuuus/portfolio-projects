CREATE DATABASE ess;

-- Import columns with numbers as VARCHAR due to the .csv formatting issues (',' instead of '.')
CREATE TABLE ess (
    name VARCHAR(255),	
    nessie_ID VARCHAR(255),	
    day DATE,		
    wbs	VARCHAR(255),
    description	VARCHAR(255),
    hours VARCHAR(255),	
    manday VARCHAR(255),		
    daily_rate VARCHAR(255)	
);

DROP TABLE ess;

SELECT *
FROM ess
WHERE daily_rate IS NOT NULL
ORDER BY daily_rate DESC
LIMIT 100;

COPY ess 
FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\ess_report.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

/* Error 'Permission denied' while uploading data. Paste the below code in pgAdmin4, PSQL Tool to load data manually:
\copy ess FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\ess.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
*/

-- Replace ',' with '.'
UPDATE ess
SET hours = REPLACE(hours, ',', '.')::NUMERIC(5,2);

UPDATE ess
SET manday = REPLACE(manday, ',', '.')::NUMERIC(5,2);

UPDATE ess
SET daily_rate = REPLACE(daily_rate, ',', '.')::NUMERIC(6,2);

-- Convert (cast) the data type from VARCHAR(255) to INT and NUMERIC
ALTER TABLE ess
ALTER COLUMN nessie_ID TYPE INT 
USING nessie_ID::INT;

ALTER TABLE ess
ALTER COLUMN hours TYPE NUMERIC(5,2) 
USING hours::NUMERIC(5,2);

ALTER TABLE ess
ALTER COLUMN manday TYPE NUMERIC(5,2) 
USING manday::NUMERIC(5,2);

ALTER TABLE ess
ALTER COLUMN daily_rate TYPE NUMERIC(6,2) 
USING daily_rate::NUMERIC(6,2);

SELECT *
FROM ess
LIMIT 10;

-- Calculate hourly rate
SELECT
    name,
    day,
    wbs,
    hours,
    daily_rate,
    ROUND(daily_rate / hours, 2) AS hourly_rate
FROM
    ess
WHERE
    (daily_rate / hours) > 0
ORDER BY 
    hourly_rate DESC
;

-- Calculate the total hours for each WBS code, grouped by month and year
SELECT
    wbs,
    CONCAT(EXTRACT(YEAR FROM day),'-', EXTRACT (MONTH FROM day)) AS year_month,
    SUM(hours)
FROM
    ess
GROUP BY
    wbs,
    year_month
ORDER BY
    year_month DESC
;

-- Group years in separate tables
-- 2022
CREATE TABLE ess_2022 AS
    SELECT *
    FROM ess
    WHERE EXTRACT(YEAR FROM day) = 2022;

-- 2023
CREATE TABLE ess_2023 AS
    SELECT *
    FROM ess
    WHERE EXTRACT(YEAR FROM day) = 2023;

-- 2024
CREATE TABLE ess_2024 AS
    SELECT *
    FROM ess
    WHERE EXTRACT(YEAR FROM day) = 2024;

-- 2025
CREATE TABLE ess_2025 AS
    SELECT *
    FROM ess
    WHERE EXTRACT(YEAR FROM day) = 2025;

SELECT *
FROM ess_2024
WHERE daily_rate IS NOT NULL
;

-- Group costs and hours per month and year and insert into separate tables
-- 2025
CREATE TABLE costs_2025 AS
    SELECT
        CONCAT(EXTRACT(MONTH FROM ess_2025.day),'-', EXTRACT (YEAR FROM ess_2025.day)) AS month_year,
        SUM(ess_2025.hours) AS total_hours,
        SUM(ess_2025.daily_rate) AS total_cost
    FROM
        ess_2025
    GROUP BY
        EXTRACT(MONTH FROM ess_2025.day),
        EXTRACT(YEAR FROM ess_2025.day)
    HAVING
        SUM(ess_2025.daily_rate) > 0
    ORDER BY
        EXTRACT(YEAR FROM ess_2025.day) DESC,
        EXTRACT(MONTH FROM ess_2025.day) DESC
;

-- 2024
CREATE TABLE costs_2024 AS
    SELECT
        CONCAT(EXTRACT(MONTH FROM ess_2024.day),'-', EXTRACT (YEAR FROM ess_2024.day)) AS month_year,
        SUM(ess_2024.hours) AS total_hours,
        SUM(ess_2024.daily_rate) AS total_cost
    FROM
        ess_2024
    GROUP BY
        EXTRACT(MONTH FROM ess_2024.day),
        EXTRACT(YEAR FROM ess_2024.day)
    HAVING
        SUM(ess_2024.daily_rate) > 0
    ORDER BY
        EXTRACT(YEAR FROM ess_2024.day) DESC,
        EXTRACT(MONTH FROM ess_2024.day) DESC
;

-- 2023
CREATE TABLE costs_2023 AS
    SELECT
        CONCAT(EXTRACT(MONTH FROM ess_2023.day),'-', EXTRACT (YEAR FROM ess_2023.day)) AS month_year,
        SUM(ess_2023.hours) AS total_hours,
        SUM(ess_2023.daily_rate) AS total_cost
    FROM
        ess_2023
    GROUP BY
        EXTRACT(MONTH FROM ess_2023.day),
        EXTRACT(YEAR FROM ess_2023.day)
    HAVING
        SUM(ess_2023.daily_rate) > 0
    ORDER BY
        EXTRACT(YEAR FROM ess_2023.day) DESC,
        EXTRACT(MONTH FROM ess_2023.day) DESC
;

-- 2022
CREATE TABLE costs_2022 AS
    SELECT
        CONCAT(EXTRACT(MONTH FROM ess_2022.day),'-', EXTRACT (YEAR FROM ess_2022.day)) AS month_year,
        SUM(ess_2022.hours) AS total_hours,
        SUM(ess_2022.daily_rate) AS total_cost
    FROM
        ess_2022
    GROUP BY
        EXTRACT(MONTH FROM ess_2022.day),
        EXTRACT(YEAR FROM ess_2022.day)
    HAVING
        SUM(ess_2022.daily_rate) > 0
    ORDER BY
        EXTRACT(YEAR FROM ess_2022.day) DESC,
        EXTRACT(MONTH FROM ess_2022.day) DESC
;

/* Update costs_(...) tables with changed order of month_year to year_month. It needs to be changed to adjust dates 
to SQL default date formatting. 
*/
-- Change column name to reflect the current data formatting.
ALTER TABLE costs_2022
RENAME COLUMN month_year TO year_month;

ALTER TABLE costs_2023
RENAME COLUMN month_year TO year_month;

ALTER TABLE costs_2024
RENAME COLUMN month_year TO year_month;

ALTER TABLE costs_2025
RENAME COLUMN month_year TO year_month;

-- Change the date formattting from MM-YYYY to YYYY-MM
UPDATE costs_2022
SET year_month = TO_CHAR(TO_DATE(year_month, 'MM-YYYY'), 'YYYY-MM');

UPDATE costs_2023
SET year_month = TO_CHAR(TO_DATE(year_month, 'MM-YYYY'), 'YYYY-MM');

UPDATE costs_2024
SET year_month = TO_CHAR(TO_DATE(year_month, 'MM-YYYY'), 'YYYY-MM');

UPDATE costs_2025
SET year_month = TO_CHAR(TO_DATE(year_month, 'MM-YYYY'), 'YYYY-MM');

SELECT *
FROM costs_2023



-- WBS monthly and yearly split
SELECT * FROM costs_2022
UNION ALL
SELECT * FROM costs_2023
UNION ALL
SELECT * FROM costs_2024
UNION ALL
SELECT * FROM costs_2025
ORDER BY
    year_month ASC;


-- Total cost split per year
SELECT
    EXTRACT(YEAR FROM TO_DATE(year_month, 'YY-MMMM')) AS year,
    SUM(total_cost) AS cost
FROM (
    SELECT * FROM costs_2022
    UNION ALL
    SELECT * FROM costs_2023
    UNION ALL
    SELECT * FROM costs_2024
    UNION ALL
    SELECT * FROM costs_2025
) AS subquery
GROUP BY year
ORDER BY year;




















