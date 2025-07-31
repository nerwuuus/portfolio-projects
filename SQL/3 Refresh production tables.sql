-- Create table if it doesn't exist
CREATE TABLE IF NOT EXISTS ess AS (
    SELECT *
    FROM inm
    UNION ALL
    SELECT *
    FROM mnp
);

-- Refresh data for ess table (main table)
TRUNCATE TABLE ess;


-- Insert combined data from mnp and inm into ess
WITH combined_data AS (
    SELECT name, nessie, date, status, wbs, wbs_description, hours 
    FROM mnp
    UNION
    SELECT name, nessie, date, status, wbs, wbs_description, hours 
    FROM inm
)
INSERT INTO ess (name, nessie, date, status, wbs, wbs_description, hours)
SELECT *
FROM combined_data;

-- Create (partition) tables if they don't exist
CREATE TABLE IF NOT EXISTS ess_2022 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2022
LIMIT 0;

CREATE TABLE IF NOT EXISTS ess_2023 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2023
LIMIT 0;

CREATE TABLE IF NOT EXISTS ess_2024 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2024
LIMIT 0;

CREATE TABLE IF NOT EXISTS ess_2025 AS
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2025
LIMIT 0;

-- Refresh data for partition table
TRUNCATE TABLE ess_2022;
INSERT INTO ess_2022
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2022;

TRUNCATE TABLE ess_2023;
INSERT INTO ess_2023
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2023;

TRUNCATE TABLE ess_2024;
INSERT INTO ess_2024
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2024;

TRUNCATE TABLE ess_2025;
INSERT INTO ess_2025
SELECT *
FROM ess
WHERE EXTRACT(YEAR FROM date) = 2025;
