SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
USE CONCURENCY_ISSUES;

BEGIN TRANSACTION;
 
SELECT * FROM Unrepeatable_Reads;
 
WAITFOR DELAY '00:00:05.000';

SELECT * FROM Unrepeatable_Reads;
 
COMMIT;