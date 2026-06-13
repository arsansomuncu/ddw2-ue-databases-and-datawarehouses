USE shutdown2017;

-- Drop tables in reverse FK order
IF OBJECT_ID('dbo.ActivityLine',        'U') IS NOT NULL DROP TABLE dbo.ActivityLine;
IF OBJECT_ID('dbo.ActivityHeader',      'U') IS NOT NULL DROP TABLE dbo.ActivityHeader;
IF OBJECT_ID('dbo.Item',                'U') IS NOT NULL DROP TABLE dbo.Item;
IF OBJECT_ID('dbo.AccountingCategory',  'U') IS NOT NULL DROP TABLE dbo.AccountingCategory;
IF OBJECT_ID('dbo.Site',                'U') IS NOT NULL DROP TABLE dbo.Site;
IF OBJECT_ID('dbo.Unit',                'U') IS NOT NULL DROP TABLE dbo.Unit;

-- Unit
CREATE TABLE dbo.Unit (
    UnitId  INT IDENTITY(1,1) PRIMARY KEY,
    Unit    NVARCHAR(100)
);

-- Site
CREATE TABLE dbo.Site (
    SiteId  INT IDENTITY(1,1) PRIMARY KEY,
    Site    NVARCHAR(100),
    UnitId  INT FOREIGN KEY REFERENCES dbo.Unit(UnitId)
);

-- AccountingCategory
CREATE TABLE dbo.AccountingCategory (
    CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName    NVARCHAR(100),
    TaxRate         DECIMAL(5,2),
    TaxRateName     NVARCHAR(100)
);

-- Item
CREATE TABLE dbo.Item (
    Id                    INT IDENTITY(1,1) PRIMARY KEY,
    Name                  NVARCHAR(200),
    Type                  NVARCHAR(100),
    Cash                  DECIMAL(10,2),
    Cashless              DECIMAL(10,2),
    AccountingCategoryId  INT FOREIGN KEY REFERENCES dbo.AccountingCategory(CategoryId)
);

-- ActivityHeader
CREATE TABLE dbo.ActivityHeader (
    Id               INT IDENTITY(1,1) PRIMARY KEY,
    SiteId           INT FOREIGN KEY REFERENCES dbo.Site(SiteId),
    DeviceId         INT,
    GeneralCancelled BIT,
    Date             DATETIME2,
    ActivityType     NVARCHAR(50),
    IsReversed       BIT,
    HasReversal      BIT,
    ReversalId       INT,
    ReversedId       INT,
    VisitorTagNr     NVARCHAR(100),
    OperatorTagNr    NVARCHAR(100),
    CashTotal        DECIMAL(10,2),
    CashlessReal     DECIMAL(10,2),
    CashlessGift     DECIMAL(10,2),
    CashlessTotal    DECIMAL(10,2)
);

-- ActivityLine
CREATE TABLE dbo.ActivityLine (
    ActivityId  INT FOREIGN KEY REFERENCES dbo.ActivityHeader(Id),
    ItemId      INT FOREIGN KEY REFERENCES dbo.Item(Id),
    Count       INT,
    PRIMARY KEY (ActivityId, ItemId)
);
