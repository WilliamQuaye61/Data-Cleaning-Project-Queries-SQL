--NB:THE RESULT OF ANY QUERY WITH "GETDATE" IS SUBJECT TO CHANGE DEPENDING ON THE DATE IT IS EXECUTED AS GETDATE USES CURRENT TIME

-- Find the names of employees who are currently working on projects in the IT department.

select [Full Name]
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
where b.Department = 'IT' and project_status = 'Ongoing';

--List the project names and the corresponding start dates for all projects that are currently ongoing.

Select project_name ,Cast([start_date] as Date) as [Start_date]
from projects$ a 
join ['project_departments data$'] b
on a.project_id = b.project_id
where project_status = 'Ongoing'
Group by project_name,start_date;

--Retrieve the names and ages of employees who have resigned after working for more than 3 years

Select [Full Name], [Age], [Date Joined],[Date Resigned]
from ['Employees Data$']
where DATEDIFF(year,[Date Joined],[Date Resigned]) > 3

--Find the total salary paid to employees in the 'Finance' department.
Select Sum(salary) as Total_Salary_For_Finance
from ['Employees Data$']
where Department = 'Finance'

--List the project names and employee names for projects that started in 2024
Select project_name,[Full Name],Cast([start_date] as date)
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where Year([start_date]) = '2024'

--Retrieve the employee names and project names for employees who have worked on more than one project

With ProNumCTE as
(
Select [Employee ID],[Full Name],project_name, ROW_NUMBER () over (partition by employee_id order by employee_id) as Project_Num
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
)

select *--,[Full Name],project_name
from ProNumCTE
where Project_Num >1

-- Find the employees who are currently working in the 'Operations' department and have a performance level of 'Exceeds'
Select [Full Name]
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
where b.department = 'Operations' and project_status = 'Ongoing'

--Retrieve the names of employees who joined before 2023 and are working on ongoing projects

Select [Full Name]
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
where Year([Date Joined]) < '2023' and project_status = 'Ongoing'

--Find the employees who have worked on projects and in the 'Finance' or 'IT' departments

Select [Full Name]
from ['Employees Data$']
where Department = 'IT' or Department = 'Finance'

--Retrieve the names of employees who share the same last name as another employee, along with their respective departments

Select [Full Name],Department
From ['Employees Data$'] 
Where [Last Name] IN (
    Select [Last Name]
    from ['Employees Data$'] 
    Group by [Last Name]
    Having Count(*) > 1 )

--find employees whose performance level is higher than the average performance level in their respective departments



--find the top 3 departments with the highest average salary. Return the department and the average salary, rounded to 2 decimal places.

select Top 3 Department,Round(AVG(salary),2) as average_salary
from ['Employees Data$']
group by Department
order by average_salary desc

--find the project names and the total number of employees who have joined before the project start date. Return the project_name and the count of such employees.

Select project_name,Count([Employee ID]) as number_of_employees
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where [Date Joined] < start_date
group by project_name

--find the employees who have not been assigned to any project but not retired. Return the employee_id, first_name, last_name, and department.

SELECT *
FROM ['Employees Data$'] a
JOIN projects$ b ON a.[Employee ID] = b.employee_id
JOIN ['project_departments data$'] c ON b.project_id = c.project_id
WHERE [Date Resigned] > GETDATE() AND project_status Not in ('Ongoing','onhold')


--find the names of employees who have been assigned to projects that are in 'Finance' and 'IT' departments but not in 'Customer Service'. Return the employee_id, first_name, and last_name.
SELECT [Employee ID],[First Name],[Last Name]
FROM ['Employees Data$'] a
JOIN projects$ b ON a.[Employee ID] = b.employee_id
JOIN ['project_departments data$'] c ON b.project_id = c.project_id
where b.department in ('Finance','IT') and b.department <> 'Customer Service'

--Write an SQL query to find the average salary of employees for each project, rounded to 2 decimal places. Return the project_id, project_name, and average salary.

SELECT b.project_id,project_name,round(avg(salary),2) as Average_salary
FROM ['Employees Data$'] a
JOIN projects$ b ON a.[Employee ID] = b.employee_id
JOIN ['project_departments data$'] c ON b.project_id = c.project_id
Group by b.project_id,project_name
order by Average_salary desc

--Find the names of employees who have worked on more than one project, along with the count of distinct projects they have been involved in.
With ProNumCTE as
(
Select [Employee ID],[Full Name],project_name, ROW_NUMBER () over (partition by employee_id order by employee_id) as Number_of_Projects
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
)
select [Full Name],Number_of_Projects
from ProNumCTE
where Number_of_Projects > 1

--PART B

--find the average salary of employees who have not resigned, grouped by department and performance level.

Select Department,[performance Level],Round(AVG(SALARY),2) as Average_Salary
from ['Employees Data$']
where [Date Resigned] > Getdate ()
group by Department,[Performance level]

--Find the employee(s) who have worked on the most number of projects, and return their names and the count of projects they have worked on.

With NumCTE as
(
Select [Employee ID],[Full Name],project_name, ROW_NUMBER () over (partition by employee_id order by employee_id) as Number_of_Projects
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
)
select Top 1 [Full Name],Number_of_Projects
from NumCTE
where Number_of_Projects > 1
order by Number_of_Projects desc

