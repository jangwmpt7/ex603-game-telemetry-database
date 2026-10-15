-- 4.1.1.   Calculate the count, average, minimum, and maximum of scores, alongside the number of distinct players, from the match_participants table.
--          REQUIREMENTS: SELECT, COUNT, AVG, MIN, MAX, DISTINCT
SELECT
    COUNT(score) AS total_plays, ROUND(AVG(score), 2) AS average_score_per_match, MIN(score) AS minimum_score,
    MAX(score) AS maximum_score, COUNT(DISTINCT player_id) AS unique_participants
FROM match_participants;
--  Note that the minimum score has been found to be zero, and records with that value for the score all represent players who have prematurely disconnected from the match,
--  be it quitting by oneself and technical issues, particularly network timeouts.

-- 4.1.2.   Calculate the participation count and average score for each match, sorted from the match with the most participations to the one with the least.
--          REQUIREMENTS: SELECT, COUNT, AVG, GROUP BY, ORDER BY
SELECT match_id, COUNT(*) AS total_participations, ROUND(AVG(score), 2) AS average_score FROM match_participants
GROUP BY match_id ORDER BY total_participations DESC;
--  Note that matches with fewer participation records generally underestimate the average score per participation with their average score by a significant amount.
--  For that, I could consider that these matches might have high rates of network timeouts that attributed to their below-average performance.

-- 4.1.3.   Same query as above, but only looking for ones that each has at least 16 participation records.
--          REQUIREMENTS: SELECT, COUNT, AVG, GROUP BY, HAVING, ORDER BY
SELECT match_id, COUNT(*) AS total_participations, ROUND(AVG(score), 2) AS average_score FROM match_participants
GROUP BY match_id HAVING COUNT(*) >= 16 ORDER BY total_participations DESC;
--  I chose 16 as the minimum of total participations for each match.  That number is just above the average number of participants per match, meaning that it is high enough.

-- 4.1.4.   Query that groups the data by two dimensions, including region, and calculate the relevant summary statistics.
--          REQUIREMENTS: SELECT, GROUP BY
SELECT
    match_id, client_region, COUNT(*) AS total_participations, ROUND(AVG(score), 2) AS average_score,
    MIN(score) AS minimum_score, MAX(score) AS maximum_score, COUNT(DISTINCT player_id) AS unique_participants
FROM match_participants
GROUP BY (match_id, client_region) ORDER BY match_id;
