# Revenue Operations: Pipeline Performance & Forecasting

> **Portfolio project | Synthetic B2B SaaS CRM data | SQL + Python + Power BI**

## Project overview

This project builds a small Revenue Operations reporting layer from source-style CRM exports. It focuses on the operational questions a RevOps analyst is expected to answer:

- What is the value of the open sales pipeline, and how much is probability-weighted?
- Where are opportunities progressing or stalling?
- What are the win rate, average deal size, and sales-cycle trends?
- How are sales reps performing against monthly bookings targets?
- Which open opportunities have gone too long without a sales activity?
- How reliable is the CRM data behind management reporting?

All company, account, rep, and opportunity records are **synthetic**. The fictional business context is a B2B SaaS provider. No real customer or employer data is included.

## What is included

| Layer | Contents |
|---|---|
| Raw data | CSV exports for leads, accounts, opportunities, stage history, activities, reps, targets, and customers |
| Data preparation | Python script to standardize fields, enrich opportunities, and produce QA reports |
| SQL | Table definitions, pipeline/funnel/performance queries, and data-quality checks |
| Power BI | Dashboard specification, model relationships, and DAX measure library |
| Documentation | Data dictionary, metric definitions, assumptions, build steps, and QA checklist |

## Repository map

```text
revops-pipeline-performance/
├── README.md
├── data/
│   ├── raw/                 # Original synthetic source-style CSVs
│   ├── processed/           # Created by the Python preparation script
│   └── reference/           # Reserved for lookup tables / mappings
├── python/
│   ├── 01_prepare_data.py
│   └── requirements.txt
├── sql/
│   ├── 01_schema.sql
│   ├── 02_analysis_queries.sql
│   └── 03_data_quality_checks.sql
├── dax/
│   └── revops_measures.dax
├── power_bi/
│   └── POWER_BI_BUILD_GUIDE.md
├── docs/
│   ├── DATA_DICTIONARY.md
│   ├── METRIC_DEFINITIONS.md
│   ├── ASSUMPTIONS_AND_LIMITATIONS.md
│   └── PROJECT_WALKTHROUGH.md
└── outputs/
    ├── qa_reports/
    └── summary_tables/
```

## Quick start

### 1. Create a Python environment

```bash
python -m venv .venv
# Windows:
.venv\\Scripts\\activate
# macOS/Linux:
source .venv/bin/activate

pip install -r python/requirements.txt
```

### 2. Prepare the datasets

From the repository root:

```bash
python python/01_prepare_data.py
```

This writes:
- `data/processed/opportunities_enriched.csv`
- `data/processed/opportunity_activity_health.csv`
- `outputs/qa_reports/table_profile.csv`
- `outputs/qa_reports/referential_integrity.csv`

### 3. Load the raw CSVs into PostgreSQL

Create a database, run `sql/01_schema.sql`, then import the CSVs from `data/raw/` into tables with the same names. Run the analytical queries in `sql/02_analysis_queries.sql` and validation checks in `sql/03_data_quality_checks.sql`.

### 4. Build the Power BI report

Follow `power_bi/POWER_BI_BUILD_GUIDE.md`. Import the raw and processed CSVs, create the relationships, add the DAX measures from `dax/revops_measures.dax`, and build the four report pages described in the guide.

**Note:** A `.pbix` file is not included in this source package. Power BI Desktop is required to create and save the interactive report. Do not represent a dashboard as completed until you have built it and validated its measures.

## Dashboard pages to build

1. **Revenue & Sales Performance** — closed-won bookings, win rate, average deal size, sales cycle, rep attainment.
2. **Funnel & Stage Progression** — opportunity counts by stage, stage-entry counts, win/loss outcomes.
3. **Pipeline Health & Forecast** — open pipeline, weighted pipeline, ageing, forecast by rep and stage.
4. **CRM & Activity Hygiene** — stale opportunities, last activity, duplicate/incomplete lead flags, referential integrity.

## Important analytical notes

- Funnel stage-history counts represent the number of unique opportunities that entered each stage. They are not automatically a same-period cohort conversion rate.
- Weighted pipeline is `ACV × probability` for open opportunities. It is a simple probability-weighted view, not a statistically calibrated forecast.
- Closed-won bookings use opportunity ACV and close date. This is a bookings proxy, not recognized revenue.
- Customer ARR is derived from closed-won opportunities and should not be added to bookings in the same chart without explaining the different time basis.
- Targets are monthly rep-level booking targets. Attainment should be filtered to the matching rep and month.

## Attribution and project development

This repository is an independent portfolio implementation using synthetic data and original scripts/documentation. It was informed by common RevOps analytics patterns and reviewed alongside the public reference project:
[DurellMarshall/revenue-ops-analytics-layer](https://github.com/DurellMarshall/revenue-ops-analytics-layer).

If you use or adapt that repository's code, assets, or dashboard, preserve its license and attribution. This package does not copy its PBIX or claim its work as yours.

## Suggested portfolio presentation

Explain the project in this order:
1. Reporting problem and source systems.
2. Dataset design and relational keys.
3. Data cleaning and quality checks.
4. Metric definitions and SQL logic.
5. Power BI model and dashboard decisions.
6. Findings, limitations, and operational recommendations.

## Current build status

- [x] Synthetic source datasets generated
- [x] Python preparation and QA script included
- [x] SQL schema, analysis queries, and QA checks included
- [x] DAX measure library included
- [x] Data dictionary and metric documentation included
- [ ] Power BI report built and saved as `.pbix` by project owner
- [ ] Dashboard screenshots captured after validation
- [ ] SQL queries executed against a local database
