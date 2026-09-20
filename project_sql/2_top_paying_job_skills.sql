WITH top_paying_jobs AS(
SELECT 
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
  salary_year_avg is not null
--HAVING 
  --job_title_short like '%Data%'
ORDER BY 3 DESC
);
