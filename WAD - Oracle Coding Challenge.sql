/*
******************************************************
BUILD / RUN INSTRUCTIONS:
-- Widget Ltd 
-- MVP (Filing System Build 1.00)

Prerequisites
- Windows 11 Ver. 23H2 (OS Build 22631.3737)
- Oracle 12c Database must be installed
- SQL*Plus or Oracle SQL Developer
- DB User with Appropriate Privileges
******************************************************
*/

/* 
1.)
-- OPEN SQL*Plus or Oracle SQL Developer:
--Set up connection and connect to your database
*/


/*
2.) DDL
*/
	------------------------------------------------------
	--2.1 Create the Departments table
	------------------------------------------------------
	CREATE TABLE Departments (
		Department_Id NUMBER(5) CONSTRAINT dept_id_pk PRIMARY KEY,
		Department_Name VARCHAR2(50) NOT NULL,
		Location VARCHAR2(50) NOT NULL
	);

	-- Add comments to the columns
	COMMENT ON COLUMN Departments.Department_Id IS 'The unique identifier for the department';
	COMMENT ON COLUMN Departments.Department_Name IS 'The name of the department';
	COMMENT ON COLUMN Departments.Location IS 'The physical location of the department';

	------------------------------------------------------
	--2.2 Create the Employees table
	------------------------------------------------------
	CREATE TABLE Employees (
		Employee_Id NUMBER(10) CONSTRAINT emp_id_pk PRIMARY KEY,
		Employee_Name VARCHAR2(50) NOT NULL,
		Job_Title VARCHAR2(50) NOT NULL,
		Manager_Id NUMBER(10),
		Date_Hired DATE NOT NULL,
		Salary NUMBER(10) NOT NULL,
		Department_Id NUMBER(5) NOT NULL,
		CONSTRAINT dept_id_fk FOREIGN KEY (Department_Id) REFERENCES Departments(Department_Id)
	);

	-- Add comments to the columns
	COMMENT ON COLUMN Employees.Employee_Id IS 'The unique identifier for the employee';
	COMMENT ON COLUMN Employees.Employee_Name IS 'The name of the employee';
	COMMENT ON COLUMN Employees.Job_Title IS 'The job role undertaken by the employee. Some employees may undertaken the same job role';
	COMMENT ON COLUMN Employees.Manager_Id IS 'Line manager of the employee';
	COMMENT ON COLUMN Employees.Date_Hired IS 'The date the employee was hired';
	COMMENT ON COLUMN Employees.Salary IS 'Current salary of the employee';
	COMMENT ON COLUMN Employees.Department_Id IS 'Each employee must belong to a department';


/*
3.) DML
*/
	------------------------------------------------------
	--3.1 Insert data into the Departments table
	------------------------------------------------------
	INSERT INTO Departments (Department_Id, Department_Name, Location) VALUES (1, 'Management', 'London');
	INSERT INTO Departments (Department_Id, Department_Name, Location) VALUES (2, 'Engineering', 'Cardiff');
	INSERT INTO Departments (Department_Id, Department_Name, Location) VALUES (3, 'Research & Development', 'Edinburgh');
	INSERT INTO Departments (Department_Id, Department_Name, Location) VALUES (4, 'Sales', 'Belfast');
	
	------------------------------------------------------
	--3.2 Insert data into the Employees table
	------------------------------------------------------
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90001, 'John Smith', 'CEO', NULL, TO_DATE('01/01/1995', 'DD/MM/YYYY'), 100000, 1);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90002, 'Jimmy Willis', 'Manager', 90001, TO_DATE('23/09/2003', 'DD/MM/YYYY'), 52500, 4);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90003, 'Roxy Jones', 'Salesperson', 90002, TO_DATE('11/02/2017', 'DD/MM/YYYY'), 35000, 4);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90004, 'Selwyn Field', 'Salesperson', 90003, TO_DATE('20/05/2015', 'DD/MM/YYYY'), 32000, 4);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90005, 'David Hallett', 'Engineer', 90006, TO_DATE('17/04/2018', 'DD/MM/YYYY'), 40000, 2);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90006, 'Sarah Phelps', 'Manager', 90001, TO_DATE('21/03/2015', 'DD/MM/YYYY'), 45000, 2);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90007, 'Louise Harper', 'Engineer', 90006, TO_DATE('01/01/2013', 'DD/MM/YYYY'), 47000, 2);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90008, 'Tina Hart', 'Engineer', 90009, TO_DATE('28/07/2014', 'DD/MM/YYYY'), 45000, 3);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90009, 'Gus Jones', 'Manager', 90001, TO_DATE('15/05/2018', 'DD/MM/YYYY'), 50000, 3);
	INSERT INTO Employees (Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id) VALUES (90010, 'Mildred Hall', 'Secretary', 90001, TO_DATE('12/10/1996', 'DD/MM/YYYY'), 35000, 1);

