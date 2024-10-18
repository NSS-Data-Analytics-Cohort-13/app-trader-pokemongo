/*SELECT *
FROM(	SELECT name, a.rating, CAST(a.price AS text), a.content_rating, CAST(a.review_count AS int),
				'app_store' AS store
	FROM app_store_apps AS a
	UNION ALL
	SELECT name, p.rating, p.price, p.content_rating, p.review_count, 'play_store' AS store
	FROM play_store_apps AS p
	WHERE rating IS NOT NULL) AS main_table
	--WHERE content_rating = 'Everyone'
	--WHERE store = 'app_store'
	--WHERE review_count > 200000 --AND content_rating iLIKE 'Everyone%' AND rating > 4.7
	--GROUP BY name, rating, price, content_rating, review_count, store
	--HAVING COUNT(name) >1
	ORDER BY name*/

SELECT 	p.name AS Name
	--, 	a.name AS Apple_Name
	, 	p.rating AS Play_Rating
	, 	a.rating AS Apple_Rating
	,	p.price AS Play_Price
	, 	a.price AS Apple_Price
	,	p.content_rating AS Play_Con_Rating
	--, 	a.content_rating AS Apple_Con_Rating
	, 	p.review_count AS Play_Rev_Count
	, 	a.review_count AS Apple_Rev_Count
	,	p.install_count
FROM play_store_apps AS p
		LEFT JOIN app_store_apps AS a
			USING (name)
WHERE p.rating IS NOT NULL AND p.rating >= 4.5
	AND a.rating IS NOT NULL
	AND p.content_rating iLIKE 'Everyone%'
	AND a.content_rating IS NOT NULL
	AND p.review_count > 1000000
	AND a.review_count IS NOT NULL
ORDER BY p.name, p.rating

WITH Strategy AS (SELECT 	p.name AS Name
	,	a.name AS Apple_Name
	, 	p.rating AS Play_Rating
	, 	a.rating AS Apple_Rating
	,	p.price AS Play_Price
	, 	a.price AS Apple_Price
	,	p.content_rating AS Play_Con_Rating
	,	a.content_rating AS Apple_Con_Rating
	, 	p.review_count AS Play_Rev_Count
	, 	a.review_count AS Apple_Rev_Count
	,	p.install_count
FROM play_store_apps AS p
		LEFT JOIN app_store_apps AS a
			USING (name)
WHERE p.rating IS NOT NULL AND p.rating >= 4.5
	AND a.rating IS NOT NULL
	AND p.content_rating iLIKE 'Everyone%'
	AND a.content_rating IS NOT NULL
	AND p.review_count > 200000
	AND a.review_count IS NOT NULL
ORDER BY p.name, p.rating)

SELECT 	p.name AS name
	, 	(AVG(strategy.Play_Rating + strategy.Apple_Rating))/2 AS Rating
	, 	AVG(CAST(strategy.play_price AS numeric)+strategy.apple_price) AS Price
	,	SUM(strategy.Play_Rev_Count+CAST(strategy.Apple_Rev_Count AS int)) AS Total_Review_Count
	--,	strategy.Play_con_rating
FROM play_store_apps AS p
FULL JOIN strategy 
	USING (name)
WHERE 	strategy.Apple_Rating IS NOT NULL 
	AND strategy.apple_price IS NOT NULL
GROUP BY p.name
ORDER BY name DESC--, strategy.play_con_rating DESC

--Strategy

--Egg Inc? 4.85 $1 

--LIST OF APPS

--Domino's Pizza USA - $1 - 5/5 rating - Everyone
--Geometry Dash Lite : $1 : 5/5 rating : Everyone
--Fishdom : $1 : 4.5/5 rating : Everyone
--Clash of Clans : $1 : 4.5/5 rating : Everyone 10+
--Google Duo : $1 : 4.5/5 rating : Everyone
--Egg, Inc. : $1 : 5/5 rating : Everyone
--Score! Hero : $1 : 4.5/5 : Everyone
--Evernote : $1 : 4.5/5 : Everyone
--Candy Crush Saga : $1 : 4.5/5 : Everyone
--Subway Surfers : $1 : 4.5 : Everyone 10+


/* Overhead
Purchase Price for app list : $100,000
Marketing: $10,000/mo
*/

--Overhead
SELECT 	(10000/*for every $1 spent*/ * 10 /*apps*/)::MONEY AS Purchase_Price
	, 	(1000/*for each app per month*/ * 10)::MONEY AS Monthly_marketing_cost
	,	((5000/*per app per app store it is listed*/ * 2 /*stores listed*/) * 10 /*total apps*/)::MONEY AS Monthly_Revenue

	SELECT	(Monthly_Revenue - Monthly_marketing_cost) AS Monthly_Net_Profit




--Monthly Revenue: $100,000
--Monthly Net Profit: $90,000
--Yearly Revenue: $1.2M
--Yearly Net Profit: $1.08M
--Revenue per app after lifespan of apps : (10 year)$10.8M + (11 year)$14.4M
--Profit per app after lifespan of apps: (10 year)$9.72M + (11 year)$12.96M
--Revenue from all apps: 
--Profit from all apps: 

--*ROI at 2 months with an excess profit of $80,000


--Notes worth mentioning:
-- Android has more users than Apple, with over 3.9 billion Android users compared to over 1.46 billion iOS users (over 2.5x as many users)
-- Avg phone storage is ~128GB
-- 4.5 rating lasts 10 years (8 apps)
-- 5.0 rating lasts 11 years (2 apps)