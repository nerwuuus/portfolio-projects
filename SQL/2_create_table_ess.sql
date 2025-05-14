-- Create table and set data types (VARCHAR used due to the .csv formatting issues (',' instead of '.' in some of the columns))
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

-- Verify if table works
SELECT *
FROM ess
WHERE daily_rate IS NOT NULL
ORDER BY daily_rate DESC
LIMIT 100;
