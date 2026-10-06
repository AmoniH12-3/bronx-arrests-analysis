-- 05 | Dangerous-drug arrests as a share of each year  ->  data/clean/drug_share.csv
WITH counted AS (
  SELECT arrest_year, offense, COUNT(*) AS arrests
  FROM bronx_arrests_clean
  GROUP BY arrest_year, offense
),
with_total AS (
  SELECT *,
    SUM(arrests) OVER (PARTITION BY arrest_year) AS arrests_per_year
  FROM counted
)
SELECT *,
  ROUND(arrests / arrests_per_year * 100.0, 1) AS pct_of_year
FROM with_total
WHERE offense = 'DANGEROUS DRUGS'
ORDER BY arrest_year;
