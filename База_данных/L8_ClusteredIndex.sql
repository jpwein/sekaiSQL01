
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'IndexTestDB')
BEGIN
    CREATE DATABASE IndexTestDB;
END
GO

USE IndexTestDB;
GO

IF OBJECT_ID('TestTable', 'U') IS NOT NULL DROP TABLE TestTable;
GO

CREATE TABLE TestTable (
    ID INT NOT NULL,
    Code INT NOT NULL,
    ValueData NVARCHAR(100) NOT NULL,
    CreatedDate DATETIME NOT NULL
);
GO

PRINT 'Заполнение таблицы 1 000 000 записей...';

WITH CTE AS (
    SELECT TOP (1000000) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Seq
    FROM sys.all_columns a1
    CROSS JOIN sys.all_columns a2
)
INSERT INTO TestTable (ID, Code, ValueData, CreatedDate)
SELECT 
    Seq AS ID,
    (Seq % 1000) + 1 AS Code,
    N'Тестовая строка № ' + CAST(Seq AS NVARCHAR(10)),
    DATEADD(second, -Seq, GETDATE())
FROM CTE;
GO


SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT * FROM TestTable WHERE ID = 750000;
GO


CREATE CLUSTERED INDEX CX_TestTable_ID ON TestTable(ID);
GO

SELECT * FROM TestTable WHERE ID = 750000;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO