# Project walkthrough and interview notes

## 1. Problem
Sales leadership needs consistent visibility into open pipeline, weighted pipeline, bookings, quota attainment, stage progression, sales-cycle duration, and CRM hygiene. The source information is spread across separate CRM-style exports.

## 2. Data design
The project separates accounts, leads, opportunities, activities, stage history, sales reps, targets, and customers. The opportunity table stores the current snapshot; stage history stores progression events. This distinction prevents the common mistake of treating current stage as a complete funnel history.

## 3. Preparation
The Python pipeline standardizes dates and text, removes duplicate primary-key rows, enriches opportunities with account and rep attributes, calculates weighted pipeline, and creates table-profile and referential-integrity reports.

## 4. SQL analysis
The SQL scripts cover pipeline by stage, win rate, average sales cycle, rep quota attainment, stale opportunity identification, stage reach counts, and data-quality exceptions.

## 5. Power BI
The report is designed as four pages: Revenue & Sales Performance, Funnel & Stage Progression, Pipeline Health & Forecast, and CRM & Activity Hygiene. The DAX file contains reusable measures.

## 6. Limitations
The weighted pipeline is a simple estimate, not a calibrated forecast. The data has no historical forecast snapshots, so forecast accuracy cannot be calculated. Stage reach counts are not cohort conversion rates without cohort alignment.

## Interview prompts to prepare
- Why separate opportunity current state from stage history?
- Why exclude open opportunities from win-rate denominator?
- What is the difference between bookings, ARR, and recognized revenue?
- Why can weighted pipeline be misleading?
- How would you define a stale opportunity?
- What CRM quality checks would you automate?
- What extra data would you request to measure forecast accuracy?
