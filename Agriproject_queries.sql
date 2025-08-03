



--total rice production 

SELECT year, state_name, SUM(rice_production_1000_tons) AS total_rice_production
FROM agriculture_stats
GROUP BY year, state_name
ORDER BY total_rice_production DESC;

--1: Year-wise Trend of Rice Production Across States (Top 3)
WITH ranked_rice_production AS (
    SELECT 
        year,
        state_name,
        SUM(rice_production_1000_tons) AS total_rice_production,
        RANK() OVER (PARTITION BY year ORDER BY SUM(rice_production_1000_tons) DESC) AS rank
    FROM agriculture_stats
    GROUP BY year, state_name
)
SELECT 
    year, 
    state_name, 
    total_rice_production
FROM ranked_rice_production
WHERE rank <= 3
ORDER BY year, rank;


--
--2. Top 5 Districts by Wheat Yield Increase Over the Last 5 Years
WITH wheat_yield AS (
    SELECT dist_name, year, AVG(wheat_yield_kg_per_ha) AS avg_yield
    FROM agriculture_stats
    WHERE year >= (SELECT MAX(year) - 5 FROM agriculture_stats)
    GROUP BY dist_name, year
)
SELECT dist_name, 
       (MAX(avg_yield) - MIN(avg_yield)) AS yield_increase
FROM wheat_yield
GROUP BY dist_name
ORDER BY yield_increase DESC
LIMIT 5;
--

--3. States with the Highest Growth in Oilseed Production (5-Year Growth Rate)
WITH oilseed_growth AS (
    SELECT state_name,
           SUM(CASE WHEN year = (SELECT MAX(year) FROM agriculture_stats) THEN oilseeds_production_1000_tons ELSE 0 END) AS current,
           SUM(CASE WHEN year = (SELECT MAX(year) - 5 FROM agriculture_stats) THEN oilseeds_production_1000_tons ELSE 0 END) AS five_years_ago
    FROM agriculture_stats
    GROUP BY state_name
)
SELECT state_name,
       ((current - five_years_ago) / NULLIF(five_years_ago, 0)) * 100 AS growth_rate_percent
FROM oilseed_growth
ORDER BY growth_rate_percent DESC;
--

-- 4. District-wise Correlation Between Area and Production for Major Crops (Rice, Wheat, and Maize)
SELECT dist_name, 
       CORR(rice_area_1000_ha, rice_production_1000_tons) AS rice_corr,
       CORR(wheat_area_1000_ha, wheat_production_1000_tons) AS wheat_corr,
       CORR(maize_area_1000_ha, maize_production_1000_tons) AS maize_corr
FROM agriculture_stats
GROUP BY dist_name;
--

--5. Yearly Production Growth of Cotton in Top 5 Cotton Producing States
WITH top_states AS (
    SELECT state_name, SUM(cotton_production_1000_tons) AS total_cotton
    FROM agriculture_stats
    GROUP BY state_name
    ORDER BY total_cotton DESC
    LIMIT 5
)
SELECT a.year, a.state_name, SUM(a.cotton_production_1000_tons) AS yearly_cotton_production
FROM agriculture_stats a
JOIN top_states t ON a.state_name = t.state_name
GROUP BY a.year, a.state_name
ORDER BY a.year, yearly_cotton_production DESC;
--


--6. Districts with the Highest Groundnut Production in 2020
SELECT dist_name, SUM(groundnut_production_1000_tons) AS total_groundnut
FROM agriculture_stats
WHERE year = 2020
GROUP BY dist_name
ORDER BY total_groundnut DESC;
--

-- 7. Annual Average Maize Yield Across All States
SELECT year, AVG(maize_yield_kg_per_ha) AS avg_maize_yield
FROM agriculture_stats
GROUP BY year
ORDER BY year;
--

--8. Total Area Cultivated for Oilseeds in Each State
SELECT state_name, SUM(oilseeds_area_1000_ha) AS total_oilseed_area
FROM agriculture_stats
GROUP BY state_name
ORDER BY total_oilseed_area DESC;
--

-- 9. Districts with the Highest Rice Yield
SELECT dist_name, AVG(rice_yield_kg_per_ha) AS avg_rice_yield
FROM agriculture_stats
GROUP BY dist_name
ORDER BY avg_rice_yield DESC;
--

--10. Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years
WITH top_states AS (
    SELECT state_name, SUM(wheat_production_1000_tons + rice_production_1000_tons) AS total_production
    FROM agriculture_stats
    GROUP BY state_name
    ORDER BY total_production DESC
    LIMIT 5
)
SELECT year, state_name,
       SUM(rice_production_1000_tons) AS total_rice,
       SUM(wheat_production_1000_tons) AS total_wheat
FROM agriculture_stats
WHERE state_name IN (SELECT state_name FROM top_states)
  AND year >= (SELECT MAX(year) - 10 FROM agriculture_stats)
GROUP BY year, state_name
ORDER BY year, state_name;