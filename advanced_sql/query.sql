--Cleaned up 
-- ==========================================
-- BASIC SELECTS & DATE EXTRACTION
-- ==========================================

SELECT EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
LIMIT 10;

SELECT *
FROM job_postings_fact
LIMIT 10;


-- ==========================================
-- PRACTICE PROBLEM 1: Schedule & Salaries
-- ==========================================

SELECT 
    job_posted_date::DATE AS posted_date, 
    job_schedule_type, 
    AVG(salary_year_avg) AS avg_yearly_salary, 
    AVG(salary_hour_avg) AS avg_hourly_salary
FROM job_postings_fact
GROUP BY job_schedule_type, posted_date
HAVING job_posted_date::DATE >= '2023-06-01';


-- ==========================================
-- PRACTICE PROBLEM 2: Time Zones & Months
-- ==========================================

SELECT  
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'AMERICA/NEW_YORK') AS month,
    COUNT(*)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'AMERICA/NEW_YORK') = 2023
GROUP BY month
ORDER BY 1;


-- ==========================================
-- PRACTICE PROBLEM 3: Company Job Postings
-- ==========================================

SELECT 
    name, 
    EXTRACT(MONTH FROM job_posted_date) AS post_months, 
    COUNT(*) AS job_postings_count
FROM job_postings_fact
JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE job_health_insurance = 'Yes'
GROUP BY name, post_months 
HAVING EXTRACT(MONTH FROM job_posted_date) IN (3, 4, 5);


-- ==========================================
-- PRACTICE PROBLEM 4: Creating Tables & Cases
-- ==========================================

CREATE TABLE Mar_2023_job AS
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3 
  AND EXTRACT(YEAR FROM job_posted_date) = 2023;

SELECT *
FROM Jan_2023_job;

-- Case When Salary Buckets
SELECT 
    job_title_short, 
    salary_year_avg,
    CASE 
        WHEN salary_year_avg > 100000 THEN 'High Salary'
        WHEN salary_year_avg BETWEEN 60000 AND 100000 THEN 'Standard Salary'
        ELSE 'Low Salary'
    END AS salary_bucket
FROM job_postings_fact
where job_title_short = 'Data Analyst';


-- ==========================================
-- COMPANY POSTINGS & CTEs
-- ==========================================

SELECT 
    company_id, 
    name 
FROM company_dim
WHERE company_id IN (
    SELECT company_id 
    FROM job_postings_fact
);

SELECT 
    company_id, 
    COUNT(*) AS job_posting_count
FROM job_postings_fact
GROUP BY company_id;

-- Using a CTE for Company Postings
WITH most_job_postings AS (
    SELECT 
        company_id, 
        COUNT(*) AS job_posting_count
    FROM job_postings_fact
    GROUP BY company_id 
)
SELECT 
    name,  
    job_posting_count
FROM most_job_postings
JOIN company_dim
    ON most_job_postings.company_id = company_dim.company_id
ORDER BY job_posting_count DESC;


-- ==========================================
-- SKILLS ANALYSIS
-- ==========================================

-- Skill Count via CTE
WITH skill_count_cte AS (
    SELECT 
        skill_id, 
        COUNT(job_id) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
)
SELECT  
    b.skills, 
    skill_count
FROM skill_count_cte AS a
JOIN skills_dim AS b
    ON a.skill_id = b.skill_id
ORDER BY skill_count DESC;


-- ==========================================
-- COMPANY SIZE CATEGORIES
-- ==========================================

SELECT 
    f.company_id, 
    d.name,
    CASE 
        WHEN COUNT(*) < 10 THEN 'Small'
        WHEN COUNT(*) BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_bucket
FROM job_postings_fact AS f
JOIN company_dim AS d
    ON f.company_id = d.company_id
GROUP BY f.company_id, d.name
ORDER BY 2 DESC;


-- ==========================================
-- REMOTE JOB SKILLS DEMAND
-- ==========================================

SELECT 
    a.skill_id, 
    b.skills, 
    COUNT(a.job_id) AS job_count
FROM skills_job_dim AS a
LEFT JOIN skills_dim AS b
    ON a.skill_id = b.skill_id
WHERE a.job_id IN (
    SELECT job_id
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
GROUP BY a.skill_id, b.skills
ORDER BY 3 DESC
LIMIT 5;


-- ==========================================
-- UNION ALL & Q1 QUERIES
-- ==========================================

WITH q1 AS (
    SELECT job_id, job_posted_date, salary_year_avg FROM jan_2023_job
    UNION ALL
    SELECT job_id, job_posted_date, salary_year_avg FROM feb_2023_job
    UNION ALL
    SELECT job_id, job_posted_date, salary_year_avg FROM mar_2023_job
)
SELECT DISTINCT
    skill_d.skills,
    skill_d.type
FROM skills_dim AS skill_d
LEFT JOIN skills_job_dim AS skill_jd 
    ON skill_d.skill_id = skill_jd.skill_id
LEFT JOIN q1 
    ON skill_jd.job_id = q1.job_id;

-- Advanced Problem 8
WITH q1 AS (
    SELECT * FROM jan_2023_job
    UNION ALL
    SELECT * FROM feb_2023_job
    UNION ALL
    SELECT * FROM mar_2023_job
)
SELECT *
FROM q1
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023 
  AND salary_year_avg >= 70000;

--My code process
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
