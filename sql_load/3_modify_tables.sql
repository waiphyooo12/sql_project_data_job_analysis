-- Active: 1777581393850@@localhost@5432@sql_course
/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim
FROM '/Users/waiphyooo/Desktop/all_folders/csv_files/company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM '/Users/waiphyooo/Desktop/all_folders/csv_files/skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM ' /Users/waiphyooo/Desktop/all_folders/csv_files/job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM '/Users/waiphyooo/Desktop/all_folders/csv_files/skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT extract (month from job_posted_date)as month
FROM job_postings_fact
limit 10
;

select *
from job_postings_fact
limit 10;

--Practice problem 1 
select job_posted_date:: date as posted_date ,job_schedule_type , avg(salary_year_avg) as avg_yearly_salary , avg(salary_hour_avg) as avg_hourly_salary
from job_postings_fact
group by job_schedule_type,posted_date
having job_posted_date:: date  >= '2023-06-01';

--Practice problem 2

select  extract( month from job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'AMERICA/NEW_YORK') as month,count(*)
from job_postings_fact
where extract(year from job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'AMERICA/NEW_YORK') = 2023
group by month
order by 1;

--Practice problem 3
select * 
from job_postings_fact
limit 10;

select * 
from company_dim;

select name ,extract(month from job_posted_date) post_months, count(*) as job_postings_count
from job_postings_fact
join company_dim
on job_postings_fact.company_id = company_dim.company_id
where job_health_insurance = 'Yes'
group by name , post_months 
having extract(month from job_posted_date ) in (3,4,5);

--Practice problem 4
Create table Mar_2023_job as
select * 
from job_postings_fact
where extract(month from job_posted_date)= 3 and extract(year from job_posted_date) = 2023;

select *
from Jan_2023_job;

--case when
--practice problem 1 
select job_title_short , salary_year_avg,
CASE 
        WHEN salary_year_avg > 100000 THEN 'High Salary'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'Standard Salary'
        ELSE 'Low Salary'
    END AS salary_bucket
from job_postings_fact
where job_title_short = 'Data Analyst';


select company_id, name 
from company_dim
where company_id in (
    select company_id 
    from job_postings_fact
);

select *
from company_dim;
select * 
from job_postings_fact
limit 10;

select company_id , count(*) job_posting_count
from job_postings_fact
group by company_id ;

select name ,job_posting_count
from company_dim
where company_id in(
    select company_id , count(*) job_posting_count
    from job_postings_fact
    group by company_id 
);

WITH most_job_postings AS(
    select company_id , count(*) job_posting_count
    from job_postings_fact
    group by company_id 
)
select name ,  job_posting_count
from most_job_postings
join company_dim
on most_job_postings.company_id = company_dim.company_id
order by job_posting_count DESC;

--Practice problem 1
--identify the top 5 skills that are most in demand based on the number of job postings that require them.
--data analysis, data visualization, machine learning, SQL, Python
select job_id, count(job_id) as skill_count
    from skills_job_dim
    group by skill_id
    order by 2 desc;
select *
from skills_dim;

select job_id, count(skill_id)
from skills_job_dim
where skill_id in(
    select skill_id
    from skills_dim
)
group by job_id;
--I want to compare side by side so I use CTE

WITH skill_count_cte as(
    select 
        skill_id, 
        count(job_id) as skill_count
    from skills_job_dim
    group by skill_id
)
select  b.skills , skill_count
from skill_count_cte as a
join skills_dim as b
on a.skill_id = b.skill_id
order by skill_count DESC;


--prcactice problem 2
/*Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have. Use a subquery to calculate the total job postings per company. A company is considered 
'Small' if it has less than 10 job postings, 
'Medium' if the number of job postings is between 10 and 50, and 
'Large' if it has more than 50 job postings.
Implement a subquery to aggregate job counts per company before classifying them based on size.*/

select 
    company_id ,
    count(*)
from job_postings_fact
group by company_id
order by 2 desc;

SELECT 
    f.company_id ,d.name,
   
case 
    WHEN count(*)<10 THEN 'Small'
    WHEN count(*) BETWEEN 10 AND 50 THEN 'Medium'
    ELSE 'Large'
    END as 
        size_bucket
from 
    job_postings_fact as f
join company_dim as d
on f.company_id = d.company_id
group by 
    f.company_id, d.name
order by 2 desc;

/*Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill*/


select a.skill_id , b.skills , count(a.job_id) job_count
from skills_job_dim as a
left join skills_dim as b
on a.skill_id = b.skill_id
where a.job_id in (
    select job_id
from job_postings_fact
where job_work_from_home = true
)
group by a.skill_id ,b.skills
order by 3 DESC
limit 5;

--union, union all problem
--skill and skill type ,without any skill too
select *
from job_postings_fact;

WITH q1 AS (
    SELECT job_id FROM jan_2023_job
    UNION ALL
    SELECT job_id FROM feb_2023_job
    UNION ALL
    SELECT job_id FROM mar_2023_job
)
SELECT DISTINCT
    skill_d.skills,
    skill_d.type
FROM skills_dim AS skill_d
LEFT JOIN skills_job_dim AS skill_jd 
    ON skill_d.skill_id = skill_jd.skill_id
LEFT JOIN q1 
    ON skill_jd.job_id = q1.job_id;

--advanced problem 8
WITH q1 AS (
    SELECT * FROM jan_2023_job
    UNION ALL
    SELECT * FROM feb_2023_job
    UNION ALL
    SELECT * FROM mar_2023_job
)
select *
from q1
where 
    extract(year from job_posted_date) = 2023 AND
    salary_year_avg >= 70000
;
