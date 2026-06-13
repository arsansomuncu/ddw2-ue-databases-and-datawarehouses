- 1. Create two new Customers and at least two Accounts each.
INSERT INTO [exercise].[Customers] (FirstName, LastName, Email, PhoneNumber, CreditRating)
VALUES 
('Alice', 'Miller', 'alice.miller@email.com', '555-0101', 5),
('Bob', 'Carter', 'bob.carter@email.com', '555-0202', 7);

-- Storing the generated CustomerIDs in variables to dynamically assign them
DECLARE @AliceID INT = (SELECT CustomerID FROM [exercise].[Customers] WHERE Email = 'alice.miller@email.com');
DECLARE @BobID INT = (SELECT CustomerID FROM [exercise].[Customers] WHERE Email = 'bob.carter@email.com');

INSERT INTO [exercise].[Accounts] (CustomerID, AccountNumber, Balance)
VALUES 
(@AliceID, 'ACC-AM-01', 1500.00),
(@AliceID, 'ACC-AM-02', 500.00),
(@BobID, 'ACC-BC-01', 2000.00),
(@BobID, 'ACC-BC-02', 300.00);

DECLARE @AliceAcc1 INT = (SELECT AccountID FROM [exercise].[Accounts] WHERE AccountNumber = 'ACC-AM-01');
DECLARE @BobAcc1 INT = (SELECT AccountID FROM [exercise].[Accounts] WHERE AccountNumber = 'ACC-BC-01');

-- 2. Exchange money between just these two Customers.
EXEC [exercise].[TransferMoney] @SourceAccountID = @AliceAcc1, @TargetAccountID = @BobAcc1, @Amount = 250.00;

-- 3. Prove that your implementation does not lose any money in the process.
SELECT SUM(Balance) AS TotalSystemBalance 
FROM [exercise].[Accounts] 
WHERE CustomerID IN (@AliceID, @BobID);

-- 4. The two of them marry, update their last name and credit rating (+2, max 10).
UPDATE [exercise].[Customers]
SET LastName = 'Miller-Carter',
    CreditRating = CASE 
                       WHEN CreditRating + 2 > 10 THEN 10 
                       ELSE CreditRating + 2 
                   END
WHERE CustomerID IN (@AliceID, @BobID);

-- 5. Delete the two Customers and their Accounts.
DELETE FROM [exercise].[Transactions] 
WHERE SourceAccountID IN (SELECT AccountID FROM [exercise].[Accounts] WHERE CustomerID IN (@AliceID, @BobID))
   OR DestinationAccountID IN (SELECT AccountID FROM [exercise].[Accounts] WHERE CustomerID IN (@AliceID, @BobID));

DELETE FROM [exercise].[Accounts] WHERE CustomerID IN (@AliceID, @BobID);
DELETE FROM [exercise].[Customers] WHERE CustomerID IN (@AliceID, @BobID);
