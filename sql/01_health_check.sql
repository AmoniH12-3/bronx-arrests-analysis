-- 01 | Data health check on the raw extract (all boroughs, historic + year-to-date stacked)
-- Run BEFORE cleaning. Results are recorded in docs/data_quality.md.

-- Stack the historic and year-to-date files
CREATE OR REPLACE TABLE bronx_arrests AS
SELECT * FROM bronx_hist
UNION ALL BY NAME
SELECT * FROM bronx_ytd;

SELECT
  COUNT(*)                                                          AS total_rows,
  COUNT(DISTINCT arrest_key)                                        AS unique_arrests,
  COUNT(*) - COUNT(DISTINCT arrest_key)                             AS duplicate_rows,
  COUNT(*) FILTER (WHERE ofns_desc IS NULL OR TRIM(ofns_desc) = '') AS missing_offense,
  COUNT(*) FILTER (WHERE law_cat_cd IS NULL)                        AS missing_severity,
  COUNT(*) FILTER (WHERE arrest_precinct IS NULL)                   AS missing_precinct,
  COUNT(*) FILTER (WHERE arrest_boro <> 'B')                        AS non_bronx_rows,
  CAST(MIN(arrest_date) AS DATE)                                    AS first_date,
  CAST(MAX(arrest_date) AS DATE)                                    AS last_date
FROM bronx_arrests;
