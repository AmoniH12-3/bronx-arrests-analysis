# Data quality log

## Health check (before cleaning)

Run on the stacked historic + year-to-date extract (`sql/01_health_check.sql`).

| Check | Result | What it means |
| --- | --- | --- |
| Total rows | 6,548,718 | All five boroughs, not Bronx only |
| Unique arrest keys | 6,406,848 | |
| Duplicate rows | 141,870 (2.2%) | Overlap between the historic and year-to-date files |
| Missing offense (NULL or blank) | 9,169 (0.1%) | Labelled `UNKNOWN` in cleaning |
| Missing severity code | 28,192 (0.4%) | Labelled `Other/Unknown` in cleaning |
| Missing precinct | 0 | Clean |
| Non-Bronx rows | 5,051,726 | Borough filter was not applied at download, so it is applied in cleaning |
| Date range | 2006-01-01 → 2026-06-30 | 20.5 years; 2026 is partial |

Missing-value counts above are citywide, measured before the Bronx filter.

## Cleaning decisions (`sql/02_clean.sql`)

| Decision | Why |
| --- | --- |
| Keep `arrest_boro = 'B'` only | The analysis is about the Bronx |
| Keep one row per `arrest_key` (`ROW_NUMBER()`, most recent date) | Removes overlap between the two source files |
| Blank or NULL offense → `UNKNOWN` | Keeps the arrest in totals instead of silently dropping it |
| Severity codes F / M / V → Felony / Misdemeanor / Violation; anything else → `Other/Unknown` | Readable categories for charts |
| Kept all years, 2006–2026 | A 20-year view shows long-term shifts that a 5-year window would miss |

## Result

| Step | Rows |
| --- | --- |
| Raw extract | 6,548,718 |
| Bronx only | 1,496,992 |
| Duplicates removed | −32,690 |
| **Clean table** | **1,464,302** (1,464,302 unique arrest keys) |

## Cross-checks

- Yearly totals from `03_felony_share.sql`, `04_severity_trend.sql` and `05_drug_share.sql` match exactly (e.g. 2006 = 83,895).
- Bronx arrests in `07_borough_rates.sql` (built from the raw table with `COUNT(DISTINCT)`) match the clean table (2025 = 62,833).
