
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Lesson9DB')
BEGIN
    CREATE DATABASE Lesson9DB;
END
GO

USE Lesson9DB;
GO

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY, 
    FirstName NVARCHAR(50) NOT NULL,          
    LastName NVARCHAR(50) NOT NULL,          
    Email VARCHAR(100) NULL,                  
    PhoneNumber VARCHAR(20) NULL,            
    HireDate DATE DEFAULT GETDATE()
);
GO

INSERT INTO Employees (FirstName, LastName, Email, PhoneNumber)
VALUES 
    (N'Алексей', N'Иванов', 'alexey@example.com', '+79991112233'),
    (N'Мария', N'Петрова', NULL, '+79992223344'),              
    (N'Дмитрий', N'Сидоров', 'dmitry@example.com', NULL),      
    (N'Елена', N'Смирнова', NULL, NULL);                       
GO

CREATE TABLE ArchivedEmployees (
    ArchiveID INT IDENTITY(1,1) PRIMARY KEY,   
    OriginalID INT NOT NULL,                  
    FullName NVARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(100) NULL
);
GO

INSERT INTO ArchivedEmployees (OriginalID, FullName, ContactInfo)
SELECT 
    EmployeeID,
    FirstName + N' ' + LastName,
    ISNULL(Email, ISNULL(PhoneNumber, 'Нет контактов')) 
FROM Employees;
GO

SELECT * FROM Employees;
SELECT * FROM ArchivedEmployees;
GO