SELECT CAST(rownum() AS VARCHAR(10)) AS
	_id,
	fv.viewerID,
	fv.edID,
	fv.partID,
	fv.catName,
	fv.voteMode,
	fv.vote,
	fv.voteDate,
	fv.cost
AS edYear, partName, 
FROM FactVotes fv
JOIN DimParticipants dp ON fv.partID = dp.partID
JOIN DimEdition de ON fv.edID = de.edID;

-- curl -X POST http://admin:couchdb@127.0.0.1:5984/fact_votes/_bulk_docs -H "Content-type: application/json" -d @fact_votes.json

