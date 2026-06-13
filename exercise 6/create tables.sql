DROP TABLE IF EXISTS ActivityLine;
DROP TABLE IF EXISTS ActivityHeader;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS AccountingCategory;
DROP TABLE IF EXISTS Site;
DROP TABLE IF EXISTS Unit;


CREATE TABLE Unit (
    UnitId  INTEGER PRIMARY KEY,
    Unit    VARCHAR(100)
);


CREATE TABLE Site (
    SiteId  INTEGER PRIMARY KEY,
    Site    VARCHAR(100),
    UnitId  INTEGER REFERENCES Unit(UnitId)
);


CREATE TABLE AccountingCategory (
    CategoryId      INTEGER PRIMARY KEY,
    CategoryName    VARCHAR(100),
    TaxRate         NUMERIC(5,2),
    TaxRateName     VARCHAR(100)
);


CREATE TABLE Item (
    Id                    INTEGER PRIMARY KEY,
    Name                  VARCHAR(200),
    Type                  VARCHAR(100),
    Cash                  NUMERIC(10,2),
    Cashless              NUMERIC(10,2),
    AccountingCategoryId  INTEGER REFERENCES AccountingCategory(CategoryId)
);


CREATE TABLE ActivityHeader (
    Id               INTEGER PRIMARY KEY,
    SiteId           INTEGER REFERENCES Site(SiteId),
    DeviceId         INTEGER,
    GeneralCancelled INTEGER,
    Date             TIMESTAMP,
    ActivityType     VARCHAR(50),
    IsReversed       INTEGER,
    HasReversal      INTEGER,
    ReversalId       INTEGER,
    ReversedId       INTEGER,
    VisitorTagNr     VARCHAR(100),
    OperatorTagNr    VARCHAR(100),
    CashTotal        NUMERIC(10,2),
    CashlessReal     NUMERIC(10,2),
    CashlessGift     NUMERIC(10,2),
    CashlessTotal    NUMERIC(10,2)
);


CREATE TABLE ActivityLine (
    ActivityId  INTEGER REFERENCES ActivityHeader(Id),
    ItemId      INTEGER REFERENCES Item(Id),
    Count       INTEGER,
    PRIMARY KEY (ActivityId, ItemId)
);
