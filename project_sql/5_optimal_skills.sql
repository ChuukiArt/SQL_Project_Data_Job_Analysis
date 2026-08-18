/*
Question: What are the most optimal skills to learn - High Demand and High Paying?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analyssis
*/


WITH skills_demand AS(
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(job_postings_fact.job_id) as demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' 
        AND job_postings_fact.job_work_from_home = TRUE
        AND job_postings_fact.salary_year_avg IS NOT null
    GROUP BY
        skills_dim.skill_id
),  average_salary AS(
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) as avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_postings_fact.salary_year_avg IS NOT null AND
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.job_work_from_home = TRUE -- Remote work
    GROUP BY
        skills_dim.skill_id

)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    
    avg_salary DESC,
    demand_count DESC



