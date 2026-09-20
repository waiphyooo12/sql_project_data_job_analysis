-- ==========================================
-- 1. Main Analysis: Top Paying Skills for Non-Senior Data Roles
--    (Thailand & Singapore)
-- ==========================================
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title_short, 
        job_country,
        salary_year_avg, 
        name AS company_name
    FROM job_postings_fact AS fact
    LEFT JOIN company_dim AS com_d
        ON fact.company_id = com_d.company_id
    WHERE job_country IN ('Thailand', 'Singapore') 
      AND salary_year_avg IS NOT NULL 
      AND job_title_short LIKE 'Data Analyst' 
      AND job_title_short NOT LIKE '%Senior%'
    ORDER BY salary_year_avg DESC
)

SELECT 
    a.job_title_short, 
    c.skills,
    a.job_country, 
    a.salary_year_avg, 
    a.company_name
FROM top_paying_jobs AS a
INNER JOIN skills_job_dim AS b
    ON a.job_id = b.job_id
INNER JOIN skills_dim AS c
    ON b.skill_id = c.skill_id
ORDER BY a.salary_year_avg DESC
LIMIT 20;


/*
📊 Regional Data Market Analysis: Thailand & Singapore (Non-Senior)
* Core Stack: Python and SQL anchor the highest-paying non-senior roles across regional hubs.
* BI & Cloud Premium: Tools like Tableau and Snowflake highlight a demand for modern stack navigation and data visualization.
* Key Takeaway: High compensation requires multi-tool proficiency (coding + querying + BI) rather than a single software skill.
*/


-- ==========================================
-- 2. CTE Verification Query: Check Top Paying Jobs
-- ==========================================
SELECT 
    job_id,
    job_title_short, 
    job_country,
    salary_year_avg, 
    name AS company_name
FROM job_postings_fact AS fact
LEFT JOIN company_dim AS com_d
    ON fact.company_id = com_d.company_id
WHERE job_country IN ('Thailand', 'Singapore') 
  AND salary_year_avg IS NOT NULL 
  AND job_title_short LIKE '%Data%' 
  AND job_title_short NOT LIKE '%Senior%'
ORDER BY salary_year_avg DESC;