-- Chapter 5: Burnout Analysis

-----------------------------------------------------------
-- 1. Count active employees currently experiencing burnout
-----------------------------------------------------------
SELECT
    COUNT(*) AS burnt_out_employees
FROM employee_performance
WHERE resigned = 0  -- only current employees
  AND overtime_hours >= 20
  AND sick_days > 5
  AND employee_satisfaction_score < 3;

-----------------------------------------------------------
-- 2. Burnout by gender among active employees
-----------------------------------------------------------
WITH burnout_active_employees AS (
    SELECT
        gender,
        COUNT(*) AS burnt_out_employees
    FROM employee_performance
    WHERE resigned = 0
      AND overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
    GROUP BY gender
)
SELECT
    gender,
    burnt_out_employees,
    SUM(burnt_out_employees) OVER () AS total_employees,
    CONCAT(ROUND(100.0 * burnt_out_employees / SUM(burnt_out_employees) OVER (), 2), '%') AS pct
FROM burnout_active_employees;

-----------------------------------------------------------
-- 3. Burnout by gender among resigned employees
-----------------------------------------------------------
WITH burnout_resigned AS (
    SELECT
        gender,
        COUNT(*) AS burnt_out_employees
    FROM employee_performance
    WHERE resigned = 1
      AND overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
    GROUP BY gender
)
SELECT
    gender, 
    burnt_out_employees,
    SUM(burnt_out_employees) OVER () AS total_resignations,
    CONCAT(ROUND(100.0 * burnt_out_employees / SUM(burnt_out_employees) OVER (), 2), '%') AS pct
FROM burnout_resigned;

-----------------------------------------------------------
-- 4. Burnout by tenure
-----------------------------------------------------------
SELECT
    CASE    
        WHEN years_at_company >= 6 THEN 'Senior'
        WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
        ELSE 'Entry-Level'
    END AS tenure,
    COUNT(*) AS burnt_employees
FROM employee_performance
WHERE overtime_hours >= 20
  AND sick_days > 5
  AND employee_satisfaction_score < 3
GROUP BY
    CASE    
        WHEN years_at_company >= 6 THEN 'Senior'
        WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
        ELSE 'Entry-Level'
    END
ORDER BY burnt_employees DESC;

-----------------------------------------------------------
-- 5. Burnout rate by tenure
-----------------------------------------------------------
WITH tenure_group AS (
    SELECT
        CASE
            WHEN years_at_company >= 6 THEN 'Senior'
            WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
            ELSE 'Entry-Level'
        END AS tenure,
        COUNT(*) AS total_employees
    FROM employee_performance
    GROUP BY 
        CASE
            WHEN years_at_company >= 6 THEN 'Senior'
            WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
            ELSE 'Entry-Level'
        END
),
burnt_out_employees AS (
    SELECT
        CASE
            WHEN years_at_company >= 6 THEN 'Senior'
            WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
            ELSE 'Entry-Level'
        END AS tenure,
        COUNT(*) AS burnt_employees
    FROM employee_performance
    WHERE overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
    GROUP BY 
        CASE
            WHEN years_at_company >= 6 THEN 'Senior'
            WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
            ELSE 'Entry-Level'
        END
)
SELECT 
    b.tenure,
    b.burnt_employees,
    CONCAT(ROUND(100.0 * b.burnt_employees / t.total_employees, 2), '%') AS burnout_rate
FROM burnt_out_employees b
INNER JOIN tenure_group t ON b.tenure = t.tenure
ORDER BY burnout_rate DESC;

-----------------------------------------------------------
-- 6. Burnout across gender within tenure groups
-----------------------------------------------------------
SELECT
    CASE
        WHEN years_at_company >= 6 THEN 'Senior'
        WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
        ELSE 'Entry-Level'
    END AS tenure_group,
    gender,
    COUNT(*) AS burned_employees
FROM employee_performance
WHERE overtime_hours >= 20
  AND sick_days > 5
  AND employee_satisfaction_score < 3
GROUP BY 
    CASE
        WHEN years_at_company >= 6 THEN 'Senior'
        WHEN years_at_company BETWEEN 3 AND 5 THEN 'Mid-Level'
        ELSE 'Entry-Level'
    END,
    gender
ORDER BY burned_employees DESC;

-----------------------------------------------------------
-- 7. Burnout as a predictor of resignations
-----------------------------------------------------------
SELECT
    SUM(CASE WHEN resigned = 1 THEN 1 ELSE 0 END) AS resigned_burned,
    SUM(CASE WHEN resigned = 0 THEN 1 ELSE 0 END) AS active_burned
FROM employee_performance
WHERE overtime_hours >= 20
  AND sick_days > 5
  AND employee_satisfaction_score < 3;

