--3. Deliverables
--a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.
--b. Develop a Top 10 List of the apps that App Trader should buy.
--c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.

	SELECT *
FROM (SELECT name, a.rating, CAST(a.price AS text), a.content_rating, CAST(a.review_count AS numeric), 
				'app_store' AS store
	FROM app_store_apps AS a
	UNION ALL
	SELECT name, p.rating, p.price, p.content_rating, p.review_count, 'play_store' AS store
	FROM play_store_apps AS p
	WHERE rating IS NOT NULL) AS main_table
	--WHERE content_rating = 'Everyone'
	WHERE review_count >10000000 --10,000,000
	--WHERE store = 'play_store' AND store = 'app_store'
	ORDER BY rating desc

	--my custom formula
	SELECT a.name, a.rating, a.price, p.price, a.content_rating, CAST(a.review_count AS int)
			
	FROM app_store_apps AS a
	INNER JOIN play_store_apps AS p
	ON a.name = p.name
	--identify duplicate names
	--average ratings for apps in both stores
	--columns are apple.rating, playstore.rating
	AND a.rating = p.rating
	AND a.price = p.price
	AND a.content_rating = p.content_rating
	AND a.review_count = p.review_count
	
SELECT 
    table1.column1, 
    table1.column2, 
    table2.column3, 
    table2.column4
FROM 
    table1
INNER JOIN 
    table2
ON 
    table1.columnA = table2.columnA
AND 
    table1.columnB = table2.columnB;
				


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