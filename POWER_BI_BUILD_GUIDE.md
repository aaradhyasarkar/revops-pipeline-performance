# Power BI build guide

## Import
Use Power BI Desktop → Get Data → Text/CSV. Import:
- `data/processed/opportunities_enriched.csv`
- `data/raw/sales_reps.csv`
- `data/raw/sales_targets.csv`
- `data/raw/opportunity_stage_history.csv`
- `data/raw/sales_activities.csv`
- `data/raw/customers.csv`
- `data/raw/accounts.csv`
- `data/raw/leads.csv`

Run the Python preparation script before importing processed files.

## Model
Recommended relationships:
- SalesReps[rep_id] 1:* Opportunities[rep_id]
- Accounts[account_id] 1:* Opportunities[account_id]
- Opportunities[opportunity_id] 1:* SalesActivities[opportunity_id]
- Opportunities[opportunity_id] 1:* OpportunityStageHistory[opportunity_id]
- SalesReps[rep_id] 1:* SalesTargets[rep_id]
- Opportunities[opportunity_id] 1:0..1 Customers[source_opportunity_id]

Create a dedicated Date table and relate it to Opportunities[close_date] for bookings reporting. Use a separate inactive relationship or role-playing date table for created_date analysis.

## Page 1 — Revenue & Sales Performance
Cards: Closed Won Bookings, Win Rate %, Average Won Deal Size, Average Sales Cycle (Days).
Charts: bookings by month, quota attainment by rep, won deals by rep.
Slicers: close month, rep, sales team.

## Page 2 — Funnel & Stage Progression
Charts: opportunity count by current stage, distinct opportunities reaching each historical stage, closed won vs closed lost.
Table: stage reach counts and stage-entry dates.
Add a note that stage reach is not a cohort conversion rate.

## Page 3 — Pipeline Health & Forecast
Cards: Total Pipeline, Weighted Pipeline, Open Opportunity Count.
Charts: open pipeline by stage, weighted pipeline by rep, pipeline by forecast stage.
Table: opportunity, rep, stage, ACV, probability, weighted pipeline, created date.

## Page 4 — CRM & Activity Hygiene
Charts: lead duplicate flags, incomplete lead flags, stale open opportunities by rep.
Table: open opportunity with last activity date and days since last touch.
Use 30 days as the illustrative stale threshold and label it.

## Validation before publishing
- Confirm totals in Power BI match SQL results.
- Check that closed-won bookings exclude open and lost opportunities.
- Check that target attainment matches rep and month.
- Check that weighted pipeline includes only open opportunities.
- Check relationship cardinality and avoid many-to-many joins.
- Label all data as synthetic and all amounts with an explicit currency/unit.
