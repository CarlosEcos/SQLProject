USE Employees;
GO

-- PROCEDURE TO GET THE DATA OF EMPLOYEES AND THEIR JOBS IN THE LAST N YEARS

CREATE PROCEDURE dbo.last_n_years_contract_data
	@n INT
AS
BEGIN
	DECLARE @min_year INT
	
	BEGIN
		SELECT
			@min_year = MIN([Year])
		FROM (
			SELECT DISTINCT TOP (@n)
				YEAR(from_date) AS [Year]
			FROM dbo.dept_emp
			ORDER BY [Year] DESC) A
	END

	SELECT
		T2.[Year],
		e.first_name,
		e.last_name,
		e.first_name + ' ' + e.last_name AS [FullName],
		d.dept_name,
		T2.from_date,
		T2.to_date,
		T2.[Year] - YEAR(e.birth_date) AS [Age],
		CASE e.gender
			WHEN 'M' THEN 'Male'
			WHEN 'F' THEN 'Female'
		END AS [Gender]
	FROM (
		SELECT
			*
		FROM (
			SELECT
				*,
				CASE 
					WHEN YEAR(de.to_date) >= C.[Year] AND YEAR(de.from_date) <= C.[Year] THEN 1
					ELSE 0
				END AS active
			FROM (
				SELECT DISTINCT
					YEAR(from_date) AS [Year]
				FROM dbo.dept_emp
				WHERE YEAR(from_date) >= @min_year) C -- List of years
			CROSS JOIN (
				SELECT
					*
				FROM dbo.dept_emp
				WHERE YEAR(from_date) >= @min_year) de -- List of employees and their departments per contract
			) T1 -- List of all years and contracts 
		WHERE active = 1) T2 -- List of active years for each contract
	JOIN dbo.employees e -- Employees data
		ON T2.emp_no = e.emp_no
	JOIN dbo.departments d -- Departments data
		ON T2.dept_no = d.dept_no
END
GO
