# Task 5.1 Write Up

1. What feature or report on your platform could use the three-table join from Question 1? What information would it display?

The feature that would require using the three-table-join would be the one who finds all players who has participated, the matches associated with their participation, and the date that signifies when the player has participated in a match.  It would identify the first two subjects not by their IDs, but rather their proper names/labels (i.e. identifying the user by his username of ‘JohnDoe26’ rather than his ID of 1 and identifying the match by its label of ‘Match 7’ rather than its ID of 7).  Speaking of the datetime for each player’s participation, it would be in this format: YYYY-MM-DD HH-MM-SS, with seconds being rounded up rather than including decimals.

2. Why is the junction table important for answering Question 2? What would make this analysis more difficult without it?

A junction table is essential when an entity can be assigned with not just one, but many categories as in the many-to-many relationship.  In my case of game telemetry, matches can be associated with more than one gamemode, which is something that is uncommon (from what I believe) among the multiplayer video games that I have played.  With the help of the junction tables, queries that search the categories for each entity, or the gamemodes associated with each match, are faster and simpler.
Without the junction table, just for an entity to be associated with many categories, either it must be duplicated multiple times in a single table, or the value of its category attribute must be expressed as a comma-separated list.  Either way, the data integrity is compromised, as the former requires performing a tedious task of updating all names of each instance of an entity should an instance’s name gets updated to ensure consistency, and the latter requires string parsing.  At this rate, the queries would be slower and more complex.

# Task 5.2 Write Up

1. Which matches were excluded by the inner join? Report their identifiers.

Matches 14 and 15, identified under 14 and 15 as their IDs, respectively.

2. What does it mean when a match has no participants? What are some possible explanations?

Given that these two matches do not have any associated participation records, it means that they are not active and have never started at all, as not a single player has participated in either of them.  This contradicts these matches’ stated player counts in the matches table (i.e. Matches 14 and 15 were stated to have 8 and 6 players, respectively, even though they have none).  Besides, every match’s stated player count in the matches table are not representative to the actual number of (unique) players they have according to the match_participants table.

3. How could a report based only on an inner join give leadership an incomplete picture of the platform?

An inner join only returns the matches that each has at least one player as its participant, or at least one associated participation record in other words.  Therefore, it never returned every single match that existed in the matches table, as only the active ones were returned.

4. Why might leadership want to identify matches that has never been active?

Every match in the matches table, be it active or inactive, has its timestamp (that records when it is scheduled to take place), region (that it is hosted from), code, and a ranked flag (that identifies whether it is a ranked match or not) recorded, not just its ID and label.  Each attribute of the first group of attributes that I mentioned in the previous sentence holds importance in different cases, i.e. for someone who is curious to know whether they live in the same region as the server hosting a match.

5. What action could leadership take based on these findings?

Revise the player_count into a derived attribute that can be computed from counting the number of unique players for each match in the match_participants table, not a regular one.  That way, the player counts for each match of the matches table will not drift out of sync with reality should the records be added to or deleted from the match_participants table.  For instance, new rows that add players as participants of Match 14 and/or 15 can be added to the match_participants table, increasing their player counts from 0 and therefore rendering them as active.  I would also say that it is desirable to add an explicit flag that identifies whether the match in the matches table is not active yet, is currently active, or has ended.

# Task 5.3 Write Up

1. Give an example of when a Cartesian product could be useful on your platform, or explain why you would not need one.

An example of when a Cartesian product can be useful in a video game telemetry database is finding how much each match’s average score per participation deviates from the overall average score per participation that is calculated from the whole table.

2. Which join algorithms did PostgreSQL choose for your query?

The join algorithms that are chosen for my query I have written for 5.1.1. are Nested Loop Join and Hash Join.

3. What information in the execution plan helps explain those choices?

For Nested Loop Join, there is an index scan that uses the primary key constraint on matches, rendering match_id of the matches table as an index, and an index condition that matches rows by their match_id of match_participants with that index.  For Hash Join, there is a hash condition that matches the rows of player table by their player_id, alongside two sequential scans on that and participants.

4. Why is it useful to understand the selected join algorithms?

Using EXPLAIN, I can view the execution plans and which join algorithms will be used for a query before I run it, as I would be able to understand the range of the cost and how many widths and rows are needed for the steps, along with what key is used as an index in the case of nested loop joins.

5. What changes to the data or database might make another join algorithm more appropriate?

I would sort the player_id in an ascending order for each match in the match_participants table (as in ORDER BY match_id, player_id), remove any rows that duplicate pairs of match_id and player_id values, and then replace the existing primary key (participation_id) with a composite one that covers these two keys.  This might make a merge join algorithm, which is not used by the query that I wrote for 5.1.1., more appropriate.

# Reflection

For nested loop joins, I can add a primary key that can be used as its index for the table, that I am performing a join operation with as a right table, besides ensuring that at least one table is small enough by removing unnecessary rows.  That way, this algorithm would be chosen, as it is more optimized in this case.  In other cases where there are no indices or neither tables are large, though, nested loop join is not the way to go.

As for hash joins, alongside having indices or sorted rows not being necessary, I would add more data to these tables such that they are larger. The main problem about this algorithm, however, is that it is heavy on memory usage, as it can compromise query performance by spilling to disk if memory runs out.

Finally, for merge joins, I would have the rows of the tables be sorted by the attribute that would be used in the join operation, alongside removing any row that duplicates values of this attribute.  That way, using this algorithm over hash join is much more efficient in terms of memory and (query) performance.
