-- 1. For each edition of the programme, what is the total votes cast by each age group in each county?
-- Include age group description and county name in the output
SELECT SUM(vote), ageGroupDesc, countyName, e.edYear
FROM FactVotes fv
JOIN DimEdition e ON 
    fv.edID = e.edID 
JOIN DimViewers v ON 
    fv.viewerID = v.viewerID 
GROUP BY v.ageGroupDesc, v.countyName, e.edYear;

-- 2. For each county, what is the total number of votes received by each participant 
-- in the 2022 edition of the programme from audience viewers in that county 
-- voting for participants from the same county
-- Include county name in output
SELECT SUM(vote), dp.partName, dp.countyName
FROM FactVotes fv 
JOIN DimParticipants dp ON
    fv.partID = dp.partID 
JOIN DimViewers dv ON
    fv.viewerID = dv.viewerID 
JOIN DimEdition de ON
	fv.edID = de.edID
WHERE de.edYear = 2022 
AND dv.countyName = dp.countyName 
GROUP BY partName;

-- 3.For the 2013 and 2019 edition of the programme respectively, for each county, what was the
-- total income earned from audience viewers in that county for each voting category?
-- Include county names and year in output
SELECT SUM(cost), dv.countyName, de.edYear, voteMode 
FROM FactVotes fv 
JOIN DimViewers dv ON 
    fv.viewerID = dv.viewerID
JOIN DimEdition de ON
	fv.edID = de.edID
WHERE de.edYear = 2013
GROUP BY countyName, voteMode
UNION
SELECT SUM(cost), dv.countyName, de.edYear, voteMode
FROM FactVotes fv 
JOIN DimViewers dv ON 
    fv.viewerID = dv.viewerID 
JOIN DimEdition de ON
	fv.edID = de.edID
WHERE de.edYear = 2019
GROUP BY countyName, voteMode;