USE FH_DDW2_AIS;
GO

-- Create your own schema for the corrected tables
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'solution')
BEGIN
    EXEC('CREATE SCHEMA solution');
END
GO

-- ==========================================
-- DROP EXISTING TABLES (Reverse Dependency Order)
-- ==========================================
-- This makes the script idempotent so you can run it multiple times safely.

DROP TABLE IF EXISTS solution.f_ExamResult;
DROP TABLE IF EXISTS solution.f_Exam;
DROP TABLE IF EXISTS solution.e_WorkingHours;
DROP TABLE IF EXISTS solution.e_Employee;
DROP TABLE IF EXISTS solution.d_InvoiceLine;
DROP TABLE IF EXISTS solution.d_Item;
DROP TABLE IF EXISTS solution.c_CarModel;
DROP TABLE IF EXISTS solution.c_Manufacturer;
DROP TABLE IF EXISTS solution.b_Sales;
DROP TABLE IF EXISTS solution.b_Branch;
DROP TABLE IF EXISTS solution.a_Book;
GO

-- ==========================================
-- (a) Book 
-- ==========================================
-- [SOLVING E5.1 & E5.2: Table Creation & Constraints]
-- Splitting the multi-value ISBN column to achieve 1st and 3rd Normal Form.
CREATE TABLE solution.a_Book (
    ISBN13 CHAR(14) PRIMARY KEY,
    ISBN10 CHAR(10),
    Title NVARCHAR(255),
    Author NVARCHAR(100)
);
GO

-- [SOLVING E5.3: Data Insertion]
INSERT INTO solution.a_Book (ISBN13, ISBN10, Title, Author)
SELECT 
    SUBSTRING([ISBN10, ISBN13], 14, 14), -- Extracts 978-...
    SUBSTRING([ISBN10, ISBN13], 2, 10),  -- Extracts 10-digit ISBN
    Title,
    Author
FROM exercise.a_Book;
GO

-- ==========================================
-- (b) Sales Statistics 
-- ==========================================

-- [SOLVING E5.1 & E5.2: Table Creation & Constraints]
CREATE TABLE solution.b_Branch (
    Branch INT PRIMARY KEY,
    BranchName NVARCHAR(100)
);

CREATE TABLE solution.b_Sales (
    Branch INT,
    ISBN BIGINT,
    SoldCopies INT,
    PRIMARY KEY (Branch, ISBN),
    FOREIGN KEY (Branch) REFERENCES solution.b_Branch(Branch)
);
GO

-- [SOLVING E5.3: Data Insertion]
INSERT INTO solution.b_Branch (Branch, BranchName)
SELECT DISTINCT Branch, BranchName 
FROM exercise.b_SalesStatistics;

INSERT INTO solution.b_Sales (Branch, ISBN, SoldCopies)
SELECT Branch, ISBN, SoldCopies 
FROM exercise.b_SalesStatistics;
GO


-- ==========================================
-- (c) Car Model 
-- ==========================================

-- [SOLVING E5.1 & E5.2: Table Creation & Constraints]
CREATE TABLE solution.c_Manufacturer (
    ManufacturerID INT PRIMARY KEY,
    ManufacturerName NVARCHAR(100)
);

CREATE TABLE solution.c_CarModel (
    ModelID INT PRIMARY KEY,
    ModelName NVARCHAR(100),
    ManufacturerID INT,
    FOREIGN KEY (ManufacturerID) REFERENCES solution.c_Manufacturer(ManufacturerID)
);
GO

-- [SOLVING E5.3: Data Insertion]
INSERT INTO solution.c_Manufacturer (ManufacturerID, ManufacturerName)
SELECT DISTINCT ManufacturerID, ManufacturerName 
FROM exercise.c_CarModel;

INSERT INTO solution.c_CarModel (ModelID, ModelName, ManufacturerID)
SELECT ModelID, ModelName, ManufacturerID 
FROM exercise.c_CarModel;
GO

-- ==========================================
-- (d) Invoice 
-- ==========================================
CREATE TABLE solution.d_Item (
    ItemNumber INT PRIMARY KEY,
    ItemName NVARCHAR(100)
);

CREATE TABLE solution.d_InvoiceLine (
    InvoiceNo INT,
    InvoiceLine INT,
    ItemNumber INT,
    Quantity INT,
    PRIMARY KEY (InvoiceNo, InvoiceLine),
    FOREIGN KEY (ItemNumber) REFERENCES solution.d_Item(ItemNumber)
);
GO

-- [SOLVING E5.3: Data Insertion]
INSERT INTO solution.d_Item (ItemNumber, ItemName)
SELECT DISTINCT ItemNumber, ItemName 
FROM exercise.d_Invoice;

INSERT INTO solution.d_InvoiceLine (InvoiceNo, InvoiceLine, ItemNumber, Quantity)
SELECT InvoiceNo, InvoiceLine, ItemNumber, Quantity 
FROM exercise.d_Invoice;
GO

-- ==========================================
-- (e) Working Hours 
-- ==========================================

-- [SOLVING E5.1 & E5.2: Table Creation & Constraints]
-- Normalizing the combined "Name (Department)" string into its own table.
CREATE TABLE solution.e_Employee (
    EmployeeName NVARCHAR(100) PRIMARY KEY,
    Department NVARCHAR(100)
);

CREATE TABLE solution.e_WorkingHours (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    WorkingTimeEntry NVARCHAR(255),
    FOREIGN KEY (EmployeeName) REFERENCES solution.e_Employee(EmployeeName)
);
GO

-- [SOLVING E5.3: Data Insertion]
INSERT INTO solution.e_Employee (EmployeeName, Department)
SELECT DISTINCT 
    TRIM(SUBSTRING(EmployeeDepartment, 1, CHARINDEX('(', EmployeeDepartment) - 1)),
    SUBSTRING(EmployeeDepartment, CHARINDEX('(', EmployeeDepartment) + 1, CHARINDEX(')', EmployeeDepartment) - CHARINDEX('(', EmployeeDepartment) - 1)
FROM exercise.e_WorkingHours;

INSERT INTO solution.e_WorkingHours (EmployeeName, WorkingTimeEntry)
SELECT 
    TRIM(SUBSTRING(EmployeeDepartment, 1, CHARINDEX('(', EmployeeDepartment) - 1)),
    WorkingTimeEntry
FROM exercise.e_WorkingHours;
GO

-- ==========================================
-- (f) Exam 
-- ==========================================

-- [SOLVING E5.1 & E5.2: Table Creation & Constraints]
CREATE TABLE solution.f_Exam (
    ExamNo INT PRIMARY KEY,
    ExamDate DATE,
    Course NVARCHAR(100)
);

CREATE TABLE solution.f_ExamResult (
    ExamNo INT,
    StudentNo INT,
    Grade INT,
    PRIMARY KEY (ExamNo, StudentNo),
    FOREIGN KEY (ExamNo) REFERENCES solution.f_Exam(ExamNo)
);
GO

-- [SOLVING E5.3: Data Insertion]
INSERT INTO solution.f_Exam (ExamNo, ExamDate, Course)
SELECT DISTINCT ExamNo, ExamDate, Course 
FROM exercise.f_Exam;

INSERT INTO solution.f_ExamResult (ExamNo, StudentNo, Grade)
SELECT ExamNo, StudentNo, Grade 
FROM exercise.f_Exam;
GO
