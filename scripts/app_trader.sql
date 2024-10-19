SELECT *
FROM app_store_apps
--WHERE name ILIKE '%Groupon%'

SELECT * 
FROM play_store_apps 
--WHERE name ILIKE '%Groupon%'

--SELECT *
--FROM(	SELECT name, a.rating, CAST(a.price AS text), a.content_rating, a.review_count,
				'app_store' AS store
	--FROM app_store_apps AS a
	--UNION ALL
	--SELECT name, p.rating, p.price, p.content_rating, CAST(p.review_count AS text), 'play_store' AS store
	--FROM play_store_apps AS p
	--WHERE rating IS NOT NULL) AS main_table
	--WHERE store = 'play_store' AND store = 'app_store'
	--ORDER BY rating desc

--SELECT *
--FROM(	SELECT name, a.rating, CAST(a.price AS text), a.content_rating, CAST(a.review_count AS int),
				'app_store'
	--FROM app_store_apps AS a
	--UNION ALL
	--SELECT name, p.rating, p.price, p.content_rating, p.review_count, 'play_store' AS store
	--FROM play_store_apps AS p
	--WHERE rating IS NOT NULL) AS main_table
	--GROUP BY name, rating, price, content_rating, review_count, store
	--HAVING COUNT(name) >1
	--ORDER BY review_count DESC
	
	--SELECT *
--FROM(	SELECT name, a.rating, CAST(a.price AS text), a.content_rating, CAST(a.review_count AS int),
				'app_store'
	--FROM app_store_apps AS a
	--UNION ALL
	--SELECT name, p.rating, p.price, p.content_rating, p.review_count, 'play_store' AS store
	--FROM play_store_apps AS p
	--WHERE review_count > 100000) AS main_table
	--GROUP BY name, rating, price, content_rating, review_count, store
	--HAVING COUNT(name) >1
	--ORDER BY rating DESC
	
	
--SELECT app.name, app.price, 
--FROM app_store_apps AS app
--INNER JOIN play_store_apps AS play
--ON app.name = play.name
--WHERE play.review_count > 100000 
	--ORDER BY app.rating DESC

--SELECT app.name, app.rating, app.price, app.content_rating, CAST(app.review_count AS int)
	--FROM app_store_apps AS app
	--INNER JOIN play_store_apps AS play
	--ON app.name = play.name
	
WITH Agg_Data AS (SELECT 	p.name AS Name
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
	AND p.review_count > 100000
	AND a.review_count IS NOT NULL
ORDER BY p.name, p.rating DESC)



Main_Table AS (	SELECT 	p.name AS name
		, 		CASE
					WHEN CAST(AVG(agg_data.Play_Rating + agg_data.Apple_Rating)/2 AS numeric) >= 4.75 THEN '5'
					WHEN CAST(AVG(agg_data.Play_Rating + agg_data.Apple_Rating)/2 AS numeric) < 4.75 THEN '4.5'
			ELSE '0'
			END AS Rating
		, 	CASE
			WHEN AVG(CAST(agg_data.play_price AS numeric)+agg_data.apple_price) <= 1 Then '1'
			WHEN AVG(CAST(agg_data.play_price AS numeric)+agg_data.apple_price) > 1 Then '0'
			ELSE '0'
			END AS Price
	, SUM(agg_data.Play_Rev_Count+CAST(agg_data.Apple_Rev_Count AS int)) AS Total_Review_Count
FROM play_store_apps AS p
FULL JOIN agg_data
	USING (name)
WHERE agg_data.Apple_Rating IS NOT NULL
	AND agg_data.apple_price IS NOT NULL
GROUP BY p.name
ORDER BY name DESC

