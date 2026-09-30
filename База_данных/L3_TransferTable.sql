
USE CompanyDB;
GO

CREATE TABLE Sales.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL
);
GO

INSERT INTO Sales.Orders (CustomerName, TotalAmount)
VALUES 
    (N'Иван Иванов', 1500.00),
    (N'Петр Петров', 3200.50);
GO

SELECT * FROM Sales.Orders;
GO

ALTER SCHEMA Archive TRANSFER Sales.Orders;
GO

SELECT * FROM Archive.Orders;
GO