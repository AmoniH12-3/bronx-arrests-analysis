# Bronx Arrests, 2006–2026: Fewer Arrests, More Serious Ones

**An SQL analysis of 1.46 million Bronx arrests from NYC Open Data**, built to answer how the volume, severity and location of arrests in the Bronx have changed over 20 years.

**Headline finding:** felonies grew from about **1 in 5** Bronx arrests (22.4% in 2011) to about **2 in 5** (39.9% in 2025), even as total arrests fell. Most of the shift happened between 2015 and 2021.

**Live dashboard:** [Tableau Public — add link here]

![Felony share of Bronx arrests](images/felony_share.png)

**Tools:** SQL (DuckDB / MotherDuck), Tableau Public, GitHub
**SQL skills shown:** data-quality checks, deduplication with window functions, CTE pipelines, `LAG`, `RANK`, `SUM() OVER (PARTITION BY …)`, joins, rates per 100,000

---

## Key findings

| # | Finding | Evidence |
| --- | --- | --- |
| 1 | **The mix shifted toward serious offenses.** Felony share rose from a low of 22.4% (2011) to a peak of 43.8% (2021) and was 39.9% in 2025. | `03_felony_share.sql` |
| 2 | **Total arrests fell by two-thirds, then partly rebounded.** 100,535 in 2010 → 32,724 in 2020 (−67%) → 62,833 in 2025, still about 38% below the peak. | `04_severity_trend.sql` |
| 3 | **Felony arrests are at a near-20-year high.** 25,077 in 2025, the most since 2007 and 43% above 2019. | `04_severity_trend.sql` |
| 4 | **Drug arrests went from the largest category to a small one.** 35.2% of arrests in 2007 → 5.6% in 2022 (33,668 → 2,463 arrests). The decline began around 2012, well before marijuana legalization in 2021. | `05_drug_share.sql` |
| 5 | **The Bronx has the highest arrest rate per resident.** 4,266.7 arrests per 100,000 residents in 2025, ahead of Manhattan (3,922.0) and 46% above Brooklyn. It has ranked first every year since 2022. | `07_borough_rates.sql` |
| 6 | **Arrests concentrate in the same precincts.** Precincts 46, 44, 40, 43 and 52 were the top five in both 2006 and 2007. | `06_top_precincts.sql` |

Full write-up with context and caveats: [`docs/findings.md`](docs/findings.md)

---

## Questions this project answers

1. How have Bronx arrests changed each year, overall and by severity?
2. Has the mix shifted between felonies, misdemeanors and violations?
3. How has drug enforcement changed as a share of all arrests?
4. Which precincts account for the most arrests each year?
5. How does the Bronx compare with other boroughs per 100,000 residents?

## Data

- **NYPD Arrests Data (Historic)** and **NYPD Arrest Data (Year to Date)**, NYC Open Data (opendata.cityofnewyork.us). Extract covers 1 Jan 2006 – 30 Jun 2026.
- **Borough population:** 2020 U.S. Census counts.
- Raw files (1 GB+) are not stored in this repo. Download them from NYC Open Data to reproduce.

## Method

1. **Stack** the historic and year-to-date files (`UNION ALL BY NAME`).
2. **Health check** before cleaning: row counts, duplicates, missing values, date range, borough filter (`01_health_check.sql`).
3. **Clean** (`02_clean.sql`): keep Bronx only, remove duplicate arrest keys with `ROW_NUMBER()`, label severity codes, replace blank offenses with `UNKNOWN`.
4. **Analyze** with reusable SQL patterns:
   - *Count → Copy → Calculate* for year-over-year change (`LAG`)
   - *Count → Total → Divide* for share of total (`SUM() OVER`)
   - *Count → Rank → Filter* for top-N per year (`RANK`)
5. **Visualize** each finding in Tableau Public, one chart per question.

## Data quality

The raw extract had 6,548,718 rows across all five boroughs. After filtering to the Bronx (1,496,992 rows) and removing 32,690 duplicate arrest keys, **1,464,302 arrests** remain, with every arrest key unique. Under 0.5% of rows had a missing offense or severity; these were labelled rather than dropped. No rows were missing a precinct. Details: [`docs/data_quality.md`](docs/data_quality.md)

## Repository structure

```text
bronx-arrests-analysis/
  README.md
  data/clean/     results of each query (CSV)
  sql/            01_health_check.sql → 07_borough_rates.sql, in run order
  images/         dashboard screenshots
  docs/           findings, data quality log, data dictionary
```

## How to reproduce

1. Download both NYPD arrest datasets from NYC Open Data as CSV.
2. Load them into DuckDB or MotherDuck as `bronx_hist` and `bronx_ytd`.
3. Run the files in `sql/` in order, `01` through `07`.

## Limitations

- **Arrests are not crimes.** Arrest counts reflect police activity and enforcement priorities as well as offending, so changes may reflect policy as much as behavior.
- **2026 is partial** (through 30 June) and is labelled year to date.
- **2020** was shaped by the pandemic and should be treated as an outlier.
- **Rates use 2020 population for every year**, which is reasonable for comparing boroughs but less precise for early years.
- **Manhattan's per-resident rate is inflated** by commuters and visitors arrested there who live elsewhere.
- This analysis describes patterns. It does not establish causes.

---

*Built by Amoni Haynes as part of a public-sector data portfolio. Feedback welcome via [LinkedIn](https://linkedin.com/amoni-haynes).*
