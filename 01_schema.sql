-- PostgreSQL-compatible starter schema.
-- Import CSVs from data/raw into tables with matching names/columns.

CREATE TABLE IF NOT EXISTS accounts (
  account_id VARCHAR(10) PRIMARY KEY, account_name TEXT, industry TEXT,
  company_size TEXT, billing_country TEXT, created_date DATE
);
CREATE TABLE IF NOT EXISTS sales_reps (
  rep_id VARCHAR(10) PRIMARY KEY, rep_name TEXT, sales_team TEXT, manager TEXT
);
CREATE TABLE IF NOT EXISTS leads (
  lead_id VARCHAR(10) PRIMARY KEY, account_id VARCHAR(10), created_date DATE,
  lead_source TEXT, persona TEXT, lead_status TEXT, country TEXT,
  possible_duplicate_flag INTEGER, incomplete_record_flag INTEGER
);
CREATE TABLE IF NOT EXISTS opportunities (
  opportunity_id VARCHAR(10) PRIMARY KEY, account_id VARCHAR(10), rep_id VARCHAR(10),
  created_date DATE, current_stage TEXT, acv NUMERIC(14,2), probability NUMERIC(5,2),
  close_date DATE, outcome TEXT, lost_reason TEXT, opportunity_type TEXT
);
CREATE TABLE IF NOT EXISTS opportunity_stage_history (
  opportunity_id VARCHAR(10), stage TEXT, stage_entered_date DATE, stage_probability NUMERIC(5,2)
);
CREATE TABLE IF NOT EXISTS sales_activities (
  activity_id VARCHAR(12) PRIMARY KEY, opportunity_id VARCHAR(10), rep_id VARCHAR(10),
  activity_type TEXT, activity_date DATE, activity_status TEXT, activity_subject TEXT
);
CREATE TABLE IF NOT EXISTS sales_targets (
  rep_id VARCHAR(10), target_month DATE, monthly_bookings_target NUMERIC(14,2)
);
CREATE TABLE IF NOT EXISTS customers (
  customer_id VARCHAR(10) PRIMARY KEY, source_opportunity_id VARCHAR(10),
  account_id VARCHAR(10), account_owner_rep_id VARCHAR(10), contract_start_date DATE,
  contract_term_months INTEGER, arr NUMERIC(14,2)
);
