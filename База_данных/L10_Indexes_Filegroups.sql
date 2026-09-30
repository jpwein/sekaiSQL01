USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'AdvancedDb')
BEGIN
    ALTER DATABASE AdvancedDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AdvancedDb;
END
GO

CREATE DATABASE AdvancedDb
ON PRIMARY 
(
    NAME = 'AdvancedDb_Primary',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdvancedDb_Primary.mdf'
),
FILEGROUP FastFG
(
    NAME = 'AdvancedDb_Fast',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdvancedDb_Fast.ndf'
),
FILEGROUP SlowFG
(
    NAME = 'AdvancedDb_Slow',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdvancedDb_Slow.ndf'
);
GO

USE AdvancedDb;
GO

CREATE TABLE FastFG.ActiveOrders (
    OrderID INT IDENTITY(1,1) NOT NULL,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    IsCompleted BIT NOT NULL DEFAULT 0
) ON FastFG;
GO

CREATE TABLE SlowFG.ArchivedOrders (
    ArchiveID INT IDENTITY(1,1) NOT NULL,
    OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    ArchiveDate DATETIME NOT NULL DEFAULT GETDATE()
) ON SlowFG;
GO


-- А) Кластерный индекс 
CREATE CLUSTERED INDEX CX_ActiveOrders_OrderID 
ON FastFG.ActiveOrders(OrderID);
GO

-- Б) Обычный некластерный индекс 
CREATE NONCLUSTERED INDEX NIX_ActiveOrders_CustomerID 
ON FastFG.ActiveOrders(CustomerID);
GO

-- В) Некластерный фильтрованный индекс 
CREATE NONCLUSTERED INDEX NIX_ActiveOrders_Uncompleted 
ON FastFG.ActiveOrders(OrderDate, TotalAmount)
WHERE IsCompleted = 0;
GO

-- Г) Поколоночный индекс 
CREATE NONCLUSTERED COLUMNSTORE INDEX NCIX_ArchivedOrders_Columnstore
ON SlowFG.ArchivedOrders(OrderID, CustomerID, OrderDate, TotalAmount);
GO

-- Проверка 1

INSERT INTO FastFG.ActiveOrders (CustomerID, TotalAmount, IsCompleted) VALUES
(101, 1500.00, 0),
(102, 3200.50, 1),
(103, 450.00, 0),
(101, 8900.00, 0);

INSERT INTO SlowFG.ArchivedOrders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(1, 101, '2025-01-15', 1200.00),
(2, 102, '2025-02-20', 5400.00);
 
-- Проверка 2
SELECT * FROM FastFG.ActiveOrders WHERE IsCompleted = 0; 
SELECT CustomerID, SUM(TotalAmount) FROM SlowFG.ArchivedOrders GROUP BY CustomerID; 
GO