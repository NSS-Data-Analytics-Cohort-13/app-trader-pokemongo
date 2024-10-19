SELECT * FROM app_store_apps;

SELECT * FROM play_store_apps;




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