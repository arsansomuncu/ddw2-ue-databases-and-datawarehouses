ALTER TABLE exercise.Accounts ADD Nickname VARCHAR(50) NULL;
ALTER TABLE exercise.Accounts ADD SortingCode INT NULL;
ALTER TABLE exercise.Customers ADD Street NVARCHAR(100) NULL;
ALTER TABLE exercise.Customers ADD City NVARCHAR(50) NULL;
ALTER TABLE exercise.Customers ADD PostalCode NVARCHAR(20) NULL;
ALTER TABLE exercise.Customers ADD Country NVARCHAR(50) NULL;
GO
