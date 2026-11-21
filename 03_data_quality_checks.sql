-- Run after loading source tables.
SELECT 'duplicate_lead_ids' AS test, COUNT(*) AS failures
FROM (SELECT lead_id FROM leads GROUP BY lead_id HAVING COUNT(*)>1) x
UNION ALL
SELECT 'orphan_opportunity_accounts', COUNT(*)
FROM opportunities o LEFT JOIN accounts a USING(account_id)
WHERE a.account_id IS NULL
UNION ALL
SELECT 'orphan_opportunity_reps', COUNT(*)
FROM opportunities o LEFT JOIN sales_reps r USING(rep_id)
WHERE r.rep_id IS NULL
UNION ALL
SELECT 'probability_out_of_range', COUNT(*)
FROM opportunities WHERE probability < 0 OR probability > 1
UNION ALL
SELECT 'negative_acv', COUNT(*)
FROM opportunities WHERE acv < 0;
