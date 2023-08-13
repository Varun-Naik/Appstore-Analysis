/*

App store sql data analysis


In summary:
- Books and Finance apps have the lowest ratings, more opputunity to meed user needs
- Paid apps have higher ratings
- Apps with medium number (6-50) language support have highest ratings.
- Apps with descriptions longer than 2000 characters have higher ratings.
- Average price of an app is $1.72
- Average rating of an app is 3.52
- Gaming is the most popular genre, which means it is the most saturated with over 3,000 apps
- Gaming is the most engaging genre with the highest number of ratings by users.
- There are a lot of top rated apps in productivity genre, which is the highest rated genre.
- Among top rated apps (rating > 4), Medical apps have an highest average price of $11.6


*/

select *
from appstore.dbo.applestore;

-- Checking the dataset

-- Count
-- There are 7197 unique apps
select count(distinct id) as unique_count
from appstore.dbo.applestore;


-- Missing values
-- No null values
select * 
from appstore.dbo.applestore
where track_name is null or user_rating is null 


-- Price Column
-- Average price of an app is $1.72
SELECT 
    AVG(price) AS mean,
    MIN(price) AS min,
    MAX(price) AS max
from appstore.dbo.applestore;

-- Ratings column
-- Average rating of an app is 3.52
SELECT 
    AVG(user_rating) AS mean,
    MIN(user_rating) AS min,
    MAX(user_rating) AS max
from appstore.dbo.applestore;


-- Exploring by Category


-- Most popular apps (total ratings) by category
-- Games are the most popular apps with 52m ratings in total
select prime_genre, AVG(user_rating) as avgRating, sum(rating_count_tot) as TotalRatings, COUNT(id) as numberOfApps
from appstore.dbo.applestore
group by prime_genre
order by 3 desc;


-- App Ratings per Category
-- Productivity is the highest rated cat. with 4.00 avg. rating
select prime_genre, AVG(user_rating) as avgRating, sum(rating_count_tot) as TotalRatings, COUNT(id) as numberOfApps
from appstore.dbo.applestore
group by prime_genre
order by 2 desc;

-- Number of apps per Category
-- Games category has the highest number of apps with 3,862 apps
select prime_genre, COUNT(distinct(id)) as numberOfApps
from appstore.dbo.applestore
group by prime_genre
order by numberOfApps desc



-- Top Rated Free Apps
-- Productivity apps are the highest rated free apps with average rating of 3.95
select prime_genre, AVG(user_rating) as avgRating, sum(rating_count_tot) as TotalRatings, COUNT(id) as numberOfApps, max(price)
from appstore.dbo.applestore
group by prime_genre, price
having price = 0
order by 2 desc;



-- Exploring individual apps


-- Top Rated Individual app
-- Head soccer is the highest rated app in the app store
-- It has a rating of 5 and has the highest numver of ratings
select track_name, user_rating, rating_count_tot, prime_genre, price
from appstore.dbo.applestore
where user_rating > 4.5
order by 3 desc;


-- Top Rated Paid App
-- Plants vs. Zombies is the highest rated (5) paid app ($0.99)
select track_name, user_rating, rating_count_tot, prime_genre, price
from appstore.dbo.applestore
where user_rating > 4.5 and 
	price > 0
order by 3 desc;

-- Most Popular App
-- Facebook is the most popular app with 2.9m user ratings
select track_name, user_rating, rating_count_tot, prime_genre, price
from appstore.dbo.applestore
order by 3 desc;

-- Additional Exploration
-- Among top rated apps (rating > 4), Medical apps have an highest average price of $11.6
select prime_genre, avg(price) as avgPrice, avg(user_rating) as avgRating
from appstore.dbo.applestore
where user_rating > 4
group by prime_genre
order by 2 desc


-- checking ratings for free and paid apps
-- Paid apps have a higher avg. rating of 3.72
WITH CTE AS(
select
	CASE
		when price > 0 then 'Paid'
		else 'Free'
	END as appType,
	user_rating
from appstore.dbo.applestore
)

select 
	appType,
	avg(user_rating) as rating
from CTE
group by appType


select
	CASE
		when price > 0 then 'Paid'
		else 'Free'
	END as appType,
	avg(user_rating)

from appstore.dbo.applestore
group by 
CASE
	when price > 0 then 'Paid'
	else 'Free'
END 


-- Checking apps with more supported laguages
select *
from appstore.dbo.applestore;

select
    AVG(lang_num) AS mean,
    MIN(lang_num) AS min,
    MAX(lang_num) AS max
from appstore.dbo.applestore;


-- Apps with more supported languages are rated higher
WITH CTE as(
select 
	CASE
	when lang_num > 50 then '>50'
	when lang_num > 5 then '6-50'
	else '<5'
	END as supLang,
	user_rating
from appstore.dbo.applestore
)

select supLang, avg(user_rating) as Rating
from CTE
group by supLang
order by 2 desc



-- Ratings and Length of description
-- Apps with longer descriptions have higher ratings
WITH CTE as(
select 
	CASE
		when len(b.app_desc) > 2000 then '>2000'
		else '<2000'
	END as desc_len,
	a.user_rating as rating		
from appstore.dbo.applestore as a
join appstore.dbo.appleStore_description as b 
on a.id = b.id
)

Select
	desc_len,
	avg(rating) as rating
from CTE
group by desc_len


-- Top rated app for each category

-- Getting the top rated app for each category using CTE where rating is 5 and rating count is maximum
WITH maxRatingCount as(
	select
	prime_genre,
	max(rating_count_tot) as max_count
	from appstore.dbo.applestore 
	where user_rating = 5
	group by prime_genre
)
select	
	a.prime_genre,
	a.track_name,
	a.user_rating,
	a.rating_count_tot
from appstore.dbo.applestore a
JOIN 
	maxRatingCount b
ON a.prime_genre = b.prime_genre and  a.rating_count_tot = b.max_count
order by a.prime_genre














