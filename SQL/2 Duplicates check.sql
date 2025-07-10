-- Check if duplicates were inserted mnp
SELECT 
    *, 
    COUNT(*) 
FROM mnp
GROUP BY 
    name,
    nessie,
    date,
    status,
    wbs,
    wbs_description,
    hours
HAVING COUNT(*) > 1;

-- Check if duplicates were inserted inm
SELECT 
    *, 
    COUNT(*) 
FROM inm
GROUP BY 
    name,
    nessie,
    date,
    status,
    wbs,
    wbs_description,
    hours
HAVING COUNT(*) > 1;
