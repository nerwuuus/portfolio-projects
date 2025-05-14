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
to the default SQL date formatting. 
*/
-- Change column names in costs_(...) tables to reflect the default SQL date formatting
ALTER TABLE costs_2022
RENAME COLUMN month_year TO year_month;

ALTER TABLE costs_2023
RENAME COLUMN month_year TO year_month;

ALTER TABLE costs_2024
RENAME COLUMN month_year TO year_month;

ALTER TABLE costs_2025
RENAME COLUMN month_year TO year_month;

-- Change the date formatting from MM-YYYY to YYYY-MM
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