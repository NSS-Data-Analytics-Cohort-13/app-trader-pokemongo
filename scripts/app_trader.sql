SELECT *
FROM app_store_apps
--WHERE name ILIKE '%Groupon%'

SELECT * 
FROM play_store_apps 
--WHERE name ILIKE '%Groupon%'

SELECT *
FROM(	SELECT name, a.rating, CAST(a.price AS text), a.content_rating, a.review_count,
				'app_store' AS store
	FROM app_store_apps AS a
	UNION ALL
	SELECT name, p.rating, p.price, p.content_rating, CAST(p.review_count AS text), 'play_store' AS store
	FROM play_store_apps AS p
	WHERE rating IS NOT NULL) AS main_table
	--WHERE store = 'play_store' AND store = 'app_store'
	ORDER BY rating desc

SELECT *
FROM(	SELECT name, a.rating, CAST(a.price AS text), a.content_rating, CAST(a.review_count AS int),
				'app_store' AS store
	FROM app_store_apps AS a
	UNION ALL
	SELECT name, p.rating, p.price, p.content_rating, p.review_count, 'play_store' AS store
	FROM play_store_apps AS p
	WHERE rating IS NOT NULL) AS main_table
	GROUP BY name, rating, price, content_rating, review_count, store
	HAVING COUNT(name) >1
	ORDER BY review_count DESC


	SELECT *
FROM(	SELECT name, a.rating, CAST(a.price AS text), a.content_rating, CAST(a.review_count AS int),
				'app_store' AS store
	FROM app_store_apps AS a
	UNION ALL
	SELECT name, p.rating, p.price, p.content_rating, p.review_count, 'play_store' AS store
	FROM play_store_apps AS p
	WHERE review_count > 100000) AS main_table
	GROUP BY name, rating, price, content_rating, review_count, store
	HAVING COUNT(name) >1
	ORDER BY rating DESC
	
	
SELECT app.name, app.price, 
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
ON app.name = play.name
WHERE play.review_count > 100000 
	ORDER BY app.rating DESC


SELECT app.name, app.rating, app.price, app.content_rating, CAST(app.review_count AS int)
	FROM app_store_apps AS app
	INNER JOIN play_store_apps AS play
	ON app.name = play.name

	
	WHERE play.review_count > 100000
	GROUP BY app.rating
	ORDER BY app.rating DESC
