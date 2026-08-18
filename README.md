# Introduction
A detailed look into the data job market, with a focus on data analyst roles. This project explores the top paying data analyst roles, in-demand skills and were high demand meets high salary in data analytics.

Check out the SQL queries here: [project_sql folder](/project_sql/)
# Background
This project was started from a desire to better navigate the data analyst roles, pinpointing the top-paid and in-demand skills, serving as a reference for job seekers helping them identify which skills they need and should aquire.

The data is from [SQL for Data Analytics](https://lukeb.co/sql_project_csvs). With insights into job titles, salaries, location and skills.

### The questions I wanted to answer through my SQL queries:
1. What are the top-paying data analyst job listings?
2. What are the skills required for the top paying data analyst jobs?
3. what are the most in-demand skills for data analysts?
4. Which skills are associated with higher salaries
5. What are the most optimal skills to aquire?

# Tools I used
- **SQL:** This is the backbone of my analysic, allowing me to query the data base and explore key insights.
- **PostgresSQL:** The chosen databse managment system.
- **Visual Studio Code:** For database managment and executing SQL queries.
- **Git & GitHub:** Version control and sharing SQL scripts and anlaysis, allowing for collaboration and project tracking.


# The Analysis
Each query for this project was aimed to investigate specific aspect of the data analyst job market. Here is how each question was approached.

### 1. Top Paying Data Analyst Jobs
To identify to highest paying data analyst roles, I filtered data analyst positions by their average yearly salary and location, with a focus on remote jobs. This query highlights the high paying opportunities in this field.

```sql
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
```
Here's the breakdown of the top data analyst jobs:

- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Senior-Leaning Titles:** Most roles are Director, Associate Director, or Principal-level rather than standard analyst positions, reflecting how top pay concentrates in leadership roles.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing broad interest across different industries.
- **Notable Outlier:** Mantys' $650,000 listing is nearly 2x the next-highest salary — worth a sanity check on the data.
- **Job Title Variety:** High diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. The Skilled Needed For Top Paying Data Analyst Jobs
To identify the skilled required for the highest paying data analyst positions, I created a CTE using the first query, then mapped the required skills to the top 10 data analyst jobs.

```sql
WITH top_paying_jobs AS(
    SELECT 
        job_id,
        job_title,
        company_dim.name AS company_name,
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
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC
```

Skills Breakdown for Top Paying Data Analyst Jobs:

- **SQL dominates:** appears in 8 of the 10 top-paying jobs — clearly the baseline expectation for high-paying analyst roles.
- **Python is close behind:** shows up in 7 listings, reinforcing SQL + Python as the core pairing.
- **Tableau leads BI tools:** required in 6 jobs, ahead of Power BI (2).
- **R shows up in 4 listings** — notable since it's less universal than SQL/Python but still a recurring ask.
- **Excel, Pandas, and Snowflake tie at 3 each** — a mix of traditional and modern data-handling tools.
- **Cloud/platform skills split evenly:** Azure and AWS each appear twice, mostly tied to the same postings (AT&T, Inclusively).
- **Collaboration tools cluster together:** Jira, Confluence, Atlassian, and Bitbucket each appear twice, mostly from Inclusively and Motional — suggesting these roles lean more cross-functional/project-based.
- **Long tail of niche skills:** Databricks, PySpark, Hadoop, and SAP appear just once each, tied to specific companies' stacks.

### 3. In-demand Skills For Data Analyst Roles
To find the most in-demand skills in the data analyst field, I first filtered for data analyst roles and remote roles, then I mapped all the required skills for each job. I then count the number of job postings that include each skill.

```sql
SELECT
    skills,
    COUNT(job_postings_fact.job_id) as demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
limit 10

```

Top In-Demand Skills for Remote Data Analyst Roles:

- **SQL leads by a wide margin:** 7,291 postings — the clear must-have skill for data analyst roles.
- **Excel remains highly relevant:** 4,611 postings, showing traditional tools still hold strong demand alongside modern ones.
- **Python rounds out the core trio:** 4,330 postings, reinforcing SQL + Excel + Python as the foundational skill set.
- **Tableau leads BI tools:** 3,745 postings, well ahead of Power BI (2,609).
- **R sits mid-pack:** 2,142 postings — a solid presence but notably behind Python.
- **SAS still has demand:** 1,866 postings, suggesting legacy enterprise/statistical tooling hasn't disappeared.
- **Looker and Azure trail:** 868 and 821 postings respectively — more specialized or company-specific requirements.
- **Powerpoint closes the top 10:** 819 postings, pointing to the reporting/presentation side of analyst work.

### 4. Highest Paying skills based On Salary
To find the top paying skills based on salary, I first filter for remote data analyst jobs that specify a average yearly salary. Then I get the average salary based on each skill by grouping the skills.

```sql
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
```
Highest Paying Skills for Remote Data Analyst Roles:

- **PySpark tops the list:** $208,172 avg salary — big data processing skills command a premium.
- **Bitbucket follows:** $189,155 — version control/dev-adjacent skills pay well, likely tied to more technical analyst roles.
- **Couchbase and Watson tie:** $160,515 each — niche database and AI platform experience stands out.
- **DataRobot commands $155,486:** automated ML tooling reflects growing demand for AI-adjacent skills.
- **GitLab and Swift follow closely:** $154,500 and $153,750 — again pointing to overlap with software engineering skill sets.
- **Jupyter and Pandas sit mid-list:** $152,777 and $151,821 — core Python data-science tooling, but not as rare as the skills above them.
- **Elasticsearch closes the top 10:** $145,000 — search/data infrastructure knowledge still pays a premium.

**Overall pattern:** the highest-paying skills skew toward specialized engineering, big-data, and ML tooling rather than traditional analyst staples like Excel or Tableau — suggesting analysts who blend data engineering/ML skills into their toolkit earn significantly more.

### 5. Most Optimal Skill To Aquire
To find the most optimal skill to aquire, I first need to find the most in-demand skills with the specified salary. The list is then shorted based on the salary, and skills that have less than 10 job listings are not consisdered in-demand.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) as demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) as avg_salary
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
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count ASC
limit 25
```

Most Optimal Skills to Acquire (Demand + Salary Balance)

- **Go stands out:** highest avg salary ($115,320) among skills with meaningful demand (27 postings) — a strong high-pay, moderate-demand pick.
- **Cloud platforms cluster near the top:** Snowflake ($112,948), Azure ($111,225), and AWS ($108,317) all pay well with decent demand (32–37 postings), reflecting strong cloud-data-infrastructure value.
- **Python and R offer the best demand-to-pay balance:** Python has by far the highest demand (236 postings) at $101,397, and R follows with 148 postings at $100,499 — both solid "safe bet" choices since they combine strong pay with high job availability.
- **Tableau is the most in-demand BI tool here:** 230 postings at $99,288 — lower pay than niche tools, but hard to ignore given its sheer demand volume.
- **Niche/specialized tools pay more but offer fewer openings:** Confluence, Hadoop, BigQuery, SSIS, and Qlik all sit in the $99K–$114K range with only 11–22 postings — higher risk, lower job pool.
- **SAS appears twice** (duplicate skill_id entries, 63 postings each at $98,902) — likely a data quality issue worth cleaning up (two skill_ids mapped to the same skill name).

**Takeaway:** Python and R are the most "optimal" picks — high demand *and* strong pay. For higher salary ceilings, cloud/big-data skills (Snowflake, Azure, AWS, Go) offer good upside with acceptable demand.

# What I Learned

# Conclusions