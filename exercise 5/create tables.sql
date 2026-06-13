GO
CREATE TABLE solution.a_Book ( 
ISBN13 CHAR(14) PRIMARY KEY, 
ISBN10 CHAR(10), 
Title NVARCHAR(255), 
Author NVARCHAR(100) 
); 
  
CREATE TABLE solution.b_Branch ( 
Branch INT PRIMARY KEY, 
BranchName NVARCHAR(100) 
);

CREATE TABLE solution.b_Sales ( 
Branch INT, 
ISBN BIGINT, 
SoldCopies INT, 
PRIMARY KEY (Branch, ISBN));


CREATE TABLE solution.c_Manufacturer ( 
ManufacturerID INT PRIMARY KEY, 
ManufacturerName NVARCHAR(100) 
); 

CREATE TABLE solution.c_CarModel ( 
ModelID INT PRIMARY KEY, 
ModelName NVARCHAR(100), 
ManufacturerID INT);

CREATE TABLE solution.d_Item ( 
ItemNumber INT PRIMARY KEY, 
ItemName NVARCHAR(100) 
); 
 
CREATE TABLE solution.d_InvoiceLine ( 
InvoiceNo INT, 
InvoiceLine INT, 
ItemNumber INT, 
Quantity INT, 
PRIMARY KEY (InvoiceNo, InvoiceLine));



CREATE TABLE solution.e_Employee ( 
EmployeeName NVARCHAR(100) PRIMARY KEY, 
Department NVARCHAR(100) 
); 


CREATE TABLE solution.e_WorkingHours ( 
LogID INT IDENTITY(1,1) PRIMARY KEY, 
EmployeeName NVARCHAR(100), 
WorkingTimeEntry NVARCHAR(255));
 
 
CREATE TABLE solution.f_Exam ( 
ExamNo INT PRIMARY KEY, 
ExamDate DATE, 
Course NVARCHAR(100) 
); 


CREATE TABLE solution.f_ExamResult ( 
ExamNo INT, 
StudentNo INT, 
Grade INT, 
PRIMARY KEY (ExamNo, StudentNo));






