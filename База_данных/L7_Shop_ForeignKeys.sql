USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'OnlineShopDB')
BEGIN
    CREATE DATABASE OnlineShopDB;
END
GO

USE OnlineShopDB;
GO

IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
GO

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20) NULL
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    ParentCategoryID INT NULL,
    CONSTRAINT FK_Categories_Parent FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    CategoryID INT NOT NULL,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

INSERT INTO Categories (CategoryName, ParentCategoryID) VALUES
(N'Электроника', NULL),
(N'Бытовая техника', NULL),
(N'Смартфоны', 1),    
(N'Ноутбуки', 1);      

INSERT INTO Customers (FirstName, LastName, Email, Phone) VALUES
(N'Алексей', N'Иванов', 'alex@example.com', '+79991112233'),
(N'Мария', N'Петрова', 'maria@example.com', '+79992223344'),
(N'Дмитрий', N'Сидоров', 'dmitry@example.com', '+79993334455');

INSERT INTO Products (ProductName, Price, StockQuantity, CategoryID) VALUES
(N'iPhone 15', 89990.00, 15, 3),
(N'Samsung Galaxy S24', 79990.00, 20, 3),
(N'MacBook Air M2', 115000.00, 10, 4),
(N'ASUS ROG Strix', 135000.00, 5, 4);

INSERT INTO Orders (OrderDate, TotalAmount, CustomerID) VALUES
('2026-09-10', 89990.00, 1),
('2026-09-12', 194990.00, 2),
('2026-09-15', 115000.00, 3);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 89990.00),  
(2, 2, 1, 79990.00),  
(2, 3, 1, 115000.00), 
(3, 3, 1, 115000.00); 
GO

-- Проверка результата
SELECT * FROM Customers;
SELECT * FROM Categories;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
GO