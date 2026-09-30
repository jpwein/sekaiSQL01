
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Lesson11DB')
BEGIN
    CREATE DATABASE Lesson11DB;
END
GO

USE Lesson11DB;
GO

CREATE SCHEMA Persons;
GO
CREATE SCHEMA Products;
GO

CREATE TABLE Persons.Clients (
    ID INT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email VARCHAR(100) NULL,
    CreatedDate DATE DEFAULT GETDATE()
);

CREATE TABLE Persons.Employees (
    ID INT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Position VARCHAR(50) NULL,
    Salary DECIMAL(10, 2) NULL,
    IsActive BIT DEFAULT 1
);
GO

ALTER TABLE Persons.Clients DROP COLUMN ID;
ALTER TABLE Persons.Clients ADD ID INT IDENTITY(1,1) CONSTRAINT PK_Clients PRIMARY KEY;

ALTER TABLE Persons.Employees DROP COLUMN ID;
ALTER TABLE Persons.Employees ADD ID INT IDENTITY(1,1) CONSTRAINT PK_Employees PRIMARY KEY;
GO

CREATE TABLE Products.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NULL
);

CREATE TABLE Products.Items (
    ItemID INT IDENTITY(1,1) PRIMARY KEY,
    ItemName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);
GO

INSERT INTO Products.Categories (CategoryName, Description) 
VALUES (N'Электроника', N'Бытовая и компьютерная техника'), (N'Книги', N'Печатные издания');

INSERT INTO Products.Items (ItemName, Price) 
VALUES (N'Смартфон', 29990.00), (N'Ноутбук', 65000.50);
GO

ALTER SCHEMA Persons TRANSFER Products.Categories;
ALTER SCHEMA Persons TRANSFER Products.Items;
GO

SELECT * FROM Persons.Categories;
SELECT * FROM Persons.Items;
GO