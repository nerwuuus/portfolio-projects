-- Check which employees book on MNP and iNM simultaneously
SELECT DISTINCT
    m.name,
    m.date,
    m.status,
    m.wbs mnp_wbs,
    m.hours mnp_hours,
    i.wbs inm_wbs,
    i.hours inm_hours,
    CASE
        WHEN i.wbs IS NULL THEN '0'
        ELSE '1'
    END AS flag
FROM mnp m
LEFT JOIN inm i
    ON m.nessie = i.nessie
WHERE
    TO_CHAR(m.date, 'MM-YYYY') = '06-2025' 
    AND m.status = 'Approved'
    AND i.wbs IS NOT NULL;

-- Filter out specific employee
SELECT *
FROM (
    SELECT * FROM mnp
    UNION
    SELECT * FROM inm
) AS combined
WHERE name LIKE '%Alan%';



