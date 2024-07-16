create database datacleaning;
use datacleaning;
select * from layoffs_raw;

#create a staging table as a copy of the original table 
create table layoffs like layoffs_raw;

#insert values from raw data into the staging table
insert layoffs select * from layoffs_raw; 

select * from layoffs;



#Removing duplicates

#first lets identify the duplicates using the rownumber over partition window function
select *, row_number() over(partition by company, location, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs; 

with duplicate_cte as (
select *, row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
    as row_num
from layoffs 
)
select * from duplicate_cte where row_num>1;

select * from layoffs where company = 'Casper'; 

# let's try deleting rows from CTE 
with duplicate_cte as (
select *, row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
    as row_num
from layoffs 
)
delete from duplicate_cte where row_num>1;

# Error Code: 1288. The target table duplicate_cte of the DELETE is not updatable

#create another table to delete just the duplicates from it because deleting rows from a CTE is not possible
Create table layoffs2 (company varchar(50), location varchar(50), 
industry varchar(50), total_laid_off int, percentage_laid_off varchar(20),
 date varchar(20), stage varchar(50), country varchar(50), funds_raised_millions varchar(50), row_num int);
 
 #insert values from layoffs along with the row number
 insert into layoffs2 (
 select *, row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
    as row_num
from layoffs );

#view values from table 2
select * from layoffs2;

#view rows where row_num > 1
select * from layoffs2 where row_num>1;

#delete these duplicates
delete from layoffs2 where row_num>1;

#view table2 after deleting duplicates
select * from layoffs2;




#Standardizing data - trimming spaces before and after values
select company, (trim(company)) from layoffs2;

update layoffs2 
set company = Trim(company);

#go through distinct industries and look for discrepencies 
select distinct industry from layoffs2 order by 1;

# see which variation is maximum
select * from layoffs2 where industry like 'Crypto%';

# update all industries that starts with crypto with crypto
update layoffs2 
set industry = 'Crypto'
where industry like 'Crypto%';

#let's look at location - looks good
select distinct location
from layoffs2 order by 1;

#let's look at country - united states. is the issue
select distinct country
from layoffs2 order by 1;

# use trailing method to remove the '.' from the end
select distinct country, trim(trailing '.' from country)
from layoffs2 order by 1;

update layoffs2
set country = trim(trailing '.' from country)
where country like 'United States%';

#modify the date column's datatype
alter table layoffs2
modify column `date` date;

#format it into the default format
select `date`, str_to_date(`date`, '%m/%d/%Y') from layoffs2;

update layoffs2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date` from layoffs2;




#Dealing with nulls and blanks
select * from layoffs2;

#seems like there are many nulls in total_laid_off and percentage_laid_off
select * from layoffs2
where total_laid_off is null or percentage_laid_off is null;

#we can delete the rows where both the columns have nulls as they don't any value 
select * from layoffs2 
where total_laid_off is null and percentage_laid_off is null;

delete from layoffs2 
where total_laid_off is null and percentage_laid_off is null;

#the column industry seems to be having some blanks and nulls
select * from layoffs2
	where industry is null or industry ='';

#lets replace blanks with nulls
update layoffs2
	set industry = NULL
    where industry = '';

#let's look at airbnb to see if there's value in industry field for any other airbnb instance
select * from layoffs2
where company = 'Airbnb';


# let's do a self join 
select l1.industry, l2.industry from layoffs2 l1 join layoffs2 l2
	on l1.company = l2.company
    where l1.industry is null and l2.industry is not null;
    
# populate the null values with actual values
update layoffs2 l1 join layoffs2 l2
	on l1.company = l2.company
    set l1.industry = l2.industry 
    where l1.industry is null and l2.industry is not null;
    
select * from layoffs2
	where company = 'Airbnb';
    
select * from layoffs2
	where industry is null;
    
    
    

#remove the row_num column
alter table layoffs2
	drop column row_num;














