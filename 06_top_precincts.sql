-- 06 | Top 5 precincts by arrests, per year  ->  data/clean/top_precincts.csv
-- Pattern: Count -> Rank -> Filter
WITH arrests_by_precinct AS (
  SELECT arrest_year, arrest_precinct, COUNT(*) AS arrests
  FROM bronx_arrests_clean
  GROUP BY arrest_year, arrest_precinct
),
ranked AS (
  SELECT *,
    RANK() OVER (PARTITION BY arrest_year ORDER BY arrests DESC) AS precinct_rank
  FROM arrests_by_precinct
)
SELECT arrest_year, arrest_precinct, arrests, precinct_rank
FROM ranked
WHERE precinct_rank <= 5
ORDER BY arrest_year, precinct_rank;
