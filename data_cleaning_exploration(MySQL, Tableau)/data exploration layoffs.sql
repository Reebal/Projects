use datacleaning;

select * from layoffs2;

-- 1.	Maximum total layoffs and percentage layoffs
select max(total_laid_off), max(percentage_laid_off) from layoffs2;

-- 2.	Companies that went under. List companies where percentage_laid_off = 1
select company, total_laid_off, percentage_laid_off from layoffs2 
where percentage_laid_off = 1 
order by total_laid_off desc;

-- 3.	Companies and total layoffs
select company, sum(total_laid_off) as Total_layoffs from layoffs2 
group by company
order by sum(total_laid_off) desc;

-- 4.	Industries and total layoffs
select industry, sum(total_laid_off) as Total_layoffs from layoffs2 
group by industry
order by sum(total_laid_off) desc;

-- 5.	Countries and total layoffs 
select country, sum(total_laid_off) as Total_layoffs from layoffs2 
group by country
order by sum(total_laid_off) desc;

-- 6.	Year and total layoffs 
select Year(`date`) as `Year`, sum(total_laid_off) as Total_layoffs from layoffs2 
where Year(`date`) is not null
group by Year(`date`)
order by Year(`date`) desc;

-- 7.	Rolling sum of layoffs based of by year and months in ascending (remove nulls)
select substring(`date`,1,7) as `year-month`, sum(total_laid_off) as Total_layoffs from layoffs2 
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by substring(`date`,1,7) asc;

with total_layoff as (
select substring(`date`,1,7) as `year-month`, sum(total_laid_off) as Total_layoffs from layoffs2 
where substring(`date`,1,7) is not null
group by `year-month`
order by 1 asc)
select `year-month`, Total_layoffs, sum(Total_layoffs) over(order by `year-month`) as Rolling_total
from total_layoff;

-- 8.	Total layoffs in descending order by company, year
select company, Year(`date`) `Year`, sum(total_laid_off) as Total_layoffs
from layoffs2
where total_laid_off is not null
group by company, Year(`date`)
order by 3 desc;

-- 9.	Rank top 5 companies total layoffs by years using Dense_rank() 

with total (Company, Years, Total_layoffs) as (
select company, Year(`date`), sum(total_laid_off) as Total_layoffs
from layoffs2
group by company, Year(`date`)),
rank_year as (
select *, DENSE_RANK() over (partition by Years order by Total_layoffs desc) as Ranking
from total
where Years is not null)
select * from rank_year
where Ranking <=5;



