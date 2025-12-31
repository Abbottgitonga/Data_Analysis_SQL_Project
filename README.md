# Introduction
This project dives into the data job market with a specific focus on Data Analyst and Business Analyst roles. 

It explores top-paying jobs, in-demand skills, and the intersection where high demand meets high salary in data analytics.

The SQL queries for this analysis can be found here: [project_sql folder](project_sql)



# Background
Driven by a desire to navigate the job market more effectively, this project filters through thousands of job postings to answer five core questions:
1. What are the top-paying Data and Business Analyst roles?
2. What skills are required for these high-paying roles?
3. What skills are most in-demand for these roles?
4. Which skills are associated with the highest average salaries?
5. What are the most optimal skills to learn (high demand + high salary)?

# Tools I Used

- SQL: The backbone of my analysis, allowing me to query the database and unearth critical insights.

- PostgreSQL: The database management system I used for handling the job posting data.

- Visual Studio Code: My primary tool for database management and executing SQL queries.

- Git & GitHub: Essential for version control and sharing my SQL scripts and analysis with you

# The Analysis

## 1. Top Paying Data & Business Analyst Jobs



**Objective**
To identify the highest-paying opportunities in the current market, I filtered the `job_postings_fact` table specifically for Data Analyst and Business Analyst roles. This analysis highlights the salary ceiling for these positions and identifies the specific companies offering the most lucrative compensation packages.

**SQL Query**
```sql
SELECT 
    job_title_short,
    job_title,
    salary_year_avg,
    job_id,
    company_dim.company_id,
    name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short IN ('Business Analyst', 'Data Analyst') AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```

### Findings and Insights
*   **Salary Ceiling:** The highest-paying role identified is a Data Analyst position at **Mantys**, offering a staggering **$650,000/year**.

*   **Business Analyst Breakthrough:** Unlike typical trends where Data Analysts dominate technical pay scales, a **Business Analyst** role at **Roblox** appears in the top 3 ($387,460). This proves that top-tier tech companies value business-focused analytical roles almost as highly as technical data roles.

*   **Salary Clustering:** There is a significant cluster of roles paying exactly **$375,000** across diverse sectors—including Defense/Government Services (Illuminate Mission Solutions), Finance (Citigroup), and Autonomous Tech (Torc Robotics). This suggests a standardized "upper cap" for Senior Individual Contributor roles in these industries.

*   **Company Repeats:** **Illuminate Mission Solutions** holds two spots in the top 5, indicating that they are currently aggressively hiring for high-value data talent.


![Top Paying Analyst Jobs](assets/Top_10_Analyst_Jobs.png)







## 2. Top Skills for High-Paying Roles

**Objective** 

Building on the previous analysis of the top-paying jobs, I sought to uncover the specific technical requirements for these premium roles. By joining the job postings with the skills dimension table, I identified which technical competencies are most frequently associated with salaries ranging from **$350,000 to $400,000+**.

**SQL Query**
```sql
WITH top_paying_jobs AS
    (SELECT 
        job_title_short,
        salary_year_avg,
        job_id,
        company_dim.company_id,
        name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short IN ('Business Analyst', 'Data Analyst')
        AND salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
    )

SELECT
    skills,
    job_title_short,
    salary_year_avg,
    top_paying_jobs.job_id,
    name
FROM 
    top_paying_jobs
LEFT JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC;
```

### Findings and Insights
*   **The "Core" Trio:** **SQL** and **Python** are the dominant requirements, appearing in nearly every high-paying role (from Roblox to Anthropic). **R** also maintains a strong presence, suggesting that for top-tier salaries, proficiency in statistical programming is non-negotiable.

*   **Big Data & Cloud Command Premiums:** The highest salary brackets often require skills beyond standard analysis. Tools like **Spark**, **Airflow**, **Hadoop**, **Kafka**, and **Snowflake** appear frequently. This indicates a "Hybrid Analyst" trend, where high earners are expected to handle data engineering tasks (pipelines and big data processing) in addition to analysis.

*   **Visualization Remains Critical:** Despite the heavy engineering requirements, "Business Intelligence" tools like **Tableau** and **Power BI** are still required in roles paying $350k+. This proves that the ability to translate complex data into visual insights is still a core value driver.

*   **The Excel Paradox:** Interestingly, **Excel** appears in multiple roles paying over $375,000 (Citi, Illuminate, Torc). This reinforces that while advanced coding is necessary for data manipulation, Excel remains the lingua franca for final business delivery and strategy.




| Rank | Skill | Frequency | Example Companies |
| :--- | :--- | :--- | :--- |
| 1 | Python | 5 | Roblox, Anthropic, Illuminate |
| 2 | SQL | 4 | Roblox, Care.com, Torc Robotics |
| 3 | R | 4 | Roblox, Illuminate, Torc Robotics |
| 4 | Excel | 3 | Citigroup, Illuminate, Torc Robotics |
| 5 | Tableau | 3 | Care.com, Illuminate, Torc Robotics |
| 6 | Spark | 2 | Roblox, Torc Robotics |
| 7 | Airflow | 2 | Roblox, Torc Robotics |
| 8 | Power BI | 2 | Care.com, Torc Robotics |

