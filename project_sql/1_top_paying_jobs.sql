--QUESTION: What are the top paying jobs for my target roles of 'Business Analyst' and 'Data Analyst'? 

SELECT 
    job_title,
    job_title_short,
    salary_year_avg,
    job_id,
    company_dim.company_id,
    name
FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short IN ('Business Analyst', 'Data Analyst')
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;