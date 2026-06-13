UPDATE exercise.Customers
SET 
    Street = '123 Tech Lane', City = 'Linz', PostalCode = '4020', Country = 'Austria'
WHERE Email = 'alice.miller@email.com';

UPDATE exercise.Customers
SET 
    Street = '456 Data Drive', City = 'Hagenberg', PostalCode = '4232', Country = 'Austria'
WHERE Email = 'bob.carter@email.com';

UPDATE exercise.Accounts
SET Nickname = 'Everyday Checking', SortingCode = 1
WHERE AccountNumber = 'ACC-AM-01';

UPDATE exercise.Accounts
SET Nickname = 'Holiday Savings', SortingCode = 2
WHERE AccountNumber = 'ACC-AM-02';

UPDATE exercise.Accounts
SET Nickname = 'Main Account', SortingCode = 1
WHERE AccountNumber = 'ACC-BC-01';

UPDATE exercise.Accounts
SET Nickname = 'Emergency Fund', SortingCode = 2
WHERE AccountNumber = 'ACC-BC-02';
GO
