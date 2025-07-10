-- All wbs split per year and month
SELECT
    wbs,
    CONCAT(EXTRACT(YEAR FROM date),'-', EXTRACT (MONTH FROM date)) AS year_month,
    SUM(hours)
FROM
    ess -- this table contains inm and mnp tables
GROUP BY
    wbs,
    year_month
ORDER BY
    year_month DESC;


