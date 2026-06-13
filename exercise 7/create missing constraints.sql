GO
PRINT N'Creating Unique Constraint unnamed constraint on [exercise].[Accounts]...';


GO
ALTER TABLE [exercise].[Accounts]
    ADD UNIQUE NONCLUSTERED ([AccountNumber] ASC);


GO
PRINT N'Creating Unique Constraint unnamed constraint on [exercise].[Customers]...';


GO
ALTER TABLE [exercise].[Customers]
    ADD UNIQUE NONCLUSTERED ([Email] ASC);


GO
PRINT N'Creating Default Constraint unnamed constraint on [exercise].[Transactions]...';


GO
ALTER TABLE [exercise].[Transactions]
    ADD DEFAULT (getdate()) FOR [TransactionDate];


GO
PRINT N'Creating Foreign Key unnamed constraint on [exercise].[Accounts]...';


GO
ALTER TABLE [exercise].[Accounts] WITH NOCHECK
    ADD FOREIGN KEY ([CustomerID]) REFERENCES [exercise].[Customers] ([CustomerID]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [exercise].[Transactions]...';


GO
ALTER TABLE [exercise].[Transactions] WITH NOCHECK
    ADD FOREIGN KEY ([DestinationAccountID]) REFERENCES [exercise].[Accounts] ([AccountID]);


GO
PRINT N'Creating Foreign Key unnamed constraint on [exercise].[Transactions]...';


GO
ALTER TABLE [exercise].[Transactions] WITH NOCHECK
    ADD FOREIGN KEY ([SourceAccountID]) REFERENCES [exercise].[Accounts] ([AccountID]);


GO
PRINT N'Creating Check Constraint unnamed constraint on [exercise].[Customers]...';


GO
ALTER TABLE [exercise].[Customers] WITH NOCHECK
    ADD CHECK ([CreditRating]>=(1) AND [CreditRating]<=(10));


GO
PRINT N'Creating Check Constraint unnamed constraint on [exercise].[Transactions]...';


GO
ALTER TABLE [exercise].[Transactions] WITH NOCHECK
    ADD CHECK ([Amount]>(0));


GO
PRINT N'Creating Check Constraint unnamed constraint on [exercise].[Transactions]...';


GO
ALTER TABLE [exercise].[Transactions] WITH NOCHECK
    ADD CHECK ([SourceAccountID]<>[DestinationAccountID]);


GO
