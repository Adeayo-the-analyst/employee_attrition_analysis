# Employee Analytics – Data Storytelling Project

This repository contains **five analytical chapters** exploring employee performance, attrition, workload, promotion, and burnout patterns using SQL. The project demonstrates **persona-driven storytelling** with data and actionable insights for training purposes.

> **Note:** The full dataset is confidential and **not included**. Sample data and descriptions are provided for reference.

---

## Dataset Description

The dataset contains employee information across multiple departments. Below are the **columns**:

| Column | Description |
|--------|-------------|
| `Employee_ID` | Unique identifier for each employee |
| `Department` | Employee’s department (Finance, IT, HR, Sales, etc.) |
| `Gender` | Employee’s gender (`Male`, `Female`, `Other`) |
| `Age` | Employee’s age |
| `Job_Title` | Job title (Analyst, Engineer, Manager, etc.) |
| `Hire_Date` | Date employee was hired |
| `Years_At_Company` | Total years with the company |
| `Education_Level` | Highest education attained (`High School`, `Bachelor`, `Master`, `PhD`) |
| `Performance_Score` | Performance rating (1 = Low, 5 = High) |
| `Monthly_Salary` | Employee’s monthly salary |
| `Work_Hours_per_Week` | Standard work hours per week |
| `Projects_Handled` | Number of projects handled |
| `Overtime_Hours` | Monthly overtime hours |
| `Sick_Days` | Total sick days taken |
| `Remote_Work_Frequency` | Days per week working remotely |
| `Team_Size` | Size of employee’s team |
| `Training_Hours` | Hours of training received |
| `Promotions` | Number of promotions received |
| `Employee_Satisfaction_Score` | Satisfaction rating (1 = Low, 5 = High) |
| `Resigned` | Employee status (`0 = Active`, `1 = Resigned`) |

> **Sample Rows (anonymized):**  

| Employee_ID | Department | Gender | Age | Job_Title | Years_At_Company | Education_Level | Performance_Score | Projects_Handled | Overtime_Hours | Sick_Days | Promotions | Employee_Satisfaction_Score | Resigned |
|-------------|------------|--------|-----|-----------|-----------------|----------------|-----------------|-----------------|----------------|-----------|------------|----------------------------|----------|
| 10123 | Finance | Male | 32 | Analyst | 4 | Bachelor | 4 | 15 | 12 | 2 | 1 | 4 | 0 |
| 10484 | IT | Female | 41 | Engineer | 7 | Master | 5 | 40 | 25 | 8 | 2 | 2 | 1 |
| 18857 | HR | Other | 25 | Technician | 1 | High School | 2 | 10 | 22 | 6 | 0 | 1 | 1 |

---

## Chapters

### Chapter 1 – Attrition Trends
Explores **resignation patterns over time**, highlighting overall turnover and departmental attrition trends.

### Chapter 2 – Severity of the Exodus Virus
Analyzes **resignation severity** by performance, tenure, and other factors.

### Chapter 3 – High Project Workload Paradox
Investigates **high-performing employees handling extreme workloads** and their attrition risk. Includes **persona-driven insights**.

### Chapter 4 – Performance-Promotion Disconnect
Assesses whether **high performance correlates with promotions**, factoring in education, overtime, and satisfaction.

### Chapter 5 – Burnout
Examines **burnout patterns**, including tenure, gender, department, promotion, and performance tiers. Personas of **highly burned-out employees** are highlighted.

---

## Notes

- All analyses are written in **SQL** assuming the dataset table name is `employee_performance`.
- Data is anonymized; **no real identifiers or salaries** are included.
- Project is intended for **training and learning purposes**.

---


Each SQL file contains the **queries and comments** for the respective chapter.

