# Data dictionary

## Clean table: `bronx_arrests_clean` (1,464,302 rows, one per arrest)

| Column | Type | Description | Source |
| --- | --- | --- | --- |
| `arrest_key` | integer | Unique ID for each arrest | `arrest_key` |
| `arrest_date` | date | Date of arrest | `arrest_date`, time removed |
| `arrest_year` | integer | Year of arrest | derived |
| `arrest_month` | date | First day of the arrest month | derived |
| `arrest_precinct` | integer | NYPD precinct where the arrest occurred | `arrest_precinct` |
| `offense` | text | Broad offense category (e.g. DANGEROUS DRUGS); blanks set to UNKNOWN | `ofns_desc` |
| `severity` | text | Felony, Misdemeanor, Violation or Other/Unknown | `law_cat_cd` (F/M/V) |
| `age_group` | text | Age group of the person arrested | `age_group` |
| `latitude`, `longitude` | decimal | Arrest location | source columns |

## Result files (`data/clean/`)

| File | One row per | Key columns |
| --- | --- | --- |
| `felony_share.csv` | year | `arrests` (felonies), `arrests_per_year` (all), `pct_of_year` |
| `severity_trend.csv` | year × severity | `arrests`, `pct_change_vs_prior_year` |
| `drug_share.csv` | year | `arrests` (drug offenses), `arrests_per_year`, `pct_of_year` |
| `top_precincts.csv` | year × top-5 precinct | `arrests`, `precinct_rank` |
| `borough_rates.csv` | year × borough | `arrests`, `arrests_per_100k` |
