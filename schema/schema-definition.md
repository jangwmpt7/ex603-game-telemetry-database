The database will include five schemas for the players (actor), matches (producer), match participants (event), game modes (catalog), and match modes (junction), as they are shown below.

* Players(<ins>pID</ins>, Username, XP, Level)
* Matches(<ins>mID</ins>, MatchName, matchStatus, NumericAttribute)
* MatchParticipants(pID<sup>FK_Players.pID</sup>, mID<sup>FK_Matches.mID</sup>, Timestamp, Score, Kills, Deaths, Assists, mpStatus)
* GameModes(<ins>gmID</ins>, ModeName)
* MatchModes(<ins>mID<sup>FK_Matches.mID</sup>, gmID<sup>FK_GameModes.gmID</sup></ins>)

Schemas that have a primary key has it denoted with an **underline** (i.e. <ins>pID</ins> is a primary key for Players), whereas those with foreign keys has each of them marked with a **superscript** that indicates what key of a different schema that it is referring to (i.e. playerID<sup>FK_Players.pID</sup> in MatchParticipants is linked to pID, a primary key of Players).  A schema with a composite primary key of many keys has it denoted with an **underline** across the corresponding key (i.e. <ins>mID<sup>FK_Matches.mID</sup>, gmID<sup>FK_GameModes.gmID</sup></ins> of MatchModes serves as a composite primary key).
