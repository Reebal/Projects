SELECT * FROM MyProject.job_title;
use myproject;

#temporary table containing top 10 employers from h1b_8years table
create temporary table temp1 
select employer_name, sum(initial_approval) as approval_sum
from h1b_8years 
group by employer_name
order by 2 desc limit 10;

#top 30 job titles 
Select A.job_title, count(A.job_title) from job_title A join temp1 B
on A.employer_name = B.employer_name
group by A.job_title
order by 2 desc limit 30;

#top 30 soc titles
Select A.soc_title, count(A.soc_title) from job_title A join temp1 B
on A.employer_name = B.employer_name
group by A.soc_title
order by 2 desc limit 30;

















