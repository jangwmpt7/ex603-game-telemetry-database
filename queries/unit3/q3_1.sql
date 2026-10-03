-- 3.1.1.   Top ten ranked, highly popular matches, sorted in a descending order.
--          Requirements: SELECT, WHERE, ORDER BY, LIMIT.
SELECT match_id, match_label, player_count
FROM matches
WHERE is_ranked = TRUE AND player_count >= 8
ORDER BY player_count DESC
LIMIT 10;

-- 3.1.2.   Possible event participation statuses, listed in a distinct manner,
--          Requirements: SELECT
SELECT DISTINCT participation_status
FROM match_participants;

-- 3.1.3.   Filtering the match participation table in two different ways, with the first using a numeric range and the second using an explicit list of values.
--          REQUIREMENTS: SELECT, WHERE, BETWEEN (first query), IN (second query).
SELECT player_id, match_id, score, duration_min, participation_status   -- First query that uses a numeric range.
FROM match_participants
WHERE score BETWEEN 12.5 AND 37.5;

SELECT player_id, match_id, score, duration_min, participation_status   -- Second query that uses an explicit list of values.
FROM match_participants
WHERE match_id IN (1, 10, 4, 3);

-- 3.1.4.   Find matches whose label matches a certain pattern, and then find the player where a value for any of their attribute is missing and replace that with a useful label.
--          REQUIREMENTS: SELECT, WHERE, LIKE, COALESCE
SELECT match_label, scheduled_on, player_count, is_ranked
FROM matches
WHERE match_label LIKE 'Match_0_';

SELECT p1.player_name, coalesce(p2.player_name, 'Self-recruited') AS recruiter_name
FROM players p1
LEFT JOIN players p2 on p1.recruited_by = p2.player_id;

-- 3.1.5.   A query with a calculated/computed columns, the total number of minutes and matches that a player has played in this case.
--          REQUIREMENTS: SELECT, AS
SELECT player_name, SUM(duration_min) AS total_minutes_played, COUNT(match_participants.*) AS total_matches_played
FROM players
JOIN match_participants ON players.player_id = match_participants.player_id
GROUP BY players.player_id
ORDER BY total_minutes_played DESC;
