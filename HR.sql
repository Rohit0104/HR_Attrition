create database Hr;
use hr;

#------------------------------------------


select * from hr_1;

ALTER TABLE hr_1 ADD COLUMN attrition_number INT;

UPDATE hr_1
SET attrition_number = CASE
    WHEN Attrition = 'Yes' THEN 1
    WHEN Attrition = 'No' THEN 0
    END;
    
#-------------------------------------------------------------------
    
# Date of Joining Column created from Year,Month and Day of Joining fields

ALTER TABLE hr__2 ADD COLUMN date_of_joining DATE;

select * from hr__2;

UPDATE hr__2 SET date_of_joining =date_format(CONCAT(`Year Of Joining` , '-', `Month Of Joining`, '-', `Day Of Joining`), '%Y-%m-%d');

#--------------------------------------------------------------------

# 2 Number of Years from Joining Date.

ALTER TABLE hr__2 ADD COLUMN number_of_years INT;

UPDATE hr__2 SET number_of_years = TIMESTAMPDIFF(YEAR, date_of_joining, CURDATE());



#--------------------------------------------------------------------

# Number of Months from Joining Date.

ALTER TABLE hr__2 ADD COLUMN `number of months` INT;

UPDATE hr__2 SET number_of_months = TIMESTAMPDIFF(MONTH, date_of_joining, CURDATE());


#--------------------------------------------------------------------

# Full name of Month Of Joining

ALTER TABLE hr__2 ADD COLUMN month_full_name VARCHAR(20);

UPDATE hr__2 SET month_full_name = DATE_FORMAT(date_of_joining, '%M');


#--------------------------------------------------------------------

# Joining Quarter(Q1,Q2,Q3,Q4):

ALTER TABLE hr__2 ADD COLUMN joining_quarter VARCHAR(2);

UPDATE hr__2
SET joining_quarter = CASE
    WHEN QUARTER(date_of_joining) = 1 THEN 'Q1'
    WHEN QUARTER(date_of_joining) = 2 THEN 'Q2'
    WHEN QUARTER(date_of_joining) = 3 THEN 'Q3'
    WHEN QUARTER(date_of_joining) = 4 THEN 'Q4'
    END;
    
    
#--------------------------------------------------------------------
    
# Year-Month YYYY-MMM

ALTER TABLE hr__2 ADD COLUMN year_and_month VARCHAR(8);

UPDATE hr__2 SET year_and_month = DATE_FORMAT(date_of_joining, '%Y-%b');


#--------------------------------------------------------------------

#Weekdayno of Joining Date:

ALTER TABLE hr__2
ADD COLUMN weekday_no INT;

UPDATE  hr__2 SET weekday_no = DAYOFWEEK(date_of_joining);


#--------------------------------------------------------------------

#Weekday name of Joining Date:

ALTER TABLE hr__2 ADD COLUMN weekday_name VARCHAR(20);

UPDATE hr__2 SET weekday_name = DAYNAME(date_of_joining);

select * from hr__2;

#--------------------------------------------------------------------

# Financial Month of the Joining Date:

ALTER TABLE hr__2 ADD COLUMN financial_month_no INT;

UPDATE hr__2
SET financial_month_no = CASE
    WHEN MONTH(date_of_joining) >= 4 THEN MONTH(date_of_joining) - 3
    ELSE MONTH(date_of_joining) + 9
    END;


#--------------------------------------------------------------------
    
# Financial Quarter of the Joining Date:
ALTER TABLE hr__2 ADD COLUMN financial_quarter VARCHAR(3);

#--------------------------------------------------------------------

UPDATE hr__2
SET financial_quarter = CASE
    WHEN MONTH(date_of_joining) >= 4 THEN CONCAT('Q', CEIL((MONTH(date_of_joining) - 3) / 3))
    ELSE CONCAT('Q', CEIL((MONTH(date_of_joining) + 9) / 3))
    END;
    
Select* from hr.hr__2;

Select Employee ID from hr__2;


#--------------------------------------------------------------------

# Created a view for the KPI Columns:

create view employee_details_view As
select `Employee ID`,`date_of_joining`,`number_of_months`,`month_full_name`, `joining_quarter`, `year_and_month`,
`weekday_no`,`weekday_name`, `financial_month_no`,`financial_quarter`
from hr.hr__2;

 SELECT * FROM employee_details_view;
 
ALTER TABLE hr__2  RENAME COLUMN `ï»¿Employee ID` to `Employee ID`;


#--------------------------------------------------------------------

# Joining the table:

SELECT * From hr_1 Left Join hr__2 on hr_1.`Employee ID` = hr__2.`Employee ID`;

select * from hr_1;

Select* from hr.hr__2; # join table

# -----------------------------------KPI'S-------------------------------------------------------------------------------------------------------

#1 Average Attrition rate for all Departments

select Department, avg(attrition_number)*100 as average_attrition_rate
from hr.hr_1
group by Department;

# 2.Average Hourly rate of Male Research Scientist

select avg(HourlyRate) As average_hourly_rate
from hr_1
where Gender = 'Male' and JobRole = "Research Scientist";

# 3.Attrition rate Vs Monthly income stats

select hr_1.Department,round(sum(hr_1.attrition_number)/sum(hr_1.EmployeeCount)*100,2) As attrition_rate, sum(hr__2.MonthlyIncome) As sum_of_monthlyincome
from hr_1 
join hr__2  on hr_1.`Employee ID` = hr__2.`Employee ID`
group by hr_1.Department;


# 4.Average working years for each Department

select hr_1.Department,avg(hr__2.TotalWorkingYears ) as avg from hr_1 
left join hr__2  on hr_1.`Employee ID` = hr__2.`Employee ID`
group by hr_1.Department;


# 5.Departmentwise No of Employees
select Department, count(EmployeeCount) as `Employee Count` from hr_1 group by Department;


# 6.Count of Employees based on Educational Fields

select EducationField,count(EmployeeCount) as number_of_employees
from hr_1
group by EducationField;

#7.Job Role Vs Work life balance

select hr_1.JobRole, avg(hr__2.WorkLifeBalance) `work life balance`
from hr_1  join hr__2  on hr_1.`Employee ID`=hr__2.`Employee ID`
group by hr_1.JobRole;



#8.Attrition rate Vs Year since last promotion relation

select hr__2.YearsSinceLastPromotion,round(sum(hr_1.attrition_number)/sum(hr_1.EmployeeCount)*100,2) as attrition_rate
from hr__2 Join hr_1 as hr_1 on hr__2.`Employee ID` = hr_1.`Employee ID`
group by hr__2.YearsSinceLastPromotion
ORDER BY  hr__2.YearsSinceLastPromotion;

#9.Gender based Percentage of Employee

select Gender, COUNT(*) AS total_count,round(Count(*)/(select count(EmployeeCount) from hr_1)*100,2) AS percentage
FROM hr_1
group by Gender;

#10.Monthly New Hire vs Attrition Trendline

select hr__2.`Month Of Joining` ,hr__2.number_of_months as New_hires, round(sum(hr_1.attrition_number)/sum(EmployeeCount)*100,2) as Attrition_Trendline
from hr__2 Join hr_1  on hr__2.`Employee ID`=hr_1.`Employee ID`
group by hr__2.`Month Of Joining`,hr__2.number_of_months
order by hr__2.`Month Of Joining`,hr__2.number_of_months;

#11.Deptarment / Job Role wise job satisfaction

select Department,JobRole, round(avg(JobSatisfaction),2) as Job_Ratings
from hr_1
group by Department,JobRole;
    
    select * from hr_1;

    

    