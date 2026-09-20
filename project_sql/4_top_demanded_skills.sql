WITH job_posting AS (
    SELECT  
        b.skill_id,
        COUNT(*) AS skill_count
    FROM job_postings_fact AS a
    INNER JOIN skills_job_dim AS b
        ON a.job_id = b.job_id
    WHERE a.job_title_short = 'Data Analyst' 
      AND a.job_work_from_home = TRUE
    GROUP BY b.skill_id
)

SELECT 
    c.skill_id,
    c.skills,
    jp.skill_count
FROM job_posting AS jp
INNER JOIN skills_dim AS c
    ON jp.skill_id = c.skill_id
ORDER BY jp.skill_count DESC;