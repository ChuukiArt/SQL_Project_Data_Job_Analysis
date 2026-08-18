/*
Question: What are the top skills based on salary?
- Identify the Average Salary associated with each skill for Data Analyst roles
- Filter out job postings with no specified salary information (NULL), regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts, Identify the
    most financially rewarding skill to aquire.
*/

-- need 2 inner joins


SELECT
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
ORDER BY
    avg_salary DESC
LIMIT 10

/*
SVN's $400K is likely a data artifact (tiny sample size) — legacy tech, not a real signal.

AI/ML skills dominate the premium tier: DataRobot, MXNet, Keras, PyTorch, Hugging Face, 
    TensorFlow all cluster $120K–155K — the largest group on the list.

Infra/DevOps pays well too: Terraform, VMware, Ansible, Puppet, GitLab ($124K–147K) — 
    analysts blending into platform engineering.

Big data/streaming tools (Kafka, Cassandra, Couchbase, Airflow) suggest the highest 
    earners do engineering-adjacent work, not just analysis.

Niche tech commands scarcity premiums: Solidity ($179K) despite being outside core data work.

Common collaboration tools pay least: Notion, Atlassian, Bitbucket (~$117K) — 
    expected baseline skills, not differentiators.
*/