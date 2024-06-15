SELECT *
FROM runners_dbo;

--How many states are represented in the race
SELECT COUNT(DISTINCT state) as disctinct_state_count
FROM runners_dbo;

--what was the avg time of Men and Woman
SELECT Gender, AVG(Total_minutes) as avg_time
FROM runners_dbo
GROUP BY Gender

--What were the youngest and oldest ages in the race
SELECT Gender, Min(Age) as youngest, Max(Age) as oldest
FROM runners_dbo
GROUP BY Gender

--What was the avg time for each age group
WITH age_buckets as(
	Select total_minutes, 
		case when age < 30 then 'age_20-29'
			 when age < 40 and age > 30 then 'age_30-39'
			 when age < 50 and age > 40 then 'age_40-49'
			 when age < 60 and age > 50 then 'age_50-59'
		else 'age_60+' end as age_group
	FROM runners_dbo
)
SELECT age_group, ROUND(avg(total_minutes),1) as avg_minutes
FROM age_buckets
GROUP BY age_group

--Top 3 males and females finishers
with gender_rank AS (
	Select rank() over(partition by Gender Order by total_minutes asc) as gender_rank,
	FullName, gender, total_minutes
	from runners_dbo
)
select * from gender_rank
Where gender_rank < 4
ORDER by total_minutes asc

--