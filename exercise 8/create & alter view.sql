GO
-- View 1: Customer Overview
CREATE OR ALTER VIEW [exercise].[vw_CustomerOverview] AS
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS FullName,
    c.Email,
    c.PhoneNumber,
    c.CreditRating,
    c.Street + ', ' + c.PostalCode + ' ' + c.City + ', ' + c.Country AS FullAddress,
    (c.CreditRating * 1000) AS TotalAllowedOverdraft,
    -- Charged overdraft is the absolute value of the negative balance sum
    ISNULL(SUM(CASE WHEN a.Balance < 0 THEN ABS(a.Balance) ELSE 0 END), 0) AS TotalChargedOverdraft,
    ISNULL(SUM(a.Balance), 0) AS TotalBalance
FROM [exercise].[Customers] c
LEFT JOIN [exercise].[Accounts] a ON c.CustomerID = a.CustomerID
GROUP BY 
    c.CustomerID, c.FirstName, c.LastName, c.Email, c.PhoneNumber, 
    c.CreditRating, c.Street, c.City, c.PostalCode, c.Country;
GO

-- View 2: Account Overview
CREATE OR ALTER VIEW [exercise].[vw_AccountOverview] AS
-- TOP 100 PERCENT allows the use of ORDER BY inside a View
SELECT TOP 100 PERCENT
    a.CustomerID,
    a.AccountID,
    a.Nickname,
    a.SortingCode,
    a.AccountNumber,
    a.Balance,
    CASE WHEN a.Balance < 0 THEN ABS(a.Balance) ELSE 0 END AS ChargedOverdraft,
    t.Amount AS LatestTransactionAmount,
    CASE 
        WHEN t.SourceAccountID = a.AccountID THEN 'Transfer OUT to ' + ISNULL(dest.AccountNumber, 'Unknown')
        WHEN t.DestinationAccountID = a.AccountID THEN 'Transfer IN from ' + ISNULL(src.AccountNumber, 'Unknown')
        ELSE 'No Transactions'
    END AS LatestTransactionDescription
FROM [exercise].[Accounts] a
-- OUTER APPLY fetches the single most recent transaction per account
OUTER APPLY (
    SELECT TOP 1 *
    FROM [exercise].[Transactions] tr
    WHERE tr.SourceAccountID = a.AccountID OR tr.DestinationAccountID = a.AccountID
    ORDER BY tr.TransactionDate DESC
) t
LEFT JOIN [exercise].[Accounts] dest ON t.DestinationAccountID = dest.AccountID
LEFT JOIN [exercise].[Accounts] src ON t.SourceAccountID = src.AccountID
ORDER BY a.SortingCode ASC;
GO

-- View 3: Transaction Overview
CREATE OR ALTER VIEW [exercise].[vw_TransactionOverview] AS
SELECT 
    t.TransactionID,
    t.SourceAccountID,
    t.DestinationAccountID,
    t.Amount,
    t.TransactionDate,
    src.AccountNumber AS SourceAccountNumber,
    dest.AccountNumber AS DestinationAccountNumber,
    srcCust.FirstName + ' ' + srcCust.LastName + ' - ' + srcCust.Street + ', ' + srcCust.PostalCode + ' ' + srcCust.City + ', ' + srcCust.Country AS SourceHolderDetails,
    destCust.FirstName + ' ' + destCust.LastName + ' - ' + destCust.Street + ', ' + destCust.PostalCode + ' ' + destCust.City + ', ' + destCust.Country AS TargetHolderDetails,
    DATEDIFF(DAY, t.TransactionDate, GETDATE()) AS DaysAgo
FROM [exercise].[Transactions] t
JOIN [exercise].[Accounts] src ON t.SourceAccountID = src.AccountID
JOIN [exercise].[Customers] srcCust ON src.CustomerID = srcCust.CustomerID
JOIN [exercise].[Accounts] dest ON t.DestinationAccountID = dest.AccountID
JOIN [exercise].[Customers] destCust ON dest.CustomerID = destCust.CustomerID;
GO
