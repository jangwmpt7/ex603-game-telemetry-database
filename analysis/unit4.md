# Task 4.1 Write Up

The regional director has found that the minimum score found in the match_participants table is zero.  Looking at that table, all of its records that has that value for score each represents a player who has prematurely disconnected from a match they were participating in (be it due to quitting by oneself or technical issues, particularly network timeouts).  For that, matches that has their average score per match lower than the average score per participation may be linked to high rates of network timeouts.

# Task 4.2 Write Up

**Part A:** How many participation records for each match?  How many of them are classified with network timeouts for each match?

**Part B:** The regional director finds that the grand total only generalizes the data across all regions, whereas the subtotals more precisely showed the data per region.

**Part C:** What should be the minimum number of participants to consider for each match?

# Reflection

Performing many aggregates, each with different conditions over different subsets, over the same table is a common task for analytical needs.  Conditional aggregation allows me to do this task using the CASE WHEN clause, which would evaluate to either a value that I defined, when the associated condition holds true, or NULL otherwise.  Only the rows, of the table that I am performing an operation on, that satisfies that condition are accounted for during each occurrence of this operation.  As such, performing conditional aggregates allow me to perform two or more conditions and aggregations within both a single pass through the table with a single GROUP BY operation inside a single focused query, and thus a single resulting table as output, rendering my query viable in terms of performance in the process.

On the other hand, running two or more different queries not only requires performing that amount of table scans (one per query), but also requires UNION ALL to combine results into one (as they would originally return separate tables) alongside repeating the same query structure as many times as needed.  This is detrimental when it comes to performance, especially when there exists too many (i.e. millions) rows on a table.  In that case, using conditional aggregation requires far less overhead than using many different queries.
