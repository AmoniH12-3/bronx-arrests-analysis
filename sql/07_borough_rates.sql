-- 07 | Arrests per 100,000 residents, all boroughs  ->  data/clean/borough_rates.csv
-- Uses the raw all-borough table, so COUNT(DISTINCT) removes duplicate arrest keys.
WITH counted AS (
  SELECT
    EXTRACT(YEAR FROM arrest_date) AS arrest_year,
    arrest_boro,
    COUNT(DISTINCT arrest_key)     AS arrests
  FROM bronx_arrests
  GROUP BY EXTRACT(YEAR FROM arrest_date), arrest_boro
)
SELECT
  counted.arrest_year,
  boro_population.borough,
  counted.arrests,
  ROUND(counted.arrests / boro_population.population * 100000.0, 1) AS arrests_per_100k
FROM counted
JOIN boro_population ON counted.arrest_boro = boro_population.boro_code
ORDER BY counted.arrest_year, arrests_per_100k DESC;
