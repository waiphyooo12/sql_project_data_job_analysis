-- 1. Quick preview of the raw job postings table
SELECT * 
FROM job_postings_fact;


-- 2. Top-paying jobs across Thailand and Singapore
SELECT 
    job_title_short, 
    job_country, 
    salary_year_avg, 
    name AS company_name
FROM job_postings_fact AS fact
LEFT JOIN company_dim AS com_d
    ON fact.company_id = com_d.company_id
WHERE job_country IN ('Thailand', 'Singapore') 
  AND salary_year_avg IS NOT NULL
-- AND job_title_short LIKE '%Data%'
ORDER BY salary_year_avg DESC
LIMIT 10;