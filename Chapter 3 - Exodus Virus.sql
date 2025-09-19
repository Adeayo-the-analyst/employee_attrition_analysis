-- =================================================================================
-- Chapter 3: The High Project Workload Paradox
-- Purpose: Examine how project workloads influence resignations, promotions, 
--          and employee satisfaction. Identify the paradox where moderate workloads 
--          trigger the highest attrition.
-- =================================================================================

-- 1. Classify employees by project workload
SELECT 
    employee_id,
    years_at_company,
    projects_handled,
    CASE    
        WHEN projects_handled >= 36 THEN 'Very High'
        WHEN projects_handled BETWEEN 26 AND 35 THEN 'High'
        WHEN projects_handled BETWEEN 16 AND 25 THEN 'Medium'
        WHEN projects_handled BETWEEN 6 AND 15 THEN 'Low'
        ELSE 'Very Low'
    END AS project_workload
FROM employee_performance
WHERE resigned = 1
ORDER BY CASE    
        WHEN projects_handled >= 36 THEN 1
        WHEN projects_handled BETWEEN 26 AND 35 THEN 2
        WHEN projects_handled BETWEEN 16 AND 25 THEN 3
        WHEN projects_handled BETWEEN 6 AND 15 THEN 4
        ELSE 5
    END;

-- 2. Resignations by project workload category
SELECT
    CASE    
        WHEN projects_handled >= 36 THEN 'Very High'
        WHEN projects_handled BETWEEN 26 AND 35 THEN 'High'
        WHEN projects_handled BETWEEN 16 AND 25 THEN 'Medium'
        WHEN projects_handled BETWEEN 6 AND 15 THEN 'Low'
        ELSE 'Very Low'
    END AS project_workload,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1 
GROUP BY CASE    
        WHEN projects_handled >= 36 THEN 'Very High'
        WHEN projects_handled BETWEEN 26 AND 35 THEN 'High'
        WHEN projects_handled BETWEEN 16 AND 25 THEN 'Medium'
        WHEN projects_handled BETWEEN 6 AND 15 THEN 'Low'
        ELSE 'Very Low'
    END
ORDER BY resignations DESC;

-- 3. High project load and promotion likelihood
SELECT
    COUNT(employee_id) AS total_numbers
FROM employee_performance
WHERE resigned = 1
  AND projects_handled >= 36
  AND promotions = 0;

-- 4. Resignations by exact project count
SELECT
    projects_handled,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY projects_handled
ORDER BY resignations DESC;

-- 5. Promotion vs resignation by workload
SELECT
    CASE    
        WHEN projects_handled >= 36 THEN 'Very High'
        WHEN projects_handled BETWEEN 26 AND 35 THEN 'High'
        WHEN projects_handled BETWEEN 16 AND 25 THEN 'Medium'
        WHEN projects_handled BETWEEN 6 AND 15 THEN 'Low'
        ELSE 'Very Low'
    END AS project_workload,
    CASE
        WHEN promotions = 0 THEN 'Not Promoted'
        ELSE 'Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY 
    CASE    
        WHEN projects_handled >= 36 THEN 'Very High'
        WHEN projects_handled BETWEEN 26 AND 35 THEN 'High'
        WHEN projects_handled BETWEEN 16 AND 25 THEN 'Medium'
        WHEN projects_handled BETWEEN 6 AND 15 THEN 'Low'
        ELSE 'Very Low'
    END,
    CASE
        WHEN promotions = 0 THEN 'Not Promoted'
        ELSE 'Promoted'
    END
ORDER BY resignations DESC;

-- 6. Categorize workload threat levels
SELECT
    CASE
        WHEN projects_handled >= 42 THEN 'Burnout'
        WHEN projects_handled BETWEEN 31 AND 41 THEN 'Pressure Zone'
        WHEN projects_handled BETWEEN 11 AND 30 THEN 'Stable'
        WHEN projects_handled BETWEEN 5 AND 10 THEN 'Stagnant'
        ELSE 'Underutilized'
    END AS threat_level,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    CASE
        WHEN projects_handled >= 42 THEN 'Burnout'
        WHEN projects_handled BETWEEN 31 AND 41 THEN 'Pressure Zone'
        WHEN projects_handled BETWEEN 11 AND 30 THEN 'Stable'
        WHEN projects_handled BETWEEN 5 AND 10 THEN 'Stagnant'
        ELSE 'Underutilized'
    END
ORDER BY resignations DESC;

-- 7. Average projects handled by performance tier (resigned employees)
SELECT
    CASE 
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END AS performance_tier,
    AVG(projects_handled) AS average_projects
FROM employee_performance
WHERE resigned = 1
GROUP BY CASE 
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END;

-- 8. Compare resigned vs active employees by performance tier and projects
SELECT
    CASE
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END AS performance_tier,
    SUM(projects_handled) AS total_projects
FROM employee_performance
WHERE resigned = 0
GROUP BY CASE
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END
ORDER BY total_projects DESC;

