-- 5.1.1.   Find the player who has participated, the match associated with their participation, and their timestamps.
--          REQUIREMENTS: SELECT, JOIN
SELECT p.player_name, m.match_label, TO_CHAR(mp.joined_at, 'YYYY-MM-DD HH24:MI:SS') AS paricipation_timestamp FROM players p
JOIN match_participants mp ON p.player_id = mp.player_id JOIN matches m ON mp.match_id = m.match_id;

-- 5.1.2.   Find the gamemodes for each event.
--          REQUIREMENTS: SELECT, JOIN
SELECT m.match_label, g.mode_name FROM matches m
JOIN match_modes mm ON m.match_id = mm.match_id JOIN game_modes g ON mm.mode_id = g.mode_id;

-- 5.1.3.   Comparing each match with others of the same player count and ranked classification using self-join.
--          REQUIREMENTS: SELECT, JOIN
SELECT m1.match_label, m1.scheduled_on, m1.server_region, m1.player_count, m2.match_label AS similar_match FROM matches m1
JOIN matches m2 ON m1.player_count = m2.player_count AND m1.is_ranked = m2.is_ranked;
