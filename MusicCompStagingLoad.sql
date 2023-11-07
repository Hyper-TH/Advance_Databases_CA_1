USE MusicCompDB;

-- CREATE STAGING TABLES

-- CREATE EDITION STAGE TABLE
DROP TABLE IF EXISTS stage_edition;
CREATE TABLE stage_edition (
	ed_sk INT(11), 
	edYear YEAR(4) NOT NULL,
 	edPresenter VARCHAR(255) NOT NULL
);

-- CREATE VIEWER_CATEGORY STAGE TABLE
DROP TABLE IF EXISTS stage_viewer_category;
CREATE TABLE stage_viewer_category (
	catID INT(11) NOT NULL,
   	catName VARCHAR(10) DEFAULT NULL CHECK (catName IN ('Jury','Audience'))
);

-- CREATE PARTICIPANTS STAGE TABLE
DROP TABLE IF EXISTS stage_participants;
CREATE TABLE stage_participants (
	part_sk INT(11),
	partName VARCHAR(255) NOT NULL,
	countyID VARCHAR(11) NOT NULL,
 	countyName VARCHAR(50) DEFAULT NULL
);

-- CREATE VIEWERS STAGE TABLE
DROP TABLE IF EXISTS stage_viewer;
CREATE TABLE stage_viewer (
	viewerID INT(11) NOT NULL,
	ageGroupID INT(11) NOT NULL,
    ageGroupDesc VARCHAR(50) DEFAULT NULL,
    countyID VARCHAR(11) NOT NULL,
    countyName VARCHAR(50) DEFAULT NULL
);


-- INSERT DATA INTO STAGES

------ EDITION STAGE ------
-- INSERT DATA FROM SOURCE
INSERT INTO stage_edition (edYear, edPresenter)
SELECT EDYEAR, EDPRESENTER FROM MusicCompDB.Edition;

-- CREATE SEQUENCE FOR SK
DROP SEQUENCE IF EXISTS ed_seq;
CREATE SEQUENCE ed_seq
START WITH 1
INCREMENT BY 1;

-- INSERT SURROGATE KEY
UPDATE stage_edition SET ed_sk = (NEXT value FOR ed_seq);


------ PARTICIPANTS STAGE ------
-- INSERT DATA FROM SOURCE 
INSERT INTO stage_participants (partName, countyID)
SELECT PARTNAME, COUNTYID FROM MusicCompDB.PARTICIPANTS;

-- SET COUNTY NAME BASED ON ID
UPDATE stage_participants SET countyName = 
(SELECT countyName FROM MusicCompDB.COUNTY 
WHERE stage_participants.countyID = MusicCompDB.COUNTY.COUNTYID);

-- CREATE SEQUENCE FOR SK
DROP SEQUENCE IF EXISTS part_seq;
CREATE SEQUENCE part_seq
START WITH 1
INCREMENT BY 1;

-- INSERT SURROGATE KEY
UPDATE stage_participants SET part_sk = (NEXT value FOR part_seq);


------ VIEWER STAGE ------
-- Some queries required for stage_viewer
INSERT INTO stage_viewer (viewerID, ageGroupID, countyID) 
SELECT VIEWERID, AGE_GROUP, COUNTYID FROM MusicCompDB.VIEWERS;


-- UPDATE AGE GROUP DESC BASED ON ID --
UPDATE stage_viewer SET ageGroupDesc =
(SELECT AGE_GROUP_DESC FROM MusicCompDB.AGEGROUP
WHERE stage_viewer.ageGroupID = MusicCompDB.AGEGROUP.AGE_GROUPID);

-- UPDATE COUNTY NAME BASED ON ID --
UPDATE stage_viewer SET countyName =
(SELECT countyName FROM MusicCompDB.COUNTY
WHERE stage_viewer.countyID  = MusicCompDB.COUNTY.COUNTYID);

------ VIEWER CATEGORY STAGE ------
-- INSERT DATA FROM SOURCE
INSERT INTO stage_viewer_category (catID, catName)
SELECT CATID, CATNAME FROM MusicCompDB.VIEWERCATEGORY;


