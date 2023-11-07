-- INSERT DATA FROM STAGES TO DIMS
INSERT INTO DimEdition (edID, edYear, edPresenter)
SELECT ed_sk, edYear, edPresenter FROM MusicCompDB.stage_edition;

INSERT INTO DimParticipants (partID, partName, countyName)
SELECT part_sk, partName, countyName FROM MusicCompDB.stage_participants; 

INSERT INTO DimViewers (viewerID, ageGroupDesc, countyName)
SELECT viewerId, ageGroupDesc, countyName FROM MusicCompDB.stage_viewer;

INSERT INTO FactVotes (voteID, viewerID, edID, partID, catName, voteMode, vote, voteDate, cost)
SELECT voteID, viewerID , edID, partID, catName, voteMode, vote, voteDate, cost FROM MusicCompDB.stage_votes; 
 