-----------------------------------------------------------
-- 8. Burnout vs performance tier
-----------------------------------------------------------
WITH active_employees AS (
    SELECT
        CASE
            WHEN performance_score >= 4 THEN 'High Performer'
            WHEN performance_score = 3 THEN 'Average'
            ELSE 'Low Performer'
        END AS performance_tier,
        COUNT(*) AS active_burned_out
    FROM employee_performance
    WHERE overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
      AND resigned = 0
    GROUP BY performance_tier
),
resigned_employees AS (
    SELECT
        CASE
            WHEN performance_score >= 4 THEN 'High Performer'
            WHEN performance_score = 3 THEN 'Average'
            ELSE 'Low Performer'
        END AS performance_tier,
        COUNT(*) AS resigned_burn_out
    FROM employee_performance
    WHERE resigned = 1
      AND overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
    GROUP BY performance_tier
)
SELECT
    r.performance_tier,
    r.resigned_burn_out,
    a.active_burned_out
FROM resigned_employees r
JOIN active_employees a ON r.performance_tier = a.performance_tier;

-----------------------------------------------------------
-- 9. Burnout vs satisfaction
-----------------------------------------------------------
WITH burnout_satisfaction_active AS (
    SELECT
        CASE
            WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
            WHEN employee_satisfaction_score = 3 THEN 'Average'
            ELSE 'Low Satisfaction'
        END AS satisfaction_category,
        COUNT(*) AS active_burned_out
    FROM employee_performance
    WHERE resigned = 0
      AND overtime_hours >= 20
      AND sick_days > 5
    GROUP BY satisfaction_category
),
burnout_satisfaction_resigned AS (
    SELECT
        CASE
            WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
            WHEN employee_satisfaction_score = 3 THEN 'Average'
            ELSE 'Low Satisfaction'
        END AS satisfaction_category,
        COUNT(*) AS resigned_burned_out
    FROM employee_performance
    WHERE resigned = 1
      AND overtime_hours >= 20
      AND sick_days > 5
    GROUP BY satisfaction_category
)
SELECT
    r.satisfaction_category,
    r.resigned_burned_out,
    a.active_burned_out
FROM burnout_satisfaction_resigned r
INNER JOIN burnout_satisfaction_active a 
    ON r.satisfaction_category = a.satisfaction_category;

-----------------------------------------------------------
-- 10. Burnout by department
-----------------------------------------------------------
WITH department_burnout_active AS (
    SELECT department, COUNT(*) AS active_burned
    FROM employee_performance
    WHERE resigned = 0
      AND overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
    GROUP BY department
),
department_burnout_resigned AS (
    SELECT department, COUNT(*) AS resigned_burned
    FROM employee_performance
    WHERE resigned = 1
      AND overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
    GROUP BY department
)
SELECT
    r.department,
    r.resigned_burned,
    a.active_burned
FROM department_burnout_resigned r
INNER JOIN department_burnout_active a ON r.department = a.department;

-----------------------------------------------------------
-- 11. Burnout and promotion
-----------------------------------------------------------
WITH burnout_active AS (
    SELECT
        SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) AS promoted_burnouts_active,
        SUM(CASE WHEN promotions = 0 THEN 1 ELSE 0 END) AS unpromoted_burnouts_active
    FROM employee_performance
    WHERE overtime_hours >= 20
      AND resigned = 0
      AND sick_days > 5
      AND employee_satisfaction_score < 3
),
burnout_resigned AS (
    SELECT
        SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) AS promoted_resigned_burnouts,
        SUM(CASE WHEN promotions = 0 THEN 1 ELSE 0 END) AS unpromoted_resigned_burnouts 
    FROM employee_performance
    WHERE resigned = 1
      AND overtime_hours >= 20
      AND sick_days > 5
      AND employee_satisfaction_score < 3
)
SELECT
    promoted_resigned_burnouts,
    promoted_burnouts_active,
    unpromoted_burnouts_active,
    unpromoted_resigned_burnouts
FROM burnout_resigned
CROSS JOIN burnout_active;

-----------------------------------------------------------
-- 12. Burnout personas
-----------------------------------------------------------
-- High-Performing Senior Engineer (Resigned)
SELECT *
FROM employee_performance
WHERE employee_satisfaction_score < 3
  AND resigned = 1
  AND performance_score >= 4
  AND years_at_company >= 6
  AND sick_days > 5
  AND overtime_hours >= 20
  AND job_title = 'Engineer';

-- Mid-Level Average Specialist (Active)
SELECT *
FROM employee_performance
WHERE years_at_company BETWEEN 3 AND 5
  AND overtime_hours >= 20
  AND resigned = 0
  AND employee_satisfaction_score < 3
  AND sick_days > 5
  AND performance_score = 3
  AND job_title = 'Specialist';

-- Entry-Level Low-Satisfaction Technician/Developer
SELECT *
FROM employee_performance
WHERE years_at_company <= 2
  AND overtime_hours >= 20
  AND performance_score <= 3
  AND job_title IN ('Technician', 'Developer')
  AND gender = 'Other'
  AND employee_satisfaction_score < 3;

-----------------------------------------------------------
-- 13. Overall burnout rate
-----------------------------------------------------------
SELECT
    COUNT(*) AS burned,
    (SELECT COUNT(*) FROM employee_performance) AS total_employees,
    100.0 * COUNT(*) / (SELECT COUNT(*) FROM employee_performance) AS burnout_rate
FROM employee_performance
WHERE employee_satisfaction_score < 3
  AND overtime_hours >= 20
  AND sick_days > 5;
