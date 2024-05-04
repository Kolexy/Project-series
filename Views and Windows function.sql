use tdi_sql_project;
SET sql_mode = 'TRADITIONAL';
#VIEWS IN SQL
SELECT * FROM empd;
#Question 1(create view)
create view new_empDEM as 
select employeeID, department, salary from empd;

#Question 2(Modify view)
SET SQL_SAFE_UPDATES=0;
update new_empDEM
set department = 'Information Technology'
where department = 'IT';
 
 #Question 3(Drop view)
 Drop view new_empDEM;
 
 #WINDOWS FUNCTIONS AND CTES
 #Question 1
 select concat(firstname, ' ' ,lastname) as Name, gender, salary, 
row_number() over(order by salary desc) as ranking_based_on_salary,
rank() over(order by salary desc) as position,
dense_rank() over(order by salary desc) as dense_rank_postion from empd;

#Q2.	With the aid of window functions write a query to assign 
#new salary to the employees and set the default value for employees without salary to ‘1000’.
select *,
lead(salary, 1, 1000) over(order by employeeID) as new_salary from empd;

#Q3.Select the names, departments, and salaries of employees and 
#divide the result set into two based on their salaries.

select concat(firstname, ' ' ,lastname) as Name, department, salary,
ntile(2) over(order by salary) as bucket from empd;

#Q4.Select the names, departments, and salaries of employees. 
#List the first and last value in each department using their salaries.

select firstname, lastname, department, salary,
first_value(salary) over w as first_salary,
last_value(salary) over w as last_salary from empd
window w as (partition by department order by employeeID
 range between unbounded preceding and unbounded following);
 
#Q5. List the names, department, salary and 
#find the sum, average, min, max of salaries in each department.

select concat(firstname, ' ' ,lastname) as Name, department, salary, 
sum(salary) over(partition by department) as sum_of_salary_by_dept,
round(avg(salary) over(partition by department), 2)as average_salary_by_dept,
max(salary) over(partition by department) as maximum_salary_by_dept,
min(salary) over(partition by department) as minimum_salary_by_dept from empd d;

#Q6.List the names, department, and find the percentage rank of each salary.
select concat(firstname, ' ' ,lastname) as Name, department,
round(percent_rank() over(order by salary)*100, 2)as percentage_rank from empd;

#Q7. Retrieve the department which have more than two employees.
with count_employees as 
		(select department, count(employeeID) as no_of_employees from empd group by department)
Select department, no_of_employees from count_employees 
Where no_of_employees > 2
