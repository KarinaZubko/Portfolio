Create table applestore_descriprion_combined as 

Select * from appleStore_description1 
Union ALL

Select * from appleStore_description2
Union ALL

Select * from appleStore_description3
Union ALL

Select * from appleStore_description4

--check the number of unique apps in both tables

Select count(DISTINCT id) as UniqueAppIDs
From AppleStore

Select count(DISTINCT id) as UniqueAppIDs
From applestore_descriprion_combined

--Check for any missing values in key fields

Select Count(*) as MissingValues
From AppleStore
WHERE track_name is null or user_rating is null

Select Count(*) as MissingValues
From applestore_descriprion_combined
WHERE app_desc is null

-- Find the number of apps per ganre

Select prime_genre, count(*) as NumApps
From AppleStore
GROUP by prime_genre
Order by NumApps desc

--Get an overview of the apps' raitingAppleStore
Select min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
From AppleStore

*DATA ANALYSIS*
--Determine whetehr paid apps have higher raitings than free apps 

SELECT case 
			WHEn price > 0 THEN 'Paid'
            Else 'Free'
            End As App_type,
            avg(user_rating) as Avg_Raiting
frOM AppleStore
GROUP BY App_type

-- Check if apps with more supported languages have higher raitings 
SELECT CASE WHEN lang_num < 10 then '<10 languages'
			when lang_num BETWEEN 10 and 30 THEN '10-30 languages'
            ELSE '>30 languages' END AS language_basket,
            avg(user_rating) as Avg_Raiting
from AppleStore
GROUP BY language_basket
ORDER  by Avg_Raiting DESC

--Check the ganres with low raitings 
SELECT prime_genre,
		avg(user_rating) as Avg_Raiting
From AppleStore
GROUP by prime_genre
ORDER  by Avg_Raiting ASc 
Limit 10

--Check if there is correlation between app descriprion rate and user raiting
SELECT CASE
 	WHEN length(b.app_desc) < 500 then 'Short'
    WHEN length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
    Else 'Long'
    End as description_length_basket,
    avg(a.user_rating) as average_rating
FROM 
	AppleStore AS A
    JOIN applestore_descriprion_combined AS B 
ON a.id = b.id

GROUP BY description_length_basket
oRDER BY average_rating DESC

-- Check the top-rated apps for each genre
SELECT prime_genre,
		track_name,
        user_rating
from (
    SELECT 
    prime_genre,
    track_name,
    user_rating,
    RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank
    FROM 
    AppleStore
    ) as a
  WHERE
  a.rank = 1