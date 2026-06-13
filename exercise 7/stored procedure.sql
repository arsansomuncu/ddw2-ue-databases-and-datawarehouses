CREATE PROCEDURE [exercise].[TransferMoney]
    @SourceAccountID INT,
    @TargetAccountID INT,
    @Amount DECIMAL(15,2)
AS
BEGIN
    -- Meaningful parameter checks

    IF @Amount <= 0
    BEGIN
        RAISERROR('The transfer amount must be strictly greater than zero.', 16, 1);
    END;

    IF @SourceAccountID = @TargetAccountID
    BEGIN
        RAISERROR('The source and target accounts cannot be the same.', 16, 1);
    END;

    BEGIN TRANSACTION;

    BEGIN TRY

        -- Deduct from source account
        UPDATE [exercise].[Accounts]
        SET Balance = Balance - @Amount
        WHERE AccountID = @SourceAccountID;

        -- Add to target account
        UPDATE [exercise].[Accounts]
        SET Balance = Balance + @Amount
        WHERE AccountID = @TargetAccountID;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        ROLLBACK TRANSACTION;

        THROW;

    END CATCH
END;
