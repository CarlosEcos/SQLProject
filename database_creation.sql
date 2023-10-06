USE master;
GO

DROP DATABASE IF EXISTS Employees;
GO

CREATE DATABASE Employees;
GO

USE Employees;
GO

CREATE TABLE employees
(
	emp_no		INT			NOT NULL,
	birth_date	DATE		NOT NULL,
	first_name	VARCHAR(16) NOT NULL,
	last_name	VARCHAR(16) NOT NULL,
	gender		CHAR(1)		NOT NULL CHECK(gender IN ('M', 'F')),
	hire_date	DATE		NOT NULL,
	CONSTRAINT PK_employees PRIMARY KEY (emp_no)
);

CREATE TABLE departments
(
	dept_no		CHAR(4)		NOT NULL,
	dept_name	VARCHAR(40) NOT NULL,
	CONSTRAINT PK_departments	PRIMARY KEY (dept_no),
	CONSTRAINT UC_dept_name	UNIQUE (dept_name)
);

CREATE TABLE dept_manager
(
	emp_no		INT			NOT NULL,
	dept_no		CHAR(4)		NOT NULL,
	from_date	DATE		NOT NULL,
	to_date		DATE		NOT NULL,
	CONSTRAINT PK_dept_manager	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no) ON DELETE CASCADE,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no) ON DELETE CASCADE
);

CREATE TABLE dbo.dept_emp
(
	emp_no		INT			NOT NULL,
	dept_no		CHAR(4)		NOT NULL,
	from_date	DATE		NOT NULL,
	to_date		DATE		NOT NULL,
	CONSTRAINT PK_dept_emp	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no) ON DELETE CASCADE,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no) ON DELETE CASCADE,
);

CREATE TABLE titles
(
	emp_no		INT			NOT NULL,
	title		VARCHAR(50)	NOT NULL,
	from_date	DATE		NOT NULL,
	to_date		DATE		NOT NULL,
	CONSTRAINT PK_titles	PRIMARY KEY (emp_no, from_date),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no) ON DELETE CASCADE
);

CREATE TABLE salaries
(
	emp_no		INT			NOT NULL,
	salary		INT			NOT NULL,
	from_date	DATE		NOT NULL,
	to_date		DATE		NOT NULL,
	CONSTRAINT PK_salaries	PRIMARY KEY	(emp_no, from_date),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no) ON DELETE CASCADE
);
GO

ALTER TABLE salaries
ALTER COLUMN salary MONEY NOT NULL;
GO

CREATE VIEW dept_emp_latest_date AS
SELECT
	emp_no,
	MAX(from_date) AS from_date,
	MAX(to_date) AS to_date
FROM dept_emp
GROUP BY emp_no;
GO

CREATE VIEW current_dept_emp AS
SELECT
	l.emp_no,
	d.dept_no,
	l.from_date,
	l.to_date
FROM dept_emp d
INNER JOIN dept_emp_latest_date l
ON d.emp_no = l.emp_no 
	AND d.from_date = l.from_date 
	AND d.to_date = l.to_date;
GO