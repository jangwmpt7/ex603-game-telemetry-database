-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Game Telemetry
-- Author: Jack Nguyen
-- Target: PostgreSQL 14+
-- =================================================================

-- Reset. Reverse creation order, so no dependency blocks a drop.
DROP TABLE IF EXISTS mp_tag             CASCADE;
DROP TABLE IF EXISTS MatchParticipants  CASCADE;
DROP TABLE IF EXISTS MatchModes         CASCADE;
DROP TABLE IF EXISTS Matches            CASCADE;
DROP TABLE IF EXISTS GameModes          CASCADE;
DROP TABLE IF EXISTS Players            CASCADE;

-- ----------------------------------------------------------------
-- 1. actor — first, because it references nothing but itself.
--  The recursive FK is shown here; in your theme it may belong
--  on a different table. Put it where it makes sense and
--  justify the placement in your write-up.
-- ----------------------------------------------------------------
CREATE TABLE Players (
    pID         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username    VARCHAR(100) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    joined_at   TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    XP          INTEGER NOT NULL DEFAULT 0,
    Level       INTEGER NOT NULL DEFAULT 1,
    referred_by INTEGER,
    CONSTRAINT fk_player_referrer
        FOREIGN KEY (referred_by) REFERENCES Players (pID)
        ON DELETE SET NULL,
    CONSTRAINT chk_player_no_self_referral
        CHECK (referred_by IS DISTINCT FROM pID),
    CONSTRAINT chk_player_XP_Level
        CHECK ((XP >= 0) AND (Level >= 1))
);

-- ----------------------------------------------------------------
-- 2. catalog — lists the gamemodes that each match can choose
-- from.  Note that from my experience from playing FPSes, each
-- match is usually of exclusively one gamemode, although each
-- gamemode can belong to many matches.
-- ----------------------------------------------------------------
CREATE TABLE GameModes(
    gmID        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ModeName    VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    TeamBased   BOOLEAN NOT NULL
);

-- ----------------------------------------------------------------
-- 3. producer — lists the matches that players participate in.
-- ----------------------------------------------------------------
CREATE TABLE Matches(
    mID         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    MatchName   VARCHAR(100),
    Status      VARCHAR(11) NOT NULL,
    -- NumberOfPlayersParticipated, A derived attribute that tracks a total number of players that participated in a match.
    CONSTRAINT chk_status CHECK (Status in ('starting', 'running', 'over'))
);

-- ----------------------------------------------------------------
-- 4. junction — resolves the M:N between producer and catalog.
--  The primary key is the pair of foreign keys, not a new id.
-- ----------------------------------------------------------------
CREATE TABLE MatchModes (
    mID         INTEGER NOT NULL,
    gmID        INTEGER NOT NULL,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_junction PRIMARY KEY (mID, gmID),
    CONSTRAINT fk_junction_producer
        FOREIGN KEY (mID) REFERENCES Matches (mID)
        ON DELETE CASCADE,
    CONSTRAINT fk_junction_catalog
        FOREIGN KEY (gmID) REFERENCES GameModes (gmID)
        ON DELETE RESTRICT
);

-- ----------------------------------------------------------------
-- 5. Events
-- ----------------------------------------------------------------
CREATE TABLE MatchParticipants(
    pID         INTEGER NOT NULL,
    mID         INTEGER NOT NULL,
    mpTimestamp TIMESTAMP,
    Faction     VARCHAR(100),   -- In case of a team-based match.  Can be left as NULL if the match is individual-based, i.e. Free-For-All.  Subject to change.
    Score       INT NOT NULL DEFAULT 0,
    Kills       INT NOT NULL DEFAULT 0,
    Deaths      INT NOT NULL DEFAULT 0,
    Assists     INT NOT NULL DEFAULT 0,
    Outcome     VARCHAR(7),
    CONSTRAINT pk_event PRIMARY KEY (pID, mID),
    CONSTRAINT fk_event_actor FOREIGN KEY (pID) REFERENCES Players(pID),
    CONSTRAINT fk_event_producer FOREIGN KEY (mID) REFERENCES Matches(mID),
    CONSTRAINT chk_faction CHECK (Faction in (NULL, 'alpha', 'beta')),
    CONSTRAINT chk_outcome CHECK (Outcome in (NULL, 'victory', 'draw', 'defeat'))
);