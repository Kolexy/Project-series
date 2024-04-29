use tdi_sql_project;
SET sql_mode = 'TRADITIONAL';
SELECT * FROM tdi_sql_project.hr ;
#PART A Subqueries used in filtering data
#Question 1(Simple subquery)
select Name from hr
where salary > (select avg(salary) from hr);

#Question 2(List comparison subquery)
select * from hr
where Name in (select Name from hr where department = 'sales');

#Question 4(Exists subquery)
Select * from 
	(select Department, count(*) as number_of_employees from hr group by 1) sub
group by Department
having count(*) > 2;

#Question 5(Employees earning below average salaries)
select * from hr h1
where salary < (select avg(salary) from hr h2 where h1.Department = h2.Department)
;

#PART B Correlated subqueries
#Question 1(Basic Correlated subquery)
select name from hr h1
where salary > (select avg(salary) from hr h2 where h1.Department = h2.Department)
;

#Question 2(Multiple column Correlation)
select * from hr 
group by EmployeeID
having count(*) > (select avg(number_of_employees)from
	(select department, count(EmployeeID) as number_of_employees from hr 
	group by department) a)
;

#Question 3(Non-Exists Correlation)
select * from hr h2
where not exists(select * from hr h1 
	where Department in ("HR","Sales") and 
    h1.Department = h2.Department);

#Question 4 (Employees hired before their manager)
update hr set HireDate = DATE_FORMAT(STR_TO_DATE(HireDate, '%m/%d/%Y'),'%Y-%m-%d');
Select *
From hr
Where  department= “HR” and  HireDate<
(select hiredate from hr
Where department= “HR” and position=”Manager”);
