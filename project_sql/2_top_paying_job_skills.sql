WITH top_paying_jobs AS(
SELECT 
  job_id,
  job_title_short, 
  job_country ,
  salary_year_avg , 
  name as company_name
FROM
  job_postings_fact AS fact
LEFT JOIN company_dim AS com_d
ON fact.company_id = com_d.company_id
WHERE
  job_country IN ('Thailand', 'Singapore') AND
  salary_year_avg is not null And
  job_title_short like '%Data%' And 
  job_title_short not like '%Senior%'
--HAVING 
  --job_title_short like '%Data%'
ORDER BY 4 DESC
)

select 
job_title_short, 
  skills,
  job_country ,
  salary_year_avg , 
  company_name
from 
  top_paying_jobs AS a
INNER JOIN skills_job_dim as b
on a.job_id = b.job_id
INNEr Join skills_dim as c
on b.skill_id = c.skill_id
ORDER BY 4 DESC
LIMIT 20 
;

--Checking CTE
SELECT 
  job_id,
  job_title_short, 
  job_country ,
  salary_year_avg , 
  name as company_name
FROM
  job_postings_fact AS fact
LEFT JOIN company_dim AS com_d
ON fact.company_id = com_d.company_id
WHERE
  job_country IN ('Thailand', 'Singapore') AND
  salary_year_avg is not null And
  job_title_short like '%Data%' And 
  job_title_short not like '%Senior%'
--HAVING 
  --job_title_short like '%Data%'
ORDER BY 4 DESC;