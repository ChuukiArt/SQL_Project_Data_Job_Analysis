/*
Question: What are the skills required for the top paying data analyst jobs?
- Use the top 10 highest paying data analyst jobs from the first query
- add the skills required for these jobs
- Why? Provide a detailed look at which high paying jobs demand certain skills,
    helping job seekers understand which skills to develop to align with top salaries.
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