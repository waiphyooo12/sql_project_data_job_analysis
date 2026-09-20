# 📊 Data Analyst Job Market Analysis — SQL Project

## 📌 Introduction

This project uses SQL and PostgreSQL to analyze the data analyst job market, with a focus on salary, skill demand, and work-from-home opportunities.

The analysis explores job postings across Thailand and Singapore, as well as remote data analyst positions, to identify valuable skills and understand the relationship between skill demand and salary.

---

## 🎯 Project Objectives

- Identify the highest-paying data jobs in Thailand and Singapore.
- Explore the skills connected to high-paying, non-senior data analyst roles.
- Find the most demanded skills in remote data analyst job postings.
- Analyze skills associated with higher average salaries.
- Identify skills that combine salary potential with sufficient job demand.

---

## 🛠️ Tools Used

| Tool               | Purpose                               |
| ------------------ | ------------------------------------- |
| SQL                | Data querying and analysis            |
| PostgreSQL         | Database management                   |
| Visual Studio Code | Writing and managing SQL scripts      |
| GitHub             | Version control and project portfolio |

---

## 📂 Dataset Tables

The analysis uses the following tables:

- `job_postings_fact` — job posting information, location, salary, job title, and work-from-home status.
- `company_dim` — company information.
- `skills_job_dim` — relationship between jobs and skills.
- `skills_dim` — skill names and identifiers.

---

## 🔍 Analysis

### 1. Top-Paying Jobs in Thailand and Singapore

The first analysis identifies the top 10 highest-paying jobs in Thailand and Singapore.

**Filters and approach:**

- Includes jobs located in Thailand or Singapore.
- Excludes postings without an annual average salary.
- Joins job postings with company information.
- Sorts results by annual average salary in descending order.

---

### 2. Skills Required for High-Paying, Non-Senior Data Analyst Jobs

This analysis explores the skills connected to high-paying, non-senior data analyst positions in Thailand and Singapore.

**Filters and approach:**

- Includes Thailand and Singapore.
- Focuses on `Data Analyst` roles.
- Excludes roles containing `Senior` in the job title.
- Joins job postings with job-skill and skill dimension tables.
- Sorts the results by annual average salary in descending order.
- Returns the top 20 job-skill records.

**Key insight documented in the SQL file:**

- Python and SQL are highlighted as core skills.
- Tableau and Snowflake are identified as business intelligence and cloud-related tools.
- The analysis emphasizes the value of combining coding, querying, and business intelligence skills.

---

### 3. Most Demanded Skills in Remote Data Analyst Jobs

This analysis identifies the most frequently requested skills in remote data analyst job postings.

**Filters and approach:**

- Includes `Data Analyst` positions.
- Includes only work-from-home jobs.
- Counts the number of job postings associated with each skill.
- Sorts skills by demand count in descending order.

---

### 4. Top-Paying Skills in Remote Data Analyst Jobs

This analysis explores skills associated with higher average salaries among remote data analyst positions.

**Filters and approach:**

- Includes `Data Analyst` positions.
- Includes only work-from-home jobs.
- Excludes postings without an annual average salary.
- Groups results by skill.
- Calculates the average salary for each skill.
- Requires each skill to appear in more than 10 job postings.
- Sorts results by average salary in descending order, followed by demand count.
- Returns the top 10 skills.

---

### 5. Optimal Skills: Salary and Demand

The final analysis combines two important factors:

- **Average salary** — the average annual salary associated with each skill.
- **Demand count** — the number of job postings requiring each skill.

By applying a minimum demand threshold of more than 10 job postings, the analysis focuses on skills that have both measurable demand and salary data.

This provides a practical way to explore skills that may be relevant for future career development.

---

## 📚 What I Learned

### SQL and Technical Skills

- Writing SQL queries for job market analysis.
- Using `INNER JOIN` and `LEFT JOIN` to combine related tables.
- Applying Common Table Expressions (CTEs).
- Using aggregate functions such as `COUNT()` and `AVG()`.
- Grouping results with `GROUP BY`.
- Filtering grouped data with `HAVING`.
- Sorting results with `ORDER BY`.
- Filtering data using `WHERE`.
- Working with Boolean fields such as `job_work_from_home`.

### Analytical Skills

- Translating career-related questions into SQL queries.
- Comparing salary and demand across skills.
- Filtering data to focus on specific job categories and locations.
- Using a minimum demand threshold to make skill comparisons more meaningful.
- Interpreting the relationship between technical skills, salary, and job demand.

---

## 📁 Project Structure

```text
project_sql/
│
├── 1_top_paying_jobs.sql
├── 2_top_paying_job_skills.sql
├── 3_top_paying_skills.sql
├── 4_top_demanded_skills.sql
└── 5_optimal_skills.sql
```

---

## 🚀 Future Improvements

- Compare data analyst salaries between Thailand and Singapore.
- Analyze differences between remote and non-remote positions.
- Add visualizations for salary and skill demand.
- Explore trends by company, location, and job title.
- Improve the analysis by separating skills into categories such as programming, databases, cloud, and business intelligence.
- Include a larger sample of job postings where appropriate.

---

## 👤 Author

**Wai Phyo Oo**

This project is part of my learning journey in SQL, data analytics, and the data job market.
