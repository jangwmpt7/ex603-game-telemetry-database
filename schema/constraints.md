# Players

| Attribute | Description | Constraints |
| --- | --- | --- |
| pID | Integer that uniquely identifies a player, regardless of the username. | PRIMARY KEY |
| Username | Variable length up to 50 characters that serve as the player's name, cannot be blank, and no duplicates. | NOT NULL, UNIQUE |
| XP | Integer that identify the player's experience points and must be a positive number. | NOT NULL, CHECK |
| Level | Integer that identify the player's level in the game and must be a positive number. | NOT NULL, CHECK |


# Matches

| Attribute | Description | Constraints |
| --- | --- | --- |
| mID | Integer that uniquely identifies a match, regardless of the match name. | PRIMARY KEY |
| MatchName | Variable length up to 100 characters that serve as the match's name and cannot be blank.  Subject to change. | NOT NULL |
| Status | Variable length up to 11 characters, cannot be blank, and serves as an activity flag that can either be "Starting", "In Progress", or "Over".  Subject to change. | NOT NULL, CHECK |
| NumericAttribute | Integer that cannot be blank.  Purpose for filtering as numeric attribute is yet to be known. | NOT NULL |


# MatchParticipants

| Attribute | Description | Constraints |
| --- | --- | --- |
| pID | Integer that identifies the player, by their ID (pID) from Players schema, and cannot be blank.  If that player is removed from that schema, then the row that comprises their record of the match that they participated in (as shown below) in this schema would be removed as well. | NOT NULL, FOREIGN KEY, ON DELETE CASCADE |
| mID | Integer that identifies the match, by its ID (mID) from the Matches schema, that the aforementioned player participates in and cannot be blank.  If that match is removed from that schema, then this key that identify it on this schema would be set to blank while preserving the player's records in the row (as shown below). | FOREIGN KEY, ON DELETE SET NULL |
| mpTimestamp | Timestamp that consists of the date and time of the player's participation of the match.  Can be left as blank if that match is marked with "Starting" in Matches schema. |  |
| Score | Integer that tracks the player's score in the match, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Kills | Integer that tracks the amount of kills that the player has in the match, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Deaths | Integer that tracks the number of times the player dies in the match, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Assists | Integer that tracks the number of times the player assisted another player in a kill, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Outcome | Variable length up to 7 characters and indicates the match's outcome to the player after it has concluded, with an "Over" indication in Matches schema.  Can either be "Victory", "Draw", and "Defeat".   If the match has not concluded yet, then the Outcome key is blank. | CHECK |


# GameModes

| Attribute | Description | Constraints |
| --- | --- | --- |
| gmID | Integer that uniquely identifies a gamemode, regardless of its name. | PRIMARY KEY |
| ModeName | Variable length up to 100 characters that serve as the gamemode's name and cannot be blank. | NOT NULL |


# MatchModes

| Attribute | Description | Constraints |
| --- | --- | --- |
| mID | Integer that is linked to the corresponding match by its ID (mID) from the Matches schema and makes up the first half of the composite primary key of this schema.  If that match is removed from the former, then the row that recorded its game mode would be deleted from the latter as well. | PRIMARY KEY, FOREIGN KEY, ON DELETE CASCADE |
| gmID | Integer that identifies the aforementioned match's gamemode by its ID (gmID) from the GameModes schema and makes up the second half of the composite primary key of this schema.  If that gamemode is removed from that schema, then the row(s) that recorded the matches associated by it would be deleted from the latter as well. | PRIMARY KEY, FOREIGN KEY, ON DELETE CASCADE |
