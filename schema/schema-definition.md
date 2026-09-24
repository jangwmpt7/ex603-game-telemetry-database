The database will include five schemas for the players (actor), matches (producer), match participants (event), game modes (catalog), and match modes (junction), as they are shown below.

* Players(<ins>pID</ins>, Username, email, joined_at, XP, Level, referred_by<sup>FK_Players.pID</sup>)
* Matches(<ins>mID</ins>, MatchName, Status, _NumbersOfPlayersParticipated_)
* MatchParticipants(pID<sup>FK_Players.pID</sup>, mID<sup>FK_Matches.mID</sup>, mpTimestamp, Faction, Score, Kills, Deaths, Assists, Outcome)
* GameModes(<ins>gmID</ins>, ModeName, Description, TeamBased)
* MatchModes(<ins>mID<sup>FK_Matches.mID</sup>, gmID<sup>FK_GameModes.gmID</sup></ins>, assigned_at)

Tables that have a primary key has it denoted with an **underline** (i.e. <ins>pID</ins> is a primary key for Players), whereas those with foreign keys has each of them marked with a **superscript** that indicates what key of a different table that it is referring to (i.e. playerID<sup>FK_Players.pID</sup> in MatchParticipants is linked to pID, a primary key of Players).  A table with a composite primary key of many keys has it denoted with an **underline** across the corresponding key (i.e. <ins>mID<sup>FK_Matches.mID</sup>, gmID<sup>FK_GameModes.gmID</sup></ins> of MatchModes serves as a composite primary key).  Also, derived keys are denoted in _italic_.
