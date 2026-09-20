--high demand n salary
select skills ,avg(salary_year_avg) AS average_salary ,count(a.job_id) as demand_count 
from job_postings_fact a
inner join skills_job_dim as b
on a.job_id = b.job_id
inner join skills_dim c
on b.skill_id = c.skill_id 
where salary_year_avg is not null and job_work_from_home = true and job_title_short = 'Data Analyst'
group by c.skill_id
having count(a.job_id) > 10
order by 2 DESC, 3 DESC
limit 10;