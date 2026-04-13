---1 create a database named employee then import tables.

create table emp_record_table (EMP_ID Varchar(225) Primary Key Not NULL,
FIRST_NAME Varchar(225),
LAST_NAME Varchar(225),
GENDER Varchar(225),
ROLE Varchar(225),
DEPT Varchar(225),
EXP Integer,
COUNTRY Varchar(225),
CONTINENT Varchar(225),
SALARY Integer,
EMP_RATING Integer,
MANAGER_ID Varchar(225),
PROJ_ID Varchar(225),
Foreign Key (MANAGER_ID) References emp_record_table(EMP_ID)
);

create table proj_table(PROJECT_ID Varchar(225) Primary Key not NULL,
PROJ_NAME Varchar(225),
DOMAIN Varchar(225),
START_DATE DATE,
CLOSURE_DATE DATE,
DEV_QTR Varchar(225),
STATUS Varchar(225),
Foreign Key (PROJECT_ID) References emp_record_table(PROJ_ID)
);

create table data_science_team(EMP_ID Varchar(225) Primary Key not Null,
FIRST_NAME Varchar(225),
LAST_NAME Varchar(225),
GENDER Varchar(225),
ROLE Varchar(225),
DEPT Varchar(225),
EXP Integer,
COUNTRY Varchar(225),
CONTINENT Varchar(225),
Foreign Key (EMP_ID) References emp_record_table (EMP_ID)
);

---2 create an ER diagram for the given employee database

---3 Write a query to find EMP_ID, FIRST__NAME, LAST_NAME, GENDER, and Department.

select e.emp_Id as Employee_ID
,e.first_name as First_Name
,e.last_name as Last_Name
,e.gender as Gender
,e.dept as Department
from emp_record_table e
order by Employee_ID asc;

/* Write 3 seperate SQL statements with the following columns from the employee table
 * EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING. */

select e.emp_Id as Employee_ID
,e.first_name as First_Name
,e.last_name as Last_Name
,e.gender as Gender
,e.dept as Department
,e.emp_rating as Employee_Rating
from emp_record_table e
where Employee_Rating < 2;

select e.emp_Id as Employee_ID
,e.first_name as First_Name
,e.last_name as Last_Name
,e.gender as Gender
,e.dept as Department
,e.emp_rating as Employee_Rating
from emp_record_table e
where Employee_Rating > 4;

select e.emp_Id as Employee_ID
,e.first_name as First_Name
,e.last_name as Last_Name
,e.gender as Gender
,e.dept as Department
,e.emp_rating as Employee_Rating
from emp_record_table e
where Employee_Rating between 2 and 4
order by Employee_Rating desc;

---5 Write a query to concatenate First_NAME and LAST_NAME from Finance 

select concat(e.first_name,' ',e.last_name) as Name
from emp_record_table e
where e.dept = 'FINANCE';

---6. write a query to find employees with who have someone reporting to them.

select m.emp_id as Manager_ID
,concat(m.first_name,' ',m.last_name) as Manager_name
,count(e.manager_id) as employee_count
from emp_record_table e
left join emp_record_table m on m.emp_id = e.manager_id
group by m.manager_id
,concat(m.first_name,' ',m.last_name)
order by employee_count desc;


---7.Write a query to list all the employees from the health care and finance department using Union all

Select e.emp_id as Employeer_ID
,concat(e.first_name,' ',e.last_name) as Employee_name
,e.dept as Department
from emp_record_table e
where Department = 'FINANCE'
Union all
select e.emp_id as Employeer_ID
,concat(e.first_name,' ',e.last_name) as Employee_name
,e.dept as Department
from emp_record_table e
Where Department = 'HEALTHCARE';

---8. Write a query to display each employee's details along with the maximum rating in each department

select e.emp_id as ID
,concat(e.first_name,' ',e.last_name) as Employee_Name
,e.role as ROLE
,e.dept as Department
,e.emp_rating as Rating
,max(e.emp_rating) over (partition by e.dept) as Highest_rating 
from emp_record_table e
order by Highest_rating desc;

---9. Write a query to calculate the minimum and the maximum salsary of the employees in each role.

select e.emp_id as ID
,concat(e.first_name,' ',e.last_name) as Employee_Name
,e.role as ROLE
,e.salary as Salary
,max(e.salary) over (partition by e.role) as Max_Role_salary
,min(e.salary) over (partition by e.role) as Min_Role_salary
from emp_record_table e
order by e.role;

---10. write a quert to assign ranks to each employee base on their experience

select e.emp_id as Employee_ID
,concat(e.first_name,' ',e.last_name) as Name
,e.exp as Experience
,rank() over(order by e.exp desc) as rank
from emp_record_table e;


---11. Write a query to create a view that displays employees in various countries whose salary is more than 6,000


 Create view employee_salary as
select e.emp_id as Employee_ID
,concat(e.first_name,' ',e.last_name) as Name
,e.country as Country
,e.salary as Salary
from emp_record_table e
where Salary > 6000
order by Salary desc;


---12 Write a subquery to find employees with experience more than 10 years

Select e.emp_id
,concat(e.first_name,' ',e.last_name)
from emp_record_table e
where e.exp in (select exp
	from emp_record_table 
	where exp >10);

/* Write a query using the prohect table to check whether
 * the job profile assigned to each employee in the data team matches
 * organization standards
 */

select d.emp_id as Employee_ID
,concat(d.first_name,' ',d.last_name) as Name
,d.exp as Experience
,d.dept as Department
,case
	when d.exp <= 2 then 'Junior Data Scientist'
	when d.exp > 2 and d.exp <= 5 then 'Associate Data Scientist'
	when d.exp > 5 and d.exp<= 10 then 'Senior Data Scientist'
	when d.exp>10 and d.exp<= 12 then 'Lead Data Scientist'
	else 'Manager' 
	end as Job_Role
,avg(d.exp) over (partition by d.dept) as average_by_dept
from data_science_team d
group by d.emp_id 
,concat(d.first_name,' ',d.last_name)
,d.exp;


---14. Write a query to calculate the bonus for all the employees base on their rating and salaries

select e.emp_id as Employee_ID
,concat(e.first_name,' ',e.last_name)
,(e.salary * 0.05 * e.emp_rating) as Employee_Bonus
,((e.salary * 0.05 * e.emp_rating) + E.Salary) as New_Salary
from emp_record_table e
order by New_Salary desc;

---15. Write a query to calculate the average salary distribution base on the continent and country

Select e.salary as Salary
,e.continent as Continent
,e.country as Country
,avg(e.salary) over (partition by e.continent, e.country) as Average_By_Country
from emp_record_table e
group by e.salary
,e.continent 
,e.country;