*Table: A frequency count of skills appearing in the top 10 highest-paying job postings. Python and SQL remain the most critical hard skills, while "Big Data" tools like Spark and Airflow begin to appear as salary requirements increase.*

## 3. Most In-Demand Skills

**Objective**

To determine the most valuable skills for market entry and general employability, I analyzed the frequency of skill requirements across all Data Analyst and Business Analyst job postings. This query identifies the "baseline" toolkit expected by the majority of employers.

**SQL Query**
```sql
SELECT
    COUNT (skills_job_dim.job_id) AS in_demand_skills,
    skills
FROM 
    job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short IN ('Data Analyst' , 'Business Analyst')
GROUP BY 
    skills
ORDER BY 
    in_demand_skills DESC
LIMIT 10;
```

### Findings and Insights
*   **SQL is King:** With over **110,000 mentions**, SQL is the undisputed leader in demand. It appears in nearly 30% more job descriptions than the next closest technical skill (Excel), reinforcing that database interaction is the fundamental requirement for these roles.
*   **Excel's Endurance:** Despite the rise of advanced tools, **Excel** ranks #2 with **84,165** mentions. This highlights that spreadsheets remain the primary interface for business stakeholders, and analysts must be proficient in bridging the gap between databases and Excel.
*   **Python vs. R:** **Python (65,423)** significantly outperforms **R (34,110)** in terms of demand. While R is valuable for statistical niches (as seen in the high-salary analysis), Python is the broader market standard for general automation and analysis.
*   **The Visualization Battle:** The demand for **Tableau (55,878)** slightly edges out **Power BI (48,719)**, but both are essential. Collectively, they appear in over 100,000 postings, proving that data visualization is a core pillar of the analyst role.


    | Rank | Skill | Demand Count |
    | :--- | :--- | :--- |
    | 1 | SQL | 110,000 |
    | 2 | Excel | 84,165 |
    | 3 | Python | 65,423 |
    | 4 | Tableau | 55,878 |
    | 5 | Power BI | 48,719 |
    | 6 | R | 34,110 |
    | 7 | SAS | 31,672 |
    | 8 | PowerPoint | 18,439 |
    | 9 | Word | 17,266 |
    | 10 | SAP | 14,948 |

*Table: The demand hierarchy for analysts. While advanced tools like Python and Tableau are essential, foundational skills like SQL and Excel remain the primary gatekeepers for market entry.*



## 4. Skills Associated with the Highest Salaries

**Objective**
To identify which specific technical skills command the highest salary premiums, I analyzed the average salary associated with each skill for Data and Business Analyst roles. This analysis helps differentiate between high-value niche skills and standard industry requirements.

**SQL Query**
```sql
SELECT 
    count (skills_job_dim.job_id) AS job_count,
    skills_dim.skill_id,
    skills,
    ROUND (avg (salary_year_avg), 2) AS avg_pay
FROM 
    skills_job_dim
 LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
 LEFT JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE 
    salary_year_avg IS NOT NULL 
    AND job_title_short IN ('Business Analyst', 'Data Analyst')
GROUP BY    
    skills_dim.skill_id
ORDER BY 
    avg_pay DESC
LIMIT 25
```

### Findings and Insights
*   **The Niche Premium:** The highest average salaries are associated with highly specialized or "legacy" skills like SVN ($246k) and Solidity ($179k). While lucrative, the low job counts (only 1-2 postings) indicate these are rare, unicorn roles (e.g., Crypto Analysts or Legacy System maintainers).

*   **The "AI/ML" Analyst:** There is a clear financial incentive for analysts to upskill in Machine Learning. Libraries like DataRobot ($155k), Keras ($127k), PyTorch ($124k), and TensorFlow ($120k) all command salaries well above the industry average.

*   **Engineering Overlap:** High-paying skills frequently overlap with Data Engineering. Tools like Kafka ($126k), Airflow ($117k), and Cassandra ($116k) suggest that analysts who can manage their own data pipelines and handle streaming data are valued significantly higher than those who rely solely on pre-cleaned datasets.

*   **Programming Languages:** specialized languages like Golang ($155k) and Perl ($122k) appear in the top bracket, further emphasizing that polyglot programmers in the analysis space have a higher earning ceiling.


**The following table details the top 10 skills by average salary.**

| Rank | Skill | Average Salary ($) | Job Count | Category |
| :--- | :--- | :--- | :--- | :--- |
| 1 | SVN | $246,585 | 2 | Version Control (Legacy) |
| 2 | Solidity | $179,000 | 1 | Blockchain / Web3 |
| 3 | Couchbase | $160,515 | 1 | NoSQL Database |
| 4 | DataRobot | $155,485 | 1 | AI / AutoML |
| 5 | Golang | $155,000 | 2 | Programming |
| 6 | Dplyr | $147,633 | 3 | R Library |
| 7 | VMware | $147,500 | 1 | Cloud / Infrastructure |
| 8 | Twilio | $138,500 | 2 | API / Communications |
| 9 | MXNet | $136,000 | 3 | Deep Learning |
| 10 | Puppet | $129,820 | 2 | DevOps / Automation |

