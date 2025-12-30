
--Question : What are the most in demand skills for Data Analysts and Business Analysts?


SELECT
    count (skills_job_dim.job_id) AS in_demand_skills,
    skills
FROM job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short IN ('Data Analyst' , 'Business Analyst')
    GROUP BY skills
    ORDER BY in_demand_skills DESC
    LIMIT 10