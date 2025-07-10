-- CTE: temp. table with inm and mnp wbs, YYYY-MM split and sum of hours
WITH combined_data AS (
    SELECT *
    FROM inm
    UNION ALL
    SELECT *
    FROM mnp
)
SELECT
    wbs,
    CONCAT(EXTRACT(YEAR FROM date),'-', EXTRACT (MONTH FROM date)) AS year_month,
    SUM(hours)
FROM
    combined_data
GROUP BY
    wbs,
    year_month
ORDER BY
    year_month DESC;
