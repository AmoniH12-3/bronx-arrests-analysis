-- 04 | Arrests by severity with year-over-year change  ->  data/clean/severity_trend.csv
-- Pattern: Count -> Copy (LAG) -> Calculate
WITH yearly AS (
  SELECT arrest_year, severity, COUNT(*) AS arrests
  FROM bronx_arrests_clean
  GROUP BY arrest_year, severity
),
prev AS (
  SELECT *,
    LAG(arrests) OVER (PARTITION BY severity ORDER BY arrest_year) AS prev_year_arrests
  FROM yearly
)
SELECT
  arrest_year,
  severity,
  arrests,
  ROUND((arrests - prev_year_arrests) / prev_year_arrests * 100.0, 1) AS pct_change_vs_prior_year
FROM prev
ORDER BY severity, arrest_year;
