-- 5.3A.1.  Counting the rows of each source before cross join.
WITH avg_score_per_participation AS ( SELECT ROUND(AVG(score), 2) AS avg_score FROM match_participants )
SELECT COUNT(*) FROM avg_score_per_participation;   -- 1 row returned.

WITH avg_score_per_match AS (
    SELECT m.match_label, ROUND(AVG(mp.score), 2) AS avg_score_per_match
    FROM match_participants mp
    JOIN matches m ON mp.match_id = m.match_id
    GROUP BY m.match_label ORDER BY m.match_label
) SELECT COUNT(*) FROM avg_score_per_match;  -- 13 rows returned.

-- 5.3A.2.  Using cross join to find how much the average score per match has deviated from the average score per participation.
--          REQUIREMENTS: WITH, SELECT, CROSS JOIN
WITH avg_score_per_participation AS ( SELECT ROUND(AVG(score), 2) AS avg_score FROM match_participants )
SELECT m.match_label, ROUND(AVG(mp.score), 2) AS avg_score_per_match,
       ROUND(AVG(mp.score), 2) - aspp.avg_score AS deviation_from_overall_average_score
FROM match_participants mp
JOIN matches m ON mp.match_id = m.match_id
CROSS JOIN avg_score_per_participation aspp
GROUP BY m.match_label, aspp.avg_score ORDER BY m.match_label;
-- Counting the resulting rows: 13
WITH cross_join_result AS (
    WITH avg_score_per_participation AS ( SELECT ROUND(AVG(score), 2) AS avg_score FROM match_participants )
    SELECT m.match_label, ROUND(AVG(mp.score), 2) AS avg_score_per_match,
           ROUND(AVG(mp.score), 2) - aspp.avg_score AS deviation_from_overall_average_score
    FROM match_participants mp
    JOIN matches m ON mp.match_id = m.match_id
    CROSS JOIN avg_score_per_participation aspp
    GROUP BY m.match_label, aspp.avg_score ORDER BY m.match_label
) SELECT COUNT(*) FROM cross_join_result;

-- 5.3A.3   1 * 13 = 13

-- 5.3A.4   A Cartesian product could be useful when it comes to scalar subqueries that compare each entity's aggregated value against the
--          overall aggregated value of the table, i.e. finding how much each match's average score diverges from the overall average score
--          in the match_participants table.  It could return an error if two tables are used in the FROM clause without any JOIN or ON
--          operation.

-- 5.3B.1   Capturing the execution plan of the query from 5.1.1.
--          REQUIREMENTS: EXPLAIN, SELECT
EXPLAIN
SELECT p.player_name, m.match_label, TO_CHAR(mp.joined_at, 'YYYY-MM-DD HH24:MI:SS') AS paricipation_timestamp FROM players p
JOIN match_participants mp ON p.player_id = mp.player_id JOIN matches m ON mp.match_id = m.match_id;

-- 5.3B.2   Nested loop, hash join, hash condition, sequence scan, hash, memoize, cache, index scan, and index condition is used.

-- 5.3B.2   Nested loop join is chosen because it involves an index lookup in the (right) matches table, which is far smaller than the (left)
--          match_participants table, while looking for rows in the latter that matches with those in the former with the surrogate key, match_id.
--          Given that it serves as a primary key for the matches table, it therefore serves as an index of that table.  Meanwhile, hash join is
--          used since it joins the (left) players table with a much larger (right) match_participants via another surrogate key, player_id.  That
--          key, while serving as an index of the former, does not serve as an index of the latter, as that table is not sorted by the key.
--          Furthermore, the associated join condition is an equi-join.

-- 5.3B.4   As the dataset grows, the second (inner) join operation of the query from 5.1.1., JOIN matches m ON mp.match_id = m.match_id, becomes
--          less efficient.