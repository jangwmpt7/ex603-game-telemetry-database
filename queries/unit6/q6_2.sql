-- 6.2A.    Return the list of participation records, ordered by time and comparing to the previous and next one along the way.
--          Is the score among match participants going up or down overtime?
--          REQUIREMENTS: SELECT, LAG(), LEAD(), OVER, PARTITION BY, ORDER BY, delta column (current - previous), WHERE match_id = something
WITH participant_scores AS (
    SELECT participation_id, player_id, match_id, joined_at, score,
           LAG(score) OVER (PARTITION BY match_id ORDER BY joined_at) AS prev_score,
           LEAD(score) OVER (PARTITION BY match_id ORDER BY joined_at) AS next_score,
           participation_status
    FROM match_participants ORDER BY joined_at
) SELECT ps.participation_id, p.player_name, m.match_label, ps.joined_at, ps.score, ps.prev_score,
         ps.score - ps.prev_score AS difference_from_previous, -- Delta column
         ps.next_score, ps.participation_status
FROM participant_scores ps
JOIN players p ON ps.player_id = p.player_id JOIN matches m ON ps.match_id = m.match_id
WHERE ps.match_id = 1;  -- Filter to one match to easily read the trend.

-- 6.2B.    Find the running total and moving average of participant scores over time.
--          How are the scores over time, both in terms in running totals and 16-record moving averages and how they got there?
--          REQUIREMENTS: SELECT, SUM(), OVER, ORDER BY, ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, AVG, ROWS BETWEEN n PRECEDING AND CURRENT ROW,
--          target for running total
WITH quarterly_target AS ( SELECT SUM(score)/4 AS target_total_score_per_quarter FROM match_participants ), -- Quarterly target.
running_total_and_moving_averages AS (
    SELECT participation_id, player_id, match_id, joined_at, score,
           SUM(score) OVER (ORDER BY joined_at ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
           AVG(score) OVER (ORDER BY joined_at ROWS BETWEEN 16 PRECEDING AND CURRENT ROW) AS moving_average,
           participation_status
    FROM match_participants
    ORDER BY joined_at
), remaining_total_until_quarterly_target AS (
    SELECT rtama.participation_id, rtama.player_id, rtama.match_id, rtama.joined_at,
           rtama.score, rtama.running_total, ROUND(rtama.moving_average, 2) AS moving_average, rtama.participation_status,
           ROUND(qt.target_total_score_per_quarter - (rtama.running_total % qt.target_total_score_per_quarter), 2) AS modulo,
           ROUND(qt.target_total_score_per_quarter, 2) AS target_quarterly_total
    FROM running_total_and_moving_averages rtama
    CROSS JOIN quarterly_target qt
) SELECT rtuqt.participation_id, p.player_name, m.match_label, rtuqt.joined_at, rtuqt.score, rtuqt.participation_status, rtuqt.running_total, rtuqt.moving_average,
         CASE WHEN rtuqt.modulo = rtuqt.target_quarterly_total AND rtuqt.running_total != 0 THEN 0 ELSE modulo END AS remaining_score_until_quarterly_target,
         rtuqt.target_quarterly_total
FROM remaining_total_until_quarterly_target rtuqt
JOIN players p ON rtuqt.player_id = p.player_id JOIN matches m ON rtuqt.match_id = m.match_id;
-- ROWS treat two or more rows that share a value/date in a specific order as individual ones, whereas RANGE groups these rows into one.

-- 6.2C.    Find the gap between the every two occurrences of participation records in a match.
--          Are there gaps in match participation records in terms of days?
--          REQUIREMENTS: SELECT, LAG() or LEAD(), CTE or subquery, WHERE
WITH daily_match_participants AS (
    SELECT match_id, joined_at::date AS day, COUNT(*) AS daily_participants FROM match_participants GROUP BY (match_id, day) ORDER BY match_id, day
), gaps AS (
    SELECT *, LAG(day) OVER (PARTITION BY match_id ORDER BY day) AS prev_day
    FROM daily_match_participants dmp
), gaps2 AS ( SELECT *, day - prev_day AS days_since_prev FROM gaps )
SELECT m.match_label, g.daily_participants, g.day AS current_day, g.prev_day, g.days_since_prev  FROM gaps2 g
JOIN matches m ON g.match_id = m.match_id WHERE days_since_prev > 1;
-- If so, is the participation data lost between the gaps of match participation records?

-- Additional query that takes account of gaps.
WITH calendar_2023 AS ( SELECT generate_series('2023-01-01'::date, '2023-12-31'::date, interval '1 day')::date AS day ),
daily_total_scores AS (
    SELECT c.day, COALESCE(SUM(mp.score), 0) AS daily_total_score FROM calendar_2023 c LEFT JOIN match_participants mp ON c.day = mp.joined_at::date GROUP BY c.day ORDER BY c.day
), quarterly_target AS ( SELECT SUM(score)/4 AS target_total_score_per_quarter FROM match_participants ), -- Quarterly target.
running_total_and_moving_average_scores AS (
    SELECT dts.day, dts.daily_total_score,
           SUM(dts.daily_total_score) OVER (ORDER BY dts.day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
           AVG(dts.daily_total_score) OVER (ORDER BY dts.day ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) as moving_7_day_average
    FROM daily_total_scores dts
), remaining_total_until_quarterly_target AS (
    SELECT rtamas.day, rtamas.daily_total_score, rtamas.running_total, ROUND(rtamas.moving_7_day_average, 2) AS moving_7day_average,
           ROUND(qt.target_total_score_per_quarter - (rtamas.running_total % qt.target_total_score_per_quarter), 2) AS modulo,
           ROUND(qt.target_total_score_per_quarter, 2) AS target_quarterly_total
    FROM running_total_and_moving_average_scores rtamas CROSS JOIN quarterly_target qt
) SELECT day, running_total, moving_7day_average,
         CASE WHEN (modulo = target_quarterly_total AND running_total != 0) THEN 0 ELSE modulo END AS remaining_score_until_quarterly_target,
         target_quarterly_total
FROM remaining_total_until_quarterly_target;