SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
USE CONCURENCY_ISSUES;

BEGIN TRANSACTION;

UPDATE Phantom_Reads
SET Field = Field + 11
WHERE ID = 2;

SELECT * FROM Phantom_Reads;

COMMIT;