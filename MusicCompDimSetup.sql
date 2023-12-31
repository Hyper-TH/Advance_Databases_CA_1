USE MusicCompFacts;

-- CREATE DIMS


-- DROP EXISTING
DROP TABLE IF EXISTS FactVotes;
DROP TABLE IF EXISTS DimViewers;
DROP TABLE IF EXISTS DimParticipants;
DROP TABLE IF EXISTS DimEdition;
DROP TABLE IF EXISTS DimViewerCategory;

-- CREATE DIM EDITIONS 
CREATE TABLE DimEdition (
 	edID INT(11) NOT NULL,
 	edYear YEAR(4) NOT NULL,
 	edPresenter VARCHAR(255) NOT NULL,
 	PRIMARY KEY (edID)
);
 

-- CREATE DIM PARTICIPANTS
CREATE TABLE DimParticipants (
 	partID INT(11) NOT NULL,
 	partName VARCHAR(255) NOT NULL,
 	countyName VARCHAR(50) DEFAULT NULL,
 	PRIMARY KEY (partID)
);
 
-- CREATE DIM VIEWERS
CREATE TABLE DimViewers (
	viewerID INT(11) NOT NULL,
	ageGroupDesc VARCHAR(50) DEFAULT NULL,
	countyName VARCHAR(50) NOT NULL,
	PRIMARY KEY (viewerID)
);
 	

-- CREATE FACT VOTES TABLE
CREATE TABLE FactVotes (
	voteID INT(11) NOT NULL,
	viewerID INT(11) NOT NULL,
	edID INT(11) NOT NULL,
	partID INT(11) NOT NULL,
	catName VARCHAR(10) DEFAULT NULL CHECK (catName IN ('Jury','Audience')),
	voteMode VARCHAR(10) DEFAULT NULL CHECK (voteMode in ('Phone','Facebook','Instagram','TV')),
	vote INT(11) DEFAULT NULL CHECK (vote > 0 and vote < 6),
	voteDate DATE NOT NULL,
	cost DECIMAL (18,5),
	PRIMARY KEY (voteID),
	CONSTRAINT FK_viewerID FOREIGN KEY (viewerID) REFERENCES DimViewers,
	CONSTRAINT FK_partID FOREIGN KEY (partID) REFERENCES DimParticipants,
	CONSTRAINT FK_edID FOREIGN KEY (edID) REFERENCES DimEdition
);