-- 9. Promotions among stable workload category
SELECT
    CASE
        WHEN promotions = 0 THEN 'Not Promoted'
        ELSE 'Promoted'
    END AS promotion_status,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
  AND projects_handled BETWEEN 11 AND 30
GROUP BY CASE
        WHEN promotions = 0 THEN 'Not Promoted'
        ELSE 'Promoted'
    END
ORDER BY resignations DESC;

-- 10. Workload, promotion, and satisfaction relationship
SELECT
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END AS satisfaction_level,
    CASE
        WHEN projects_handled >= 36 THEN 'Very High'
        WHEN projects_handled BETWEEN 26 AND 35 THEN 'High'
        WHEN projects_handled BETWEEN 16 AND 25 THEN 'Medium'
        WHEN projects_handled BETWEEN 6 AND 15 THEN 'Low'
        ELSE 'Very Low'
    END AS project_workload,
    COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
    CASE
        WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
        WHEN employee_satisfaction_score = 3 THEN 'Average'
        ELSE 'Low Satisfaction'
    END,
    CASE
        WHEN projects_handled >= 36 THEN 'Very High'
        WHEN projects_handled BETWEEN 26 AND 35 THEN 'High'
        WHEN projects_handled BETWEEN 16 AND 25 THEN 'Medium'
        WHEN projects_handled BETWEEN 6 AND 15 THEN 'Low'
        ELSE 'Very Low'
    END
ORDER BY resignations DESC;

-- Do longer work hours correlate with lower satisfaction? 
SELECT
	MIN(work_hours_per_week) AS minimum,
	MAX(work_hours_per_week) AS maximum,
	AVG(work_hours_per_week) AS average
FROM employee_performance
WHERE resigned = 1;

SELECT
	CASE	
		WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
		WHEN employee_satisfaction_score = 3 THEN 'Average'
		ELSE 'Low Satisfaction'
	END AS satisfaction_category,
	AVG(work_hours_per_week) AS average_hours
FROM employee_performance
WHERE resigned = 1
GROUP BY
	CASE	
		WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
		WHEN employee_satisfaction_score = 3 THEN 'Average'
		ELSE 'Low Satisfaction'
	END
ORDER BY average_hours DESC;

-- Is work hours tied to performance?

SELECT
	CASE	
		WHEN performance_score >= 4 THEN 'High Performer'
		WHEN performance_score = 3 THEN 'Average'
		ELSE 'Low Performer'
	END AS satisfaction_category,
	AVG(work_hours_per_week) AS average_hours
FROM employee_performance
WHERE resigned = 1
GROUP BY
	CASE	
		WHEN performance_score >= 4 THEN 'High Performer'
		WHEN performance_score = 3 THEN 'Average'
		ELSE 'Low Performer'
	END
ORDER BY average_hours DESC;

-- Is performance correlated to total_hours_spent?
SELECT
	CASE	
		WHEN performance_score >= 4 THEN 'High Performer'
		WHEN performance_score = 3 THEN 'Average'
		ELSE 'Low Performer'
	END AS performance_tier,
	SUM(work_hours_per_week) AS total_hours_spent
FROM employee_performance
WHERE resigned = 1
GROUP BY 
	CASE	
		WHEN performance_score >= 4 THEN 'High Performer'
		WHEN performance_score = 3 THEN 'Average'
		ELSE 'Low Performer'
	END
ORDER BY total_hours_spent DESC;


/* What of satisfaction?*/
SELECT
	CASE
		WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
		WHEN employee_satisfaction_score = 3 THEN 'Average'
		ELSE 'Low Satisfaction'
	END AS satisfaction_category,
	SUM(work_hours_per_week) AS total_hours_spent
FROM employee_performance
WHERE resigned = 1
GROUP BY
	CASE
		WHEN employee_satisfaction_score >= 4 THEN 'Highly Satisfied'
		WHEN employee_satisfaction_score = 3 THEN 'Average'
		ELSE 'Low Satisfaction'
	END 
ORDER BY total_hours_spent DESC;

-- Look at overtime hours.
SELECT
	MIN(overtime_hours) AS minimum_overtime,
	MAX(overtime_hours) AS maximum_overtime,
	AVG(overtime_hours) AS average_overtime
FROM employee_performance
WHERE resigned = 1;

SELECT
	CASE
		WHEN overtime_hours >= 20 THEN 'High'
		WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
		WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
		ELSE 'None'
	END AS overtime_category,
	COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY 
	CASE
		WHEN overtime_hours >= 20 THEN 'High'
		WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
		WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
		ELSE 'None'
	END
ORDER BY resignations DESC;


-- Are employees with higher overtime less satisfed?
SELECT
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
	COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY 
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
	END
ORDER BY resignations DESC;

