SELECT * FROM app_store_apps;

SELECT * FROM play_store_apps;





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
	AND p.review_count > 200000
	AND a.review_count IS NOT NULL
ORDER BY p.name, p.rating), 



Main_Table AS (	SELECT 	p.name AS name
		, 		CASE
					WHEN	CAST(AVG(agg_data.Play_Rating + agg_data.Apple_Rating)/2 AS numeric) >= 4.75 THEN '5'
					WHEN	CAST(AVG(agg_data.Play_Rating + agg_data.Apple_Rating)/2 AS numeric) < 4.75 THEN '4.5'
						ELSE '0'
						END AS Rating
		, 		CASE
					WHEN	AVG(CAST(agg_data.play_price AS numeric)+agg_data.apple_price) <= 1 Then '1'
					WHEN 	AVG(CAST(agg_data.play_price AS numeric)+agg_data.apple_price) > 1 Then '0'
						ELSE '0'
						END AS Price
	,	SUM(agg_data.Play_Rev_Count+CAST(agg_data.Apple_Rev_Count AS int)) AS Total_Review_Count
FROM play_store_apps AS p
FULL JOIN agg_data
	USING (name)
WHERE 	agg_data.Apple_Rating IS NOT NULL
	AND agg_data.apple_price IS NOT NULL
GROUP BY p.name
ORDER BY name DESC),



Strategy AS (	Select main_table.name AS name
		,		CASE
					WHEN	CAST(main_table.rating AS numeric) = 4.5 THEN '10'
					WHEN	CAST(main_table.rating AS numeric) = 5   THEN '11'
						ELSE '0'
						END AS Years
		,		CASE
					WHEN 	CAST(main_table.price AS numeric) = 1	THEN '10,000'::MONEY
						ELSE '0'
						END AS Cost
		,		main_table.total_review_count AS Total_Review_Count
					FROM main_table),
Strategy_Table AS (SELECT 	strategy.name AS Name
					, 		main_table.rating
					, 		CAST(strategy.years AS numeric) AS years
					, 		strategy.cost
					, 		strategy.total_review_count AS total_review_count
	FROM strategy
		FULL JOIN main_table
			USING (name)
		WHERE cost > 0::money
		ORDER BY total_review_count DESC),
TOP_10 AS (SELECT 	DISTINCT strategy_table.name AS Top_10_Name
			,		strategy_table.rating
			,		strategy_table.years
			,		strategy_table.cost
			,		strategy_table.total_review_count
			,	CASE
					WHEN strategy_table.name iLIKE '%' THEN 1
					ELSE 0
					END AS Marketing_Count
			FROM strategy_table
			WHERE
					name iLIKE 	'Geometry Dash Lite'
				OR name iLIKE 	'Domino%'
				OR name iLIKE	'Egg, Inc.'
				OR name iLIKE 	'Fishdom'
				OR name iLIKE	'Clash of Clans'
				OR name iLIKE	'Score! Hero'
				OR name iLIKE	'My Talking Angela'
				OR name iLIKE	'Clash Royale'
				OR name iLIKE	'Subway Surfers'
				OR name iLIKE	'My Talking Tom'),
				
Monthly_Numbers AS (SELECT	top_10.top_10_name
	,	SUM(top_10.cost) AS initial_cost
	,	SUM(marketing_count * 1000)::MONEY AS monthly_marketing_cost
	,	SUM(marketing_count * 10000)::MONEY AS monthly_Revenue
	,	SUM((marketing_count * 10000) - (marketing_count * 1000))::MONEY AS monthly_net_profit
	,	top_10.years AS Yrs_Runway
FROM top_10
GROUP BY top_10.top_10_name, top_10.years),
Yearly_Numbers AS (SELECT	monthly_numbers.top_10_name AS app_name
	,	SUM(monthly_numbers.monthly_revenue * 12) AS yearly_revenue
	,	SUM(monthly_numbers.monthly_marketing_cost * 12) AS yearly_marketing
	, 	SUM(monthly_numbers.monthly_net_profit * 12) AS yearly_net_profit
	,	monthly_numbers.yrs_runway AS Yrs_Runway
FROM monthly_numbers
GROUP BY app_name, yrs_runway),
Lifespan_Numbers AS (SELECT 	yearly_numbers.app_name AS app_name
	,	SUM(yearly_numbers.yearly_revenue * yearly_numbers.yrs_runway) AS Lifespan_Revenue
	,	SUM(yearly_numbers.yearly_marketing * yearly_numbers.yrs_runway) AS Lifespan_Marketing_Cost
	,	SUM(yearly_numbers.yearly_net_profit * yearly_numbers.yrs_runway) AS Lifespan_Net_Profit
FROM yearly_numbers
GROUP BY yearly_numbers.app_name)
SELECT 	SUM(lifespan_revenue) AS Total_Revenue
	, 	SUM(lifespan_marketing_cost) AS Total_Marketing_Cost
	, 	SUM(lifespan_net_profit) AS Total_Net_Profit
FROM lifespan_numbers
