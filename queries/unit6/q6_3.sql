-- 6.3A.    Rank the top three participants per match in terms of score.
--          What is the highest scoring player, and the two runner-ups, for each match?
--          REQUIREMENTS: ROW_NUMBER, CTE or subquery, FIRST_VALUE() or LAST_VALUE()
WITH ranked_participants_per_match AS (
    SELECT participation_id,
           ROW_NUMBER() OVER (PARTITION BY match_id ORDER BY (score, participation_status) DESC) AS ranking,
           FIRST_VALUE(player_id) OVER (PARTITION BY match_id ORDER BY (score, participation_status) DESC) AS best_player_id,
           player_id, match_id, joined_at, score, participation_status
    FROM match_participants ORDER BY match_id, ranking
) SELECT rppm.ranking, p.player_name, m.match_label, rppm.score, rppm.joined_at, rppm.participation_status,
         CASE WHEN rppm.player_id = rppm.best_player_id THEN 'This Row' ELSE bp.player_name END AS best_player_per_match
FROM ranked_participants_per_match rppm
JOIN players p ON rppm.player_id = p.player_id JOIN players bp ON rppm.best_player_id = bp.player_id JOIN matches m ON rppm.match_id = m.match_id
WHERE rppm.ranking <= 3;
-- A tiebreaker column is added to handle participants that are tied with the same score, such that the one that finished the match is picked over another that is contested.


-- 6.3B.    Comparing scores from each month with that from the previous.
--          Are the scores among match participants getting better or worse each month, and at what rate?
--          REQUIREMENTS: Grouping events into months, LAG(), percentage-change column with NULLIF()
WITH total_score_per_month AS ( SELECT EXTRACT(MONTH FROM joined_at) AS month, SUM(score) AS total_score_earned FROM match_participants GROUP BY month ),
with_previous_totals AS (SELECT *, LAG(total_score_earned) OVER (ORDER BY month) AS total_from_previous_month FROM total_score_per_month)
SELECT *, ROUND((total_score_earned - total_from_previous_month) / NULLIF(total_score_earned, 0) * 100, 1) AS pct_change
FROM with_previous_totals;