*Table: A breakdown of the top 10 highest-paying skills for analysts. Note that the highest salaries are often linked to lower job volumes, indicating a "High Risk, High Reward" market for specialized tech.*




## 5. Most Optimal Skills to Learn

**Objective**

To identify the "sweet spot" for skill acquisition, I combined demand frequency with salary data for both Data Analyst and Business Analyst roles. This query filters for skills that are both in high demand (offering job security) and high paying (offering financial growth). The goal is to identify which skills offer the highest Return on Investment (ROI) for a professional looking to maximize their value in the analytics market.

**SQL Query**
```sql

WITH average_salary AS
    (SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        avg (salary_year_avg) AS avg_pay
    FROM 
        skills_job_dim
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    LEFT JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE 
        salary_year_avg IS NOT NULL 
        AND job_title_short IN ('Data Analyst','Business Analyst')
    GROUP BY 
        skills_dim.skill_id
    ORDER BY 
        avg_pay DESC)

,

demand_skills AS
    (SELECT
        count (skills_job_dim.job_id) AS in_demand_skills,
        skills_dim.skill_id,
        skills_dim.skills
    FROM 
        job_postings_fact
    LEFT JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short IN ('Data Analyst','Business Analyst')
        AND salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
    ORDER BY 
        in_demand_skills DESC)



SELECT
    demand_skills.skill_id,
    demand_skills.skills,
    in_demand_skills,
    avg_pay
FROM 
   demand_skills
INNER JOIN average_salary ON demand_skills.skill_id = average_salary.skill_id
WHERE 
    in_demand_skills > 100
ORDER BY 
    in_demand_skills DESC,
    avg_pay DESC;
    
```

### Findings and Insights
*   **The "Big Data" Paycheck:** The highest average salaries are reserved for skills associated with big data processing and cloud architecture. **Hadoop** ($113k), **Databricks** ($112k), **Spark** ($112k), and **Snowflake** ($111k) top the list. This confirms that analysts who can handle large-scale data engineering tasks are the most valued in the market.
*   **Python: The Optimal Hybrid:** **Python** stands out as the single most "optimal" skill. It is the only skill with massive demand (1,983 postings) that also commands a six-figure average salary (**$101,711**). It bridges the gap between high-volume operational roles and high-salary engineering roles.
*   **Cloud is Essential:** **AWS** ($106k) and **Azure** ($105k) both appear in the top tier of salaries with healthy demand counts (300+). This suggests that familiarity with at least one major cloud provider is a key differentiator for senior salary brackets.
*   **The "Analyst" Base:** Fundamental skills like **SQL** ($96k), **Tableau** ($98k), and **Excel** ($86k) have the highest demand but lower average salaries compared to engineering tools. While necessary for entry, they do not drive compensation as effectively as specialized technical skills.




| Rank | Skill | Average Salary | Demand (Job Count) |
| :--- | :--- | :--- | :--- |
| 1 | Hadoop | $113,462 | 154 |
| 2 | Databricks | $112,331 | 106 |
| 3 | Spark | $112,236 | 201 |
| 4 | Snowflake | $111,697 | 275 |
| 5 | Nosql | $109,348 | 119 |
| 6 | Express | $107,203 | 101 |
| 7 | AWS | $106,405 | 316 |
| 8 | Jira | $105,312 | 161 |
| 9 | Azure | $105,299 | 341 |
| 10 | Looker | $104,445 | 285 |
| 11 | Alteryx | $104,427 | 140 |
| 12 | Python | $101,711 | 1,983 |
| 13 | Oracle | $100,180 | 369 |
| 14 | Java | $99,247 | 148 |
| 15 | Visio | $99,269 | 117 |

*Table: A strategic overview of the optimal skills for Data & Business Analysts, balancing high market demand with average salaries, largely dominated by cloud and big data tools.*

# What I Learned

Through this project, I have significantly strengthened my technical and analytical toolkit:
- Complex Querying: Mastered advanced SQL techniques, including CTEs to create temporary result sets and Joins to merge diverse data for comprehensive analysis.

- Data Aggregation: Proficiently used GROUP BY and aggregate functions like COUNT() and AVG() to turn thousands of rows into manageable market trends.

- Analytical Wizardry: Developed the ability to translate raw code into a strategic roadmap, identifying high-ROI career paths


# Conclusions

## Insights:
1. **Specialisation Pays:** The highest-paying roles are often "Hybrid Analyst" positions that require knowledge of cloud infrastructure and big data tools like Spark and Snowflake.
2. **SQL is the Foundation:** Across all analyses, SQL remains the most essential entry-level skill, appearing in nearly 30% more job descriptions than any other tool.
3. **Python for Growth:** For those moving from entry-level to high-tier roles, Python offers the best balance of market demand and salary growth.

## Closing Thoughts: 
This project served as more than just a technical exercise; it provided a clear, data-driven path for my future career development. By focusing on the intersection of cloud technologies and advanced programming, I am better positioned to transition into high-value Data and Business Analyst roles.
