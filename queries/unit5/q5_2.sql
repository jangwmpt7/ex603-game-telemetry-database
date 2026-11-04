-- 5.2A.1.  Find all matches, including the ones that are not associated with any participant.
--          REQUIREMENTS: SELECT, LEFT JOIN
SELECT DISTINCT m.match_label FROM matches m
LEFT JOIN match_participants mp ON m.match_id = mp.match_id
ORDER BY m.match_label;

-- 5.2A.2.  Same query, but uses INNER JOIN.
--          REQUIREMENTS: SELECT, INNER JOIN
SELECT DISTINCT m.match_label FROM matches m
INNER JOIN match_participants mp ON m.match_id = mp.match_id
ORDER BY m.match_label;

-- 5.2A.3.  Given the differences of the results of the two queries above...
WITH num_all_matches AS (
    SELECT COUNT(DISTINCT m.match_label) AS num_matches FROM matches m
    LEFT JOIN match_participants mp ON m.match_id = mp.match_id
), num_matches_with_participants AS (
    SELECT COUNT(DISTINCT m.match_label) AS num_matches FROM matches m
    INNER JOIN match_participants mp ON m.match_id = mp.match_id
) SELECT nam.num_matches - nmwp.num_matches AS difference FROM num_all_matches nam, num_matches_with_participants nmwp;
-- ...2 matches are excluded in the second query (5.2A.2) with the INNER JOIN.

-- 5.2A.4.  Finding matches that are missing in the results of query 5.2A.2
WITH all_matches AS (
    SELECT DISTINCT m.match_label FROM matches m
    LEFT JOIN match_participants mp ON m.match_id = mp.match_id
    ORDER BY m.match_label
), matches_with_participants AS (
    SELECT DISTINCT m.match_label FROM matches m
    INNER JOIN match_participants mp ON m.match_id = mp.match_id
    ORDER BY m.match_label
) SELECT match_label AS missing_matches FROM all_matches EXCEPT (SELECT match_label FROM matches_with_participants);
--  Matches 14 and 15 (with their respective IDs as 14 and 15) are missing from the results of query 5.2A.2 because its INNER JOIN excludes any
--  match that does not have any matching participation records of the match_participants table that matches via the surrogate key, match_id.

-- 5.2B.1.  Same as 5.2A.1, but with RIGHT JOIN.
--          REQUIREMENTS: SELECT, RIGHT JOIN
SELECT DISTINCT m.match_label FROM match_participants mp
RIGHT JOIN matches m ON mp.match_id = m.match_id
ORDER BY m.match_label;

-- 5.2B.2.  Confirming that both queries of 5.2A.1 and 5.2B.1 return the same results.
WITH queryA AS (
    SELECT DISTINCT m.match_label FROM matches m
    LEFT JOIN match_participants mp ON m.match_id = mp.match_id
    ORDER BY m.match_label
), queryB AS (
    SELECT DISTINCT m.match_label FROM match_participants mp
    RIGHT JOIN matches m ON mp.match_id = m.match_id
    ORDER BY m.match_label
) SELECT * FROM queryA EXCEPT ( SELECT * FROM queryB );

WITH queryA AS (
    SELECT DISTINCT m.match_label FROM matches m
    LEFT JOIN match_participants mp ON m.match_id = mp.match_id
    ORDER BY m.match_label
), queryB AS (
    SELECT DISTINCT m.match_label FROM match_participants mp
    RIGHT JOIN matches m ON mp.match_id = m.match_id
    ORDER BY m.match_label
) SELECT * FROM queryB EXCEPT ( SELECT * FROM queryA );
-- These queries that compare the difference between two queries each return nothing, confirming that those two queries return the same results.

-- 5.2B.3.  Find matches and participation records by label and ID, respectively, including those that lack matches with each other.
--          REQUIREMENTS: SELECT, FULL OUTER JOIN
SELECT DISTINCT m.match_label, mp.participation_id
FROM matches m
FULL OUTER JOIN match_participants mp ON m.match_id = mp.match_id
ORDER BY m.match_label, mp.participation_id;

-- 5.2B.4.  A full outer join can simultaneously show both matches without any matching participation records and vice versa in a single result,
--          whereas left and right joins can each only show either one or the other within a result.

-- 5.2C.    Two queries that find matches that never has any associated participants, one using NOT EXISTS and the other using EXCEPT.
--          REQUIREMENTS: SELECT, NOT EXISTS (first query), EXCEPT (second query)
SELECT match_label FROM matches m WHERE NOT EXISTS
    ( SELECT 1 FROM match_participants mp WHERE m.match_id = mp.match_id);

SELECT match_label FROM matches EXCEPT
    ( SELECT match_label FROM matches m JOIN match_participants mp ON m.match_id = mp.match_id );
-- Both of these queries each identify the same two matches without any participation records.
-- The first query uses NOT EXISTS to know whether there are no rows in match_participants that matches with each match by its ID, whereas
-- the second query uses EXCEPT to subtract participant-associated matches from all matches in the matches table.

-- Additional query that compares each match's stated player count in the Matches table with the actual number of (unique) players as its
-- participants and the number of participation records it is associated with.
SELECT m.match_label, m.player_count AS stated_player_count,
       COALESCE(COUNT(DISTINCT mp.player_id), 0) AS actual_unique_player_count,
       COALESCE(COUNT(DISTINCT mp.participation_id), 0) AS associated_participation_records
FROM matches m
LEFT JOIN match_participants mp ON m.match_id = mp.match_id GROUP BY m.match_label, stated_player_count;

-- Another additional query that assumes player_count as a derived attribute.
SELECT match_label, COALESCE(COUNT(DISTINCT mp.player_id), 0) AS player_count FROM matches m
LEFT JOIN match_participants mp ON m.match_id = mp.match_id GROUP BY m.match_label;
