CREATE TRIGGER CheckAccountBalance
ON [exercise].[Accounts]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if any account balance violates the allowed negative limit
    IF EXISTS (
        SELECT a.CustomerID
        FROM [exercise].[Accounts] a
        INNER JOIN [exercise].[Customers] c ON a.CustomerID = c.CustomerID
        GROUP BY a.CustomerID, c.CreditRating
        -- The total negative balance may not exceed CreditRating x (-100)
        HAVING SUM(a.Balance) <= (c.CreditRating * -100)
    )
    BEGIN
        -- Rollback the transaction if the constraint is violated
        ROLLBACK TRANSACTION;
        -- Raise an error to notify the user
        THROW 50001, 'Account balance cannot go below the allowed negative limit.', 1;
    END
END;
