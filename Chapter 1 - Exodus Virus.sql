/*
================================================================================
Chapter 1: Initial Resignation Exploration
Dataset: employee_performance
Purpose:
- Identify employees who resigned.
- Approximate resignation dates using Hire_Date + Years_At_Company.
- Examine resignation trends by month, quarter, and year.
================================================================================
*/

-- 1. Identify employees who resigned and approximate their resignation date.
-- Logic: No explicit resignation date exists, so we use hire_date + years_at_company as an approximation.
SELECT
    Employee_ID,
    Hire_Date,
    DATEADD(YEAR, Years_At_Company, Hire_Date) AS Resignation_Date,
    Resigned
FROM employee_performance
WHERE Resigned = 1;


-- 2. Resignations by month in 2024
-- Logic: Extract the month from the approximated resignation date to see peak resignation months.
SELECT
    DATENAME(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date)) AS Resignation_Month,
    COUNT(Resigned) AS Resignations
FROM employee_performance
WHERE Resigned = 1
  AND YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)) = 2024
GROUP BY DATENAME(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date)), 
         DATEPART(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date))
ORDER BY DATEPART(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date));


-- 3. Resignations by month in 2023
SELECT
    DATENAME(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date)) AS Resignation_Month,
    COUNT(Resigned) AS Resignations
FROM employee_performance
WHERE Resigned = 1
  AND YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)) = 2023
GROUP BY DATENAME(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date)),
         DATEPART(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date))
ORDER BY DATEPART(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date));


-- 4. Combined resignation trend for 2023 and 2024
-- Logic: Aggregate by month and year to observe overall attrition trends.
SELECT
    DATENAME(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date)) AS Resignation_Month,
    YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)) AS Resignation_Year,
    COUNT(Resigned) AS Resignations
FROM employee_performance
WHERE Resigned = 1
GROUP BY DATENAME(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date)),
         DATEPART(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date)),
         YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date))
ORDER BY YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)),
         DATEPART(MONTH, DATEADD(YEAR, Years_At_Company, Hire_Date));


-- 5. Yearly resignation totals for 2023 and 2024
-- Logic: Compare total resignations per year to gauge severity of attrition.
SELECT
    YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)) AS Resignation_Year,
    COUNT(Resigned) AS Resignations
FROM employee_performance
WHERE Resigned = 1
GROUP BY YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date))
ORDER BY YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)) DESC;


-- 6. Resignations by quarter
-- Logic: Observe seasonal trends and see which quarters experience highest attrition.
SELECT
    YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)) AS Resignation_Year,
    CONCAT('Q', DATEPART(QUARTER, DATEADD(YEAR, Years_At_Company, Hire_Date))) AS Resignation_Quarter,
    COUNT(*) AS Resignations
FROM employee_performance
WHERE Resigned = 1
GROUP BY YEAR(DATEADD(YEAR, Years_At_Company, Hire_Date)),
         CONCAT('Q', DATEPART(QUARTER, DATEADD(YEAR, Years_At_Company, Hire_Date)))
ORDER BY Resignation_Year,
         Resignation_Quarter;



