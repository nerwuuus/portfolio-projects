SELECT
    subquery.company_id,
    subquery.name,
    subquery.number_of_jobs,
    CASE
        WHEN subquery.number_of_jobs < 10 THEN 'Small'
        WHEN subquery.number_of_jobs BETWEEN 10 AND 50 THEN 'Medium'
        WHEN subquery.number_of_jobs > 50 THEN 'Large'
    END AS size_category
FROM (
    SELECT
        job.company_id,
        company.name,
        COUNT(*) AS number_of_jobs
    FROM
        job_postings_fact AS job
    LEFT JOIN company_dim AS company
        ON job.company_id = company.company_id
    GROUP BY
        job.company_id,
        company.name
) AS subquery
ORDER BY
    number_of_jobs DESC
LIMIT 100;

SELECT *
FROM company_dim;