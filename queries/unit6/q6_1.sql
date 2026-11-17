-- 6.1.1.   Comparing each participation record to the match's average score.
--          How does the score of each participation record compare to the average score earned in a match?
--          REQUIREMENTS: SELECT, AVG, OVER, PARTITION
SELECT
    mp.participation_id, p.player_name AS participant, m.match_label AS match_participated_in,
    mp.participation_status, mp.score, ROUND(AVG(mp.score) OVER (PARTITION BY mp.match_id), 2) AS match_average_score
FROM match_participants mp
JOIN players p ON mp.player_id = p.player_id
JOIN matches m ON mp.match_id = m.match_id;
-- Returns 200 rows.

--  GROUP BY version of the query above.
--  What is the average score for each match?
SELECT m.match_label, ROUND(AVG(mp.score), 2) AS match_average_score
FROM match_participants mp
JOIN matches m ON mp.match_id = m.match_id
GROUP BY m.match_label ORDER BY m.match_label;
-- Returns 13 rows, costing individual participation records in the process.


-- 6.1.2.   Ranking matches in three ways.
--          How should the matches be ranked, based on their number of participation records?
--          REQUIREMENTS: SELECT, ROW_NUMBER, RANK, DENSE_RANK
SELECT
    m.match_label, COALESCE(COUNT(DISTINCT mp.participation_id), 0) AS participation_records,
    ROW_NUMBER() OVER (ORDER BY COALESCE(COUNT(DISTINCT mp.participation_id), 0) DESC) AS row_number,
    RANK() OVER (ORDER BY COALESCE(COUNT(DISTINCT mp.participation_id), 0) DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY COALESCE(COUNT(DISTINCT mp.participation_id), 0) DESC) AS dense_rank_num
FROM match_participants mp
RIGHT JOIN matches m ON mp.match_id = m.match_id
GROUP BY m.match_label;


-- 6.1.3.   Sorting matches into four bands.
--          Which matches lie on the edges of the quartile groups that are partitioned based on the number of participation records?
--          REQUIREMENTS: SELECT, NTILE(4)
SELECT
    m.match_label, COALESCE(COUNT(DISTINCT mp.participation_id), 0) AS participation_records,
    NTILE(4) OVER (ORDER BY COALESCE(COUNT(DISTINCT mp.participation_id), 0) DESC) AS participants_quartile
FROM match_participants mp
RIGHT JOIN matches m ON mp.match_id = m.match_id
GROUP BY m.match_label ORDER BY participants_quartile, participation_records DESC;
