-- docker exec -it CMPU4003mariadb mariadb --user root -pmariadb

USE MusicCompFacts;

-- NO INDEX
EXPLAIN SELECT fv.voteID, fv.vote FROM FactVotes fv WHERE fv.catName='Facebook' OR fv.catName='Phone';
ANALYZE TABLE FactVotes;
EXPLAIN SELECT fv.voteID, fv.vote FROM FactVotes fv WHERE fv.catName='Facebook' OR fv.catName='Phone';


-- WITH INDEX
EXPLAIN SELECT fv.voteID, fv.vote FROM FactVotes fv WHERE fv.catName='Facebook' OR fv.catName='Phone';

-- CREATE INDEX BASED ON CATEGORY NAMES
CREATE INDEX catNameidx ON FactVotes(catName);

EXPLAIN SELECT fv.voteID, fv.vote FROM FactVotes fv FORCE INDEX (catNameidx) WHERE fv.catName='Facebook' OR fv.catName='Phone';
ANALYZE TABLE FactVotes;

-- DROP INDEX
DROP INDEX catNameidx ON FactVotes;
