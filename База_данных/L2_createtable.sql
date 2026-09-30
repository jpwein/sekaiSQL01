-- 1. 
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ShopDB')
BEGIN
    CREATE DATABASE ShopDB;
END
GO

-- 2. 
USE ShopDB;
GO

-- 3. 
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY, --первичный ключ
    ProductName NVARCHAR(100) NOT NULL,      --название товара
    Category VARCHAR(50) NULL,              -- категория
    Price DECIMAL(10, 2) NOT NULL,          -- цена
    Rating FLOAT NULL,                      -- рейтинг товара
    IsAvailable BIT DEFAULT 1,              -- Логический тип 
    CreatedDate DATETIME DEFAULT GETDATE()  -- Дата и время создания
);
GO