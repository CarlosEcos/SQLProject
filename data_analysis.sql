IF EXISTS(SELECT [name] FROM tempdb.sys.tables WHERE [name] like '#contract_data%') 
BEGIN
   DROP TABLE #contract_data;
END;

CREATE TABLE #contract_data (
	[Year]		INT,
	FirstName	VARCHAR(50),
	LastName	VARCHAR(50),
	FullName	VARCHAR(50),
	Department	VARCHAR(50),
	FromDate	DATE,
	ToDate		DATE,
	Age			INT,
	Gender		VARCHAR(10)
)
GO

INSERT INTO #contract_data
EXEC dbo.last_n_years_contract_data @n = 10
GO

-- Get the number of employees per year and gender

SELECT
	[Year],
	Gender,
	COUNT(*) AS [NumberOfEmployees]
FROM #contract_data
GROUP BY
	[Year],
	[Gender]


-- Average salary by department and gender

SELECT
	YEAR(de.from_date) AS [Year],
	d.dept_name AS [Department],
	CASE e.gender
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
	END AS [Gender],
	AVG(s.salary) AS [AvgSalary]
FROM dbo.salaries s
JOIN dbo.dept_emp de
	ON s.emp_no = de.emp_no
JOIN dbo.employees e
	ON s.emp_no = e.emp_no
JOIN dbo.departments d
	ON de.dept_no = d.dept_no
WHERE de.from_date <= s.to_date
	AND s.from_date <= de.to_date
GROUP BY
	e.gender,
	d.dept_name,
	YEAR(de.from_date)
ORDER BY
	[Year],
	[Department]


-- Number of employees per title and department

SELECT
	[Year],
	title AS [Title],
	dept_name AS [Department],
	COUNT(*) AS [NumberOfEmployees]
FROM
	(SELECT
		t.title,
		d.dept_name,
		de.emp_no,
		CASE
			WHEN t.from_date > de.from_date THEN YEAR(t.from_date)
			ELSE YEAR(de.from_date)
		END AS [Year]
	FROM dbo.titles t
	JOIN dbo.dept_emp de
		ON t.emp_no = de.emp_no
	JOIN dbo.departments d
		ON d.dept_no = de.dept_no
	WHERE t.from_date <= de.to_date
		AND de.from_date <= t.to_date) A
GROUP BY
	[Year],
	title,
	dept_name
ORDER BY
	[Year],
	[NumberOfEmployees] DESC