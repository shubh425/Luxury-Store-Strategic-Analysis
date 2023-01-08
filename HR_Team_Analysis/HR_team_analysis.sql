-- Find the number of employees working in the ‘Sales’ department. (Use sub-query).

SELECT count(DISTINCT EMPLOYEE_ID) as Employee_count
FROM employees_data
WHERE DEPARTMENT_ID = (
						SELECT DEPARTMENT_ID
						FROM department_data
						WHERE DEPARTMENT_NAME = 'Sales');


-- Join the 3 tables and find the country-id wise count of employees and the avg salary.

SELECT l.COUNTRY_ID,
		COUNT(e.EMPLOYEE_ID) as Employee_count,
		AVG(e.SALARY) as Avg_salary
FROM employees_data e
LEFT JOIN department_data d
		ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
LEFT JOIN locations_data l
		ON d.LOCATION_ID = l.LOCATION_ID
GROUP BY l.COUNTRY_ID;


-- Which country has the maximum average salary?

WITH country as
(
SELECT l.COUNTRY_ID,
		COUNT(e.EMPLOYEE_ID) as Employee_count,
		AVG(e.SALARY) as Avg_salary
FROM employees_data e
LEFT JOIN department_data d
		ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
LEFT JOIN locations_data l
		ON d.LOCATION_ID = l.LOCATION_ID
GROUP BY l.COUNTRY_ID
)
SELECT COUNTRY_ID, Avg_salary
FROM country
WHERE Avg_salary = (SELECT MAX(Avg_salary) FROM country)

-- DE has maximum average salary - 10000


--Which country has the maximum number of employees?

WITH country as
(
SELECT l.COUNTRY_ID,
		COUNT(e.EMPLOYEE_ID) as Employee_count,
		AVG(e.SALARY) as Avg_salary
FROM employees_data e
LEFT JOIN department_data d
		ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
LEFT JOIN locations_data l
		ON d.LOCATION_ID = l.LOCATION_ID
GROUP BY l.COUNTRY_ID
)

SELECT COUNTRY_ID, Employee_count
FROM country
WHERE Employee_count = (SELECT MAX(Employee_count) FROM country);

-- US with maximum number of employees - 68


--Find the top 5 managers according to their salary
SELECT TOP 5 EMPLOYEE_ID,
			CONCAT(FIRST_NAME,' ',LAST_NAME) as MANAGER_NAME,
			SALARY
FROM employees_data
WHERE EMPLOYEE_ID in (
			SELECT distinct MANAGER_ID
			FROM [hr].[dbo].[department_data]
			UNION
			SELECT distinct MANAGER_ID
			FROM [hr].[dbo].[employees_data]
			)
ORDER BY SALARY DESC;


--Find the department name-wise percentage of employees working under each department.
--Which department is having the maximum percentage of employees?

SELECT DEPARTMENT_NAME,
	round(100*CAST(COUNT(EMPLOYEE_ID) as FLOAT)/SUM(COUNT(*)) OVER(),2)  as percentage
FROM employees_data e
LEFT JOIN department_data d
		ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME
ORDER BY percentage DESC

