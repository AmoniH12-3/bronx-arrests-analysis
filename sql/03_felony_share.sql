-- 03 | Felonies as a share of all Bronx arrests, by year  ->  data/clean/felony_share.csv
-- Pattern: Count -> Total -> Divide
WITH counted AS (
  SELECT arrest_year, severity, COUNT(*) AS arrests
  FROM bronx_arrests_clean
  GROUP BY arrest_year, severity
),
with_total AS (
  SELECT *,
    SUM(arrests) OVER (PARTITION BY arrest_year) AS arrests_per_year
  FROM counted
)
SELECT *,
  ROUND(arrests / arrests_per_year * 100.0, 1) AS pct_of_year
FROM with_total
WHERE severity = 'Felony'   -- filter last so the yearly total includes every severity
ORDER BY arrest_year;
