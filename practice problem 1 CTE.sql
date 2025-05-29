WITH number_of_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skills_per_job_id
    FROM 
        skills_job_dim
    GROUP BY
        skill_id
    ORDER BY
        skills_per_job_id DESC
)

SELECT 
    ns.skill_id,
    ns.skills_per_job_id, 
    sd.skills
FROM number_of_skills AS ns
LEFT JOIN skills_dim AS sd ON ns.skill_id = sd.skill_id
LIMIT 5;

