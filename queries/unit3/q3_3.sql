-- 3.3.1.   Finds the players that has exclusively participated in ranked matches using IN or NOT IN.
--          Requirements: SELECT, WHERE, NOT IN
SELECT player_name FROM players WHERE player_id NOT IN (
    SELECT player_id FROM match_participants WHERE match_id IN ( SELECT match_id FROM matches WHERE is_ranked = false )
) ORDER BY player_name;

-- 3.3.2.   Same, but with CTEs using WITH.
--          Requirements: SELECT, WHERE, NOT IN, WITH
WITH unranked_matches AS ( SELECT match_id FROM matches WHERE is_ranked = false ),  unranked_match_participants AS (
    SELECT player_id FROM match_participants JOIN unranked_matches ON match_participants.match_id = unranked_matches.match_id )
SELECT player_name FROM players
WHERE player_id NOT IN (SELECT player_id FROM unranked_match_participants)
ORDER BY player_name;

-- 3.3.3.   Same, but with a different subquery form, i.e. placing a subquery inside an EXCEPT block.
SELECT player_name FROM players EXCEPT (
    SELECT player_name FROM players
    JOIN match_participants ON players.player_id = match_participants.player_id
    JOIN matches ON match_participants.match_id = matches.match_id
    WHERE matches.is_ranked = false)
ORDER BY player_name;

-- 3.3.4.   Proving that the three queries above return the same results.
SELECT player_name FROM (
    SELECT player_name FROM players WHERE player_id NOT IN (
        SELECT player_id FROM match_participants WHERE match_id IN ( SELECT match_id FROM matches WHERE is_ranked = false )
    ) ORDER BY player_name ) AS query_1
EXCEPT
SELECT player_name FROM (
    WITH unranked_matches AS ( SELECT match_id FROM matches WHERE is_ranked = false), unranked_match_participants AS (
        SELECT player_id FROM match_participants JOIN unranked_matches ON match_participants.match_id = unranked_matches.match_id )
    SELECT player_name FROM players WHERE player_id NOT IN ( SELECT player_id FROM unranked_match_participants) ORDER BY player_name )
    AS query_2;

SELECT player_name FROM (
    SELECT player_name FROM players WHERE player_id NOT IN (
        SELECT player_id FROM match_participants WHERE match_id IN ( SELECT match_id FROM matches WHERE is_ranked = false )
    ) ORDER BY player_name ) AS query_1
EXCEPT
SELECT player_name FROM (
    SELECT player_name FROM players EXCEPT (
        SELECT player_name FROM players
        JOIN match_participants ON players.player_id = match_participants.player_id
        JOIN matches ON match_participants.match_id = matches.match_id
        WHERE matches.is_ranked = false) ORDER BY player_name ) AS query_3;

SELECT player_name FROM (
    WITH unranked_matches AS ( SELECT match_id FROM matches WHERE is_ranked = false), unranked_match_participants AS (
        SELECT player_id FROM match_participants JOIN unranked_matches ON match_participants.match_id = unranked_matches.match_id )
    SELECT player_name FROM players WHERE player_id NOT IN (SELECT player_id FROM unranked_match_participants) ORDER BY player_name )
    AS query_2
EXCEPT
SELECT player_name FROM (
    SELECT player_name FROM players WHERE player_id NOT IN (
        SELECT player_id FROM match_participants WHERE match_id IN ( SELECT match_id FROM matches WHERE is_ranked = false )
    ) ORDER BY player_name ) AS query_1;

SELECT player_name FROM (
    WITH unranked_matches AS ( SELECT match_id FROM matches WHERE is_ranked = false), unranked_match_participants AS (
        SELECT player_id FROM match_participants JOIN unranked_matches ON match_participants.match_id = unranked_matches.match_id )
    SELECT player_name FROM players WHERE player_id NOT IN (SELECT player_id FROM unranked_match_participants) ORDER BY player_name )
    AS query_2
EXCEPT
SELECT player_name FROM (
    SELECT player_name FROM players EXCEPT (
        SELECT player_name FROM players
        JOIN match_participants ON players.player_id = match_participants.player_id
        JOIN matches ON match_participants.match_id = matches.match_id
        WHERE matches.is_ranked = false) ORDER BY player_name ) AS query_3;

SELECT player_name FROM (
    SELECT player_name FROM players EXCEPT (
        SELECT player_name FROM players
        JOIN match_participants ON players.player_id = match_participants.player_id
        JOIN matches ON match_participants.match_id = matches.match_id
        WHERE matches.is_ranked = false) ORDER BY player_name ) AS query_3
EXCEPT
SELECT player_name FROM (
    SELECT player_name FROM players WHERE player_id NOT IN (
        SELECT player_id FROM match_participants WHERE match_id IN ( SELECT match_id FROM matches WHERE is_ranked = false )
    ) ORDER BY player_name ) AS query_1;

SELECT player_name FROM (
    SELECT player_name FROM players EXCEPT (
        SELECT player_name FROM players
        JOIN match_participants ON players.player_id = match_participants.player_id
        JOIN matches ON match_participants.match_id = matches.match_id
        WHERE matches.is_ranked = false) ORDER BY player_name ) AS query_3
EXCEPT
SELECT player_name FROM (
    WITH unranked_matches AS ( SELECT match_id FROM matches WHERE is_ranked = false), unranked_match_participants AS (
        SELECT player_id FROM match_participants JOIN unranked_matches ON match_participants.match_id = unranked_matches.match_id )
    SELECT player_name FROM players WHERE player_id NOT IN (SELECT player_id FROM unranked_match_participants) ORDER BY player_name )
    AS query_2;
-- All of these queries that each that compare the difference between two queries return nothing, meaning that the three queries did return the results.

-- 3.3.5.   The introduction of duplicate values could break the equivalence of the three queries.
