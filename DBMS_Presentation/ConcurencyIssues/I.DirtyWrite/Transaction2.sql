SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
USE CONCURENCY_ISSUES;

BEGIN TRANSACTION;

UPDATE Dirty_Write
SET Field = 11
WHERE ID = 2;

SELECT * FROM Dirty_Write;

COMMIT;