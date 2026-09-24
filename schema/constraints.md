# Players

| Attribute | Description | Constraints |
| --- | --- | --- |
| pID | Integer that uniquely identifies a player, regardless of the username. | PRIMARY KEY |
| Username | Variable length up to 100 characters that serve as the player's name, cannot be blank, and no duplicates. | NOT NULL, UNIQUE |
| email | Variable length up to 255 characters that shows the player's associated email, cannot be blank, and no duplicates | NOT NULL, UNIQUE |
| joined_at | Timestamp that records when did the player join and cannot be blank.  Default value is the current timestamp when adding the player into the table. | NOT NULL |
| XP | Integer that identify the player's experience points and must be a positive number. | NOT NULL, CHECK |
| Level | Integer that identify the player's level in the game and must be a positive number. | NOT NULL, CHECK |
| referred_by | Integer that allows a player to refer to another one by their pID, as long as they are not referring to themselves. | CHECK |


# Matches

| Attribute | Description | Constraints |
| --- | --- | --- |
| mID | Integer that uniquely identifies a match, regardless of the match name. | PRIMARY KEY |
| MatchName | Variable length up to 100 characters that serve as the match's name.  Subject to change. |  |
| Status | Variable length up to 11 characters, cannot be blank, and serves as an activity flag that can either be "Starting", "In Progress", or "Over".  Subject to change. | NOT NULL, CHECK |
| NumberOfPlayersParticipated | Integer that tracks the amount of players that participated in a match for filtering purposes.  A derived attribute. |  |


# MatchParticipants

| Attribute | Description | Constraints |
| --- | --- | --- |
| pID | Integer that identifies the player, by their ID (pID) from Players, and makes up the first half of the composite primary key of MatchParticipants.  If that player is removed from that table, then the row that comprises their record of the match that they participated in (as shown below) in this table would be removed as well. | PRIMARY KEY, FOREIGN KEY, ON DELETE CASCADE |
| mID | Integer that identifies the match, by its ID (mID) from the Matches table, that the aforementioned player participates in, and makes up the second half of the composite primary key of MatchParticipants.  The match cannot be removed from the former, unless the player's participation records of it in the latter are all removed beforehand.  | PRIMARY KEY, FOREIGN KEY, ON DELETE RESTRICT |
| mpTimestamp | Timestamp that consists of the date and time of the player's participation of the match.  Can be left as blank if that match is marked with "Starting" in Matches. |  |
| Faction | Variable length up to 100 characters and indicates the player's faction during their participation in the match, if its gamemode is team-based.  Can either be "alpha" or "beta".  Otherwise, if the match's gamemode is not team-based, then the Faction value is blank. | CHECK |
| Score | Integer that tracks the player's score in the match, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Kills | Integer that tracks the amount of kills that the player has in the match, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Deaths | Integer that tracks the number of times the player dies in the match, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Assists | Integer that tracks the number of times the player assisted another player in a kill, must be a positive integer, and cannot be blank. | NOT NULL, CHECK |
| Outcome | Variable length up to 7 characters and indicates the match's outcome to the player after it has concluded, with an "Over" indication in Matches.  Can either be "Victory", "Draw", or "Defeat".   If the match has not concluded yet, then the Outcome value is blank. | CHECK |


# GameModes

| Attribute | Description | Constraints |
| --- | --- | --- |
| gmID | Integer that uniquely identifies a gamemode, regardless of its name. | PRIMARY KEY |
| ModeName | Variable length up to 100 characters that serve as the gamemode's name, cannot be blank, and no duplicates | NOT NULL, UNIQUE |
| Description | Textual description of the gamemode. |  |
| TeamBased | Boolean attribute that identifies whether the gamemode is team-based or not and cannot be blank. | NOT NULL |


# MatchModes

| Attribute | Description | Constraints |
| --- | --- | --- |
| mID | Integer that is linked to the corresponding match by its ID (mID) from the Matches table and makes up the first half of the composite primary key of this table.  If that match is removed from the former, then the row that recorded its game mode would be deleted from the latter as well. | PRIMARY KEY, FOREIGN KEY, ON DELETE CASCADE |
| gmID | Integer that identifies the aforementioned match's gamemode by its ID (gmID) from the GameModes table and makes up the second half of the composite primary key of this table.  The gamemode cannot be removed from the former, unless, its associated matches that are recorded in the latter are all removed beforehand. | PRIMARY KEY, FOREIGN KEY, ON DELETE RESTRICT |
| assigned_at | Timestamp that records when the match is assigned a gamemode.  Default value is the current timestamp when adding the record that descrbes this assignment into the table. | NOT NULL |
