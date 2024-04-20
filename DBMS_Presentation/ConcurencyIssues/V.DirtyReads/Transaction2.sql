SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
USE CONCURENCY_ISSUES;

BEGIN TRANSACTION;

UPDATE Dirty_Read
SET Field = 11
WHERE ID = 2;

WAITFOR DELAY '00:00:05.000';

SELECT * FROM Dirty_Read;

COMMIT;