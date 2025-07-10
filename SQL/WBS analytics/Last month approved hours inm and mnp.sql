-- Filter out approved MNP and iNM hours for the last month (dynamic script)
WITH last_month_approved_hours AS (
    SELECT *
    FROM ess
    WHERE
        TO_CHAR(date, 'MM-YYYY') = TO_CHAR(CURRENT_DATE - INTERVAL '1 month', 'MM-YYYY')
        AND status = 'Approved'
)
SELECT 
    name,
    date,
    status,
    wbs,
    hours,
    SUM(hours) OVER (PARTITION BY name) AS hours_wbs
FROM last_month_approved_hours;




