# Data dictionary

All datasets are synthetic. Primary keys are shown in **bold**.

| File / table | Grain | Key fields | Purpose |
|---|---|---|---|
| `leads` | One row per lead | **lead_id**, account_id | Lead status and source; includes explicit duplicate/incomplete QA flags |
| `accounts` | One row per account | **account_id** | Account attributes used to enrich opportunity reporting |
| `opportunities` | One row per opportunity | **opportunity_id**, account_id, rep_id | Current pipeline stage, ACV, probability, outcome, loss reason |
| `opportunity_stage_history` | One row per opportunity-stage entry | opportunity_id + stage | Historical stage progression and stage-entry analysis |
| `sales_activities` | One row per logged activity | **activity_id**, opportunity_id | Calls, emails, meetings, demos and task activity |
| `sales_reps` | One row per sales rep | **rep_id** | Rep/team/manager lookup |
| `sales_targets` | One row per rep-month | rep_id + target_month | Monthly bookings quota |
| `customers` | One row per won customer | **customer_id**, source_opportunity_id | ARR proxy derived from closed-won opportunities |

## Important fields

### Opportunities
- `current_stage`: current stage at the reporting snapshot.
- `acv`: annual contract value used as the deal value proxy.
- `probability`: stage-based illustrative probability from 0 to 1.
- `outcome`: `Open`, `Closed Won`, or `Closed Lost`.
- `close_date`: populated for closed opportunities.
- `lost_reason`: populated for closed-lost opportunities.
- `opportunity_type`: `New Business` or `Expansion`.

### Stage history
- `stage_entered_date`: date the opportunity entered the stage.
- `stage_probability`: illustrative probability assigned to that stage.

### CRM quality fields
- `possible_duplicate_flag`: synthetic flag for a lead record that should be reviewed.
- `incomplete_record_flag`: synthetic flag for a lead record with incomplete required information.

## Relationships
- `accounts[account_id]` 1 → * `leads[account_id]`
- `accounts[account_id]` 1 → * `opportunities[account_id]`
- `sales_reps[rep_id]` 1 → * `opportunities[rep_id]`
- `opportunities[opportunity_id]` 1 → * `opportunity_stage_history[opportunity_id]`
- `opportunities[opportunity_id]` 1 → * `sales_activities[opportunity_id]`
- `sales_reps[rep_id]` 1 → * `sales_targets[rep_id]`
- `opportunities[opportunity_id]` 1 → 0/1 `customers[source_opportunity_id]`
