SELECT * FROM MyProject.h1b_8years;

#approval by industry codes throughout the years
select industry_code,fiscal_year, 
round((sum(initial_approval)/(select sum(initial_approval) as total_approvals from h1b_8years)) * 100,2) as approval_percent,
sum(initial_approval) as approval_sum
from h1b_8years
group by industry_code, fiscal_year;


#top 10 employers
with total_initial_approval as
(select sum(initial_approval) as total from h1b_8years)
select employer_name, industry_code, sum(initial_approval) as approval_sum,
round((sum(initial_approval)/(select total from total_initial_approval)) * 100,2) as approval_percent 
from h1b_8years
group by employer_name, industry_code
order by 3 desc limit 10;

#approval by industry codes
select industry_code,
 round((sum(initial_approval)/(select sum(initial_approval) as total_approvals from h1b_8years)) * 100,2) as approval_percent,
 sum(initial_approval) as approval_sum
 from h1b_8years group by industry_code
 order by 2 desc;


#approval percent by states
WITH total_approval AS
(
select sum(initial_approval) as total from h1b_8years
)
select petitioner_state, round((sum(initial_approval)/(SELECT total FROM total_approval))*100,2) as approval_percent,
sum(initial_approval) as approval_sum from h1b_8years
group by petitioner_state
order by 2 desc;


#current approval/denial percent - to find forecasted in tableau
SELECT fiscal_year, 
round((sum(initial_approval)/(select sum(initial_approval) as initial_total_approvals from h1b_8years)) * 100,2) as initial_approval_percent,
round((sum(initial_approval + continuing_approval)/(select sum(initial_approval + continuing_approval) as total_approvals from h1b_8years)) * 100,2) as approval_percent,
round((sum(initial_denial + continuing_denial)/(select sum(initial_denial + continuing_denial) as total_denials from h1b_8years)) * 100,2) as denial_percent,
round((sum(continuing_denial)/(select sum(continuing_denial) as initial_total_denials from h1b_8years)) * 100,2) as initial_denial_percent
from h1b_8years group by fiscal_year
order by 1;

