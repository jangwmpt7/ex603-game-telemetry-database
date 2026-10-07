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

-- 3.1.5.   A query with a calculated/computed columns, such as the bonus score that a player has earned during a ranked match.
--          REQUIREMENTS: SELECT, AS
SELECT participation_id, player_name, match_label AS match_that_the_player_participated_in, participation_status, score, (score*xp_multiplier)-score AS bonus_score_earned
FROM match_participants
JOIN players ON match_participants.player_id = players.player_id
JOIN matches ON match_participants.match_id = matches.match_id
WHERE matches.is_ranked = true;
