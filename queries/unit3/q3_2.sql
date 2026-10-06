-- 3.2a.1.  Pick a nullable column on the match_participants or matches table.
--          Column picked: disconnect_reason of match_participants.

-- 3.2a.2.  Query with negation or inequality predicate on the chosen column.
--          REQUIREMENTS: SELECT, WHERE, !=
SELECT player_name, match_label AS match_that_the_player_participated_in, joined_at, participation_status, disconnect_reason
FROM match_participants
JOIN players ON match_participants.player_id = players.player_id
JOIN matches ON match_participants.match_id = matches.match_id
WHERE disconnect_reason != 'Player quit';
--  Number of rows returned by that query: 27
--  Proof using the below query.
SELECT COUNT(*)
FROM match_participants
WHERE disconnect_reason != 'Player quit';

-- 3.2a.4.  Query that count the rows that the first one of the above question has omitted.
--          REQUIREMENTS: SELECT, COUNT, WHERE, =
SELECT COUNT(*)
FROM match_participants
WHERE disconnect_reason = 'Player quit';
--  Output: 7, which is the number of records where disconnect_reason = 'Player quit'.
--  27 + 7 = 34 ≠ 200, which is the total number of records in the match_participants table.
--  The query below that returns that number.
SELECT COUNT(*)
FROM match_participants;

-- 3.2a.5.  Repaired version of the first query of 3.2a.2., using an explicit IS NULL condition or COALESCE.
--          REQUIREMENTS: SELECT, WHERE, IS NULL, COALESCE
SELECT player_name, match_label AS match_that_the_player_participated_in, joined_at, participation_status, COALESCE(disconnect_reason, 'No connection issues') AS reason
FROM match_participants
JOIN players ON match_participants.player_id = players.player_id
JOIN matches ON match_participants.match_id = matches.match_id
WHERE disconnect_reason != 'Player quit' OR disconnect_reason IS NULL;
--  Number of rows returned by that query: 193 = 200 - 7
--  Proof using the below query.
SELECT COUNT(*)
FROM match_participants
WHERE disconnect_reason != 'Player quit' OR disconnect_reason IS NULL;

-- 3.2b.1.  A query that defines an alias in SELECT and reference it in WHERE.
--          REQUIREMENTS: SELECT, AS, WHERE
SELECT p1.player_name, COALESCE(p2.player_name, 'Self-recruited') AS recruiter_name
FROM players p1 LEFT JOIN players p2 on p1.recruited_by = p2.player_id
WHERE recruiter_name = 'Self-recruited';
--  Error received upon running the query above.
--  [42703] ERROR: column "recruiter_name" does not exist
--   Position: 164

-- 3.2b.2.  Two correct rewrites of the query of 3.2b.1., with the first using WHERE and the other using CTE or subquery.
--          REQUIREMENTS: SELECT, AS, WHERE, IN, WITH (second query)
SELECT p1.player_name, COALESCE(p2.player_name, 'Self-recruited') AS recruiter_name -- Query that repeats the expression in WHERE.
FROM players p1 LEFT JOIN players p2 on p1.recruited_by = p2.player_id
WHERE COALESCE(p2.player_name, 'Self-recruited') = 'Self-recruited';

WITH player_and_recruiter AS (  -- Query that wraps a subquery inside a CTE such that an alias becomes a real column.
    SELECT p1.player_name, COALESCE(p2.player_name, 'Self-recruited') AS recruiter_name
    FROM players p1 LEFT JOIN players p2 on p1.recruited_by = p2.player_id
)
SELECT player_name, recruiter_name
FROM player_and_recruiter
WHERE recruiter_name = 'Self-recruited';