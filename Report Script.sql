--TEST REPORTS SCRIPTS
SET SERVEROUTPUT ON;
select * from Employees;
select * from Departments;

---------------------------------------------------------------------------------
-- Call the Add_Employee procedure to add a new employee
---------------------------------------------------------------------------------
BEGIN
    Employee_Management.Add_Employee(
        p_Employee_Id => 90011,
        p_Employee_Name => 'Wennie Dianon',
        p_Job_Title => 'IT Analyst',
        p_Manager_Id => 90001, 
        p_Date_Hired => TO_DATE('08/08/2024', 'DD/MM/YYYY'),
        p_Salary => 98000,
        p_Department_Id => 2
    );
END;


---------------------------------------------------------------------------------
-- Call the Adjust_Employee_Salary procedure to increase the salary by 20%
---------------------------------------------------------------------------------
BEGIN
    Employee_Management.Adjust_Employee_Salary(
        p_Employee_Id => 90011,  -- Assuming 90002 is a valid Employee_Id
        p_Percentage => 20       -- Increase salary by 20%
    );
END;
/

-- Call the Adjust_Employee_Salary procedure to decrease the salary by 15%
BEGIN
    Employee_Management.Adjust_Employee_Salary(
        p_Employee_Id => 90011,  -- Assuming 90003 is a valid Employee_Id
        p_Percentage => -15      -- Decrease salary by 15%
    );
END;
/


---------------------------------------------------------------------------------
-- Call the Transfer_Employee_Department procedure to transfer an employee
---------------------------------------------------------------------------------
BEGIN
    Employee_Management.Transfer_Employee_Department(
        p_Employee_Id => 900011,       -- Assuming 90003 is a valid Employee_Id
        p_New_Department_Id => 2      -- Transfer to department 2
    );
END;
/


---------------------------------------------------------------------------------
-- Call the Get_Employee_Salary function to get the salary of an employee
--------------------------------------------------------------------------------- 
DECLARE
    v_Salary Employees.Salary%TYPE;
BEGIN
    v_Salary := Employee_Management.Get_Employee_Salary(90003); -- Assuming 90003 is a valid Employee_Id
    DBMS_OUTPUT.PUT_LINE('The salary of employee 90003 is ' || v_Salary);
END;
/

---------------------------------------------------------------------------------
-- Report_Employees_By_Department 
---------------------------------------------------------------------------------
--Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- Call the Report_Employees_By_Department procedure to generate a report for department 2
BEGIN
    Employee_Management.Report_Employees_By_Department(p_Department_Id => 2);
END;
/


---------------------------------------------------------------------------------
-- Total_Salary_By_Department  
---------------------------------------------------------------------------------
-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- Call the Total_Salary_By_Department procedure to calculate the total salary for department 2
BEGIN
    Employee_Management.Total_Salary_By_Department(p_Department_Id => 2);
END;
/




