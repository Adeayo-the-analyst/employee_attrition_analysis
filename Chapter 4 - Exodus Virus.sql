-- =================================================================================
-- Chapter 4: Promotion-Performance Disconnect
-- Purpose: Explore how promotions are distributed across performance, education,
--          overtime, satisfaction, and department. Investigates whether high
--          performance actually correlates with promotion.
-- =================================================================================

/* 1. Is education linked to promotion? */
SELECT
    education_level,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
GROUP BY
    education_level,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY resignations DESC;

/* 2. Promotion rate for current staff */
SELECT
    SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) AS promoted_employees,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS promotion_rate_percent
FROM employee_performance
WHERE resigned = 0;

/* 3. Overall promotion rate in company */
SELECT
    SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) AS promoted_employees,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS promotion_rate_percent
FROM employee_performance;

/* 4. Promotion status of resigned employees */
SELECT
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations,
    SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) * 100 / 10010 AS promotion_rate
FROM employee_performance
WHERE resigned = 1
GROUP BY 
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END;

/* 5. Promotion rate of resigned employees */
SELECT
    SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) AS promoted_employees,
    COUNT(*) AS total_employees,
    ROUND(SUM(CASE WHEN promotions >= 1 THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS promotion_rate_percent
FROM employee_performance
WHERE resigned = 1;

/* 6. Promotion by education level among resigned employees */
SELECT
    education_level,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    education_level,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY resignations DESC;

/* 7. Resignations per education level */
SELECT
    education_level,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY education_level
ORDER BY resignations DESC;

/* 8. Does promotion favor high performers regardless of education? */
SELECT
    education_level,
    CASE
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END AS performance_tier,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    education_level,
    CASE
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY resignations DESC;

/* 9. Combining overtime, satisfaction, and promotion for resigned employees */
SELECT
    department,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END AS overtime_category,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_category,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    department,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY resignations DESC;

/* 10. Education + Overtime + Satisfaction + Promotion */
SELECT
    education_level,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END AS overtime_category,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_category,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    education_level,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY resignations DESC;

/* 11. Department breakdown + Overtime + Satisfaction + Promotion */
SELECT
    department,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END AS overtime_category,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_category,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    department,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY resignations DESC;

/* 12. Job Title + Department breakdown */
SELECT
    department,
    job_title,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END AS overtime_category,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_category,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    department,
    job_title,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY resignations DESC;

/* 13. Average resignations per department and job title */
SELECT
    department,
    job_title,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END AS overtime_category,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_category,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END AS promotion_status,
    AVG(CAST(resigned AS INT)) AS average_resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    department,
    job_title,
    CASE
        WHEN overtime_hours >= 20 THEN 'High'
        WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
        WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
        ELSE 'None'
    END,
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END,
    CASE
        WHEN promotions >= 1 THEN 'Promoted'
        ELSE 'Not Promoted'
    END
ORDER BY average_resignations DESC;
