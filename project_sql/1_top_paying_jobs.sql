/*
Question: What are the top-paying data analyst job listings?
- Identify the top 10 highest-paying data analyst positions that is available remotely.
- Filter out job postings with no specified salary information (NULL).
- Why? Highlight the top-paying opportuities for Data Analyst, offering insights into employment opportunities.
*/

SELECT 
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_schedule_type,
    job_posted_date,
    salary_year_avg
FROM
    job_postings_fact AS job_postings
LEFT JOIN company_dim ON job_postings.company_id = company_dim.company_id
WHERE
    job_postings.job_title_short = 'Data Analyst' AND 
    job_postings.job_location = 'Anywhere' AND
    job_postings.salary_year_avg IS NOT null
ORDER BY
    job_postings.salary_year_avg DESC
LIMIT 10