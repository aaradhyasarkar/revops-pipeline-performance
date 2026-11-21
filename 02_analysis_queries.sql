-- 1. Current pipeline by stage
SELECT current_stage, COUNT(*) AS opportunity_count,
       SUM(acv) AS pipeline_value,
       SUM(acv * probability) AS weighted_pipeline
FROM opportunities
WHERE outcome = 'Open'
GROUP BY current_stage
ORDER BY weighted_pipeline DESC;

-- 2. Closed opportunity win rate (count-based)
SELECT COUNT(*) FILTER (WHERE outcome='Closed Won') AS won_count,
       COUNT(*) FILTER (WHERE outcome='Closed Lost') AS lost_count,
       ROUND(100.0 * COUNT(*) FILTER (WHERE outcome='Closed Won') /
         NULLIF(COUNT(*) FILTER (WHERE outcome IN ('Closed Won','Closed Lost')),0),2) AS win_rate_pct
FROM opportunities;

-- 3. Average sales cycle (won deals only)
SELECT ROUND(AVG(close_date - created_date),1) AS avg_days_to_close
FROM opportunities
WHERE outcome='Closed Won' AND close_date IS NOT NULL;

-- 4. Rep performance vs monthly bookings target
WITH bookings AS (
  SELECT rep_id, DATE_TRUNC('month', close_date)::date AS booking_month,
         SUM(acv) AS closed_won_bookings
  FROM opportunities
  WHERE outcome='Closed Won'
  GROUP BY 1,2
)
SELECT t.rep_id, t.target_month, t.monthly_bookings_target,
       COALESCE(b.closed_won_bookings,0) AS closed_won_bookings,
       ROUND(100.0 * COALESCE(b.closed_won_bookings,0) /
         NULLIF(t.monthly_bookings_target,0),1) AS attainment_pct
FROM sales_targets t
LEFT JOIN bookings b
  ON b.rep_id=t.rep_id AND b.booking_month=t.target_month
ORDER BY t.target_month, t.rep_id;

-- 5. Opportunity ageing / stale pipeline
WITH last_touch AS (
  SELECT opportunity_id, MAX(activity_date) AS last_activity_date
  FROM sales_activities
  GROUP BY opportunity_id
)
SELECT o.opportunity_id, o.current_stage, o.acv, o.rep_id,
       COALESCE(l.last_activity_date,o.created_date) AS last_touch_date,
       CURRENT_DATE - COALESCE(l.last_activity_date,o.created_date) AS days_since_touch
FROM opportunities o
LEFT JOIN last_touch l USING (opportunity_id)
WHERE o.outcome='Open'
ORDER BY days_since_touch DESC;

-- 6. Stage conversion using stage-history presence (cohort caveat: stage-entry counts)
WITH stage_counts AS (
  SELECT stage, COUNT(DISTINCT opportunity_id) AS opps_reached
  FROM opportunity_stage_history
  GROUP BY stage
)
SELECT stage, opps_reached,
       LAG(opps_reached) OVER (ORDER BY
         CASE stage WHEN 'Qualification' THEN 1 WHEN 'Discovery' THEN 2
          WHEN 'Demo' THEN 3 WHEN 'Proposal' THEN 4 WHEN 'Negotiation' THEN 5
          WHEN 'Closed Won' THEN 6 WHEN 'Closed Lost' THEN 7 END
       ) AS previous_stage_count
FROM stage_counts
ORDER BY CASE stage WHEN 'Qualification' THEN 1 WHEN 'Discovery' THEN 2
 WHEN 'Demo' THEN 3 WHEN 'Proposal' THEN 4 WHEN 'Negotiation' THEN 5
 WHEN 'Closed Won' THEN 6 WHEN 'Closed Lost' THEN 7 END;

-- 7. CRM data quality exceptions
SELECT 'Possible duplicate lead' AS issue_type, COUNT(*) AS issue_count
FROM leads WHERE possible_duplicate_flag=1
UNION ALL
SELECT 'Incomplete lead record', COUNT(*)
FROM leads WHERE incomplete_record_flag=1
UNION ALL
SELECT 'Opportunity missing account', COUNT(*)
FROM opportunities WHERE account_id IS NULL
UNION ALL
SELECT 'Open opportunity missing recent activity', COUNT(*)
FROM opportunities o
WHERE o.outcome='Open' AND NOT EXISTS (
  SELECT 1 FROM sales_activities a
  WHERE a.opportunity_id=o.opportunity_id
    AND a.activity_date >= CURRENT_DATE - INTERVAL '30 days'
);
