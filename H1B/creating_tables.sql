#create a database named 'myproject', then execute the following queries
use myproject; 

#to create h1b_8years table
drop table if exists h1b_8years;
create table h1b_8years(

Fiscal_Year int,

Employer_Name varchar(200),

Industry_Code varchar(200),

Petitioner_City varchar(50),

Petitioner_State varchar(10),

Petitioner_Zip_Code int,

Initial_Approval int,

Initial_Denial int, 

Continuing_Approval int,

Continuing_Denial int);

#to create job_title table
drop table if exists job_title;
create table job_title(

CASE_NUMBER varchar(100),

CASE_STATUS varchar(100),

RECEIVED_DATE date,

DECISION_DATE date,

VISA_CLASS varchar(20),

EMPLOYER_NAME varchar(250),

JOB_TITLE varchar(250),

SOC_TITLE varchar(250),

);
