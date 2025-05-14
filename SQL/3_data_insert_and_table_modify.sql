-- Insert data into table 'ess'
COPY ess 
FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\ess_report.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

/* Error 'Permission denied' while uploading data. Paste the below code in pgAdmin4, PSQL Tool to load data manually:
\copy ess FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\ess.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
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
