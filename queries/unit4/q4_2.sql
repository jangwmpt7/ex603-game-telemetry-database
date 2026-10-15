-- 4.2A.    Compute the total numbers of all participations and those classified with network timeouts for each match.
--          REQUIREMENTS: SELECT, COUNT, CASE
SELECT match_id, COUNT(*) AS total_participations, COUNT(CASE WHEN disconnect_reason = 'Network timeout' THEN 1 END) AS network_timeouts
FROM match_participants GROUP BY match_id ORDER BY match_id;
--  How many participation records for each match?  How many of them are classified with network timeouts for each match?

-- 4.2B.    Find regional subtotals and a platform-wide grand total without including individual detail rows.
--          REQUIREMENTS: SELECT, CASE, GROUPING, GROUP BY ROLLUP
SELECT
    CASE WHEN GROUPING(client_region) = 1 THEN 'All regions' ELSE client_region::TEXT END as client_region, COUNT(*) AS total_participations,
    COUNT(CASE WHEN disconnect_reason = 'Network timeout' THEN 1 END) AS network_timeouts
FROM match_participants
GROUP BY ROLLUP(client_region);
--  The regional director finds that the grand total only generalizes the data across all regions, whereas the subtotals more precisely showed the data per region.

-- 4.2C.    Query that uses CTEs to summarizes per-match performance and perform a second aggregation to calculate a baseline for high-volume matches.
--          REQUIREMENTS: WITH, SELECT
WITH match_performance AS (
    SELECT match_id, COUNT(*) AS total_participations, ROUND(AVG(score), 2) AS average_score FROM match_participants
    GROUP BY match_id
), average_participation_per_match AS (
    SELECT ROUND(AVG(total_participations)) AS average_participations FROM match_performance
)
SELECT match_id, total_participations, average_score FROM match_performance
CROSS JOIN average_participation_per_match WHERE total_participations > average_participations
ORDER BY total_participations DESC;
--  What should be the minimum number of participants to consider for each match?