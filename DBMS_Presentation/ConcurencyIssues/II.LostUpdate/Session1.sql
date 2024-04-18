-- Session 1: Employer
DECLARE @CustomerBalance	INT ;
DECLARE @BalanceDifference	INT ;
 
SET @BalanceDifference = 1600 ;
 
BEGIN TRANSACTION ;
	-- Getting back current balance value
	SELECT @CustomerBalance = BalanceAmount
	FROM BankAccounts
	WHERE AccountId = 1 ;
	PRINT 'Read Balance value: ' + CONVERT(VARCHAR(32),@CustomerBalance);
 
	-- adding salary amount
	SET @CustomerBalance = @CustomerBalance + @BalanceDifference ;
 
	-- Slowing down transaction to let tester the time
	-- to run query for other session
	PRINT 'New Balance value: ' + CONVERT(VARCHAR(32),@CustomerBalance);
 
	WAITFOR DELAY '00:00:05.000';
 
	-- updating in table
	UPDATE BankAccounts
	SET BalanceAmount = @CustomerBalance 
	WHERE AccountId = 1 ;
 
	-- display results for user
	SELECT BalanceAmount as BalanceAmountSession1
	FROM BankAccounts
	WHERE AccountId = 1 ;
COMMIT ;