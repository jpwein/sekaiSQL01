USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'ShopDB')
BEGIN
    ALTER DATABASE ShopDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ShopDB;
END
GO

CREATE DATABASE ShopDB
ON PRIMARY 
(
    NAME = 'ShopDB_Primary',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ShopDB_Primary.mdf'
),
FILEGROUP FG_Products 
(
    NAME = 'ShopDB_Products',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ShopDB_Products.ndf'
),
FILEGROUP FG_Sales   
(
    NAME = 'ShopDB_Sales',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ShopDB_Sales.ndf'
);
GO

USE ShopDB;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AdventureWorks2019')
BEGIN
    PRINT 'ОШИБКА: База данных AdventureWorks2019 не найдена! Разверните .bak файл перед выполнением импорта.';
END
GO


-- Таблица 1: Категории товаров 
CREATE TABLE dbo.ProductCategories (
    ProductCategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL,
    ParentCategoryName NVARCHAR(50) NULL,
    RowGuid UNIQUEIDENTIFIER NOT NULL,
    ModifiedDate DATETIME NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
) ON FG_Products;

-- Таблица 2: Товары 
CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50) NOT NULL,
    ProductNumber NVARCHAR(25) NOT NULL,
    Color NVARCHAR(15) NULL,
    StandardCost DECIMAL(10, 2) NOT NULL,
    ListPrice DECIMAL(10, 2) NOT NULL,
    Size NVARCHAR(5) NULL,
    Weight DECIMAL(8, 2) NULL,
    ProductCategoryID INT NULL,
    ModifiedDate DATETIME NOT NULL
) ON FG_Products;

-- Таблица 3: Поставщики 
CREATE TABLE dbo.Vendors (
    VendorID INT PRIMARY KEY,
    AccountNumber NVARCHAR(15) NOT NULL,
    VendorName NVARCHAR(50) NOT NULL,
    CreditRating TINYINT NOT NULL,
    PreferredVendorStatus BIT NOT NULL,
    ActiveFlag BIT NOT NULL,
    WebURL NVARCHAR(1024) NULL,
    ModifiedDate DATETIME NOT NULL
) ON FG_Products;

-- Таблица 4: Покупатели / персоны 
CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    Title NVARCHAR(8) NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NOT NULL,
    EmailAddress NVARCHAR(50) NULL,
    PhoneNumber NVARCHAR(25) NULL,
    ModifiedDate DATETIME NOT NULL
) ON FG_Sales;

-- Таблица 5: Заказы 
CREATE TABLE dbo.SalesOrders (
    SalesOrderID INT PRIMARY KEY,
    RevisionNumber TINYINT NOT NULL,
    OrderDate DATETIME NOT NULL,
    DueDate DATETIME NOT NULL,
    ShipDate DATETIME NULL,
    Status TINYINT NOT NULL,
    CustomerID INT NOT NULL,
    SubTotal DECIMAL(10, 2) NOT NULL,
    TaxAmt DECIMAL(10, 2) NOT NULL,
    Freight DECIMAL(10, 2) NOT NULL,
    TotalDue DECIMAL(10, 2) NOT NULL,
    ModifiedDate DATETIME NOT NULL
) ON FG_Sales;

-- Таблица 6: Позиции заказа 
CREATE TABLE dbo.SalesOrderDetails (
    SalesOrderDetailID INT PRIMARY KEY,
    SalesOrderID INT NOT NULL,
    CarrierTrackingNumber NVARCHAR(25) NULL,
    OrderQty SMALLINT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    UnitPriceDiscount DECIMAL(10, 2) NOT NULL,
    LineTotal DECIMAL(10, 2) NOT NULL,
    ModifiedDate DATETIME NOT NULL
) ON FG_Sales;
GO


IF EXISTS (SELECT * FROM sys.databases WHERE name = 'AdventureWorks2019')
BEGIN
    -- 1. Импорт категорий
    INSERT INTO dbo.ProductCategories (ProductCategoryID, CategoryName, ParentCategoryName, RowGuid, ModifiedDate)
    SELECT 
        pc.ProductCategoryID,
        pc.Name AS CategoryName,
        'Main Category' AS ParentCategoryName,
        pc.rowguid,
        pc.ModifiedDate
    FROM AdventureWorks2019.Production.ProductCategory pc;

    -- 2. Импорт товаров
    INSERT INTO dbo.Products (ProductID, ProductName, ProductNumber, Color, StandardCost, ListPrice, Size, Weight, ProductCategoryID, ModifiedDate)
    SELECT TOP 500
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.Color,
        p.StandardCost,
        p.ListPrice,
        p.Size,
        p.Weight,
        p.ProductSubcategoryID,
        p.ModifiedDate
    FROM AdventureWorks2019.Production.Product p;

    -- 3. Импорт поставщиков
    INSERT INTO dbo.Vendors (VendorID, AccountNumber, VendorName, CreditRating, PreferredVendorStatus, ActiveFlag, WebURL, ModifiedDate)
    SELECT 
        v.BusinessEntityID,
        v.AccountNumber,
        v.Name,
        v.CreditRating,
        v.PreferredVendorStatus,
        v.ActiveFlag,
        v.PurchasingWebServiceURL,
        v.ModifiedDate
    FROM AdventureWorks2019.Purchasing.Vendor v;

    -- 4. Импорт покупателей
    INSERT INTO dbo.Customers (CustomerID, Title, FirstName, MiddleName, LastName, EmailAddress, PhoneNumber, ModifiedDate)
    SELECT TOP 500
        p.BusinessEntityID,
        p.Title,
        p.FirstName,
        p.MiddleName,
        p.LastName,
        ea.EmailAddress,
        pp.PhoneNumber,
        p.ModifiedDate
    FROM AdventureWorks2019.Person.Person p
    LEFT JOIN AdventureWorks2019.Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID
    LEFT JOIN AdventureWorks2019.Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID;

    -- 5. Импорт заказов
    INSERT INTO dbo.SalesOrders (SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, Status, CustomerID, SubTotal, TaxAmt, Freight, TotalDue, ModifiedDate)
    SELECT TOP 500
        soh.SalesOrderID,
        soh.RevisionNumber,
        soh.OrderDate,
        soh.DueDate,
        soh.ShipDate,
        soh.Status,
        soh.CustomerID,
        soh.SubTotal,
        soh.TaxAmt,
        soh.Freight,
        soh.TotalDue,
        soh.ModifiedDate
    FROM AdventureWorks2019.Sales.SalesOrderHeader soh;

    -- 6. Импорт позиций заказов
    INSERT INTO dbo.SalesOrderDetails (SalesOrderDetailID, SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID, UnitPrice, UnitPriceDiscount, LineTotal, ModifiedDate)
    SELECT TOP 500
        sod.SalesOrderDetailID,
        sod.SalesOrderID,
        sod.CarrierTrackingNumber,
        sod.OrderQty,
        sod.ProductID,
        sod.UnitPrice,
        sod.UnitPriceDiscount,
        sod.LineTotal,
        sod.ModifiedDate
    FROM AdventureWorks2019.Sales.SalesOrderDetail sod;
END
GO

-- Проверка

SELECT COUNT(*) AS CategoriesCount FROM dbo.ProductCategories;
SELECT COUNT(*) AS ProductsCount FROM dbo.Products;
SELECT COUNT(*) AS VendorsCount FROM dbo.Vendors;
SELECT COUNT(*) AS CustomersCount FROM dbo.Customers;
SELECT COUNT(*) AS SalesOrdersCount FROM dbo.SalesOrders;
SELECT COUNT(*) AS OrderDetailsCount FROM dbo.SalesOrderDetails;
GO