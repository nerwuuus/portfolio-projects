/* 

- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise as 'Onsite'

*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;


/* 

- BETWEEN >= 15000 AND <123628 'Low'
- BETWEEN >=123629 AND 300000 'Standard'
- >=300001 'High'

*/

-- Check MAX and MIN value to determine buckets
SELECT
    MAX(salary_year_avg) AS max,
    MIN(salary_year_avg) AS min,
    AVG(salary_year_avg) AS average
FROM 
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT 1000;

SELECT *
FROM job_postings_fact
LIMIT 1000;

SELECT
    job_title,
    company_id,
    salary_year_avg,
    CASE
        WHEN salary_year_avg BETWEEN 15000 AND 60000 THEN 'Low'
        WHEN salary_year_avg BETWEEN 60001 AND 129000 THEN 'Standard'
        WHEN salary_year_avg >=129001  THEN 'High'
    END AS salary_category
FROM 
    job_postings_fact
WHERE
    (salary_year_avg IS NOT NULL) AND
    (job_title = 'Data Analyst')
ORDER BY
    salary_category DESC;



