/* Update the mnp and inm production tables with data from the previous month, 
using the corresponding records from the mnp_staging and inm_staging tables. */
-- inm
INSERT INTO inm
SELECT *
FROM inm_staging
WHERE EXTRACT(MONTH FROM date_column) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
  AND EXTRACT(YEAR FROM date_column) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 month');

-- mnp
INSERT INTO mnp
SELECT *
FROM mnp_staging
WHERE EXTRACT(MONTH FROM date_column) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 month')
  AND EXTRACT(YEAR FROM date_column) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 month');
