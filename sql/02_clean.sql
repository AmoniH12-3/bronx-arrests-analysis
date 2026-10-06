-- 02 | Clean: Bronx only, one row per arrest, readable categories
CREATE OR REPLACE TABLE bronx_arrests_clean AS
SELECT
  arrest_key,
  CAST(arrest_date AS DATE)                        AS arrest_date,
  EXTRACT(YEAR FROM arrest_date)                   AS arrest_year,
  CAST(date_trunc('month', arrest_date) AS DATE)   AS arrest_month,
  arrest_precinct,
  COALESCE(NULLIF(TRIM(ofns_desc), ''), 'UNKNOWN') AS offense,
  CASE law_cat_cd
    WHEN 'F' THEN 'Felony'
    WHEN 'M' THEN 'Misdemeanor'
    WHEN 'V' THEN 'Violation'
    ELSE 'Other/Unknown'
  END                                              AS severity,
  age_group,
  latitude,
  longitude
FROM bronx_arrests
WHERE arrest_boro = 'B'
QUALIFY ROW_NUMBER() OVER (PARTITION BY arrest_key ORDER BY arrest_date DESC) = 1;

-- Verify: both numbers should match (result: 1,464,302 and 1,464,302)
SELECT COUNT(*) AS rows_after, COUNT(DISTINCT arrest_key) AS unique_after
FROM bronx_arrests_clean;

-- Borough population lookup, 2020 Census (used in 07_borough_rates.sql)
CREATE OR REPLACE TABLE boro_population AS
SELECT * FROM (VALUES
  ('B', 'Bronx',         1472654),
  ('K', 'Brooklyn',      2736074),
  ('M', 'Manhattan',     1694251),
  ('Q', 'Queens',        2405464),
  ('S', 'Staten Island',  495747)
) AS t(boro_code, borough, population);
