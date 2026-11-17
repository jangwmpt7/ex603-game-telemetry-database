# Task 6.1 Write Up

1. Write a question that needs each row shown next to its group’s average. Explain why the group average alone (GROUP BY) cannot answer it.

How does the score of each participation record compare to the average score earned in a match?  Using the average alone merely answers the second part of the question, as it omits individual scores that are needed for comparison.

2. Ranking is never neutral: someone is being ordered, and tie handling decides who counts as equal. Name a platform feature that would use your ranking, and explain which of the three functions it should use and why.

To properly account for matches that have equal number of participation records without any gaps, I would designate them under the same ranking with distinct performance levels.  I would use DENSE_RANK over ROW_NUMBER and RANK to accomplish this.  Having matches with identical number of participation records is to be expected, and I do not see any competitive context over comparing matches, unlike comparing players.

# Task 6.2 Write Up

1. What would a large delta tell someone about your platform, and what should they do about it?

The meaning behind a large difference between the current and previous participant’s score in a match depends on whether it is positive or negative.  If the difference is positive, then the current player would either be much more engaged or far more skilled in playing the video game compared to the previous one.  If the difference is negative, then the exact opposite would be true.  In the latter’s case, the game should be improved, mainly in terms of fun factor, difficulty, and/or (network and hardware) stability, to win back the player(s).

2. Why does a running total answer a question that a plain SUM cannot?

The running total shows the row-by-row accumulation that shows more detail (i.e. finding the total amount of score that players earned within the first quarter of the year rather than all of it), whereas a plain total condenses all this into a single number.

3. Why did you pick your moving-average window size? A different size tells a different story.

I chose the moving-average window size to cover sixteen records, as sixteen to me represents the minimum number of participants to consider for each match.

4. What does a gap mean in your platform: a data quality problem, a real stop in activity, or a side effect of how events were recorded? Each needs a different response. Say which one yours is and how you know.

A gap could either mean that the participation records for a match between two existing occurrences (that are at least around a day apart) is missing, or a data quality problem.  A match ends when every player that participated on it has finished or left, but it cannot repeat on another day.  Besides, I believe that game matches should occur exactly once.  Given the provided database, there are so many participation records for a single match that span across days, weeks, and/or months.  This means that, in other words, either matches has repeated more than once when they should not have, or the participation records (that ensure that matches are continuously active throughout a long period of time) are absent.

# Task 6.3 Write Up

1. Name the feature in your platform that top-N would power. Explain why three is the right number, rather than one or ten.

One feature that the top-N would power is finding the top three highest scoring players per match.  When I think of three as in top-three-highest, I think of awarding the gold, silver, and bronze medal to the top three participants in a match of any kind (i.e. individual-based games and sports like racing and gymnastics).  The reason why I use three is because it renders rankings simpler and concise for a person to understand while capturing enough of the best entities (players) of a subject (match).  For comparison, number ten would induce skepticism by solely overdoing the second one, while number one accomplishes neither as a single data point.

2. What would a large month-over-month change mean in your domain, and what should someone do about it? A number nobody acts on is not a metric.

The answer is similar to my answer of the first question of task 6.2, depending on whether it is positive or negative, but with a greater emphasis on time.  With that in mind, more players may have played the game if the change is positive, and the exact opposite is true if the change is negative.  Given that my analysis found that the largest change of total score earned in the month (February to be exact) is negative, I should be very concerned about the latter case that I have described in the previous sentence, as I can say that there are far less players who have played and/or are engaged in a video game compared to the previous month.  I would have to do things to ensure existing players’ retention and/or attract new ones, such as introducing limited-time events (or LTMs), maintaining a good battle pass (without making the rewards too tacky or kitschy), and rebalancing the game mechanics (i.e. difficulty and in-game weapons), alongside improving the video game’s stability in terms of networking and player’s hardware (i.e. PCs and gaming consoles) by fixing bugs and improving the back-end.

# Reflection

One task that using windows functions accomplishes where simply using GROUP BY alone fails is computing the rolling/moving aggregate statistics, including count, sum, and average.  In this case, I write down the OVER clause, right after either the COUNT, SUM, and AVERAGE statement, to determine the specific window, partition, and order that the latter should calculate from.  This ranges from calculating up to a certain point to resetting the aggregation upon reaching a new partition.  The result would keep all the original rows of the table, adding in the statistics that vary for each row depending on what I have defined in the OVER clause.  An example of this is determining the total and/or average score earned among participants of a match in a video game during each week or quarter of the year, individually.

On the other hand, using only GROUP BY to compute a statistic merely returns a single overall number for each partition., of course, with collapsed rows.  Its supporting details and progressions being diluted into oblivion, given that the clause treats each row of the partition in no particular order.