-- Do high performers do overtime?
SELECT
	CASE
		WHEN overtime_hours >= 20 THEN 'High'
		WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
		ELSE 'None'
	END AS overtime_category,
	CASE
		WHEN performance_score >= 4 THEN 'High Performer'
		WHEN performance_score = 3 THEN 'Average'
		ELSE 'Low Performer'
	END AS performance_tier,
	COUNT(*) AS resignations
FROM employee_performance
WHERE resigned = 1
GROUP BY
	CASE
		WHEN overtime_hours >= 20 THEN 'High'
		WHEN overtime_hours BETWEEN 10 AND 19 THEN 'Medium'
		WHEN overtime_hours BETWEEN 1 AND 9 THEN 'Low'
		ELSE 'None'
	END,
	CASE
		WHEN performance_score >= 4 THEN 'High Performer'
		WHEN performance_score = 3 THEN 'Average'
		ELSE 'Low Performer'
	END
ORDER BY resignations DESC;


-- =================================================================================
-- Chapter 3: Personas
-- Purpose: Identify key employee personas contributing to the High Project Workload Paradox.
-- =================================================================================

/* Persona A: High Performer, Highly Satisfied, High Workload Employee */
-- Attributes:
-- Performance: High
-- Satisfaction: Highly Satisfied
-- Department/Job Title: Finance Engineer or IT Specialist
-- Workload: Heavy (Pressure Zone, 31-41 projects)
SELECT
    employee_id,
    department,
    job_title
FROM employee_performance
WHERE projects_handled BETWEEN 31 AND 42
  AND resigned = 1
  AND department = 'Finance'
  AND performance_score >= 4
  AND employee_satisfaction_score >= 4;

/* Persona B: High Performers Who Were Not Promoted */
-- Key Attributes:
-- Job Titles: Engineer, Developer, Analyst, Manager
-- Departments: Finance, IT, Engineering, Sales
-- Education: Bachelor, Master, PhD
-- Overtime: Medium-High (10-20 hours)
-- Satisfaction: Low-Average (<=3)
SELECT *
FROM employee_performance
WHERE resigned = 1
  AND employee_id = 21239
  AND promotions = 0
  AND department IN ('Finance', 'IT', 'Engineering', 'Sales')
  AND job_title IN ('Engineer', 'Developer', 'Analyst', 'Manager')
  AND overtime_hours BETWEEN 10 AND 20
  AND education_level IN ('Bachelor', 'Master', 'PhD')
  AND performance_score >= 4
  AND employee_satisfaction_score <= 3;

/* Persona C: Low Performer Who Got Promoted */
-- Key Attributes:
-- Job Titles: Specialist, Technician, Manager
-- Departments: Sales, HR, Marketing
-- Education: High School, Bachelor
-- Satisfaction: Low (<=3)
-- Overtime: 1-19 hours
-- Performance: Low (<3)
SELECT *
FROM employee_performance
WHERE resigned = 1
  AND promotions = 1
  AND employee_id = 10119
  AND job_title IN ('Specialist', 'Technician', 'Manager')
  AND department IN ('Sales', 'HR', 'Marketing')
  AND education_level IN ('High School', 'Bachelor')
  AND employee_satisfaction_score <= 3
  AND overtime_hours BETWEEN 1 AND 19
  AND performance_score < 3;

/* Persona D: High Performers Who Were Promoted */
-- Key Attributes:
-- Job Titles: Manager, Engineer, Analyst, Developer
-- Departments: Engineering, IT, Finance
-- Education: Bachelor, Master, PhD
-- Overtime: Medium-High (>=10 hours)
-- Satisfaction: Average-High (>=3)
-- Performance: High (>=4)
SELECT *
FROM employee_performance
WHERE resigned = 1
  AND promotions = 1
  AND employee_id = 53493
  AND job_title IN ('Manager', 'Engineer', 'Analyst', 'Developer')
  AND department IN ('Engineering', 'IT', 'Finance')
  AND education_level IN ('Bachelor', 'Master', 'PhD')
  AND overtime_hours >= 10
  AND employee_satisfaction_score >= 3
  AND performance_score >= 4;

/* Aggregate Project Workload by Performance Tier */
SELECT
    CASE
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END AS performance_tier,
    SUM(projects_handled) AS total_projects_handled
FROM employee_performance
GROUP BY CASE
        WHEN performance_score >= 4 THEN 'High Performer'
        WHEN performance_score = 3 THEN 'Average'
        ELSE 'Low Performer'
    END;

/* Persona E: Disillusioned Stable Contributor */
-- Attributes:
-- Workload: Medium-Stable (11-30 projects)
-- Resigned: Yes
-- Promotions: None
-- Satisfaction: Average (3)
-- Performance: High (>=4)
SELECT *
FROM employee_performance
WHERE projects_handled BETWEEN 11 AND 30
  AND resigned = 1
  AND promotions = 0
  AND employee_satisfaction_score = 3
  AND performance_score >= 4;

/* Additional exploratory queries */
SELECT *
FROM employee_performance
WHERE employee_id = '80966';

SELECT DISTINCT department
FROM employee_performance;
