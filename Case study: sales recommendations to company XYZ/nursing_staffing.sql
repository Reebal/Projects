SELECT * FROM pbj.staffing;
use pbj;

#top 10 states with requirement hours vs percentage covered by contract hours
with CTE as(
select state, round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as `Total hours`,
round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Total contract hours`
from staffing
group by state
order by 2 desc limit 10
)
select state, `Total hours`, `Total contract hours`, 
round((`Total contract hours`/`Total hours`) * 100,2) as `Percentage of contract hours`
from CTE;

#top 5 nursing homes with high contract hours
select provname, county_name, State, round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as `Total hours`,
round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as `Total contract hours`
from staffing
group by provname, county_name, state
order by 5 desc limit 10;


#top 5 counties within top 10 states 
WITH top_states AS (
    SELECT state, 
		   round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as Total_hours,
           ROW_NUMBER() OVER (ORDER BY sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide) DESC) as state_rank
    FROM staffing
    GROUP BY state
    ORDER BY Total_hours DESC 
    LIMIT 5
),
ranked_counties AS (
    SELECT state, county_name,
		   round(sum(Hrs_RNDON + Hrs_RNadmin + Hrs_RN + Hrs_LPNadmin + Hrs_LPN + Hrs_CNA + Hrs_NAtrn + Hrs_MedAide),2) as Total_hours,
           round(sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr), 2) as Total_contract_hours,
           ROW_NUMBER() OVER (PARTITION BY state ORDER BY sum(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr) DESC) as rn
    FROM staffing
    WHERE state IN (SELECT state FROM top_states)
    GROUP BY state, county_name
)
SELECT rc.state, rc.county_name, rc.Total_hours, rc.Total_contract_hours, 
round((rc.Total_contract_hours/rc.Total_hours) * 100,2) as percent
FROM ranked_counties rc
JOIN top_states ts ON rc.state = ts.state
WHERE rc.rn <= 5
ORDER BY ts.state_rank, rc.Total_hours DESC;


#below average contract hours
select state, 
round(avg(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as Below_average_contract_hours
from staffing
group by state
having Below_average_contract_hours < (
select 
round(avg(Hrs_RNDON_ctr + Hrs_RNadmin_ctr + Hrs_RN_ctr + Hrs_LPNadmin_ctr + Hrs_LPN_ctr + Hrs_CNA_ctr + Hrs_NAtrn_ctr + Hrs_MedAide_ctr),2) as total_avg
from staffing
)
order by 2 desc;













