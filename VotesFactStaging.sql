USE MusicCompDB;

DROP TABLE IF EXISTS stage_votes;
CREATE TABLE stage_votes (
	voteID INT(11),
	viewerID INT(11) NOT NULL,
	edID INT(11),
	partID VARCHAR(255) NOT NULL,
 	catID INT(11) NOT NULL,
 	edYear YEAR(4) NOT NULL,
 	catName VARCHAR(10) DEFAULT NULL CHECK (catName IN ('Jury','Audience')),
 	voteMode VARCHAR(10) DEFAULT NULL CHECK (voteMode in ('Phone','Facebook','Instagram','TV')),
 	vote INT(11) DEFAULT NULL CHECK (vote > 0 and vote < 6),
 	voteDate DATE NOT NULL
);

-- Insert initial data
INSERT INTO stage_votes (viewerID, edID, edYear, partID, catID, voteMode, vote, voteDate)
SELECT x.viewerID, e.ed_sk, e.edYear, p.part_sk, v.catID, o.voteMode, o.vote, o.voteDate
    FROM VOTES o
    JOIN stage_viewer x ON (o.VIEWERID = x.viewerID)
    JOIN stage_edition e ON (o.EDITION_YEAR = e.edYear)
    JOIN stage_participants p ON (o.PARTNAME = p.partName)
    JOIN stage_viewer_category v ON (o.VOTE_CATEGORY = v.catID);


DROP SEQUENCE IF EXISTS votes_seq;
CREATE SEQUENCE votes_seq
START WITH 1
INCREMENT BY 1;

UPDATE stage_votes set voteID = (NEXT value FOR votes_seq);


UPDATE stage_votes SET catName = 'Jury' WHERE catID = 1;
UPDATE stage_votes SET catName = 'Audience' WHERE catID = 2;
   
ALTER TABLE stage_votes ADD COLUMN cost DECIMAL (18,5);

UPDATE stage_votes e SET cost = (CAST(e.vote AS DECIMAL(18,5))) * .2
WHERE 
	e.edYear >= 2013 AND e.edYear <= 2015 AND 
	e.voteMode IN ('Facebook', 'Instagram') AND 
	e.catName IN ('Audience');
	
UPDATE stage_votes e SET cost = (CAST(e.vote AS DECIMAL(18,5))) * .2
WHERE 
	e.edYear >= 2013 AND e.edYear <= 2015 AND 
	e.voteMode IN ('TV', 'Phone') AND 
	e.catName IN ('Audience');
	
UPDATE stage_votes e SET cost = (CAST(e.vote AS DECIMAL(18,5))) * .5
WHERE 
	e.edYear >= 2016 AND e.edYear <= 2022 AND 
	e.voteMode IN ('Facebook', 'Instagram') AND 
	e.catName IN ('Audience');
	
UPDATE stage_votes e SET cost = (CAST(e.vote AS DECIMAL(18,5))) * 1
WHERE 
	e.edYear >= 2016 AND e.edYear <= 2022 AND 
	e.voteMode IN ('TV', 'Phone') AND 
	e.catName IN ('Audience');

UPDATE stage_votes e SET cost = (CAST(e.vote AS DECIMAL(18,5))) * 0
WHERE e.catName IN ('Jury');


SELECT * FROM stage_votes;