/*
4.) CREATE Employee_Management PACKAGE (MVP)
*/
	------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------- Package Specification: Employee_Management --------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------
	CREATE OR REPLACE PACKAGE Employee_Management AS
		PROCEDURE Add_Employee(
			p_Employee_Id IN Employees.Employee_Id%TYPE,
			p_Employee_Name IN Employees.Employee_Name%TYPE,
			p_Job_Title IN Employees.Job_Title%TYPE,
			p_Manager_Id IN Employees.Manager_Id%TYPE,
			p_Date_Hired IN Employees.Date_Hired%TYPE,
			p_Salary IN Employees.Salary%TYPE,
			p_Department_Id IN Employees.Department_Id%TYPE
		);
		PROCEDURE Adjust_Employee_Salary(p_Employee_Id IN Employees.Employee_Id%TYPE, p_Percentage IN NUMBER);
		PROCEDURE Transfer_Employee_Department(p_Employee_Id IN Employees.Employee_Id%TYPE, p_New_Department_Id IN Employees.Department_Id%TYPE);
		FUNCTION Get_Employee_Salary(p_Employee_Id IN Employees.Employee_Id%TYPE) RETURN Employees.Salary%TYPE;
		PROCEDURE Report_Employees_By_Department(p_Department_Id IN Employees.Department_Id%TYPE);
		PROCEDURE Total_Salary_By_Department(p_Department_Id IN Employees.Department_Id%TYPE);
	END Employee_Management;
	/
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------ Package Body: Employee_Management -------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	CREATE OR REPLACE PACKAGE BODY Employee_Management AS
		------------------------------------------------------
		-- 4.1 ADD EMPLOYEE PACKAGE : a stored procedure to add a new employee
		------------------------------------------------------ 
		PROCEDURE Add_Employee (
					p_Employee_Id IN Employees.Employee_Id%TYPE,
					p_Employee_Name IN Employees.Employee_Name%TYPE,
					p_Job_Title IN Employees.Job_Title%TYPE,
					p_Manager_Id IN Employees.Manager_Id%TYPE,
					p_Date_Hired IN Employees.Date_Hired%TYPE,
					p_Salary IN Employees.Salary%TYPE,
					p_Department_Id IN Employees.Department_Id%TYPE
		) AS
		BEGIN
			-- Insert a new employee into the Employees table
			INSERT INTO Employees (
				Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary, Department_Id
			) VALUES (
				p_Employee_Id, p_Employee_Name, p_Job_Title, p_Manager_Id, p_Date_Hired, p_Salary, p_Department_Id
			);

			COMMIT;
			
			DBMS_OUTPUT.PUT_LINE('Employee ' || p_Employee_Name || ' has been successfully added.');
		END Add_Employee;

		
		------------------------------------------------------
		-- 4.2 ADJUST EMPLOYEE SALARY PROCEDURE : a stored procedure to adjust an employee's salary
		------------------------------------------------------ 
		PROCEDURE Adjust_Employee_Salary (
									p_Employee_Id IN Employees.Employee_Id%TYPE,
									p_Percentage IN NUMBER
		) AS
			v_Current_Salary Employees.Salary%TYPE;
			v_New_Salary Employees.Salary%TYPE;
		BEGIN
			-- Retrieve the current salary of the employee
			SELECT Salary INTO v_Current_Salary
			FROM Employees
			WHERE Employee_Id = p_Employee_Id;

			-- Calculate the new salary
			v_New_Salary := v_Current_Salary + (v_Current_Salary * (p_Percentage / 100));

			-- Update the employee's salary
			UPDATE Employees
			SET Salary = v_New_Salary
			WHERE Employee_Id = p_Employee_Id;

			COMMIT;

			DBMS_OUTPUT.PUT_LINE('Employee ' || p_Employee_Id || ' salary has been adjusted to ' || v_New_Salary);
		END Adjust_Employee_Salary;

		
		------------------------------------------------------
		-- 4.3 TRANSFER EMPLOYEE PROCEDURE :  a stored procedure to transfer an employee to a different department
		------------------------------------------------------ 
		PROCEDURE Transfer_Employee_Department (
									p_Employee_Id IN Employees.Employee_Id%TYPE,
									p_New_Department_Id IN Employees.Department_Id%TYPE
		) AS
			v_Employee_Name Employees.Employee_Name%TYPE;
		BEGIN
			-- Retrieve the name of the employee
			SELECT Employee_Name INTO v_Employee_Name
			FROM Employees
			WHERE Employee_Id = p_Employee_Id;

			-- Update the employee's department
			UPDATE Employees
			SET Department_Id = p_New_Department_Id
			WHERE Employee_Id = p_Employee_Id;

			COMMIT;

			DBMS_OUTPUT.PUT_LINE('Employee ' || v_Employee_Name || ' has been transferred to department ' || p_New_Department_Id);
		END Transfer_Employee_Department;

		
		------------------------------------------------------
		-- 4.4 EMPLOYEE SALARY FUNCTION :  a stored procedure to transfer an employee to a different department
		------------------------------------------------------ 
		FUNCTION Get_Employee_Salary (p_Employee_Id IN Employees.Employee_Id%TYPE
									) RETURN Employees.Salary%TYPE
		AS
			v_Salary Employees.Salary%TYPE;
		BEGIN
			-- Retrieve the salary of the employee
			SELECT Salary INTO v_Salary
			FROM Employees
			WHERE Employee_Id = p_Employee_Id;

			-- Return the salary
			RETURN v_Salary;
		END Get_Employee_Salary;

		
		------------------------------------------------------
		-- 4.5 EMPLOYEES REPORT (DEPARTMENT) : a stored procedure to Generate Report of Employees for a Department
		------------------------------------------------------
		PROCEDURE Report_Employees_By_Department (
									p_Department_Id IN Employees.Department_Id%TYPE
		) AS
		BEGIN
			-- Cursor to fetch employees in the specified department
			FOR employee IN (
				SELECT Employee_Id, Employee_Name, Job_Title, Manager_Id, Date_Hired, Salary
				FROM Employees
				WHERE Department_Id = p_Department_Id
				ORDER BY Employee_Id
			) LOOP
				-- Output employee details
				DBMS_OUTPUT.PUT_LINE('Employee Id: ' || employee.Employee_Id);
				DBMS_OUTPUT.PUT_LINE('Employee Name: ' || employee.Employee_Name);
				DBMS_OUTPUT.PUT_LINE('Job Title: ' || employee.Job_Title);
				IF employee.Manager_Id IS NOT NULL THEN
					DBMS_OUTPUT.PUT_LINE('Manager Id: ' || employee.Manager_Id);
				ELSE
					DBMS_OUTPUT.PUT_LINE('Manager Id: None');
				END IF;
				DBMS_OUTPUT.PUT_LINE('Date Hired: ' || TO_CHAR(employee.Date_Hired, 'DD/MM/YYYY'));
				DBMS_OUTPUT.PUT_LINE('Salary: ' || employee.Salary);
				DBMS_OUTPUT.PUT_LINE('------------------------------------');
			END LOOP;
		END Report_Employees_By_Department;

		
		------------------------------------------------------
		-- 4.6 EMPLOYEE SALARY REPORT on DEPARTMENT : a stored procedure to Calculate Total Employee Salary for a Department
		------------------------------------------------------
		PROCEDURE Total_Salary_By_Department (
									p_Department_Id IN Employees.Department_Id%TYPE
		) AS
			v_Total_Salary NUMBER := 0;
		BEGIN
			-- Calculate the total salary of employees in the specified department
			SELECT SUM(Salary) INTO v_Total_Salary
			FROM Employees
			WHERE Department_Id = p_Department_Id;

			-- Output the total salary
			DBMS_OUTPUT.PUT_LINE('Total Salary for Department ' || p_Department_Id || ': ' || v_Total_Salary);
		END Total_Salary_By_Department;

	END Employee_Management;
	/