-- Insert data into table 'inm'
COPY inm 
FROM 'C:\Users\(...)\OneDrive(...)\(...)\inm.csv'
WITH (
    FORMAT csv, 
    HEADER true, 
    DELIMITER ';', 
    ENCODING 'UTF8'
);

-- Insert data into table 'mnp'
COPY mnp 
FROM 'C:\Users\(...)\OneDrive(...)\(...)\mnp.csv'
WITH (
    FORMAT csv, 
    HEADER true, 
    DELIMITER ';', 
    ENCODING 'UTF8'
);

/* 

Error 'Permission denied' while uploading data. Paste the below code in pgAdmin4, PSQL Tool to load data manually:
\copy inm FROM 'C:\Users\(...)\OneDrive(...)\(...)\inm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

Error 'Permission denied' while uploading data. Paste the below code in pgAdmin4, PSQL Tool to load data manually:
\copy mnp FROM 'C:\Users\(...)\OneDrive(...)\(...)\mnp.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');

*/