--Find the employee(s) who have the longest tenure (the difference between date_joined and date_resigned or the current date if they haven't resigned) in each department.

select [Full Name],Datediff(MONTH,[Date Joined], 
case when [Date Resigned] >= getdate() then getdate() else [Date Resigned] end) as years,[Date Joined],[Date Resigned]
from ['Employees Data$']
order by years desc

--Write a query to retrieve the names of employees who have worked on projects that have been completed, along with the project names and their respective departments.

Select [Full Name],project_name,a.Department
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where project_status = 'Completed'

--Find the department(s) with the highest average salary for employees who have not resigned

Select Department,Round(avg(salary),2) as Average_salary
from ['Employees Data$']
where [date resigned] < getdate()
group by Department

--Retrieve the project details (project_name, start_date, end_date, and department) for projects that have no employees assigned from the Operations department.

Select project_name,[start_date],[end_date],a.department
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where a.Department <> 'Operations'


--retrieve the names of employees who have worked on projects that have a duration of 300 days or longer

Select [Full Name],[start_date],[end_date],datediff(DAY,[start_date],end_date)
from projects$ a
join ['Employees Data$'] b
on a.employee_id = b.[Employee ID]
where (datediff(DAY,[start_date],Case when end_date >= getdate() then getdate() else end_date end )) > 300

--Find the department(s) with the highest number of resigned employees.

Select Department, Sum(case when [Date Resigned] > getdate () then 0 else 1 end) as Total_Retired
from ['Employees Data$']
group by department
order by Total_Retired desc

-- Find the project(s) that have the highest number of employees assigned to them, and return the project details (project_name, start_date, end_date, project_status) along with the count of employees.

select project_name,[start_date],[end_date],project_status,count(employee_id) as total_employees
from projects$ a
join ['project_departments data$'] b
on a.project_id = b.project_id
group by project_name,start_date,end_date,project_status
order by total_employees desc


--Find the employee(s) who have the highest salary and have not resigned, grouped by department and performance level

select [Full Name],Salary
from ['Employees Data$']
where [Date Resigned] > getdate()
order by Salary desc

--Find the department(s) with the highest average age of employees who have not resigned

Select Department,Round(Avg(age),1) as Average_age
from ['Employees Data$']
where [Date Resigned] > getdate()
group by Department
order by Average_age desc

--retrieve the names of employees who have worked on projects with a status of 'Ongoing' and have a date_joined before January 1, 2022, 
--along with the project names and respective departments of the employees

Select [Full Name],a.Department
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where project_status = 'ongoing' and [Date Joined] < '2022-01-01'

--find the employees who have worked on the most number of ongoing projects, and for each of those employees, return their name, 
--the count of ongoing projects they have worked on, and the average duration (in days) of those ongoing projects.

With NumCTE as
(
Select [Employee ID],[Full Name],project_name,project_status,DATEDIFF(DAY,start_date,end_date) as Duration_in_days,(ROW_NUMBER () over (partition by employee_id order by employee_id)) as Number_of_Projects
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
)
select [Full Name],Count(Number_of_Projects) as Total_projects,avg(Duration_in_days) average_num_of_days
from NumCTE
where project_status = 'ongoing'
group by [full name]
order by Total_projects desc

--Find the department(s) that have the highest number of employees who have resigned, and for each of those departments,
--return the department name, the count of resigned employees, and the average tenure (in days) of those resigned employees

Select a.Department,COUNT([Employee ID]) as Resigned_employees,Avg(DATEDIFF(DAY,start_date,end_date)) as Tenure_days
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where [Date Resigned] < getdate()
group by a.Department
order by Resigned_employees desc

--find the projects that have employees assigned from at least three different departments, and for each of those projects,
--return the project name, the count of distinct departments represented, and the average age of employees assigned to that project.

WIth RowNUMCTE as 
(
Select project_name,[Full Name],a.department,age,ROW_NUMBER () over (Partition by project_name,a.department order by project_name) as Row_num
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
)
select project_name,Count(row_num) as Total_Individual_Departments,Round(avg(age),1) as average_age
from RowNUMCTE
where Row_num = 1
group by project_name
having Count(row_num) >= 3
order by Total_Individual_Departments

--find the department(s) that have the highest average salary for employees who have not resigned and have an 'Outstanding' performance level, 
--and return the department name and the average salary rounded to the nearest integer.

Select a.Department,COUNT([Employee ID]) as Active_employees,Round(Avg(salary),0) as Average_salary
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where [Date Resigned] > getdate() and [Performance level] = 'Outstanding'
group by a.Department
order by average_salary desc

-- find the project(s) that have the highest average age of employees assigned to them, and for each of those projects, return the project name, 
--the average age of employees rounded to the nearest integer, and the count of employees assigned to that project.

Select project_name,COUNT([Employee ID]) as Total_employees,Round(Avg(age),0) as Aberage_age
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
group by project_name
order by Total_employees desc

--Find the employee(s) who have worked on the most number of projects that have a duration (end_date - start_date) longer than 180 days, and for each of those employees, return their name, 
--the count of projects with duration longer than 180 days, and the average duration (in days) of those projects.

With NumCTE as
(
Select [Employee ID],[Full Name],project_name,project_status,DATEDIFF(DAY,start_date,end_date) as Duration_in_days,(ROW_NUMBER () over (partition by employee_id order by employee_id)) as Number_of_Projects
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
)
select [Full Name],Count(project_name) as total_projects,avg(Duration_in_days) as Average_days
from NumCTE
where Duration_in_days > '180'
group by [full name]
order by total_projects desc

-- Retrieve the project names and the count of employees who have resigned after working on those projects, but only for projects that have at least one resigned employee.

Select project_name,count(a.[employee id]) as total_number
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where [Date Resigned] < getdate () and project_status = 'completed'
group by project_name
order by total_number desc

--Find the department(s) with the highest average salary for employees who have worked on completed projects, and return the department name(s) and the corresponding average salary.
Select a.Department,Round(avg(salary),0) as Average_salary
from ['Employees Data$'] a
join projects$ b
on a.[Employee ID] = b.employee_id
join ['project_departments data$'] c
on b.project_id = c.project_id
where project_status = 'Completed'
group by a.Department
order by Average_salary desc






