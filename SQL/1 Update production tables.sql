/* Update the mnp and inm production tables with data from the previous month, 
using the corresponding records from the mnp_staging and inm_staging tables.
Use a dynamic or static script depending on the timing of the database update. */
-- inm (dynamic script)
INSERT INTO inm
SELECT *
FROM inm_staging
WHERE EXTRACT(MONTH FROM date) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
    AND EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 month');

-- mnp (dynamic script)
INSERT INTO inm
INSERT INTO mnp
SELECT *
FROM mnp_staging
WHERE EXTRACT(MONTH FROM date) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
    AND EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 month');

-- inm
INSERT INTO inm
SELECT *
FROM inm_staging
WHERE EXTRACT(MONTH FROM date) = 7
    AND EXTRACT(YEAR FROM date) = 2025;

-- mnp
INSERT INTO mnp
SELECT *
FROM mnp_staging
WHERE EXTRACT(MONTH FROM date) = 7
    AND EXTRACT(YEAR FROM date) = 2025;
