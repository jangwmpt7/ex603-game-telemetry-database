# Player

| Attribute | Domain Values | Constraints |
| --- | --- | --- |
| pID | Integer that uniquely identifies a player, regardless of the username. | PRIMARY KEY |
| Username | Variable length up to 50 characters, cannot be blank, and no duplicates. | NOT NULL, UNIQUE |
| XP | Integer that must be a positive number. | NOT NULL, CHECK |
| Level | Ditto. | NOT NULL, CHECK |

# Matches

| Attribute | Domain Values | Constraints |
| --- | --- | --- |
| mID | Integer that uniquely identifies a match, regardless of the match name. | PRIMARY KEY |
| MatchName | Variable length up to 100 characters and cannot be blank.  Subject to change. | NOT NULL |
| Status | Variable length up to 11 characters, cannot be blank, and serves as an activity flag that can either be "Started", "Over", or "Not Started".  Subject to change. | NOT NULL, CHECK |
| NumericAttribute | Integer that must be a positive number.  Purpose for filtering as numeric attribute is yet to be known. | NOT NULL |

# MatchParticipants

| Attribute | Domain Values | Constraints |
| --- | --- | --- |
| pID | Integer that is linked to the corresponding player's ID (pID) from Player schema, cannot be blank. | FOREIGN KEY, NOT NULL |
| mID | Integer that is linked to the corresponding match ID (pID) from the Match schema that the aforementioned player participates in, cannot be blank. | FOREIGN KEY, NOT NULL |
