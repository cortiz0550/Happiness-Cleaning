-- Create the dataset we want to work from.
SELECT *
INTO #total_data
FROM (
	SELECT *
	FROM (
		SELECT
			2019 AS Year,
			Country_or_region,
			Score AS Ladder_score,
			GDP_per_capita,
			Social_support,
			Healthy_life_expectancy * 100 AS Healthy_life_expectancy,
			Freedom_to_make_life_choices,
			Generosity,
			Perceptions_of_corruption
		FROM
			World_Happiness..[2019]
		UNION 
		SELECT
			2020,
			Country_name,
			Ladder_score,
			LOG(Logged_GDP_per_capita, 10),
			Social_support,
			Healthy_life_expectancy,
			Freedom_to_make_life_choices,
			Generosity,
			Perceptions_of_corruption
		FROM 
			World_Happiness..[2020]
		UNION
		SELECT 
			2021,
			Country_name,
			Ladder_score,
			LOG(Logged_GDP_per_capita, 10),
			Social_support,
			Healthy_life_expectancy,
			Freedom_to_make_life_choices,
			Generosity,
			Perceptions_of_corruption
		FROM 
			World_Happiness..[2021]
		) AS total_data
	) AS table1

-- There should be no duplicate data since we used Union. Will check just to make sure.
-- It has the same number of rows as the total dataset (458) so we're good.
SELECT DISTINCT *
FROM #total_data

-- Check for names that appear less than three times in the dataset.
-- That way, we can find if names have changed over the three years.
SELECT 
	Country_or_region,
	COUNT(Country_or_region) AS Num_of_entries
FROM #total_data
GROUP BY Country_or_region
HAVING COUNT(Country_or_region) < 3
ORDER BY Num_of_entries DESC;

-- Check before we update the table.
SELECT Country_or_region
FROM #total_data
WHERE Country_or_region = 'Hong Kong S.A.R. of China'

UPDATE #total_data
SET Country_or_region = 'Hong Kong'
WHERE Country_or_region LIKE 'Hong Kong S.A.R. of China'

UPDATE #total_data
SET Country_or_region = 'North Macedonia'
WHERE Country_or_region = 'Macedonia'

UPDATE #total_data
SET Country_or_region = 'Northern Cyprus'
WHERE Country_or_region = 'North Cyprus'

UPDATE #total_data
SET Country_or_region = 'Trinidad and Tobago'
WHERE Country_or_region = 'Trinidad & Tobago'

UPDATE #total_data
SET Country_or_region = 'Taiwan'
WHERE Country_or_region = 'Taiwan Province of China'

-- Now we want to make sure the data is all good and the columns have only the correct values.
SELECT
	MIN(Ladder_score) AS min_score,
	MAX(Ladder_score) AS max_score
FROM #total_data

SELECT
	MIN(GDP_per_capita) AS min_GDP,
	MAX(GDP_per_capita) AS max_GDP
FROM #total_data

SELECT
	MIN(Social_support) AS min_social,
	MAX(Social_support) AS max_social
FROM #total_data

SELECT
	MIN(Healthy_life_expectancy) AS min_health,
	MAX(Healthy_life_expectancy) AS max_health
FROM #total_data

SELECT
	MIN(Freedom_to_make_life_choices) AS min_freedom,
	MAX(Freedom_to_make_life_choices) AS max_freedom
FROM #total_data

SELECT
	MIN(Generosity) AS min_generosity,
	MAX(Generosity) AS max_generosity
FROM #total_data

SELECT
	MIN(Perceptions_of_corruption) AS min_corruption,
	MAX(Perceptions_of_corruption) AS max_corruption
FROM #total_data

SELECT
	Year,
	Country_or_region,
	Ladder_score,
	NTILE(4) OVER(ORDER BY Ladder_score) AS Quartile
FROM #total_data
ORDER BY Ladder_score ASC;

SELECT * FROM #total_data

