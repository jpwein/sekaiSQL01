
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CompanyDB')
BEGIN
    CREATE DATABASE CompanyDB;
END
GO

USE CompanyDB;
GO

CREATE SCHEMA Sales;
GO

CREATE SCHEMA Archive;
GO