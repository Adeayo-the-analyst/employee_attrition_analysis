-- =================================================================================
-- Chapter 2: Satisfaction, Performance, and Department-Level Attrition
-- Purpose: Deep dive into who is leaving based on satisfaction, performance, department,
--          and job title. Prepares the data for visualizations and actionable insights.
-- =================================================================================

-- 1. Resignations by satisfaction tier
SELECT 
    CASE
        WHEN ROUND(employee_satisfaction_score, 0) >= 4 THEN 'Highly Satisfied'
        WHEN ROUND(employee_satisfaction_score, 0) = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_tier,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY CASE
        WHEN ROUND(employee_satisfaction_score, 0) >= 4 THEN 'Highly Satisfied'
        WHEN ROUND(employee_satisfaction_score, 0) = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END
ORDER BY resignations DESC;

-- 2. Resignations by year and satisfaction tier
WITH resignation_cte AS (
    SELECT
        YEAR(DATEADD(YEAR, years_at_company, hire_date)) AS resignation_year,
        COUNT(*) AS resignations,
        CASE 
            WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
            WHEN employee_satisfaction_score = 3 THEN 'Average'
            ELSE 'Low Satisfaction'
        END AS satisfaction_tier
    FROM employee_performance
    WHERE resigned = 1
    GROUP BY YEAR(DATEADD(YEAR, years_at_company, hire_date)),
             CASE 
                WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
                WHEN employee_satisfaction_score = 3 THEN 'Average'
                ELSE 'Low Satisfaction'
             END
)
SELECT
    resignation_year,
    satisfaction_tier,
    resignations
FROM resignation_cte
ORDER BY resignation_year;

-- 3. Monthly resignations by satisfaction category for 2023 and 2024
SELECT
    CASE 
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_category,
    YEAR(DATEADD(YEAR, years_at_company, hire_date)) AS resignation_year,
    DATENAME(MONTH, DATEADD(YEAR, years_at_company, hire_date)) AS resignation_month,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY CASE 
            WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
            WHEN employee_satisfaction_score = 3 THEN 'Average'
            ELSE 'Low Satisfaction'
         END,
         YEAR(DATEADD(YEAR, years_at_company, hire_date)),
         DATENAME(MONTH, DATEADD(YEAR, years_at_company, hire_date)),
         DATEPART(MONTH, DATEADD(YEAR, years_at_company, hire_date))
ORDER BY resignation_year,
         DATEPART(MONTH, DATEADD(YEAR, years_at_company, hire_date));

-- 4. Resignations by performance tier
SELECT
    CASE
        WHEN ROUND(performance_score, 0) >= 4 THEN 'High Performer'
        WHEN ROUND(performance_score, 0) = 3 THEN 'Average'
        ELSE 'Low Performer'
    END AS performance_tier,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY CASE
        WHEN ROUND(performance_score, 0) >= 4 THEN 'High Performer'
        WHEN ROUND(performance_score, 0) = 3 THEN 'Average'
        ELSE 'Low Performer'
    END
ORDER BY resignations DESC;

-- 5. Resignations by department
SELECT
    department,
    COUNT(*) AS resignations,
    YEAR(DATEADD(YEAR, years_at_company, hire_date)) AS resignation_year,
    DATENAME(MONTH, DATEADD(YEAR, years_at_company, hire_date)) AS resignation_month,
    CONCAT('Q', DATEPART(QUARTER, DATEADD(YEAR, years_at_company, hire_date))) AS resignation_quarter
FROM employee_performance
WHERE resigned = 1
GROUP BY department, 
         YEAR(DATEADD(YEAR, years_at_company, hire_date)),
         DATENAME(MONTH, DATEADD(YEAR, years_at_company, hire_date)),
         DATEPART(MONTH, DATEADD(YEAR, years_at_company, hire_date)),
         CONCAT('Q', DATEPART(QUARTER, DATEADD(YEAR, years_at_company, hire_date)))
ORDER BY DATEPART(MONTH, DATEADD(YEAR, years_at_company, hire_date)),
         resignation_quarter,
         resignation_year;

-- 6. Resignations by job title and department
SELECT    
    department,
    job_title,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY department, job_title
ORDER BY resignations DESC;

-- 7. Job titles by satisfaction and performance categories
SELECT
    department,
    job_title,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_category,
    CASE
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END AS performance_tier,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY department, job_title,
         CASE
             WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
             WHEN employee_satisfaction_score = 3 THEN 'Average'
             ELSE 'Low Satisfaction'
         END,
         CASE
             WHEN performance_score >= 4 THEN 'High Performer'
             WHEN performance_score = 3 THEN 'Average'
             ELSE 'Low Performer'
         END
ORDER BY resignations DESC;