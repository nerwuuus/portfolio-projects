/*

Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill

*/


SELECT *
FROM 
    job_postings_fact
WHERE
    job_location = 'Anywhere'
LIMIT 1000;

-- skill_id, skills (string)
SELECT *
FROM skills_dim AS skills
LEFT JOIN skills_job_dim AS job_skills 
    ON job_skills.skill_id = skills.skill_id;

-- job_id & skill_id
SELECT *
FROM skills_job_dim

;
