# Metric definitions

| Metric | Definition | Interpretation / caveat |
|---|---|---|
| Open pipeline | Sum of ACV where outcome = Open | Unweighted value of active opportunities |
| Weighted pipeline | Sum of ACV × probability for open opportunities | Probability-weighted estimate; not a calibrated forecast |
| Win rate | Closed Won ÷ (Closed Won + Closed Lost) | Count-based; excludes open opportunities |
| Average won deal size | Average ACV for Closed Won opportunities | Use won deals only |
| Average sales cycle | Average close date − created date for Closed Won | Won-deal cycle; excludes lost deals |
| Bookings | Sum of ACV for Closed Won opportunities by close month | Bookings proxy, not GAAP revenue |
| Quota attainment | Closed-won bookings ÷ rep-month target | Match both rep and month |
| Opportunity ageing | Snapshot date − opportunity created date | Age is not the same as time in current stage |
| Stale opportunity | Open opportunity with no activity in the defined lookback window | This project uses 30 days in its SQL example |
| ARR | Sum of ARR values in customers table | Derived from won opportunity ACV; synthetic proxy |
| MRR | ARR ÷ 12 | Simple monthly equivalent |
| Stage reach count | Distinct opportunities with a stage-history row | Not a cohort conversion rate unless cohort and time windows are aligned |

## Forecasting interpretation

A simple weighted pipeline is useful for prioritization, but it does not account for historical stage conversion, slippage, seasonality, or rep-level forecast bias. A production forecast should compare forecast snapshots to actual bookings over multiple periods.
